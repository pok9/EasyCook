import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_cook/home.dart';
import 'package:easy_cook/pages/feed_page/feed.dart';
import 'package:easy_cook/pages/feed_page/feed_follow.dart';
import 'package:easy_cook/pages/login_page/login.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:easy_cook/pages/register_page/register.dart';
import 'package:easy_cook/pages/register_page/register2.dart';
import 'package:easy_cook/pages/register_page/register3.dart';
import 'package:easy_cook/pages/search_page/search.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';
import 'package:easy_cook/slidepage.dart';
import 'package:flutter/material.dart';
import 'package:easy_cook/pages/search_page/searchRecipeName.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      routes: {
        '/register-page': (context) => RegisterPage(),
        '/register2-page': (context) => RegisterPage2(),
        '/register3-page': (context) => RegisterPage3(),
        '/login-page': (context) => LoginPage(),
        '/feedFollow-page':(context) => FeedFollowPage(),
        '/search-page':(context) => SearchPage(),
        // '/searchRecipeName' : (context) => SearchRecipeName(),
        '/slide-page' : (context) => SlidePage(),
        // '/showfood-page': (context) => ShowFood(),
      },
    );
  }
}
