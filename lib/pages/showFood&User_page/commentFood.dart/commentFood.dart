import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/report/addReport/addReport_model.dart';
import 'package:easy_cook/models/showfood/commentFood_model/commentPost_model.dart';
import 'package:easy_cook/models/showfood/commentFood_model/deleteComment_model.dart';
import 'package:easy_cook/models/showfood/commentFood_model/getCommentPost_model.dart';
import 'package:easy_cook/models/showfood/showfood_model.dart';
import 'package:easy_cook/pages/login&register_page/login_page/login.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:easy_cook/pages/showFood&User_page/reportFood&User&Commnt/reportComment.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommentFood extends StatefulWidget {
  ShowFoods dataFood;
  bool autoFocus;
  CommentFood({this.dataFood, this.autoFocus});

  @override
  _CommentFoodState createState() => _CommentFoodState();
}

class _CommentFoodState extends State<CommentFood> {
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    findUser();
    getCommentPosts();
  }

  String token = ""; //โทเคน
  //ดึง token
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");

      getMyAccounts();
    });
  }

  //user
  MyAccount data_MyAccount;
  DataMyAccount data_DataAc;
  Future<Null> getMyAccounts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      final String responseString = response.body;

      data_MyAccount = myAccountFromJson(responseString);
      data_DataAc = data_MyAccount.data[0];
      print(data_DataAc.userId);

      setState(() {});
    } else {
      return null;
    }
  }

  List<GetCommentPostModel> dataGetCommentPost;
  Future<Null> getCommentPosts() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/getComment/" +
            this.widget.dataFood.rid.toString();

    final response = await http.get(Uri.parse(apiUrl));
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        dataGetCommentPost = getCommentPostModelFromJson(responseString);
      });
    } else {
      return null;
    }
  }

  Future<CommentPostModel> CommentPost(
      String recipe_ID, String commentDetail, String token) async {
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/commentPost";

    var data = {
      "recipe_ID": recipe_ID,
      "commentDetail": commentDetail,
    };

    print(jsonEncode(data));
    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    if (response.statusCode == 200) {
      final String responseString = response.body;

      return commentPostModelFromJson(responseString);
    } else {
      return null;
    }
  }

  Future<DeleteCommentModel> deleteComment(int cid) async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/deleteComment";

    var data = {
      "cid": cid,
    };

    print(jsonEncode(data));
    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;
        print(responseString);
        return deleteCommentModelFromJson(responseString);
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

  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("แสดงความคิดเห็น"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: ListView(
              children: [
                (dataGetCommentPost == null || data_DataAc == null)
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        // scrollDirection: Axis.horizontal,
                        itemCount: (dataGetCommentPost == null)
                            ? 0
                            : dataGetCommentPost.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              if (data_DataAc == null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileUser(
                                            reqUid: dataGetCommentPost[index]
                                                .userId,
                                          )),
                                );
                              } else if ((data_DataAc.userId ==
                                  dataGetCommentPost[index].userId)) {
                                Navigator.push(context,
                                    CupertinoPageRoute(builder: (context) {
                                  return ProfilePage();
                                }));
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileUser(
                                            reqUid: dataGetCommentPost[index]
                                                .userId,
                                          )),
                                );
                              }
                            },
                            isThreeLine: true,
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  dataGetCommentPost[index].profileImage),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Text(
                                dataGetCommentPost[index].aliasName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: (dataGetCommentPost[index]
                                                .userStatus ==
                                            0)
                                        ? Colors.red
                                        : (dataGetCommentPost[index].userId ==
                                                data_DataAc.userId)
                                            ? Colors.blue
                                            : Colors.black),
                              ),
                            ),
                            subtitle: Text(
                              '${dataGetCommentPost[index].datetime}\n\n${dataGetCommentPost[index].commentDetail}',
                              // textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontFamily: 'OpenSans',
                                fontSize: 12,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            dense: true,
                            trailing: (data_DataAc == null)
                                ? null
                                : (dataGetCommentPost[index].userId ==
                                        data_DataAc.userId)
                                    ? IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    // ListTile(
                                                    //   leading:
                                                    //       Icon(Icons.edit),
                                                    //   title: Text("แก้ไข"),
                                                    //   onTap: () {},
                                                    // ),
                                                    ListTile(
                                                      leading:
                                                          Icon(Icons.delete),
                                                      title: Text("ลบ"),
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            // return object of type Dialog
                                                            return AlertDialog(
                                                              title: new Text(
                                                                  "ลบความคิดเห็น"),
                                                              content: new Text(
                                                                  "ลบความคิดเห็นโดยถาวรใช่ไหม"),
                                                              actions: <Widget>[
                                                                // usually buttons at the bottom of the dialog
                                                                new TextButton(
                                                                  child: new Text(
                                                                      "ยกเลิก"),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                                new TextButton(
                                                                  child:
                                                                      new Text(
                                                                          "ลบ"),
                                                                  onPressed:
                                                                      () async {
                                                                    await deleteComment(
                                                                        dataGetCommentPost[index]
                                                                            .cid);
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pop(
                                                                        context);

                                                                    final snackBar =
                                                                        SnackBar(
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              1400),
                                                                      content:
                                                                          const Text(
                                                                              'ลบความคิดเห็นแล้ว'),
                                                                    );

                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            snackBar);

                                                                    getCommentPosts();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Colors.blue,
                                        ))
                                    : (dataGetCommentPost[index].userStatus ==
                                            0)
                                        ? null
                                        : IconButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        ListTile(
                                                          leading: Icon(Icons
                                                              .flag_outlined),
                                                          title: Text("รายงาน"),
                                                          onTap: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return ReportComment();
                                                                }).then((value) async {
                                                              if (value !=
                                                                  null) {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (contex) {
                                                                      return AlertDialog(
                                                                          content:
                                                                              Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                              "กรุณารอสักครู่...   "),
                                                                          CircularProgressIndicator()
                                                                        ],
                                                                      ));
                                                                    });

                                                                AddReport dataAddReport = await addReport(
                                                                    dataGetCommentPost[
                                                                            index]
                                                                        .userId
                                                                        .toString(),
                                                                    "comment",
                                                                    null,
                                                                    "รายงานการแสดงความคิดเห็นของผู้ใช้",
                                                                    value[0],
                                                                    value[1]);

                                                                Navigator.pop(
                                                                    context);
                                                                String
                                                                    reportText1;
                                                                String
                                                                    reportText2;
                                                                Color color;
                                                                if (dataAddReport
                                                                        .success ==
                                                                    1) {
                                                                  reportText1 =
                                                                      "รายงานสำเร็จ";
                                                                  reportText2 =
                                                                      "ขอบคุณสำหรับการรายงาน";
                                                                  color = Colors
                                                                      .green;
                                                                } else {
                                                                  reportText1 =
                                                                      "รายงานไม่สำเร็จ";
                                                                  reportText2 =
                                                                      "โปรดรายงานใหม่ในภายหลัง";
                                                                  color = Colors
                                                                      .red;
                                                                }
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      Future.delayed(
                                                                          Duration(
                                                                              milliseconds: 1500),
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop(true);
                                                                        Navigator.pop(
                                                                            context);

                                                                        // Navigator.pop(context);
                                                                      });
                                                                      return alertDialog_successful_or_unsuccessful(
                                                                          reportText1,
                                                                          color,
                                                                          reportText2);
                                                                    });
                                                                print(
                                                                    "dataAddReport.success ===>>> ${dataAddReport.success}");
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            icon: Icon(Icons.more_vert),
                                          ),
                            // trailing: Text('Horse'),
                          );
                        })
              ],
            )),
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  (data_DataAc == null)
                      ? CircleAvatar(
                          child: Icon(Icons.account_box_outlined),
                        )
                      : CircleAvatar(
                          backgroundImage:
                              NetworkImage(data_DataAc.profileImage),
                        ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: TextFormField(
                    onChanged: (value) {
                      if (!value.isEmpty) {
                        if (_formKey.currentState.validate()) {}
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรอกข้อความแสดงความคิดเห็น';
                      }
                      return null;
                    },
                    onTap: () {
                      if (token == "") {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return LoginPage();
                            }).then((value) {
                          if (value != null) {
                            this.findUser();
                          }

                          // Navigator.pop(context);
                        });
                      }
                    },
                    controller: commentController,
                    autofocus: this.widget.autoFocus,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        // contentPadding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 20),
                        hintText: "แสดงความคิดเห็น...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40))),
                  )),
                  TextButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          if (token == "") {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return LoginPage();
                                }).then((value) {
                              if (value != null) {
                                this.findUser();
                              }

                              // Navigator.pop(context);
                            });
                          } else {
                            print("โพส");
                            print(commentController.text);
                            CommentPostModel commentPostModel =
                                await CommentPost(
                                    this.widget.dataFood.rid.toString(),
                                    commentController.text,
                                    token);

                            if (commentPostModel.success == 1) {
                              getCommentPosts();
                              if (data_DataAc.userId !=
                                  this.widget.dataFood.userId) {
                                insertNotificationData(
                                    this.widget.dataFood.userId.toString(),
                                    data_DataAc.aliasName,
                                    "ได้ทำการคอมเมนต์สูตรอาหาร ${this.widget.dataFood.recipeName} ของคุณ",
                                    this.widget.dataFood.rid.toString(),
                                    data_DataAc.userId.toString(),
                                    "comment");
                              }

                              commentController.text = "";
                            }
                          }
                        }
                      },
                      child: Text("โพสต์"))
                  // CircleAvatar(
                  //     child: IconButton(onPressed: () {}, icon: Icon(Icons.send)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
