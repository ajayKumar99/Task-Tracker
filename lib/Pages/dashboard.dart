import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'taskhandler.dart';
import '../Colors/colors.dart';
import '../Authentication/authentication.dart';
import '../App/app.dart';


class Dashboard extends StatefulWidget {
  final Authentication auth;
  final VoidCallback onSignedOut;
  final bool darkThemeEnabled;

  Dashboard({
    this.auth,
    this.onSignedOut,
    this.darkThemeEnabled,
  });

  _Dashboard createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _currentPage = 0;

  void _changePage(index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _userSignOutAuth() async {
    await widget.auth.signOutUser();
    widget.onSignedOut();
  }

  Widget getCurrentPage(BuildContext context, index) {
    final List<Widget> _currentBody = <Widget>[
      //To-Do Page
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              iconSize: 150.0,
              color: Colors.grey,
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskHandler(
                          darkThemeEnabled: widget.darkThemeEnabled,
                        ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      //List Page
      FutureBuilder(
        future: widget.auth.getCurrentUserCredentials(),
        builder: (context, user) {
          if (!user.hasData) return CircularProgressIndicator();
          return StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(user.data.uid)
                .collection('tasks')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              return DocumentListView(documents: snapshot.data.documents);
            },
          );
        },
      ),
    ];

    return _currentBody[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            FutureBuilder(
              future: widget.auth.getCurrentUserCredentials(),
              builder: (context, user) {
                if (!user.hasData) return CircularProgressIndicator();
                return UserAccountsDrawerHeader(
                  accountName: Text(user.data.displayName),
                  accountEmail: Text(user.data.email),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(user.data.photoUrl),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Dark Theme'),
              trailing: Switch(
                value: widget.darkThemeEnabled,
                onChanged: setDarkTheme.changeTheme,
                activeColor: Colors.redAccent,
              ),
            ),
            ListTile(
              leading: Text('Sign Out'),
              onTap: () {
                Navigator.of(context).pop();
                _userSignOutAuth();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: FutureBuilder(
          future: widget.auth.getCurrentUserCredentials(),
          builder: (BuildContext context, AsyncSnapshot<FirebaseUser> user) {
            if (!user.hasData) return CircularProgressIndicator();
            return InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(user.data.photoUrl),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              onTap: () => _scaffoldKey.currentState.openDrawer(),
            );
          },
        ),
        title: Text('Task Tracker'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: getCurrentPage(context, _currentPage),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            title: Text('To Do'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('List'),
          ),
        ],
        currentIndex: _currentPage,
        selectedItemColor: Colors.redAccent,
        onTap: _changePage,
      ),
    );
  }
}

class DocumentListView extends StatelessWidget {
  final List<DocumentSnapshot> documents;

  DocumentListView({this.documents});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documents.length,
      itemExtent: 110.0,
      itemBuilder: (BuildContext context, int index) {
        String desc = documents[index].data['desc'].toString();
        DateTime deadline = documents[index].data['deadline'];

        return Card(
          elevation: 8.0,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
              color: CustomColors().getColor(i: index),
            ),
            child: Dismissible(
              key: Key(desc),
              onDismissed: (direction) {
                Firestore.instance.runTransaction((transactionHandler) async {
                  DocumentSnapshot snapshot =
                      await transactionHandler.get(documents[index].reference);
                  await transactionHandler.delete(snapshot.reference);
                });

                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Task - $index completed"),
                ));
              },
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                ),
              ),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    desc,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(top:7.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.access_alarm,
                        color: Colors.redAccent,
                        size: 30.0,
                      ),
                      Text(
                        '${(DateTime.now().difference(deadline).inDays * -1).toString()} Days',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
