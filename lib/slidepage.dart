import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_cook/pages/addFood_page/addFood.dart';

import 'package:easy_cook/pages/feed_page/feed.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:easy_cook/pages/search_page/search.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:easy_cook/pages/test.dart';
import 'package:easy_cook/pages/test2.dart';
import 'package:easy_cook/sidebar/sidebar_layout.dart';
import 'package:flutter/material.dart';

class SlidePage extends StatefulWidget {
  @override
  _SlidePageState createState() => _SlidePageState();
}

class _SlidePageState extends State<SlidePage> {
  

   var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    int args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        color: Color(0xFF73AEF5),
        backgroundColor: Colors.white30,
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
        index: _currentIndex,
        animationCurve: Curves.bounceInOut,
        onTap: (index){
            setState(() {
              print(args);
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
    print(_currentIndex);
    if(_currentIndex == 0){
      return SideBarLayout(); 
    }else if(_currentIndex == 1){
      return SearchPage();
    }else if(_currentIndex == 2){
      return AddFoodPage();
    }else if(_currentIndex == 3){
      // return ProfileUser(); 
    }else if(_currentIndex == 4){
      return ProfilePage();
    }
  }
}