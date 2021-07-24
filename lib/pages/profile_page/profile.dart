// import 'dart:js';
import 'dart:math';

import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/profile/myPost_model.dart';
import 'package:easy_cook/pages/profile_page/edit_profile.dart';
import 'package:easy_cook/pages/profile_page/showFollower&Following.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';

// import 'package:easy_cook/models/search/searchRecipe_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      new ProfilePage();
    });

    return null;
  }

  @override
  void initState() {
    super.initState();
    findUser();
  }

  String token = ""; //โทเคน
  //ดึง token
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("tokens");
      print("ProfilePage_token = " + token);
      getMyAccounts();
      // getMyAccounts();
      // print("dataUser = " + dataUser.toString());
    });
  }

  //ข้อมูลตัวเอง
  MyAccount data_MyAccount;
  DataAc data_DataAc;

  Future<Null> getMyAccounts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        data_MyAccount = myAccountFromJson(responseString);
        data_DataAc = data_MyAccount.data[0];
        // print(data_DataAc.userId);
        getMyPost();
      });
    } else {
      return null;
    }
  }

  //ข้อมูลโพสต์ตัวเอง
  MyPost data_MyPost;
  List<RecipePost> data_RecipePost;
  Future<Null> getMyPost() async {
    String uid = data_DataAc.userId.toString();
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/mypost/" + uid;

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        data_MyPost = myPostFromJson(responseString);
        data_RecipePost = data_MyPost.recipePost;
        // newfeed = newfeedsFollowFromJson(responseString);
        //  post = newfeed.feeds[0];
        // dataUser = datas.data[0];
      });
    } else {
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////

  List<Widget> _bodyUp;
  List<Widget> _randomHeightWidgets(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _bodyUp ??= List.generate(1, (index) {
      return Container(
          // color: Colors.primaries[index],
          height: 400,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: size.height * 0.30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?size=626&ext=jpg"),
                          fit: BoxFit.cover),
                    ),
                    child: Column(
                      children: [
                        // SizedBox(
                        //   height: 36,
                        // ),
                        SizedBox(
                          height: 10,
                        ),

                        CircleAvatar(
                          radius: 48,
                          backgroundImage:
                              NetworkImage(data_DataAc.profileImage),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        MaterialButton(
                          splashColor: Colors.white,
                          color: Colors.blue,
                          onPressed: () {
                            print("แก้ไขโปรไฟล์");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditProfilePage(this.data_DataAc)),
                            );
                          },
                          child: Text(
                            'แก้ไขโปรไฟล์',
                            style: TextStyle(color: Colors.white),
                          ),
                          shape: StadiumBorder(),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Expanded(child: Container()),
                        Container(
                          height: 64,
                          color: Colors.black.withOpacity(0.4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 110,
                                child: InkWell(
                                  onTap: () {
                                    print("โพสต์");
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'โพสต์',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        data_RecipePost.length.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 110,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ShowFollowerAndFollowing(
                                                index: 0,
                                                id: this.data_DataAc.userId,
                                                name:
                                                    this.data_DataAc.aliasName,
                                              )),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'ติดตาม',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        data_MyPost.countFollower.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 110,
                                child: InkWell(
                                  onTap: () {
                                    print("กำลังตืดตาม");
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ShowFollowerAndFollowing(
                                                index: 1,
                                                id: this.data_DataAc.userId,
                                                name:
                                                    this.data_DataAc.aliasName,
                                              )),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'กำลังติดตาม',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        data_MyPost.countFollowing.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 18, right: 18, top: 18, bottom: 18),
                child: Container(
                  // height: 150,
                  padding:
                      EdgeInsets.only(left: 18, right: 18, top: 22, bottom: 22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://png.pngtree.com/thumb_back/fw800/back_our/20190628/ourmid/pngtree-blue-background-with-geometric-forms-image_280879.jpg"),
                        fit: BoxFit.cover),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "กระเป๋าหลัก(\u0E3F)",
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(.7),
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            data_DataAc.balance.toString(),
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ConstrainedBox(
                            constraints:
                                BoxConstraints.tightFor(width: 100, height: 35),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white),
                              child: Text(
                                'เติมเงิน',
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints.tightFor(width: 100, height: 35),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white),
                              child: Text(
                                'ถอนเงิน',
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ));
    });

    return _bodyUp;
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // Persistent AppBar that never scrolls
      backgroundColor: Color(0xFFf3f5f9),
      appBar: AppBar(
        title: Text(data_DataAc == null ? "" : data_DataAc.aliasName),
        elevation: 0.0,
      ),
      body: data_DataAc == null || data_MyPost == null
          ? Container(
              child: AlertDialog(
                  content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("กรุณารอสักครู่...   "),
                  CircularProgressIndicator()
                ],
              )),
            )
          : DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder: (context, _) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        _randomHeightWidgets(context),
                      ),
                    ),
                  ];
                },
                // You tab view goes here
                body: Column(
                  children: <Widget>[
                    TabBar(
                      tabs: [
                        Tab(
                          child: Text(
                            "อาหาร",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "body",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: data_RecipePost
                                .length, /////////////////////////////////////////////////////////////////
                            itemBuilder: (context, index) => index < 0
                                ? new SizedBox(
                                    child: AlertDialog(
                                        content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("กรุณารอสักครู่...   "),
                                        CircularProgressIndicator()
                                      ],
                                    )),
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
                                                              data_DataAc
                                                                  .profileImage))), /////////////////////////////////////////////////
                                                ),
                                                new SizedBox(
                                                  width: 10.0,
                                                ),
                                                new Text(
                                                  data_DataAc
                                                      .aliasName, //////////////////////////////////////////////////
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            new IconButton(
                                                icon: Icon(Icons.more_vert),
                                                onPressed: () {
                                                  print("more_vert" +
                                                      index.toString());
                                                })
                                          ],
                                        ),
                                      ),

                                      //2nd row
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              print("up $index");
                                              print(data_RecipePost[index].rid);
                                              Navigator.push(context,
                                                  CupertinoPageRoute(
                                                      builder: (context) {
                                                return ShowFood(
                                                    data_RecipePost[index].rid);
                                              })).then((value) => findUser());
                                             
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 0, 8, 0),
                                              child: Container(
                                                width: deviceSize.width,
                                                height: 350,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          24.0),
                                                  child: Image(
                                                    fit: BoxFit.cover,
                                                    // alignment: Alignment.topRight,
                                                    image: NetworkImage(
                                                        data_RecipePost[index]
                                                            .image), ////////////////////////////////////////////////////////
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // ),
                                          Positioned(
                                            left: 8.0,
                                            bottom: 0.0,
                                            right: 8.0,
                                            child: GestureDetector(
                                              onTap: () {
                                                print("down $index");
                                                Navigator.push(context,
                                                  CupertinoPageRoute(
                                                      builder: (context) {
                                                return ShowFood(
                                                    data_RecipePost[index].rid);
                                              })).then((value) => findUser());
                                              },
                                              child: Container(
                                                height: 60.0,
                                                width: deviceSize.width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          24.0),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.black,
                                                      Colors.black12,
                                                    ],
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 18.0,
                                            bottom: 10.0,
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data_RecipePost[index]
                                                          .recipeName, /////////////////////////////////////////////////////////
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 16.0,
                                                        ),
                                                        Icon(
                                                          Icons.star,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 16.0,
                                                        ),
                                                        Icon(
                                                          Icons.star,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 16.0,
                                                        ),
                                                        Icon(
                                                          Icons.star_half,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 16.0,
                                                        ),
                                                        Icon(
                                                          Icons.star_border,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 16.0,
                                                        ),
                                                        SizedBox(
                                                          width: 5.0,
                                                        ),
                                                        Text(
                                                          "(คะแนน 55)",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),

                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        color: Colors.grey[400],
                                        height: 8,
                                      ),
                                    ],
                                  ),
                          ),
                          GridView.count(
                            padding: EdgeInsets.zero,
                            crossAxisCount: 3,
                            children: Colors.primaries.map((color) {
                              return Container(color: color, height: 150.0);
                            }).toList(),
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
