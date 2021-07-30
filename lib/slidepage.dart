import 'package:easy_cook/pages/feed_page/feed.dart';
import 'package:easy_cook/pages/feed_page/feed2.dart';

import 'package:easy_cook/pages/feed_page/feed_follow.dart';
import 'package:easy_cook/pages/login&register_page/login_page/login.dart';
import 'package:easy_cook/pages/recipeArchive_page/recipeArchive.dart';
import 'package:easy_cook/pages/search_page/search.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:easy_cook/test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SlidePage extends StatefulWidget {
  SlidePage();
  // SlidePage({Key key}) : super(key: key);

  @override
  _SlidePageState createState() => _SlidePageState();
}

class _SlidePageState extends State<SlidePage> {
  @override
  void initState() {
    super.initState();
    // findUser();
    print("slidePage ======");
  }

  Future<String> findUser() async {
    String token = ""; //โทเคน
    SharedPreferences preferences = await SharedPreferences.getInstance();

    token = preferences.getString("tokens");
    return token;
  }

  int currentTab = 0;
  final List screens = [
    FeedPage(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currenetScreen = FeedPage();

  @override
  Widget build(BuildContext context) {
    // resizeToAvoidBottomPadding:
    // false;
    bool keyboardIsOpened =
        MediaQuery.of(context).viewInsets.bottom != 0.0; //ทำให้ floating หาย
    return Scaffold(
      extendBody: true,
      body: PageStorage(bucket: bucket, child: currenetScreen),
      floatingActionButton: (false)
          ? null
          : Opacity(
              opacity: keyboardIsOpened ? 0 : 1,
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () async {
                  String token = await findUser();
                  if (token != "") {
                    Navigator.pushNamed(context, '/AddFoodPage');
                  } else {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return LoginPage();
                        }).then((value) {
                      if (value != null) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SlidePage(),
                          ),
                          (route) => false,
                        );
                      }

                      // Navigator.pop(context);
                    });
                  }
                },
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: (false)
                ? MainAxisAlignment.spaceAround
                : MainAxisAlignment.spaceBetween,
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
                              color: currentTab == 0
                                  ? Colors.white
                                  : Colors.grey.shade300,
                              size: 25),
                          Text('หน้าแรก',
                              style: TextStyle(
                                  color: currentTab == 0
                                      ? Colors.white
                                      : Colors.grey.shade300,
                                  fontSize: 11))
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
                            color: currentTab == 1
                                ? Colors.white
                                : Colors.grey.shade300,
                            size: currentTab == 1 ? 27 : 25,
                          ),
                          Text('ค้นหา',
                              style: TextStyle(
                                  color: currentTab == 1
                                      ? Colors.white
                                      : Colors.grey.shade300,
                                  fontSize: 11))
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
                          // currenetScreen = FeedFollowPage();
                          currenetScreen = Feed2Page();
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
                              color: currentTab == 2
                                  ? Colors.white
                                  : Colors.grey.shade300,
                              size: 25),
                          Text('การติดตาม',
                              style: TextStyle(
                                  color: currentTab == 2
                                      ? Colors.white
                                      : Colors.grey.shade300,
                                  fontSize: 11))
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currenetScreen = RecipeArchivePage();
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
                              color: currentTab == 3
                                  ? Colors.white
                                  : Colors.grey.shade300,
                              size: 25),
                          Text('คลังสูตร',
                              style: TextStyle(
                                  color: currentTab == 3
                                      ? Colors.white
                                      : Colors.grey.shade300,
                                  fontSize: 11))
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
