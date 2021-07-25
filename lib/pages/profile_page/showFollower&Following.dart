import 'package:easy_cook/models/checkFollower_checkFollowing/checkFollower_model.dart';
import 'package:easy_cook/models/checkFollower_checkFollowing/checkFollowing_model.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:easy_cook/pages/profile_page/xxx_profile.dart';
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
      getMyAccounts();
      getFollower();
      getFollowing();
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
  Future<Null> getFollowing() async {
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
      });
    } else {
      return null;
    }
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
            (checkFollower == null)
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
            (checkFollowing == null)
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
                              }));
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
                            trailing: OutlinedButton(
                              onPressed: () {},
                              child: Text('กำลังติดตาม'),
                              style: OutlinedButton.styleFrom(
                                primary: Colors.blue,
                                backgroundColor: Colors.white,
                                side: BorderSide(width: 0, color: Colors.blue),
                              ),
                            ),
                          ),
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
