import 'dart:convert';

import 'package:easy_cook/models/admin/manage_members_model.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/search/searchUsername_model.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageMembers extends StatefulWidget {
  // const ManageMembers({ Key? key }) : super(key: key);

  @override
  _ManageMembersState createState() => _ManageMembersState();
}

class _ManageMembersState extends State<ManageMembers> {
  @override
  void initState() {
    super.initState();
    findUser();
  }

  String token = ""; //โทเคน
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");

      if (token != "") {
        getMyAccounts();
      }
    });
  }

  //user
  MyAccount datas;
  DataAc dataMyAccount;
  Future<Null> getMyAccounts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        datas = myAccountFromJson(responseString);
        dataMyAccount = datas.data[0];
      });
    } else {
      return null;
    }
  }

  //ข้อมูลผู้ใช้
  List<DataUser> dataUser;
  Future<Null> getSearchUserNames(String userName) async {
    print("55556656565656565656565656665656");
    dataUser = [];
    final String apiUrl =
        "http://apifood.comsciproject.com/pjUsers/searchUser/" + userName;

    final response = await http.get(Uri.parse(apiUrl));

    
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        // dataRecipe = searchRecipeNameFromJson(responseString).data;
        dataUser = searchUserNameFromJson(responseString).data;
      });
    } else {
      // flag = true;
      return null;
    }
  }

  String searchUser = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('จัดการสมาชิก'),
      ),
      body: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: new Container(
              color: Colors.white70,
              child: new SafeArea(
                child: Column(
                  children: <Widget>[
                    new Expanded(child: new Container()),
                    new TabBar(
                      tabs: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Text(
                            "จัดการสมาชิก",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(children: [
            (dataMyAccount == null)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (text) {
                              if (text != "") {
                                getSearchUserNames(text);
                                searchUser = text;
                              } else {
                                setState(() {
                                  dataUser = [];
                                });
                              }
                            },
                            decoration: InputDecoration(
                                labelText: "ค้นหา",
                                hintText: "ค้นหา",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.0)))),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: (dataUser == null) ? 0 : dataUser.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  if (dataMyAccount.userId ==
                                      dataUser[index].userId) {
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                      return ProfilePage();
                                    }));
                                  } else {
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                      return ProfileUser(
                                        dataUser[index].userId,
                                      );
                                    }));
                                  }
                                },
                                title: Text(dataUser[index].aliasName),
                                subtitle: Text(dataUser[index].nameSurname),
                                leading: Container(
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: new NetworkImage(
                                              dataUser[index].profileImage))),
                                ),
                                trailing: (dataMyAccount.userId ==
                                        dataUser[index].userId)
                                    ? null
                                    : OutlinedButton(
                                        onPressed: () {
                                          showDialog(
                                            barrierColor: Colors.black26,
                                            context: context,
                                            builder: (context) {
                                              return CustomAlertDialog(
                                                title: "จัดการสมาชิก",
                                                description:
                                                    "คุณแน่ใจใช่ไหมที่จะจัดการสมาชิกนี้",
                                                token: token,
                                                uid: dataUser[index].userId,
                                                image: dataUser[index]
                                                    .profileImage,
                                                aliasName:
                                                    dataUser[index].aliasName,
                                                nameSurname:
                                                    dataUser[index].nameSurname,
                                                    getSearchUserNames: getSearchUserNames(searchUser),
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          'Ban',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          primary: Colors.black,
                                          backgroundColor: Colors.red,
                                          side: BorderSide(
                                              width: 0, color: Colors.grey),
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
          ]),
        ),
      ),
    );
  }
}

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog(
      {this.title,
      this.description,
      this.token,
      this.uid,
      this.image,
      this.aliasName,
      this.nameSurname,
      this.getSearchUserNames});

  final String title, description, token, image, aliasName, nameSurname;
  final int uid;

  final Future<Null> getSearchUserNames;
  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  Future<ManageMembersModel> ManageMembers(String uid, String token) async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/banUser";

    var data = {
      "user_ID": uid,
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

      return manageMembersModelFromJson(responseString);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 15),
          Text(
            "${widget.title}",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Container(
            height: 40.0,
            width: 40.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(this.widget.image))),
          ),
          SizedBox(height: 15),
          Text(this.widget.aliasName),
          Text(this.widget.nameSurname),
          SizedBox(height: 15),
          Text(
            "${widget.description}",
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 20),
          Divider(
            height: 1,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              highlightColor: Colors.grey[200],
              onTap: () async {
                Navigator.pop(context);

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("กรุณารอสักครู่...   "),
                        CircularProgressIndicator()
                      ],
                    ));
                  },
                );

                ManageMembersModel manageMembersModel = await ManageMembers(
                    this.widget.uid.toString(), this.widget.token);

                Navigator.pop(context);

                print(this.widget.uid);

                if (manageMembersModel.success == 1) {
                  print("1111111112");
                  this.widget.getSearchUserNames;
                  print("222222222223");
                  showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                            title: "แบนสำเร็จ",
                            description: "คุณได้ทำการแบนสมาชิกเรียบร้อย",
                            image:
                                'https://i.pinimg.com/originals/06/ae/07/06ae072fb343a704ee80c2c55d2da80a.gif',
                            colors: Colors.lightGreen,
                            index: 1,
                          ));
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                            title: "แบนไม่สำเร็จ",
                            description: "มีบางอย่างผิดพลาด",
                            image:
                                'https://media2.giphy.com/media/JT7Td5xRqkvHQvTdEu/200w.gif?cid=82a1493b44ucr1schfqvrvs0ha03z0moh5l2746rdxxq8ebl&rid=200w.gif&ct=g',
                            colors: Colors.redAccent,
                            index: 0,
                          ));
                }
              },
              child: Center(
                child: Text(
                  "ยืนยัน",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
              highlightColor: Colors.grey[200],
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text(
                  "ยกเลิก",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText, image;
  final Color colors;
  final int index;
  final int rid;

  CustomDialog(
      {this.title,
      this.description,
      this.buttonText,
      this.image,
      this.colors,
      this.index,
      this.rid});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 100, bottom: 16, left: 16, right: 16),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                description,
                style: TextStyle(color: Colors.grey.shade800, fontSize: 16.0),
              ),
              SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: colors,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if (index == 1) {
                        // Navigator.pop(context);
                        print("1111111111111111");
                      } else {
                        // Navigator.pop(context);
                        print("222222222222222");
                      }
                    },
                    child: Text(
                      "เข้าใจแล้ว",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 50,
            backgroundImage: NetworkImage(this.image),
          ),
        )
      ],
    );
  }
}
