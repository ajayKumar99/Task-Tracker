import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'authentication.dart';

class LoginPage extends StatefulWidget {
  final Authentication auth;
  final VoidCallback onSignedIn;

  LoginPage({
    this.auth,
    this.onSignedIn,
  });

  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {

  void _userSignInAuth() async {
    await widget.auth.signInUser();
    widget.onSignedIn();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Tracker'),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/images/background.jpg',
              width: size.width,
              height: size.height,
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: GoogleSignInButton(
              onPressed: _userSignInAuth,
              darkMode: true,
            ),
          ),
        ],
      ),
    );
  }
}
