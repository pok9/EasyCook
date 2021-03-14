import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_cook/pages/login.dart';
import 'package:easy_cook/pages/profile.dart';
import 'package:easy_cook/pages/register2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      routes: {'/register2-page':(context) => RegisterPage2()},
    );
  }
}

 