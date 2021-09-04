import 'dart:convert';
import 'dart:math';

import 'package:easy_cook/models/checkFollower_checkFollowing/checkFollower_model.dart';
import 'package:easy_cook/models/follow/manageFollow_model.dart';
import 'package:easy_cook/models/myBuy/mybuy.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/profile/myPost_model.dart';
import 'package:easy_cook/models/report/addReport/addReport_model.dart';
import 'package:easy_cook/pages/buyFood_page/recipe_purchase_page.dart';
import 'package:easy_cook/pages/login&register_page/login_page/login.dart';
import 'package:easy_cook/pages/profile_page/showFollower&Following.dart';
import 'package:easy_cook/pages/showFood&User_page/reportFood&User&Commnt/reportUser.dart';
import 'package:easy_cook/pages/showFood&User_page/XXX_showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
    if (mounted)
      setState(() {
        token = preferences.getString("tokens");
        // print(token);

        getPostUser();

        if (token != "" && token != null) {
          getMyAccounts();
          getMybuy();
        }
      });
  }

  //ข้อมูลของเรา(ข้อมูลเข้าสู่ระบบ)
  MyAccount data_MyAccount;
  DataMyAccount data_DataAc; //ข้อมูลของเรา(ข้อมูลเข้าสู่ระบบ)-คนที่เข้ามาดู
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

  Future<Null> insertNotificationData(
    String my_ID,
    String state,
    String description,
    String recipe_ID,
    String from_userid,
    String status,
  ) async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjNoti/insertNotificationData";

    // List<st>
    var data = {
      "my_ID": my_ID,
      "state": state,
      "description": description,
      "recipe_ID": recipe_ID,
      "from_userid": from_userid,
      "status": status
    };
    print("jsonEncode(data)InsertNotificationData = " + jsonEncode(data));
    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data), headers: {"Content-Type": "application/json"});

    print(
        "response.statusCodeInsertNotificationData => ${response.statusCode}");
    print("response.bodyInsertNotificationData => ${response.body}");
  }

  //===========================================================================

  Future<AddReport> addReport(String userTarget_ID, String type_report,
      String recipe_ID, String title, String description, String image) async {
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/addReport";

    var data = {
      "userTarget_ID": userTarget_ID,
      "type_report": type_report,
      "recipe_ID": recipe_ID,
      "title": title,
      "description": description,
      "image": image
    };

    print(jsonEncode(data));
    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final String responseString = response.body;

      return addReportFromJson(responseString);
    } else {
      return null;
    }
  }

  AlertDialog alertDialog_successful_or_unsuccessful(
      String reportText1, Color color, String reportText2) {
    return AlertDialog(
      title: Text(reportText1, style: TextStyle(color: Colors.white)),
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
      backgroundColor: color,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      content: Text(reportText2, style: TextStyle(color: Colors.white)),
    );
  }

  List<Mybuy> dataMybuy;
  List<String> checkBuy = [];
  Future<Null> getMybuy() async {
    checkBuy = [];
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/mybuy";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("responseFeed_follow = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          final String responseString = response.body;

          dataMybuy = mybuyFromJson(responseString);
          for (var item in dataMybuy) {
            print(item.recipeId);
            checkBuy.add(item.recipeId.toString());
          }
        });
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // Persistent AppBar that never scrolls
      backgroundColor: Color(0xFFf3f5f9),
      appBar: AppBar(
        title: Text(data_PostUser == null ? "" : data_PostUser.aliasName),
        elevation: 0.0,
        actions: [
          (data_PostUser == null || data_DataAc == null)
              ? Container()
              : (data_DataAc.userStatus == 0 || (token == "" && token == null))
                  ? Container()
                  : PopupMenuButton(
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(Icons.more_horiz_outlined),
                      )),
                      onSelected: (value) {
                        print(value);
                        if (value == 0) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ReportUser();
                              }).then((value) async {
                            if (value != null) {
                              showDialog(
                                  context: context,
                                  builder: (contex) {
                                    return AlertDialog(
                                        content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("กรุณารอสักครู่...   "),
                                        CircularProgressIndicator()
                                      ],
                                    ));
                                  });

                              AddReport dataAddReport = await addReport(
                                  data_PostUser.userId.toString(),
                                  "user",
                                  null,
                                  "รายงานผู้ใช้",
                                  value[0],
                                  value[1]);

                              Navigator.pop(context);
                              String reportText1;
                              String reportText2;
                              Color color;
                              if (dataAddReport.success == 1) {
                                reportText1 = "รายงานสำเร็จ";
                                reportText2 = "ขอบคุณสำหรับการรายงาน";
                                color = Colors.green;
                              } else {
                                reportText1 = "รายงานไม่สำเร็จ";
                                reportText2 = "โปรดรายงานใหม่ในภายหลัง";
                                color = Colors.red;
                              }
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    Future.delayed(Duration(milliseconds: 1500),
                                        () {
                                      Navigator.of(context).pop(true);

                                      // Navigator.pop(context);
                                    });
                                    return alertDialog_successful_or_unsuccessful(
                                        reportText1, color, reportText2);
                                  });
                              print(
                                  "dataAddReport.success ===>>> ${dataAddReport.success}");
                            }
                          });
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.flag,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('รายงานผู้ใช้'),
                              ],
                            ),
                            value: 0,
                          ),
                        ];
                      })
        ],
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
                            // color: Colors.amber,
                            height: 314,
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: deviceSize.height * 0.4,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            // image: NetworkImage(
                                            //     "https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?size=626&ext=jpg"),
                                             image: new NetworkImage(
                              "https://cdnb.artstation.com/p/assets/images/images/024/538/827/original/pixel-jeff-clipa-s.gif?1582740711"),
                                            fit: BoxFit.cover),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
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
                                              height: 10,
                                            ),
                                            Text(
                                              data_PostUser.aliasName,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              data_PostUser.nameSurname,
                                              style: TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            (checkFollowers == null)
                                                ? MaterialButton(
                                                    splashColor: Colors.grey,
                                                    color: Colors.blue[400],
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
                                                : (checkFollowers
                                                            .checkFollower ==
                                                        0)
                                                    ? MaterialButton(
                                                        splashColor:
                                                            Colors.grey,
                                                        color: Colors.blue[400],
                                                        onPressed: () {
                                                          print("ติดตาม");
                                                          manageFollow(
                                                              "fol",
                                                              this
                                                                  .data_PostUser
                                                                  .userId);

                                                          insertNotificationData(
                                                              data_PostUser
                                                                  .userId
                                                                  .toString(),
                                                              data_DataAc
                                                                  .aliasName,
                                                              "ได้ติดตามคุณ",
                                                              null,
                                                              data_DataAc.userId
                                                                  .toString(),
                                                              "follow");

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
                                                        splashColor:
                                                            Colors.grey,
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
                                                    MainAxisAlignment
                                                        .spaceAround,
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
                                                              color: Colors
                                                                  .white70,
                                                              fontSize: 12),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          data_PostUser
                                                              .countPost
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
                                                        if (token == "") {
                                                          showDialog(
                                                              context: context,
                                                              builder: (_) {
                                                                return LoginPage();
                                                              }).then((value) {
                                                            findUser();
                                                            // Navigator.pop(context);
                                                          });
                                                        } else {
                                                          print("ติดตาม");
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ShowFollowerAndFollowing(
                                                                          index:
                                                                              0,
                                                                          id: this
                                                                              .data_PostUser
                                                                              .userId,
                                                                          name: this
                                                                              .data_PostUser
                                                                              .aliasName,
                                                                        )),
                                                          );
                                                        }
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
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                        if (token == "") {
                                                          showDialog(
                                                              context: context,
                                                              builder: (_) {
                                                                return LoginPage();
                                                              }).then((value) {
                                                            findUser();
                                                            // Navigator.pop(context);
                                                          });
                                                        } else {
                                                          print("กำลังติดตาม");
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ShowFollowerAndFollowing(
                                                                          index:
                                                                              1,
                                                                          id: this
                                                                              .data_PostUser
                                                                              .userId,
                                                                          name: this
                                                                              .data_PostUser
                                                                              .aliasName,
                                                                        )),
                                                          );
                                                        }
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
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                            16.0, 16.0, 8.0, 8.0),
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
                                          ],
                                        ),
                                      ),

                                      //2nd row
                                      GestureDetector(
                                        onTap: () {
                                          print(data_RecipePost[index].price);
                                          if (data_DataAc != null) {
                                            if (data_RecipePost[index].price ==
                                                    0 ||
                                                reqUid == data_DataAc.userId ||
                                                checkBuy.indexOf(
                                                        data_RecipePost[index]
                                                            .rid
                                                            .toString()) >=
                                                    0) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShowFood(
                                                            data_RecipePost[
                                                                    index]
                                                                .rid)),
                                              );
                                            } else {
                                              // print("dataRecommendRecipe.userId = ${dataRecommendRecipe.userId}");
                                              // print("dataUser.userId = ${dataUser.userId}");
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RecipePurchasePage(
                                                          req_rid:
                                                              data_RecipePost[
                                                                      index]
                                                                  .rid,
                                                        )),
                                              ).then((value) {
                                                if (token != "" &&
                                                    token != null) {
                                                  getMybuy();
                                                }
                                              });
                                            }
                                          } else {
                                            if (data_RecipePost[index].price ==
                                                0) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShowFood(
                                                            data_RecipePost[
                                                                    index]
                                                                .rid)),
                                              );
                                            } else {
                                              // print("dataRecommendRecipe.userId = ${dataRecommendRecipe.userId}");
                                              // print("dataUser.userId = ${dataUser.userId}");
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RecipePurchasePage(
                                                          req_rid:
                                                              data_RecipePost[
                                                                      index]
                                                                  .rid,
                                                        )),
                                              ).then((value) {
                                                if (token != "" &&
                                                    token != null) {
                                                  getMybuy();
                                                }
                                              });
                                            }
                                          }
                                        },
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 0, 8, 0),
                                              child: Container(
                                                width: deviceSize.width,
                                                height: 300,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0),
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
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 15, 15, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                      height: 30,
                                                      width: 30,
                                                      child: (data_DataAc ==
                                                              null)
                                                          ? (data_RecipePost[
                                                                          index]
                                                                      .price ==
                                                                  0)
                                                              ? Container()
                                                              : Image.network(
                                                                  "https://image.flaticon.com/icons/png/512/1177/1177428.png")
                                                          : (checkBuy.indexOf(data_RecipePost[
                                                                          index]
                                                                      .rid
                                                                      .toString()) >=
                                                                  0)
                                                              ? Image.network(
                                                                  "https://image.flaticon.com/icons/png/512/1053/1053171.png")
                                                              : (reqUid ==
                                                                          data_DataAc
                                                                              .userId ||
                                                                      (data_RecipePost[index]
                                                                              .price ==
                                                                          0))
                                                                  ? Container()
                                                                  : Image.network(
                                                                      "https://image.flaticon.com/icons/png/512/1177/1177428.png")),
                                                ],
                                              ),
                                            ),
                                            // ),
                                            Positioned(
                                              left: 8.0,
                                              bottom: 0.0,
                                              right: 8.0,
                                              child: Container(
                                                height: 60.0,
                                                width: deviceSize.width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0),
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
                                            Positioned(
                                              left: 18.0,
                                              bottom: 10.0,
                                              child: Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data_RecipePost[index]
                                                            .recipeName,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          RatingBarIndicator(
                                                            rating: data_RecipePost[
                                                                        index]
                                                                    .score,
                                                            itemBuilder:
                                                                (context,
                                                                        index) =>
                                                                    Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            itemCount: 5,
                                                            itemSize: 16.0,
                                                            // direction: Axis.vertical,
                                                          ),
                                                          Text(
                                                            "(คะแนน " +
                                                                (data_RecipePost[
                                                                        index]
                                                                    .score
                                                                    .toString()) +
                                                                ")",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
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
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      // Divider(
                                      //   thickness: 1,
                                      //   color: Colors.grey,
                                      // ),
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
