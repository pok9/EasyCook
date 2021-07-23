import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_cook/pages/addFood_page/addFood.dart';
import 'package:easy_cook/pages/addFood_page/addImage.dart';
import 'package:easy_cook/pages/login&register_page/register_page/register.dart';
import 'package:easy_cook/pages/login&register_page/register_page/register2.dart';
import 'package:easy_cook/pages/login&register_page/register_page/register3.dart';
import 'package:easy_cook/slidepage.dart';
import 'package:easy_cook/pages/feed_page/feed.dart';

import 'package:easy_cook/pages/search_page/search.dart';
// import 'package:easy_cook/slidepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      home: SlidePage(),
      routes: {
        '/register-page': (context) => RegisterPage(),
        '/register2-page': (context) => RegisterPage2(),
        '/register3-page': (context) => RegisterPage3(),
        // '/login-page': (context) => LoginPage(),
        // '/feedFollow-page': (context) => FeedFollowPage(),
        '/search-page': (context) => SearchPage(),
        // '/searchRecipeName' : (context) => SearchRecipeName(),
        '/slide-page': (context) => SlidePage(),
        // '/addFood-page': (context) => AddFoodPage(),
        '/AddFoodPage': (context) => AddFoodPage(),
        // '/AddImagePage': (context) => AddImagePage(),
        // '/showfood-page': (context) => ShowFood(),
      },
    );
  }
}
