import 'dart:convert';

import 'package:easy_cook/models/admin/manage_members_model.dart';
import 'package:easy_cook/models/admin/notification/api_notificationModel.dart';
import 'package:easy_cook/models/admin/notification/getAllTokenNotiModel.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/report/getAllReport_model.dart';
import 'package:easy_cook/models/search/searchUsername_model.dart';
import 'package:easy_cook/pages/admin/report/reportPage.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

      if (token != "" && token != null) {
        getMyAccounts();
        getAllReport();
        getAllTokenNoti();
      }
    });
  }

  //user
  MyAccount datas;
  DataMyAccount dataMyAccount;
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
    dataUser = [];
    final String apiUrl =
        "http://apifood.comsciproject.com/pjUsers/searchUser/" + userName;

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      if (mounted)
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

  //ฟั่งชั่นreportเข้ามา
  List<GetAllReportModel> dateGetAllReport;
  Future<Null> getAllReport() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/getAllReport";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer ${token}"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;
        dateGetAllReport = getAllReportModelFromJson(responseString);
      });
    } else {
      return null;
    }
  }

  Future<Null> deleteReport(String report_ID) async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/deleteReport";

    var data = {
      "report_ID": report_ID,
    };

    print(jsonEncode(data));
    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    print("deleteReport_response.statusCode ==>> ${response.statusCode}");
    print("deleteReport_response.body ==>> ${response.body}");
  }

  String typeReportName;

  var _ctrlNoti = TextEditingController(); //อธิบายสูตรอาหาร
  bool clear_ctrlNoti = true;

  //ฟั่งชั่นgetTokenNoti ที่ผ้ใช้ login
  GetAllTokenNotiModel dataAllTokenNoti;
  Future<Null> getAllTokenNoti() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjNoti/getAllTokenNoti";

    final response = await http.get(
      Uri.parse(apiUrl),
    );
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;
        dataAllTokenNoti = getAllTokenNotiModelFromJson(responseString);
      });
    } else {
      return null;
    }
  }

  Future<ApiNotificationModel> addIngredients(String body) async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjNoti/api_notification";

    // List<st>
    var data = {
      "token_noti": dataAllTokenNoti.tokenNoti,
      "title": "Easy Food",
      "body": body,
      "state": "multiple"
    };

    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data), headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      return apiNotificationModelFromJson(responseString);
    } else {
      return null;
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf3f5f9),
      appBar: AppBar(
        title: Text('จัดการสมาชิก'),
      ),
      body: DefaultTabController(
        length: 3,
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
                      // indicator: UnderlineTabIndicator(
                      //   borderSide: BorderSide(color: Colors.blue, width: 4),
                      //   insets: EdgeInsets.symmetric(horizontal: 20),
                      // ),
                      tabs: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: new Text(
                            "รายงาน",
                            maxLines: 1,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: new Text(
                            "จัดการสมาชิก",
                            maxLines: 1,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: new Text(
                            "แจ้งเตือนแอป",
                            maxLines: 1,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.black),
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
            Container(
              child: Scaffold(
                body: DefaultTabController(
                  length: 3,
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
                                indicatorColor: Colors.pink,
                                tabs: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.food_bank,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Expanded(
                                          child: new Text(
                                            "สูตรอาหาร",
                                            maxLines: 1,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Expanded(
                                          child: new Text(
                                            "ผู้ใช้",
                                            maxLines: 1,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.comment,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Expanded(
                                          child: new Text(
                                            "คอมเมนต์",
                                            maxLines: 1,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        (dateGetAllReport == null)
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : reportEverything("food"),
                        (dateGetAllReport == null)
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : reportEverything("user"),
                        (dateGetAllReport == null)
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : reportEverything("comment"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
                              if (dataUser[index].accessStatus == 0) {
                                return Container();
                              } else
                                return ListTile(
                                  onTap: () {
                                    if (dataMyAccount.userId ==
                                        dataUser[index].userId) {
                                      Navigator.push(context,
                                          CupertinoPageRoute(
                                              builder: (context) {
                                        return ProfilePage();
                                      }));
                                    } else {
                                      Navigator.push(context,
                                          CupertinoPageRoute(
                                              builder: (context) {
                                        return ProfileUser(
                                          reqUid: dataUser[index].userId,
                                        );
                                      }));
                                    }
                                  },
                                  title: Text(
                                      "${dataUser[index].nameSurname}(${dataUser[index].aliasName})"),
                                  subtitle: Text(dataUser[index].email),
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
                                  trailing: (dataUser[index].userStatus == 0)
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
                                                  nameSurname: dataUser[index]
                                                      .nameSurname,
                                                  email: dataUser[index].email,
                                                  getSearchUserNames:
                                                      getSearchUserNames(
                                                          searchUser),
                                                );
                                              },
                                            ).then((value) {
                                              if (value != null) {
                                                for (var item in dataUser) {
                                                  print(item.email);
                                                }
                                                print("=====================");
                                                dataUser.removeWhere(
                                                    (element) =>
                                                        element.email ==
                                                        dataUser[index].email);
                                                for (var item in dataUser) {
                                                  print(item.email);
                                                }
                                                print("=====================");
                                                // print(dataUser.length);
                                                if (mounted) {
                                                  setState(() {});
                                                }
                                              }

                                              // print("555555BBBB");
                                              // getSearchUserNames(searchUser);
                                              // if (mounted) setState(() {});
                                            });
                                          },
                                          child: Text(
                                            'แบน!',
                                            style:
                                                TextStyle(color: Colors.white),
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
                  ),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: TextFormField(
                        controller: _ctrlNoti,
                        // maxLength: 60,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*กรุณากรอกข้อความ';
                          }
                          return null;
                        },
                        minLines: 10,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          suffixIcon: (clear_ctrlNoti)
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 170),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _ctrlNoti.text = "";
                                        clear_ctrlNoti = true;
                                      });
                                    },
                                    icon: Icon(Icons.clear),
                                  ),
                                ),
                          filled: true,
                          fillColor: Color(0xfff3f3f4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "แจ้งเตือนแอป",
                          hintStyle:
                              TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (value.length > 0) {
                              clear_ctrlNoti = false;
                            } else {
                              clear_ctrlNoti = true;
                            }
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 50.0,
                      child: GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            showDialog(
                                context: context,
                                builder: (contex) {
                                  return AlertDialog(
                                      content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("กรุณารอสักครู่...   "),
                                      CircularProgressIndicator()
                                    ],
                                  ));
                                });
                            ApiNotificationModel apiNotificationModel =
                                await addIngredients(_ctrlNoti.text);
                            Navigator.pop(context);
                            _ctrlNoti.text = "";
                            clear_ctrlNoti = true;

                            if (apiNotificationModel.success == 1) {
                              Fluttertoast.showToast(
                                  msg: "ส่งแจ้งเตือนเรียบร้อย",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "มีข้อผิดพลาดโปรดส่งใหม่ในภายหลัง",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }

                            setState(() {});
                          }

                          // print(
                          //     "apiNotificationModel.success => ${apiNotificationModel.success}");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFF05A22),
                              style: BorderStyle.solid,
                              width: 1.0,
                            ),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  "ส่งแจ้งเตือน",
                                  style: TextStyle(
                                    color: Color(0xFFF05A22),
                                    fontFamily: 'Montserrat',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  String dateEdit(String date) {
    //data
    Map<String, String> map = {
      '01': "มกราคม",
      '02': "กุมภาพันธ์",
      '03': "มีนาคม",
      '04': "เมษายน",
      '05': "พฤษภาคม",
      '06': "มิถุนายน",
      '07': "กรกฎาคม",
      '08': "สิงหาคม",
      '09': "กันยายน",
      '10': "ตุลาคม",
      '11': "พฤศจิกายน",
      '12': "ธันวาคม"
    };
    List<String> dateTimeSp = date.split(" ");
    List<String> dateSp = dateTimeSp[0].split("-");

    //time
    List timeSp = dateTimeSp[1].split(".");
    List time = timeSp[0].split(":");

    String text =
        "${int.parse(dateSp[2])} ${map[dateSp[1]]} ${dateSp[0]} เวลา ${time[0]}:${time[1]} น.";
    return text;
  }

  Widget reportEverything(String typeNameReport) {
    return ListView.builder(
        //  reverse: true,
        shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        // scrollDirection: Axis.v,
        itemCount: dateGetAllReport.length,
        itemBuilder: (context, index) {
          if (dateGetAllReport[index].typeReport == typeNameReport) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
              child: Card(
                color: Colors.white,
                margin: EdgeInsets.all(1),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    // leading: FlutterLogo(size: 72.0),
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              dateGetAllReport[index].profileUserReport),
                        ),
                      ],
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        dateGetAllReport[index].nameUserReport,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Text(
                        "${dateGetAllReport[index].title}\n\n${dateEdit(dateGetAllReport[index].datetime.toString())}"),
                    trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: new Text("ลบรายงาน"),
                                content:
                                    new Text("ลบรายงานผู้ใช้โดยถาวรใช่ไหม"),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new TextButton(
                                    child: new Text("ยกเลิก"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  new TextButton(
                                    child: new Text("ลบ"),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await deleteReport(dateGetAllReport[index]
                                          .reportId
                                          .toString());

                                      await getAllReport();
                                      final snackBar = SnackBar(
                                        duration: Duration(milliseconds: 1400),
                                        content:
                                            const Text('ลบรายงานเรียบร้อยแล้ว'),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.delete_forever,
                          color: Colors.blueAccent,
                        )),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReportPage(
                                  report_ID: dateGetAllReport[index]
                                      .reportId
                                      .toString(),
                                )),
                      );
                    },
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        });
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
      this.email,
      this.getSearchUserNames});

  final String title, description, token, image, aliasName, nameSurname, email;
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

    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    print(response.body);
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
            height: 60.0,
            width: 60.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(this.widget.image))),
          ),
          SizedBox(height: 15),
          Text(this.widget.aliasName),
          Text(this.widget.nameSurname),
          Text(this.widget.email),
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
                Navigator.pop(context, "success");

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
