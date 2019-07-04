import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'App/app.dart';

main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    pref: prefs,
  ));
}
