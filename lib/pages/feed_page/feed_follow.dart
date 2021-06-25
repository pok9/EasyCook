import 'dart:async';

import 'package:easy_cook/models/feed/newFeedsFollow_model.dart';
import 'package:easy_cook/models/login/login_model.dart';
import 'package:easy_cook/pages/login_page/login.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_cook/models/feed/newFeedsProfile_model.dart';
import 'package:flutter/cupertino.dart';

class FeedFollowPage extends StatefulWidget {
  // FeedFollowPage({Key key}) : super(key: key);

  @override
  _FeedFollowPageState createState() => _FeedFollowPageState();
}

String token = ""; //โทเคน
//user
MyAccount datas;
DataAc dataUser;

//NewfeedsProfile
NewfeedsFollow newfeed;
Feed post;

class _FeedFollowPageState extends State<FeedFollowPage> {
  @override
  void initState() {
    super.initState();

    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");

      if (token != "") {
        getMyAccounts();
        newFeedPosts();
      }
    });
  }

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
      });
    } else {
      return null;
    }
  }

  Future<Null> newFeedPosts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/newfeeds";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        newfeed = newfeedsFollowFromJson(responseString);
        //  post = newfeed.feeds[0];
        // dataUser = datas.data[0];
      });
    } else {
      return null;
    }
  }

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    // int indexLogin = 1;
    return Scaffold(
      backgroundColor: Color(0xFFf3f5f9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: Text('การติดตาม'),
        ),
      ),
      drawer: (token != "" && dataUser != null)
          ? Container(
              width: deviceSize.width - 45,
              child: Drawer(
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            curve: Curves.linear,
                            type: PageTransitionType.bottomToTop,
                            child: ProfilePage(),
                          ),
                        );
                      },
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: new NetworkImage(
                                "https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?size=626&ext=jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF73AEF5),
                                    const Color(0xFF73AEF5)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: CircleAvatar(
                                  radius: 39,
                                  backgroundColor: Colors.grey,
                                  backgroundImage:
                                      NetworkImage(dataUser.profileImage),
                                ),
                              ),
                            ),
                            //Padding(padding: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
                            Text(
                              datas.data[0].aliasName,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.folder,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      title: Text('สูตรที่ซื้อ',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 23,
                              color: Colors.black)),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      title: Text('การแจ้งเตือน',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 23,
                              color: Colors.black)),
                      onTap: () {},
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.settings,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      title: Text('ตั้งค่า',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 23,
                              color: Colors.black)),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      title: Text('ออกจากระบบ',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 23,
                              color: Colors.black)),
                      onTap: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.setString("tokens", "");
                        // Navigator.pushNamedAndRemoveUntil(context,
                        //     '/slide-page', (Route<dynamic> route) => false);
                        findUser();
                      },
                    ),
                  ],
                ),
              ),
            )
          : Container(
              width: deviceSize.width - 45,
              child: Drawer(
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: new NetworkImage(
                                "https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?size=626&ext=jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return LoginPage();
                                          }).then((value) {
                                        findUser();
                                        // Navigator.pop(context);
                                      });
                                    },
                                    child: Text(
                                      'เข้าสู่ระบบ',
                                    ),
                                    style: ButtonStyle(
                                        side: MaterialStateProperty.all(
                                            BorderSide(
                                                width: 2, color: Colors.white)),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 50)),
                                        textStyle: MaterialStateProperty.all(
                                            TextStyle(fontSize: 15)))),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/register-page');
                                    },
                                    child: Text(
                                      'สมัครสมาชิก',
                                    ),
                                    style: ButtonStyle(
                                        side: MaterialStateProperty.all(
                                            BorderSide(
                                                width: 2, color: Colors.white)),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 43)),
                                        textStyle: MaterialStateProperty.all(
                                            TextStyle(fontSize: 15)))),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: Column(
                                children: [
                                  Row(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.folder,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      title: Text('สูตรที่ซื้อ',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 23,
                              color: Colors.black)),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      title: Text('การแจ้งเตือน',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 23,
                              color: Colors.black)),
                      onTap: () {},
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.settings,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      title: Text('ตั้งค่า',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 23,
                              color: Colors.black)),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      title: Text('ออกจากระบบ',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 23,
                              color: Colors.black)),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
      body: (token == "")
          ? Container()
          : (newfeed == null)
              ? AlertDialog(
                  content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("กรุณารอสักครู่...   "),
                    CircularProgressIndicator()
                  ],
                ))
              : ListView.builder(
                  itemCount: newfeed.feeds.length,
                  itemBuilder: (context, index) => index < 0
                      ? new SizedBox(
                          child: AlertDialog(
                              content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("กรุณารอสักครู่...   "),
                              CircularProgressIndicator()
                            ],
                          )),
                        )
                      : Container(
                          // height: 500,
                          width: 280,
                          child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            new Container(
                                              height: 30.0,
                                              width: 30.0,
                                              decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: new NetworkImage(
                                                          newfeed.feeds[index]
                                                              .profileImage))),
                                            ),
                                            new SizedBox(
                                              width: 10.0,
                                            ),
                                            new Text(
                                              newfeed.feeds[index].aliasName,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        IconButton(
                                            icon: Icon(Icons.more_vert),
                                            onPressed: () {
                                              // print("more_vert" + index.toString());
                                            })
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 350,
                                    // width: 500,
                                    decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                newfeed.feeds[index].image),
                                            fit: BoxFit.contain)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              newfeed.feeds[index].recipeName,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "4.2",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: 16.0,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: 16.0,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: 16.0,
                                                    ),
                                                    Icon(
                                                      Icons.star_half,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: 16.0,
                                                    ),
                                                    Icon(
                                                      Icons.star_border,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: 16.0,
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "(12)",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "\$25",
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              elevation: 5,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                        )),
    );
  }
}
