import 'dart:convert';

import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/pages/admin/manage_members.dart';
import 'package:easy_cook/pages/feed_page/feed.dart';
import 'package:easy_cook/pages/feed_page/feed2.dart';

import 'package:easy_cook/pages/login&register_page/login_page/login.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:easy_cook/pages/profile_page/profile2BottomNavbar.dart';

import 'package:easy_cook/pages/search_page/search1.dart';
import 'package:easy_cook/pages/showFood&User_page/XXX_showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:easy_cook/test.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SlidePage extends StatefulWidget {
  // SlidePage({Key key}) : super(key: key);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AndroidNotificationChannel channel;

  SlidePage({this.flutterLocalNotificationsPlugin, this.channel});
  @override
  _SlidePageState createState() => _SlidePageState();
}

class _SlidePageState extends State<SlidePage> {
  @override
  void initState() {
    super.initState();
    findUser();
    print("slidePage ======");
    // getTokenFireBase();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        this.widget.flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                this.widget.channel.id,
                this.widget.channel.name,
                this.widget.channel.description,
                largeIcon: DrawableResourceAndroidBitmap('hamburger2'),
                color: Colors.yellow,
                playSound: true,
                icon: 'hamburger1',
                timeoutAfter: 5000,
                styleInformation: DefaultStyleInformation(true, true),
              ),
            ));
      }
    });
  }

  // Future<Null> getTokenFireBase() async {
  //   try {
  //     FirebaseMessaging messaging = FirebaseMessaging.instance;

  //     // String tokenFirebase = await messaging.getToken(vapidKey: "BGpdLRs......",);
  //     String tokenFirebase = await messaging.getToken(
  //         vapidKey:
  //             "BC5Y9rRxIQizOB9jx5GuFuK9HK-XkB0NreHveINUNby-tvNdZklyAI0tY_P4u50aYhEcvQW65lzaEdPJF3rygzw");
  //     print('tokenFireBaes = $tokenFirebase');
  //   } catch (e) {
  //     print("TokenFireBaseError");
  //     print(e);
  //     print("TokenFireBaseError");
  //   }
  // }

  String token = ""; //โทเคน
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
      if (token != "" && token != null) {
        getMyAccounts1();
        getTokenFirebase();
      }
    });
  }

  getTokenFirebase() async {
    String tokenFirebase = await FirebaseMessaging.instance.getToken();
    print("tokenFirebase ===>>> $tokenFirebase");
    if (token != "" && token != null) {
      updateTokenLogin(tokenFirebase, token);
    }
  }

  Future<Null> updateTokenLogin(String tokenFirebase, String token) async {
    print("SlidPage --- tokenFirebase = ${tokenFirebase} ; token = ${token}");
    final String apiUrl = "http://apifood.comsciproject.com/pjNoti/updateToken";

    var data = {
      "token_noti": tokenFirebase,
    };

    print(data);

    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    print("token555 ===>> $token");
    print("responseUpdateTokenFirebase = ${response.statusCode}");
    print("response.body5555 = ${response.body}");
  }

  //user
  MyAccount datas;
  DataMyAccount dataUser;
  Future<Null> getMyAccounts1() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("responsegetMyAccounts() = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      // setState(() {
      final String responseString = response.body;

      datas = myAccountFromJson(responseString);
      dataUser = datas.data[0];
      print(dataUser.userId);
      setState(() {});
      // });
    } else {
      return null;
    }
  }

  Future<Null> getMyAccounts2() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("responsegetMyAccounts() = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      final String responseString = response.body;

      datas = myAccountFromJson(responseString);
      dataUser = datas.data[0];
      print(dataUser.userId);
      print(token);
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

  DateTime timeBackPressed = DateTime.now();
  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
        
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= Duration(seconds: 2);

        timeBackPressed = DateTime.now();

        if(isExitWarning){
          final message = "กดกลับอีกครั้งเพื่อออก";
          Fluttertoast.showToast(msg: message,fontSize: 18);

          return false;
        }else{
          Fluttertoast.cancel();
          return true;
        }
      },
      child: (dataUser == null || token == "")
          ? bottomNvigationUser(context)
          : (dataUser.userStatus == 1)
              ? bottomNvigationUser(context)
              : bottomNvigationAdmin(),
      );



  Scaffold bottomNvigationAdmin() {
    if (token != "" && token != null) {
      getMyAccounts2();
    }
    return Scaffold(
      extendBody: true,
      body: PageStorage(bucket: bucket, child: currenetScreen),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 50,
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
                        size: 23),
                    Text('หน้าแรก',
                        style: TextStyle(
                            color: currentTab == 0
                                ? Colors.white
                                : Colors.grey.shade300,
                            fontSize: 10))
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
                      size: currentTab == 1 ? 27 : 23,
                    ),
                    Text(' ค้นหา ',
                        style: TextStyle(
                            color: currentTab == 1
                                ? Colors.white
                                : Colors.grey.shade300,
                            fontSize: 10))
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
                           ? Icons.fastfood
                            : Icons.fastfood_outlined,
                        color: currentTab == 2
                            ? Colors.white
                            : Colors.grey.shade300,
                        size: 23),
                    Text('สูตรล่าสุด',
                        style: TextStyle(
                            color: currentTab == 2
                                ? Colors.white
                                : Colors.grey.shade300,
                            fontSize: 10))
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
                        size: 23),
                    Text('จัดการสมาชิก',
                        style: TextStyle(
                            color: currentTab == 3
                                ? Colors.white
                                : Colors.grey.shade300,
                            fontSize: 10))
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
                    (dataUser == null)
                        ? Icon(
                            currentTab == 4
                                ? Icons.account_box
                                : Icons.account_box_outlined,
                            color: currentTab == 4
                                ? Colors.white
                                : Colors.grey.shade300,
                            size: 25)
                        : currentTab == 4
                            ? Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    height: 24,
                                    width: 24,
                                  ),
                                  Positioned(
                                    top: 1,
                                    right: 1,
                                    child: CircleAvatar(
                                      radius: 11,
                                      backgroundImage:
                                          NetworkImage(dataUser.profileImage),
                                    ),
                                  ),
                                ],
                              )
                            : CircleAvatar(
                                radius: 11,
                                backgroundImage:
                                    NetworkImage(dataUser.profileImage),
                              ),
                    Text('บัญชี',
                        style: TextStyle(
                            color: currentTab == 4
                                ? Colors.white
                                : Colors.grey.shade300,
                            fontSize: 10))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Scaffold bottomNvigationUser(BuildContext context) {
    if (token != "" && token != null) {
      getMyAccounts2();
    }
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
                  
                  if (token != "" && token != null) {
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
                                ? Icons.fastfood
                            : Icons.fastfood_outlined,
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
