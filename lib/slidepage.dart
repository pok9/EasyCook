import 'package:easy_cook/pages/addFood_page/addFood.dart';
import 'package:easy_cook/pages/feed_page/feed.dart';
import 'package:easy_cook/pages/feed_page/feed_follow.dart';
import 'package:easy_cook/pages/search_page/search.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SlidePage extends StatefulWidget {
  SlidePage({Key key}) : super(key: key);

  @override
  _SlidePageState createState() => _SlidePageState();
}

class _SlidePageState extends State<SlidePage> {
  int currentTab = 0;
  final List screens = [
    FeedPage(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currenetScreen = FeedPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: bucket, child: currenetScreen),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/addFood-page');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currenetScreen = FeedPage();
                          currentTab = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              currentTab == 0
                                  ? Icons.home
                                  : Icons.home_outlined,
                              color: Colors.white,
                              size: 25),
                          Text('หน้าแรก',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currenetScreen = SearchPage();
                          currentTab = 1;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            currentTab == 1 ? Icons.search_sharp : Icons.search,
                            color: Colors.white,
                            size: currentTab == 1 ? 27 : 25,
                          ),
                          Text('ค้นหา',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currenetScreen = FeedFollowPage();
                          currentTab = 2;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              currentTab == 2
                                  ? Icons.fastfood
                                  : Icons.fastfood_outlined,
                              color: Colors.white,
                              size: 25),
                          Text('การติดตาม',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11))
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currenetScreen = ProfileUser(46);
                          currentTab = 3;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              currentTab == 3
                                  ? Icons.folder
                                  : Icons.folder_open_outlined,
                              color: Colors.white,
                              size: 25),
                          Text('คลังสูตร',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
