import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';


import '../Authentication/auth_gateway.dart';
import '../Authentication/authentication.dart';
import '../Colors/colors.dart';


class MyApp extends StatelessWidget {
  final SharedPreferences pref;

  MyApp({
    this.pref,
  });

  Future<void> setUserTheme(data) async {
    await pref.setBool('dark', data);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder (
      stream: setDarkTheme.darkThemeEnabled,
      initialData: pref.getBool('dark') ?? false,
      builder: (context, snapshot) {
        setUserTheme(snapshot.data);
        return MaterialApp(
          title: 'Task Tracker',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: CustomColors().getColor(),
            accentColor: Colors.deepOrangeAccent,
            brightness: snapshot.data ? Brightness.dark : Brightness.light,
          ),
          home: AuthenticationBridge(
            auth: Auth(),
            darkThemeEnabled: snapshot.data,
          ),
        );
      }
    );
  }
}

class SetDarkTheme {
  final _themeController = StreamController<bool>();
  get changeTheme => _themeController.sink.add;
  get darkThemeEnabled => _themeController.stream;
}

final setDarkTheme = SetDarkTheme();
