import 'package:easy_cook/class/token_class.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/profile/newFeedsProfile_model.dart';
import 'package:easy_cook/pages/feed_page/feed.dart';
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
Datum dataUser;

//NewfeedsProfile
NewfeedsProfile newfeed;
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
      newFeedPosts();
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

        newfeed = newfeedsProfileFromJson(responseString);
        //  post = newfeed.feeds[0];
        // dataUser = datas.data[0];
      });
    } else {
      return null;
    }
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffe433e68), Color(0xfffaa449)],
  ).createShader(Rect.fromLTRB(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
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
                          backgroundImage: NetworkImage('http://apifood.comsciproject.com/uploadProfile/img_avatar.png'),
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
          : (dataUser == null || newfeed == null)
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
                                    newfeed.feeds.length.toString(),
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
                                    '1.2M',
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
                                    '132',
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
                          (newfeed.feeds.length == 0)
                              ? new SizedBox(
                                  child: Container(),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    //1st row
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16.0, 16.0, 8.0, 16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              new Container(
                                                height: 40.0,
                                                width: 40.0,
                                                decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: new DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: new NetworkImage(
                                                            newfeed.feeds[0]
                                                                .profileImage))),
                                              ),
                                              new SizedBox(
                                                width: 10.0,
                                              ),
                                              new Text(
                                                newfeed.feeds[0].aliasName,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          new IconButton(
                                              icon: Icon(Icons.more_vert),
                                              onPressed: () {
                                                //print("more_vert" + index.toString());
                                              })
                                        ],
                                      ),
                                    ),

                                    //2nd row
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: new Image.network(
                                        //รูปอาหาร
                                        newfeed.feeds[0].image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    //3rd row
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(
                                                Icons.favorite_border,
                                                color: Colors.black,
                                              ),
                                              new SizedBox(
                                                width: 16.0,
                                              ),
                                              Icon(Icons.chat_bubble_outline,
                                                  color: Colors.black),
                                              new SizedBox(
                                                width: 16.0,
                                              ),
                                              Icon(Icons.share,
                                                  color: Colors.black),
                                            ],
                                          ),
                                          Icon(Icons.bookmark_border,
                                              color: Colors.black),
                                        ],
                                      ),
                                    ),

                                    //4th row
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        "Liked by pawankumar, pk and 528,331 others",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),

                                    //5th row
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16.0, 16.0, 16.0, 16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          new Container(
                                            height: 40.0,
                                            width: 40.0,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: new NetworkImage(
                                                        newfeed.feeds[0]
                                                            .profileImage))),
                                          ),
                                          new SizedBox(
                                            width: 10.0,
                                          ),
                                          Expanded(
                                            child: new TextField(
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: null,
                                              decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "เพิ่ม คอมเมนต์...",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //6th row
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        "1 วันที่แล้ว",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    )
                                  ],
                                ),
                        ],
                      ),
                    ), //เส่น hr
                  ],
                ),
    );
  }
}
