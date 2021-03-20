import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_cook/pages/login_page/login.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:easy_cook/pages/register_page/register.dart';
import 'package:easy_cook/pages/register_page/register2.dart';
import 'package:easy_cook/pages/register_page/register3.dart';
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
      routes: {
        '/register-page': (context) => RegisterPage(),
        '/register2-page': (context) => RegisterPage2(),
        '/register3-page': (context) => RegisterPage3(),
        '/login-page': (context) => LoginPage()
      },
    );
  }
}
