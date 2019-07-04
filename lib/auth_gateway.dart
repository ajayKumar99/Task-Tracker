import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dashboard.dart';
import 'loginpage.dart';
import 'authentication.dart';

class AuthenticationBridge extends StatefulWidget {
  final Authentication auth;
  final bool darkThemeEnabled;

  AuthenticationBridge({
    this.auth,
    this.darkThemeEnabled,
  });

  _AuthenticationBridge createState() => _AuthenticationBridge();
}

enum authStatus {
  signedIn,
  signedOut,
}

class _AuthenticationBridge extends State<AuthenticationBridge> {
  authStatus _status = authStatus.signedOut;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUserCredentials().then((user) {
      setState(() {
        _status = user == null ? authStatus.signedOut : authStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      _status = authStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _status = authStatus.signedOut;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case authStatus.signedOut:
        return LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );

      case authStatus.signedIn:
        return Dashboard(
          auth: widget.auth,
          onSignedOut: _signedOut,
          darkThemeEnabled: widget.darkThemeEnabled,
          );
    }
    return null;
  }
}
