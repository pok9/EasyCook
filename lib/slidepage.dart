import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_cook/pages/addFood.dart';

import 'package:easy_cook/pages/exit.dart';
import 'package:easy_cook/pages/feed.dart';
import 'package:easy_cook/pages/profile.dart';
import 'package:easy_cook/pages/search.dart';
import 'package:easy_cook/pages/test.dart';
import 'package:easy_cook/pages/test2.dart';
import 'package:flutter/material.dart';

class SlidePage extends StatefulWidget {
  @override
  _SlidePageState createState() => _SlidePageState();
}

class _SlidePageState extends State<SlidePage> {
   var _currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        color: Color(0xFF73AEF5),
        backgroundColor: Colors.white,
        buttonBackgroundColor: Color(0xFF73AEF5),
        height: 50,
        items: <Widget>[
          Icon(Icons.fastfood,size: 25,color: Colors.red[50],),
          Icon(Icons.search,size: 25,color: Colors.red[50],),
          Icon(Icons.add,size: 25,color: Colors.red[50],),
          Icon(Icons.notifications,size: 25,color: Colors.red[50],),
          Icon(Icons.person,size: 25,color: Colors.red[50],),
        ],
        animationDuration: Duration(
          milliseconds: 200
        ),
        index: 2,
        animationCurve: Curves.bounceInOut,
        onTap: (index){
            setState(() {
              print(index);
              _currentIndex = index;
            });
            //print(index);
        },
      ),
      body: getBodyWidget(),
      
    );
  }
  getBodyWidget(){
    if(_currentIndex == 0){
      return FeedPage(); 
    }else if(_currentIndex == 1){
      return SearchPage();
    }else if(_currentIndex == 2){
      return AddFoodPage();
    }else if(_currentIndex == 3){
      return test2(); 
    }else if(_currentIndex == 4){
      return ExitPage();
    }
  }
}