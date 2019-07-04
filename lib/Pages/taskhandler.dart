import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../App/app.dart';


class TaskHandler extends StatefulWidget {
  final bool darkThemeEnabled;

  TaskHandler({
    this.darkThemeEnabled,
  });

  @override
  _TaskHandler createState() => _TaskHandler();
}

class _TaskHandler extends State<TaskHandler> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();

  List<String> _month = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            FutureBuilder(
              future: FirebaseAuth.instance.currentUser(),
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
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.backspace),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Add Task'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30.0,
            onPressed: () {
              final snackbar = SnackBar(
                content: Text('Task Added'),
              );

              if (_textController.text.isNotEmpty) {
                FirebaseAuth.instance.currentUser().then((user) {
                  Firestore.instance.runTransaction((transactionHandler) async {
                    CollectionReference reference = Firestore.instance
                        .collection('users')
                        .document(user.uid)
                        .collection('tasks');
                    await reference
                        .add({
                          "desc": _textController.text,
                          "deadline": selectedDate,
                        })
                        .then((result) => {
                              Navigator.pop(context),
                              _textController.clear(),
                              _scaffoldKey.currentState.showSnackBar(snackbar),
                            })
                        .catchError((onError) => print(onError));
                  });
                });
              }
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Task Description'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Task Deadline'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${selectedDate.day} ${_month[selectedDate.month - 1]} , ${selectedDate.year}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              RaisedButton(
                child: Text('Set Deadline'),
                onPressed: () async {
                  final DateTime picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime(2101));
                  if (picked != null && picked.isAfter(selectedDate))
                    setState(() {
                      selectedDate = picked;
                    });
                },
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
