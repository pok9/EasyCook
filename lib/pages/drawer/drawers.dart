import 'dart:convert';

import 'package:easy_cook/models/notification/getCountVisited/getCountVisitedModel.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/pages/admin/report/reportPage.dart';
import 'package:easy_cook/pages/buyFood_page/purchasedRecipes/purchasedRecipes.dart';
import 'package:easy_cook/pages/drawer/helpCenter/helpCenter.dart';
import 'package:easy_cook/pages/drawer/notification_page/notification.dart';
import 'package:easy_cook/pages/login&register_page/login_page/login.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:easy_cook/slidepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Drawers extends StatefulWidget {
  Drawers({this.token, this.data_MyAccount, this.data_DataAc});
  String token;
  MyAccount data_MyAccount;
  DataMyAccount data_DataAc;

  @override
  _DrawersState createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  @override
  void initState() {
    super.initState();
    if (this.widget.token != "") {
      getCountVisited_function();
    }
  }

  GetCountVisitedModel getCountVisited;
  Future<Null> getCountVisited_function() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjNoti/getCountVisited";

    final response = await http.get(Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer ${this.widget.token}"});
    print("responsegetCountVisited_function = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      final String responseString = response.body;

      getCountVisited = getCountVisitedModelFromJson(responseString);

      setState(() {});
    } else {
      return null;
    }
  }

  //ออกจากเครื่องให้เสร็จ null
  Future<Null> updateTokenExit() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjNoti/updateToken";

    var data = {
      "token_noti": null,
    };

    print(jsonEncode(data));

    final response =
        await http.post(Uri.parse(apiUrl), body: jsonEncode(data), headers: {
      "Authorization": "Bearer ${this.widget.token}",
      "Content-Type": "application/json"
    });
    print("responseUpdateTokenFirebase = ${response.statusCode}");
    print("response.body = ${response.body}");
  }

  Future<Null> setVisited() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjNoti/setVisited";

    final response = await http.post(Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer ${this.widget.token}"});
    setState(() {
      print("responsesetVisited = " + response.statusCode.toString());
      print("responseSetVisited => ${response.body}");
      getCountVisited_function();
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    print("this.widget.token ===>>> ${this.widget.token}");
    print("this.widget.data_DataAc ===>>> ${this.widget.data_DataAc}");
    return Container(
      width: deviceSize.width - 45,
      child: (this.widget.token != "" && this.widget.data_DataAc != null)
          ? Drawer(
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          curve: Curves.linear,
                          type: PageTransitionType.bottomToTop,
                          child: ProfilePage(),
                        ),
                      );
                    },
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: new NetworkImage(
                              "https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?size=626&ext=jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF73AEF5),
                                  const Color(0xFF73AEF5)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: CircleAvatar(
                                radius: 39,
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                    this.widget.data_DataAc.profileImage),
                              ),
                            ),
                          ),
                          //Padding(padding: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
                          Text(
                            this.widget.data_MyAccount.data[0].aliasName,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            this.widget.data_MyAccount.data[0].nameSurname,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.account_box_outlined,
                      color: Colors.blue,
                      size: 25,
                    ),
                    title: Text(
                      'บัญชีของฉัน',
                      style: GoogleFonts.kanit(
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          curve: Curves.linear,
                          type: PageTransitionType.bottomToTop,
                          child: ProfilePage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.folder_open_outlined,
                      color: Colors.blue,
                      size: 25,
                    ),
                    title: Text(
                      'สูตรที่ซื้อ',
                      style: GoogleFonts.kanit(
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                      ),
                      // style: TextStyle(
                      //     fontWeight: FontWeight.w300,
                      //     fontSize: 23,
                      //     color: Colors.black)
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PurchasedRecipes()),
                      );
                    },
                  ),
                  ListTile(
                    leading: (getCountVisited == null)
                        ? Icon(
                            Icons.notifications_none_outlined,
                            color: Colors.blue,
                            size: 25,
                          )
                        : (getCountVisited.countVisit == 0)
                            ? Icon(
                                Icons.notifications_none_outlined,
                                color: Colors.blue,
                                size: 25,
                              )
                            : Stack(
                                children: <Widget>[
                                  new Icon(
                                    Icons.notifications_none_outlined,
                                    color: Colors.blue,
                                    size: 25,
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: new Container(
                                      padding: EdgeInsets.all(1),
                                      decoration: new BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 13,
                                        minHeight: 13,
                                      ),
                                      child: new Text(
                                        getCountVisited.countVisit.toString(),
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                    title: Text(
                      'การแจ้งเตือน',
                      style: GoogleFonts.kanit(
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationPage(
                                  numNotification: getCountVisited.countVisit,
                                )),
                      ).then((value) {
                        setVisited();
                      });
                    },
                  ),
                  (this.widget.data_DataAc.userStatus == 1)
                      ? Container()
                      : ListTile(
                          leading: Icon(
                            Icons.report_outlined,
                            color: Colors.blue,
                            size: 25,
                          ),
                          title: Text(
                            'การรายงานเข้ามา',
                            style: GoogleFonts.kanit(
                              fontSize: 17,
                              fontWeight: FontWeight.w300,
                            ),
                            // style: TextStyle(
                            //     fontWeight: FontWeight.w300,
                            //     fontSize: 23,
                            //     color: Colors.black)
                          ),
                          onTap: () {
                            Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReportPage()),
                      ).then((value) {
                   
                      });
                          },
                        ),
                  (this.widget.data_DataAc.userStatus == 0)
                      ? Container()
                      : ListTile(
                          leading: Icon(
                            Icons.quiz_outlined,
                            color: Colors.blue,
                            size: 25,
                          ),
                          title: Text(
                            'ศูนย์ช่วยเหลือ',
                            style: GoogleFonts.kanit(
                              fontSize: 17,
                              fontWeight: FontWeight.w300,
                            ),

                            //     color: Colors.black)
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HelpCenter()),
                            );
                          },
                        ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Colors.blue,
                      size: 25,
                    ),
                    title: Text(
                      'ตั้งค่า',
                      style: GoogleFonts.kanit(
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                      ),
                      // style: TextStyle(
                      //     fontWeight: FontWeight.w300,
                      //     fontSize: 23,
                      //     color: Colors.black)
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.exit_to_app_outlined,
                      color: Colors.blue,
                      size: 25,
                    ),
                    title: Text(
                      'ออกจากระบบ',
                      style: GoogleFonts.kanit(
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                      ),
                      // style: TextStyle(
                      //     fontWeight: FontWeight.w300,
                      //     fontSize: 23,
                      //     color: Colors.black)
                    ),
                    onTap: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      updateTokenExit();
                      preferences.setString("tokens", "");
                      preferences.setString("email", "");
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SlidePage(),
                          ),
                          (route) => false);
                    },
                  ),
                ],
              ),
            )
          : Drawer(
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 210,
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: new NetworkImage(
                                "https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?size=626&ext=jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return LoginPage();
                                      }).then((value) {
                                    // findUser();
                                  });
                                },
                                child: Text(
                                  'เข้าสู่ระบบ',
                                ),
                                style: ButtonStyle(
                                    side: MaterialStateProperty.all(BorderSide(
                                        width: 2, color: Colors.white)),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 50)),
                                    textStyle: MaterialStateProperty.all(
                                        TextStyle(fontSize: 15)))),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/register-page');
                                },
                                child: Text(
                                  'สมัครสมาชิก',
                                ),
                                style: ButtonStyle(
                                    side: MaterialStateProperty.all(BorderSide(
                                        width: 2, color: Colors.white)),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 43)),
                                    textStyle: MaterialStateProperty.all(
                                        TextStyle(fontSize: 15)))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                      onPressed: () {
                                        _tripEditModalBottomSheet(context);
                                      },
                                      child: Text(
                                        'ลืมรหัสผ่าน',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      )),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

void _tripEditModalBottomSheet(context) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => SingleChildScrollView(
            child: Container(
              color: Color(0xFF737373),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: _buildBottomNavigationMenu(context),
            ),
          ));
}

Container _buildBottomNavigationMenu(context) {
  return Container(

      // height: (MediaQuery.of(context).viewInsets.bottom != 0) ? MediaQuery.of(context).size.height * .60 : MediaQuery.of(context).size.height * .30,
      decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(30),
              topRight: const Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "ลืมรหัสผ่านเหรอ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.blue,
                      size: 25,
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    'ยืนยันอีเมลของคุณแล้วเราจะส่งลิงก์ไปให้เพื่อตั้งรหัสผ่านใหม่',
                    style: TextStyle(fontSize: 15),
                  ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  labelText: 'อีเมล',
                  // hintText: 'อีเมล'ย,
                ),
                autofocus: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                // padding: EdgeInsets.all(20),

                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      _textBottomSheet(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restart_alt_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'รีเซ็ตรหัสผ่าน',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ));
}

void _textBottomSheet(context) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => SingleChildScrollView(
            child: Container(
              color: Color(0xFF737373),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: _textBottomNavigationMenu(context),
            ),
          ));
}

Container _textBottomNavigationMenu(context) {
  return Container(

      // height: (MediaQuery.of(context).viewInsets.bottom != 0) ? MediaQuery.of(context).size.height * .60 : MediaQuery.of(context).size.height * .30,
      decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(30),
              topRight: const Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.blue,
                      size: 25,
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 50,
                    width: 50,
                    child: Image.network(
                        "https://i.pinimg.com/originals/19/38/cd/1938cdac9a1b4bea2df9e31d20273cee.png"))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    'ทางเราได้ทำการส่งอีเมลรีเซ็ตรหัสผ่านไปให้คุณเรียบร้อยแล้ว',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ))
                ],
              ),
            ),
          ],
        ),
      ));
}
