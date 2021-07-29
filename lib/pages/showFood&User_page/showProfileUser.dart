import 'dart:math';

import 'package:easy_cook/models/checkFollower_checkFollowing/checkFollower_model.dart';
import 'package:easy_cook/models/follow/manageFollow_model.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/profile/myPost_model.dart';
import 'package:easy_cook/pages/login&register_page/login_page/login.dart';
import 'package:easy_cook/pages/profile_page/showFollower&Following.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUser extends StatefulWidget {
  var reqUid;

  ProfileUser(this.reqUid);

  @override
  _ProfileUserState createState() => _ProfileUserState(reqUid);
}

class _ProfileUserState extends State<ProfileUser> {
  var reqUid;
  _ProfileUserState(this.reqUid);

  @override
  void initState() {
    super.initState();
    findUser();
  }

  String token = ""; //โทเคน

  //ดึงข้อมูล Token
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
      // print(token);

      getPostUser();

      if (token != "") {
        getMyAccounts();
      }
    });
  }

  //ข้อมูลของเรา(ข้อมูลเข้าสู่ระบบ)
  MyAccount datas;
  DataAc dataUser; //ข้อมูลของเรา(ข้อมูลเข้าสู่ระบบ)-คนที่เข้ามาดู
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

  //ข้อมูลโพสต์ที่ค้นหาจะได้ข้อมูลเจ้าของด้วย
  MyPost data_PostUser;
  List<RecipePost> data_RecipePost;
  Future<Null> getPostUser() async {
    String uid = reqUid.toString();
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/mypost/" + uid;

    final response = await http.get(Uri.parse(apiUrl));
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        data_PostUser = myPostFromJson(responseString);
        data_RecipePost = data_PostUser.recipePost;
        print("data_PostUser.userId = " + data_PostUser.userId.toString());

        if (token != "") {
          checkFollower();
        }

        // newfeed = newfeedsFollowFromJson(responseString);
        //  post = newfeed.feeds[0];
        // dataUser = datas.data[0];
      });
    } else {
      return null;
    }
  }

  //เช็คว่าเราติดตามไปแล้วหรือยัง
  CheckFollower checkFollowers;
  Future<Null> checkFollower() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjFollow/checkFollower/" +
            data_PostUser.userId.toString();

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;
        checkFollowers = checkFollowerFromJson(responseString);
        setState(() {
          print("checkkkkk222 = " + checkFollowers.checkFollower.toString());
        });
      });
    } else {
      return null;
    }
  }

  //จัดการติดตามหรือยกเลิกติดตาม
  Future<Null> manageFollow(String state, int following_ID) async {
    // final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signin";

    final String apiUrl =
        "http://apifood.comsciproject.com/pjFollow/ManageFollow";
    final response = await http.post(Uri.parse(apiUrl),
        body: {"state": state, "following_ID": following_ID.toString()},
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      final String responseString = response.body;
      ManageFollow aa = manageFollowFromJson(responseString);
      print(aa.success);
      setState(() {
        getPostUser();
        // this.initState();
      });
    } else {
      return null;
    }
  }

  //===========================================================================

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // Persistent AppBar that never scrolls
      backgroundColor: Color(0xFFf3f5f9),
      appBar: AppBar(
        title: Text(data_PostUser == null ? "" : data_PostUser.aliasName),
        elevation: 0.0,
      ),
      body: (data_PostUser == null && checkFollowers == null) ||
              (data_PostUser == null && checkFollowers != null)
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
                // allows you to build a list of elements that would be scrolled away till the body reached the top
                headerSliverBuilder: (context, _) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                            // color: Colors.primaries[index],
                            height: 233,
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: deviceSize.height * 0.30,
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
                                            backgroundImage: NetworkImage(
                                                data_PostUser
                                                    .profileImage), //////////////////
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          (checkFollowers == null)
                                              ? MaterialButton(
                                                  splashColor: Colors.grey,
                                                  color: Colors.red[400],
                                                  onPressed: () {
                                                    print("login");
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
                                                    'ติดตาม',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  shape: StadiumBorder(),
                                                )
                                              : (checkFollowers.checkFollower ==
                                                      0)
                                                  ? MaterialButton(
                                                      splashColor: Colors.grey,
                                                      color: Colors.red[400],
                                                      onPressed: () {
                                                        print("ติดตาม");
                                                        manageFollow(
                                                            "fol",
                                                            this
                                                                .data_PostUser
                                                                .userId);
                                                        // _ProfileUserState(this.reqUid);
                                                      },
                                                      child: Text(
                                                        'ติดตาม',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      shape: StadiumBorder(),
                                                    )
                                                  : MaterialButton(
                                                      splashColor: Colors.grey,
                                                      color: Colors.grey,
                                                      onPressed: () {
                                                        print("ยกเลิกติดตาม");
                                                        manageFollow(
                                                            "unfol",
                                                            this
                                                                .data_PostUser
                                                                .userId);
                                                      },
                                                      child: Text(
                                                        'กำลังติดตาม',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
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
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  width: 110,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'โพสต์',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white70,
                                                            fontSize: 12),
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                        data_PostUser.countPost
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 110,
                                                  child: InkWell(
                                                    onTap: () {
                                                      print("ติดตาม");
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ShowFollowerAndFollowing(
                                                                  index: 0,
                                                                  id: this
                                                                      .data_PostUser
                                                                      .userId,
                                                                  name: this
                                                                      .data_PostUser
                                                                      .aliasName,
                                                                )),
                                                      );
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'ติดตาม',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white70,
                                                              fontSize: 12),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          data_PostUser
                                                              .countFollower
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                      print("กำลังติดตาม");
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ShowFollowerAndFollowing(
                                                                  index: 1,
                                                                  id: this
                                                                      .data_PostUser
                                                                      .userId,
                                                                  name: this
                                                                      .data_PostUser
                                                                      .aliasName,
                                                                )),
                                                      );
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'กำลังติดตาม',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white70,
                                                              fontSize: 12),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          data_PostUser
                                                              .countFollowing
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                              ],
                            ))
                      ]),
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
                            itemCount: data_RecipePost.length,
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
                                                              data_PostUser
                                                                  .profileImage))),
                                                ),
                                                new SizedBox(
                                                  width: 10.0,
                                                ),
                                                new Text(
                                                  data_PostUser.aliasName,
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
                                              // print(data_RecipePost[index].rid);/////////////////////////////////////////////
                                              // Navigator.push(context,
                                              //     CupertinoPageRoute(
                                              //         builder: (context) {
                                              //   return ShowFood(
                                              //       data_RecipePost[index].rid);
                                              // }));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 0, 8, 0),
                                              child: Container(
                                                width: deviceSize.width,
                                                height: 300,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          24.0),
                                                  child: Image(
                                                    fit: BoxFit.cover,
                                                    // alignment: Alignment.topRight,
                                                    image: NetworkImage(
                                                        data_RecipePost[index]
                                                            .image),
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
                                                // Navigator.push(context,////////////////////////////////////
                                                //     CupertinoPageRoute(
                                                //         builder: (context) {
                                                //   return ShowFood(
                                                //       data_RecipePost[index]
                                                //           .rid);
                                                // }));
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
                                                          .recipeName,
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
                                                          "(คะแนน " +
                                                              (data_RecipePost[
                                                                      index]
                                                                  .score
                                                                  .toString()) +
                                                              ")",
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
                                      Divider(
                                        thickness: 1,
                                        color: Colors.grey,
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
