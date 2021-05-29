import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_cook/pages/addFood_page/addFood.dart';
import 'package:easy_cook/pages/test.dart';
import 'package:easy_cook/slidepage.dart';
import 'package:easy_cook/pages/feed_page/feed.dart';
import 'package:easy_cook/pages/feed_page/feed_follow.dart';
import 'package:easy_cook/pages/login_page/login.dart';
import 'package:easy_cook/pages/register_page/register.dart';
import 'package:easy_cook/pages/register_page/register2.dart';
import 'package:easy_cook/pages/register_page/register3.dart';
import 'package:easy_cook/pages/search_page/search.dart';
// import 'package:easy_cook/slidepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SlidePage(),
      routes: {
        '/register-page': (context) => RegisterPage(),
        '/register2-page': (context) => RegisterPage2(),
        '/register3-page': (context) => RegisterPage3(),
        '/login-page': (context) => LoginPage(),
        '/feedFollow-page': (context) => FeedFollowPage(),
        '/search-page': (context) => SearchPage(),
        // '/searchRecipeName' : (context) => SearchRecipeName(),
        '/slide-page': (context) => SlidePage(),
        '/addFood-page': (context) => AddFoodPage(),
        '/test': (context) => test(),
        // '/showfood-page': (context) => ShowFood(),
      },
    );
  }
}
