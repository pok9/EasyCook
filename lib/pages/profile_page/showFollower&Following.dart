import 'dart:convert';

import 'package:easy_cook/models/checkFollower_checkFollowing/checkFollower_model.dart';
import 'package:easy_cook/models/checkFollower_checkFollowing/checkFollowing_model.dart';
import 'package:easy_cook/models/follow/manageFollow_model.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';

import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShowFollowerAndFollowing extends StatefulWidget {
  int index;
  int id;
  String name;

  ShowFollowerAndFollowing({this.index, this.id, this.name});

  @override
  _ShowFollowerAndFollowingState createState() =>
      _ShowFollowerAndFollowingState();
}

class _ShowFollowerAndFollowingState extends State<ShowFollowerAndFollowing> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  String token = ""; //โทเคน
  //ดึง token
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("tokens");
      if (token != "") {
        getMyAccounts();
        getFollower();
        getFollowing();
      }
    });
  }

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
      });
    } else {
      return null;
    }
  }

  CheckFollower checkFollower;
  Future<Null> getFollower() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjFollow/checkFollower/${this.widget.id}";

    print("apiUrl = ${apiUrl}");

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        checkFollower = checkFollowerFromJson(responseString);
      });
    } else {
      return null;
    }
  }

  CheckFollowing checkFollowing;
  List<String> checkFollowingList = [];
  Future<Null> getFollowing() async {
    checkFollowingList = [];
    final String apiUrl =
        "http://apifood.comsciproject.com/pjFollow/checkFollowing/${this.widget.id}";

    print("apiUrl = ${apiUrl}");

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        checkFollowing = checkFollowingFromJson(responseString);

        for (var item in checkFollowing.user) {
          checkFollowingList.add(item.userId.toString());
        }
        print(checkFollowingList);
        getFollowerUser();
      });
    } else {
      return null;
    }
  }

  CheckFollower checkFollowerUser;
  List<int> checkFollowerList;
  Future<Null> getFollowerUser() async {
    //เช็คว่า User ติดตามเราไหม
    checkFollowerList = [];
    for (int i = 0; i < checkFollowingList.length; i++) {
      final String apiUrl =
          "http://apifood.comsciproject.com/pjFollow/checkFollower/${checkFollowingList[i]}";

      print("apiUrl = ${apiUrl}");

      final response = await http
          .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
      print("response = " + response.statusCode.toString());
      if (response.statusCode == 200) {
        setState(() {
          final String responseString = response.body;

          checkFollowerUser = checkFollowerFromJson(responseString);
          checkFollowerList.add(checkFollowerUser.checkFollower);
        });
      } else {
        return null;
      }
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
        // getFollowerUser();
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

  @override
  Widget build(BuildContext context) {
   
    return DefaultTabController(
      length: 2,
      initialIndex: this.widget.index,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text:
                    'ติดตาม ${checkFollower == null ? "" : checkFollower.count.toString() + " คน"}',
              ),
              Tab(
                text:
                    'กำลังติดตาม ${checkFollowing == null ? "" : checkFollowing.count.toString() + " บัญชี"}',
              ),
            ],
          ),
          title: Text(this.widget.name),
        ),
        body: TabBarView(
          children: [
            (checkFollower == null || data_DataAc == null)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      CircularProgressIndicator()
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(4, 20, 0, 0),
                    child: ListView.builder(
                      itemCount: checkFollower.count,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (checkFollower.user[index].userId ==
                                data_DataAc.userId) {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return ProfilePage();
                              }));
                            } else {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return ProfileUser(
                                  checkFollower.user[index].userId,
                                );
                              }));
                            }
                          },
                          child: ListTile(
                            title: Text(checkFollower.user[index].aliasName),
                            subtitle:
                                Text(checkFollower.user[index].nameSurname),
                            leading: Container(
                              height: 50.0,
                              width: 50.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(checkFollower
                                          .user[index].profileImage))),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            (checkFollowing == null || checkFollowerList == null || data_DataAc == null)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      CircularProgressIndicator()
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(4, 20, 0, 0),
                    child: ListView.builder(
                      itemCount: checkFollowing.count,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (checkFollowing.user[index].userId ==
                                data_DataAc.userId) {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return ProfilePage();
                              }));
                            } else {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return ProfileUser(
                                  checkFollowing.user[index].userId,
                                );
                              })).then((value) => getFollowerUser());
                            }
                          },
                          child: ListTile(
                              title: Text(checkFollowing.user[index].aliasName),
                              subtitle:
                                  Text(checkFollowing.user[index].nameSurname),
                              leading: Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(checkFollowing
                                            .user[index].profileImage))),
                              ),
                              trailing: (checkFollowing.user[index].userId ==
                                data_DataAc.userId) ? null :(checkFollowerList.length !=
                                          checkFollowingList.length ||
                                      checkFollowerList[index] == 1)
                                  ? OutlinedButton(
                                      onPressed: () {
                                        checkFollowerList[index] = 0;
                                        print("ยกเลิกติดตาม");
                                        manageFollow("unfol",
                                            checkFollowing.user[index].userId);
                                      },
                                      child: Text('กำลังติดตาม'),
                                      style: OutlinedButton.styleFrom(
                                        primary: Colors.black,
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                            width: 0, color: Colors.grey),
                                      ),
                                    )
                                  : OutlinedButton(
                                      onPressed: () {
                                        

                                        print("ติดตาม");
                                        checkFollowerList[index] = 1;
                                        manageFollow("fol",
                                            checkFollowing.user[index].userId);

                                        insertNotificationData(
                                            checkFollowing.user[index].userId
                                                .toString(),
                                            data_DataAc.aliasName,
                                            "ได้ติดตามคุณ",
                                            null,
                                            data_DataAc.userId.toString(),
                                            "follow");
                                      },
                                      child: Text('     ติดตาม     '),
                                      style: OutlinedButton.styleFrom(
                                        primary: Colors.white,
                                        backgroundColor: Colors.blue,
                                        side: BorderSide(
                                            width: 0, color: Colors.blue),
                                      ),
                                    )),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
