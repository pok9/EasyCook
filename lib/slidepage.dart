import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/pages/admin/manage_members.dart';
import 'package:easy_cook/pages/feed_page/feed.dart';
import 'package:easy_cook/pages/feed_page/feed2.dart';

import 'package:easy_cook/pages/feed_page/xxx_feed_follow.dart';
import 'package:easy_cook/pages/login&register_page/login_page/login.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:easy_cook/pages/profile_page/profile2BottomNavbar.dart';
import 'package:easy_cook/pages/recipeArchive_page/recipeArchive.dart';
import 'package:easy_cook/pages/search_page/xxx_search.dart';
import 'package:easy_cook/pages/search_page/search1.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:easy_cook/test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
    findUser();
    print("slidePage ======");
  }

  String token = ""; //โทเคน
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
      if (token != "") {
        getMyAccounts();
      }
    });
  }

  //user
  MyAccount datas;
  DataAc dataUser;
  Future<Null> getMyAccounts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        datas = myAccountFromJson(responseString);
        dataUser = datas.data[0];
        print(dataUser.userId);
      });
    } else {
      return null;
    }
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
    return (dataUser == null || token == "")
        ? bottomNvigationUser(keyboardIsOpened, context)
        : (dataUser.userStatus == 1)
            ? bottomNvigationUser(keyboardIsOpened, context)
            : bottomNvigationAdmin();
  }

  Scaffold bottomNvigationAdmin() => Scaffold(
        extendBody: true,
        body: PageStorage(bucket: bucket, child: currenetScreen),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          child: Container(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                // mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                // mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        Icon(currentTab == 0 ? Icons.home : Icons.home_outlined,
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
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currenetScreen = SearchPage1();
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
                        Text(' ค้นหา ',
                            style: TextStyle(
                                color: currentTab == 1
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
                                ? Icons.all_inclusive
                                : Icons.all_inclusive_outlined,
                            color: currentTab == 2
                                ? Colors.white
                                : Colors.grey.shade300,
                            size: 25),
                        Text('สูตรล่าสุด',
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
                        // currenetScreen = FeedFollowPage();
                        currenetScreen = ManageMembers();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            currentTab == 3
                                ? Icons.cancel
                                : Icons.cancel_outlined,
                            color: currentTab == 3
                                ? Colors.white
                                : Colors.grey.shade300,
                            size: 25),
                        Text('จัดการสมาชิก',
                            style: TextStyle(
                                color: currentTab == 3
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
                        currenetScreen = ProfilePage2BottomNavbar();
                        currentTab = 4;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            currentTab == 4
                                ? Icons.account_box
                                : Icons.account_box_outlined,
                            color: currentTab == 4
                                ? Colors.white
                                : Colors.grey.shade300,
                            size: 25),
                        Text('บัญชี',
                            style: TextStyle(
                                color: currentTab == 4
                                    ? Colors.white
                                    : Colors.grey.shade300,
                                fontSize: 11))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Scaffold bottomNvigationUser(bool keyboardIsOpened, BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageStorage(bucket: bucket, child: currenetScreen),
      floatingActionButton: (false)
          ? null
          : Opacity(
              opacity: keyboardIsOpened ? 0 : 1,
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              // mainAxisAlignment:  MainAxisAlignment.spaceBetween,
              // mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Icon(currentTab == 0 ? Icons.home : Icons.home_outlined,
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
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currenetScreen = SearchPage1();
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
                // Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: MaterialButton(
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
                                ? Icons.all_inclusive
                                : Icons.all_inclusive_outlined,
                            color: currentTab == 2
                                ? Colors.white
                                : Colors.grey.shade300,
                            size: 25),
                        Text('สูตรล่าสุด',
                            style: TextStyle(
                                color: currentTab == 2
                                    ? Colors.white
                                    : Colors.grey.shade300,
                                fontSize: 11))
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currenetScreen = ProfilePage2BottomNavbar();
                      currentTab = 3;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (dataUser == null)
                          ? Icon(
                              currentTab == 3
                                  ? Icons.account_box
                                  : Icons.account_box_outlined,
                              color: currentTab == 3
                                  ? Colors.white
                                  : Colors.grey.shade300,
                              size: 25)
                          : currentTab == 3
                              ? Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      height: 26,
                                      width: 26,
                                    ),
                                    Positioned(
                                      top: 1,
                                      right: 1,
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundImage:
                                            NetworkImage(dataUser.profileImage),
                                      ),
                                    ),
                                  ],
                                )
                              : CircleAvatar(
                                  radius: 12,
                                  backgroundImage:
                                      NetworkImage(dataUser.profileImage),
                                ),
                      Text('บัญชี',
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
        ),
      ),
    );
  }
}
