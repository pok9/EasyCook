import 'dart:math';

import 'package:easy_cook/class/token_class.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/feed/newFeedsProfile_model.dart';
import 'package:easy_cook/models/profile/myPost_model.dart';
import 'package:easy_cook/pages/feed_page/feed.dart';
import 'package:easy_cook/pages/feed_page/feed_follow.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_cook/pages/login_page/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

String token = ""; //โทเคน
//user
MyAccount datas;
DataAc dataUser;

//MyPost
MyPost dataPost;
//NewfeedsProfile
// NewfeedsProfile newfeed;
// Feed post;

class _ProfilePageState extends State<ProfilePage> {
  // _ProfilePageState() {
  //   tokens();
  //   getMyAccounts();

  //   print("Token = " + token);

  //   // print();
  // }
  showdialog(context) {
    return showDialog(
        context: context,
        builder: (contex) {
          return AlertDialog(
              content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Loading...   "), CircularProgressIndicator()],
          ));
        });
  }

  @override
  void initState() {
    print(dataUser);
    super.initState();
    print(dataUser);
    print("print(dataUser);");
    findUser();
    print(dataUser);
    print("print(dataUser);");
    //getMyAccounts();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      print("11111111 = " + token);
      token = preferences.getString("tokens");
      print("22222222 = " + token);
      getMyAccounts();
      print("dataUser = " + dataUser.toString());
      // print("newfeed = " + newfeed.toString());
      // newFeedPosts();
    });
    // token = await Token_jwt().getTokens();
    // setState(() {});
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
        myPosts();
      });
    } else {
      return null;
    }
  }

  Future<Null> myPosts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/mypost/" +
        dataUser.userId.toString();

    print("apiUrl = " + apiUrl);
    final response = await http.get(Uri.parse(apiUrl));
    print("responsemyPosts = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        dataPost = myPostFromJson(responseString);
        // newfeed = newfeedsProfileFromJson(responseString);
        //  post = newfeed.feeds[0];
        // dataUser = datas.data[0];
      });
    } else {
      return null;
    }
  }

  // Future<Null> newFeedPosts() async {
  //   final String apiUrl = "http://apifood.comsciproject.com/pjPost/newfeeds";

  //   final response = await http
  //       .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
  //   print("response = " + response.statusCode.toString());
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       final String responseString = response.body;

  //       newfeed = newfeedsProfileFromJson(responseString);
  //       //  post = newfeed.feeds[0];
  //       // dataUser = datas.data[0];
  //     });
  //   } else {
  //     return null;
  //   }
  // }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffe433e68), Color(0xfffaa449)],
  ).createShader(Rect.fromLTRB(0.0, 0.0, 200.0, 70.0));

  int selectedIndex = 0; //navbar
  Color backgroundColor = Colors.white;

  Widget _buildItem(NavigationItem item, bool isSelected) {
    //navbar
    return AnimatedContainer(
      duration: Duration(milliseconds: 270),
      width: isSelected ? 125 : 50,
      padding: isSelected ? EdgeInsets.only(left: 16, right: 16) : null,
      height: double.maxFinite,
      decoration: isSelected
          ? BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.all(Radius.circular(50)))
          : null,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(size: 24),
                child: item.icon,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: isSelected
                      ? DefaultTextStyle.merge(
                          style: TextStyle(color: backgroundColor),
                          child: item.title)
                      : Container())
            ],
          )
        ],
      ),
    );
  }

  List<NavigationItem> items = [
    NavigationItem(
        Icon(
          Icons.web,
        ),
        Text('สูตรอาหาร'),
        Colors.deepPurpleAccent),
    NavigationItem(
        Icon(
          Icons.image,
        ),
        Text('รูป'),
        Colors.amber),
    NavigationItem(
        Icon(
          Icons.play_circle_outline,
          // size: 28,
        ),
        Text('วิดีโอ'),
        Colors.cyan),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            title: Text('โปรไฟล์'),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  preferences.setString("tokens", "");
                  // Navigator.pushNamed(context, '/login-page');
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login-page', (route) => false);
                  // Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext context) => LoginPage()) );
                },
              )
            ],
          )),
      body: (token == "")
          ? ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xffe43e68),
                            const Color(0xfffaa449)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                              'http://apifood.comsciproject.com/uploadProfile/img_avatar.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            foreground: Paint()..shader = linearGradient,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              child: Container(
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xffe43e68),
                                      const Color(0xfffaa449),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    'แก้ไขโปรไฟล์',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                print("5555");
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                '???',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                'โพสต์',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '???',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                'ผู้ติดตาม',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '???',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                'กำลังติดตาม',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                ), //เส่น hr
              ],
            )
          : (dataUser == null || dataPost == null)
              ? AlertDialog(
                  content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("กรุณารอสักครู่...   "),
                    CircularProgressIndicator()
                  ],
                ))
              : ListView(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xffe43e68),
                                const Color(0xfffaa449)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  NetworkImage(dataUser.profileImage),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dataUser.aliasName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                foreground: Paint()..shader = linearGradient,
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 0)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  child: Container(
                                    height: 50,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xffe43e68),
                                          const Color(0xfffaa449),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'แก้ไขโปรไฟล์',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    print("5555");
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Divider(
                            thickness: 1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    dataPost.countPost.toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    'โพสต์',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    dataPost.countFollower.toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    'ผู้ติดตาม',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    dataPost.countFollowing.toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    'กำลังติดตาม',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xffe43e68),
                                      const Color(0xfffaa449),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 70,
                                width: 370, //ฟิกค่าไว้ก่อน
                                child: Center(
                                  child: Text(
                                    'ยอดเงิน ' +
                                        dataUser.balance.toString() +
                                        ' บาท',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xffe43e68),
                                          const Color(0xfffaa449),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: 70,
                                    width: 180, //ฟิกค่าไว้ก่อน
                                    child: Center(
                                      child: Text(
                                        'เติมเงิน',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xffe43e68),
                                          const Color(0xfffaa449),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: 70,
                                    width: 180, //ฟิกค่าไว้ก่อน
                                    child: Center(
                                      child: Text(
                                        'ถอนเงิน',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          Container(
                            color: Colors.white70,
                            height: 56,
                            padding: EdgeInsets.only(
                                left: 8, top: 4, bottom: 4, right: 8),
                            // decoration: BoxDecoration(
                            //   color: backgroundColor,
                            //   boxShadow: [
                            //     BoxShadow(
                            //       color: Colors.black12,
                            //       blurRadius: 4
                            //     )
                            //   ]
                            // ),
                            width: MediaQuery.of(context).size.width,
                            child: Material(
                              elevation: 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: items.map((item) {
                                  var itemIndex = items.indexOf(item);
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // print(selectedIndex);
                                        selectedIndex = itemIndex;
                                        print(selectedIndex);
                                      });
                                    },
                                    child: _buildItem(
                                        item, selectedIndex == itemIndex),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),

                          // Material(
                          //   elevation: 1,
                          //   child: Container(
                          //     height: 56,
                          //     child: Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceEvenly,

                          //       children: [
                          //         Icon(
                          //           Icons.web,
                          //           color: Colors.black,
                          //           size: 28,
                          //         ),
                          //         Icon(
                          //           Icons.image,
                          //           color: Colors.black,
                          //           size: 28,
                          //         ),
                          //         Icon(
                          //           Icons.play_circle_outline,
                          //           color: Colors.black,
                          //           size: 28,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          //         ListView.builder(
                          //   itemCount: 5,
                          //   itemBuilder: (context, index) => index < 0
                          //       ? new SizedBox(
                          //           child: Container(),
                          //         )
                          //       : Column(
                          //           mainAxisAlignment: MainAxisAlignment.start,
                          //           mainAxisSize: MainAxisSize.min,
                          //           crossAxisAlignment: CrossAxisAlignment.stretch,
                          //           children: [
                          //             //1st row
                          //             Padding(
                          //               padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
                          //               child: Row(
                          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                 children: [
                          //                   Row(
                          //                     children: [
                          //                       new Container(
                          //                         height: 40.0,
                          //                         width: 40.0,
                          //                         decoration: new BoxDecoration(
                          //                             shape: BoxShape.circle,
                          //                             image: new DecorationImage(
                          //                                 fit: BoxFit.fill,
                          //                                 image: new NetworkImage(
                          //                                     "https://variety.teenee.com/foodforbrain/img8/241131.jpg"))),
                          //                       ),
                          //                       new SizedBox(
                          //                         width: 10.0,
                          //                       ),
                          //                       new Text(
                          //                         "วัยรุ่น ซิมบัพเว",
                          //                         style: TextStyle(fontWeight: FontWeight.bold),
                          //                       )
                          //                     ],
                          //                   ),
                          //                   new IconButton(
                          //                       icon: Icon(Icons.more_vert),
                          //                       onPressed: () {
                          //                         print("more_vert" + index.toString());
                          //                       })
                          //                 ],
                          //               ),
                          //             ),

                          //             //2nd row
                          //             Flexible(
                          //               fit: FlexFit.loose,
                          //               child: new Image.network(
                          //                 //รูปอาหาร
                          //                 "https://i.ytimg.com/vi/LQUhdrHYWSg/maxresdefault.jpg",
                          //                 fit: BoxFit.cover,
                          //               ),
                          //             ),

                          //             //3rd row
                          //             Padding(
                          //               padding: const EdgeInsets.all(16.0),
                          //               child: Row(
                          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                 children: [
                          //                   new Row(
                          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                     children: [
                          //                       Icon(
                          //                         Icons.favorite_border,
                          //                         color: Colors.black,
                          //                       ),
                          //                       new SizedBox(
                          //                         width: 16.0,
                          //                       ),
                          //                       Icon(Icons.chat_bubble_outline,
                          //                           color: Colors.black),
                          //                       new SizedBox(
                          //                         width: 16.0,
                          //                       ),
                          //                       Icon(Icons.share, color: Colors.black),
                          //                     ],
                          //                   ),
                          //                   Icon(Icons.bookmark_border, color: Colors.black),
                          //                 ],
                          //               ),
                          //             ),

                          //             //4th row
                          //             Padding(
                          //               padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          //               child: Text(
                          //                 "Liked by pawankumar, pk and 528,331 others",
                          //                 style: TextStyle(fontWeight: FontWeight.bold),
                          //               ),
                          //             ),

                          //             //5th row
                          //             Padding(
                          //               padding:
                          //                   const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                          //               child: Row(
                          //                 mainAxisAlignment: MainAxisAlignment.start,
                          //                 children: [
                          //                   new Container(
                          //                     height: 40.0,
                          //                     width: 40.0,
                          //                     decoration: new BoxDecoration(
                          //                         shape: BoxShape.circle,
                          //                         image: new DecorationImage(
                          //                             fit: BoxFit.fill,
                          //                             image: new NetworkImage(
                          //                                 "https://variety.teenee.com/foodforbrain/img8/241131.jpg"))),
                          //                   ),
                          //                   new SizedBox(
                          //                     width: 10.0,
                          //                   ),
                          //                   Expanded(
                          //                     child: new TextField(
                          //                       keyboardType: TextInputType.multiline,
                          //                       maxLines: null,
                          //                       decoration: new InputDecoration(
                          //                         border: InputBorder.none,
                          //                         hintText: "เพิ่ม คอมเมนต์...",
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),

                          //             //6th row
                          //             Padding(
                          //               padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          //               child: Text(
                          //                 "1 วันที่แล้ว",
                          //                 style: TextStyle(color: Colors.grey),
                          //               ),
                          //             )
                          //           ],
                          //         ),
                          // ),
                          (dataPost.recipePost.length == 0)
                              ? new SizedBox(
                                  child: Container(),
                                )
                              : (selectedIndex == 0)
                                  ? Container(
                                      height: size.height * 0.8 - 40,
                                      padding: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 0,
                                          bottom: 24),
                                      child: GridView.count(
                                        crossAxisCount: 1,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                        physics: BouncingScrollPhysics(),
                                        children: List.generate(
                                            dataPost.recipePost.length,
                                            (index) {
                                          return Container(
                                              height: 500,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  //1st row
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        16.0, 0, 8.0, 16.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            new Container(
                                                              height: 40.0,
                                                              width: 40.0,
                                                              decoration: new BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image: new DecorationImage(
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      image: new NetworkImage(
                                                                          dataPost
                                                                              .profileImage))),
                                                            ),
                                                            new SizedBox(
                                                              width: 10.0,
                                                            ),
                                                            new Text(
                                                              dataPost
                                                                  .aliasName,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          ],
                                                        ),
                                                        new IconButton(
                                                            icon: Icon(Icons
                                                                .more_vert),
                                                            onPressed: () {
                                                              //print("more_vert" + index.toString());
                                                            })
                                                      ],
                                                    ),
                                                  ),

                                                  // //2nd row
                                                  // Flexible(
                                                  //   fit: FlexFit.loose,
                                                  //   child: new Image.network(
                                                  //     //รูปอาหาร
                                                  //     dataPost
                                                  //         .recipePost[index].image,
                                                  //     fit: BoxFit.cover,
                                                  //   ),
                                                  // ),
                                                  //2nd row
                                                  Flexible(
                                                      fit: FlexFit.loose,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          // Navigator.push(context,
                                                          //     CupertinoPageRoute(builder: (context) {
                                                          //   return ShowFood(dataPost.recipePost[index]);
                                                          // }));
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  8, 0, 8, 0),
                                                          child: Container(
                                                            width: 300,
                                                            height: 100,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .circular(
                                                                      24.0),
                                                              child: Image(
                                                                fit: BoxFit
                                                                    .cover,
                                                                
                                                                image: NetworkImage(////////////////////////////////
                                                                    newfeed.feeds[
                                                                            index]
                                                                        .image
                                                                        ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // child: new Image.network(
                                                        //   //รูปอาหาร
                                                        //   newfeed.feeds[index].image,
                                                        //   height: 500,
                                                        //   fit: BoxFit.fill,
                                                        // ),
                                                      )),

                                                  //3rd row
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        new Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .favorite_border,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            new SizedBox(
                                                              width: 16.0,
                                                            ),
                                                            Icon(
                                                                Icons
                                                                    .chat_bubble_outline,
                                                                color: Colors
                                                                    .black),
                                                            new SizedBox(
                                                              width: 16.0,
                                                            ),
                                                            Icon(Icons.share,
                                                                color: Colors
                                                                    .black),
                                                          ],
                                                        ),
                                                        Icon(
                                                            Icons
                                                                .bookmark_border,
                                                            color:
                                                                Colors.black),
                                                      ],
                                                    ),
                                                  ),

                                                  //4th row
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.0),
                                                    child: Text(
                                                      "Score : " +
                                                          dataPost
                                                              .recipePost[index]
                                                              .score
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),

                                                  //5th row
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        16.0, 16.0, 16.0, 16.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        new Container(
                                                          height: 40.0,
                                                          width: 40.0,
                                                          decoration: new BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image: new DecorationImage(
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  image: new NetworkImage(
                                                                      dataPost
                                                                          .profileImage))),
                                                        ),
                                                        new SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Expanded(
                                                          child: new TextField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .multiline,
                                                            maxLines: null,
                                                            decoration:
                                                                new InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText:
                                                                  "เพิ่ม คอมเมนต์...",
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  //6th row
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.0),
                                                    child: Text(
                                                      dataPost.recipePost[index]
                                                          .date
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ),

                                                  Divider(
                                                    thickness: 1,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ));
                                        }),
                                      ),
                                    )
                                  : (selectedIndex == 1)
                                      ? Container(
                                          height: size.height * 0.60 - 56,
                                          padding: EdgeInsets.only(
                                              left: 16,
                                              right: 16,
                                              top: 0,
                                              bottom: 24),
                                          child: GridView.count(/////////////////////////////////////////////////
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                            physics: BouncingScrollPhysics(),
                                            children: List.generate(
                                                newfeed.feeds.length, (index) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          newfeed.feeds[index]
                                                              .image),
                                                      fit: BoxFit.cover),
                                                ),
                                              );
                                            }),
                                          ),
                                        )
                                      : Container(),
                          // : Column(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     mainAxisSize: MainAxisSize.min,
                          //     crossAxisAlignment:
                          //         CrossAxisAlignment.stretch,
                          //     children: [
                          //       //1st row
                          //       Padding(
                          //         padding: const EdgeInsets.fromLTRB(
                          //             16.0, 16.0, 8.0, 16.0),
                          //         child: Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             Row(
                          //               children: [
                          //                 new Container(
                          //                   height: 40.0,
                          //                   width: 40.0,
                          //                   decoration: new BoxDecoration(
                          //                       shape: BoxShape.circle,
                          //                       image: new DecorationImage(
                          //                           fit: BoxFit.fill,
                          //                           image: new NetworkImage(
                          //                               newfeed.feeds[0]
                          //                                   .profileImage))),
                          //                 ),
                          //                 new SizedBox(
                          //                   width: 10.0,
                          //                 ),
                          //                 new Text(
                          //                   newfeed.feeds[0].aliasName,
                          //                   style: TextStyle(
                          //                       fontWeight:
                          //                           FontWeight.bold),
                          //                 )
                          //               ],
                          //             ),
                          //             new IconButton(
                          //                 icon: Icon(Icons.more_vert),
                          //                 onPressed: () {
                          //                   //print("more_vert" + index.toString());
                          //                 })
                          //           ],
                          //         ),
                          //       ),

                          //       //2nd row
                          //       Flexible(
                          //         fit: FlexFit.loose,
                          //         child: new Image.network(
                          //           //รูปอาหาร
                          //           newfeed.feeds[0].image,
                          //           fit: BoxFit.cover,
                          //         ),
                          //       ),

                          //       //3rd row
                          //       Padding(
                          //         padding: const EdgeInsets.all(16.0),
                          //         child: Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             new Row(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 Icon(
                          //                   Icons.favorite_border,
                          //                   color: Colors.black,
                          //                 ),
                          //                 new SizedBox(
                          //                   width: 16.0,
                          //                 ),
                          //                 Icon(Icons.chat_bubble_outline,
                          //                     color: Colors.black),
                          //                 new SizedBox(
                          //                   width: 16.0,
                          //                 ),
                          //                 Icon(Icons.share,
                          //                     color: Colors.black),
                          //               ],
                          //             ),
                          //             Icon(Icons.bookmark_border,
                          //                 color: Colors.black),
                          //           ],
                          //         ),
                          //       ),

                          //       //4th row
                          //       Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: 16.0),
                          //         child: Text(
                          //           "Liked by pawankumar, pk and 528,331 others",
                          //           style: TextStyle(
                          //               fontWeight: FontWeight.bold),
                          //         ),
                          //       ),

                          //       //5th row
                          //       Padding(
                          //         padding: const EdgeInsets.fromLTRB(
                          //             16.0, 16.0, 16.0, 16.0),
                          //         child: Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.start,
                          //           children: [
                          //             new Container(
                          //               height: 40.0,
                          //               width: 40.0,
                          //               decoration: new BoxDecoration(
                          //                   shape: BoxShape.circle,
                          //                   image: new DecorationImage(
                          //                       fit: BoxFit.fill,
                          //                       image: new NetworkImage(
                          //                           newfeed.feeds[0]
                          //                               .profileImage))),
                          //             ),
                          //             new SizedBox(
                          //               width: 10.0,
                          //             ),
                          //             Expanded(
                          //               child: new TextField(
                          //                 keyboardType:
                          //                     TextInputType.multiline,
                          //                 maxLines: null,
                          //                 decoration: new InputDecoration(
                          //                   border: InputBorder.none,
                          //                   hintText: "เพิ่ม คอมเมนต์...",
                          //                 ),
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),

                          //       //6th row
                          //       Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: 16.0),
                          //         child: Text(
                          //           "1 วันที่แล้ว",
                          //           style: TextStyle(color: Colors.grey),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                        ],
                      ),
                    ), //เส่น hr
                  ],
                ),
    );
  }
}

class NavigationItem {
  final Icon icon;
  final Text title;
  final Color color;

  NavigationItem(this.icon, this.title, this.color);
}
