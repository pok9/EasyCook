import 'dart:async';

import 'package:easy_cook/models/feed/newFeedsFollow_model.dart';
import 'package:easy_cook/models/login/login_model.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_cook/models/feed/newFeedsProfile_model.dart';
import 'package:flutter/cupertino.dart';

class FeedFollowPage extends StatefulWidget {
  // FeedFollowPage({Key key}) : super(key: key);

  @override
  _FeedFollowPageState createState() => _FeedFollowPageState();
}

String token = ""; //โทเคน
//user
MyAccount datas;
DataAc dataUser;

//NewfeedsProfile
NewfeedsFollow newfeed;
Feed post;

class _FeedFollowPageState extends State<FeedFollowPage> {
  @override
  void initState() {
    super.initState();

    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");

      if (token != "") {
        getMyAccounts();
        newFeedPosts();
      }
    });
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

        newfeed = newfeedsFollowFromJson(responseString);
        //  post = newfeed.feeds[0];
        // dataUser = datas.data[0];
      });
    } else {
      return null;
    }
  }

  LoginModel login;
  Future<Null> logins(String email, String password) async {
    // final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signin";

    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signin";

    final response = await http
        .post(Uri.parse(apiUrl), body: {"email": email, "password": password});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      login = loginModelFromJson(responseString);
    } else {
      return null;
    }
  }

  TextEditingController _ctrlEmail = TextEditingController(); //email
  TextEditingController _ctrlPassword = TextEditingController(); // password
  final _formKey = GlobalKey<FormState>();

  // String validateEmail(String value) {
  //   // value = "อีเมล หรือ รหัสผ่าน ไม่ถูกต้อง";
  //   if (value.isEmpty) {
  //     return "กรุณากรอก อีเมล";
  //   }
  //   // if (login != null) {
  //   //   if (login.success == 0) {
  //   //     return login.message;
  //   //   }
  //   // }
  //   // else if(value == "อีเมล หรือ รหัสผ่าน ไม่ถูกต้อง"){
  //   //   return value;
  //   // }

  //   return null;
  // }

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  // void _doSomething() async {
  //   Timer(Duration(seconds: 10), () {
  //     _btnController.success();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    // int indexLogin = 1;
    return Scaffold(
      backgroundColor: Color(0xFFf3f5f9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: Text('การติดตาม'),
        ),
      ),
      drawer: (token != "" && dataUser != null)
          ? Container(
              width: deviceSize.width - 45,
              child: Drawer(
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
                                  backgroundImage:
                                      NetworkImage(dataUser.profileImage),
                                ),
                              ),
                            ),
                            //Padding(padding: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
                            Text(
                              datas.data[0].aliasName,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.folder,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      title: Text('สูตรที่ซื้อ',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 23,
                              color: Colors.black)),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      title: Text('การแจ้งเตือน',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 23,
                              color: Colors.black)),
                      onTap: () {},
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.settings,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      title: Text('ตั้งค่า',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 23,
                              color: Colors.black)),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      title: Text('ออกจากระบบ',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 23,
                              color: Colors.black)),
                      onTap: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.setString("tokens", "");
                        // Navigator.pushNamedAndRemoveUntil(context,
                        //     '/slide-page', (Route<dynamic> route) => false);
                        findUser();
                      },
                    ),
                  ],
                ),
              ),
            )
          : Container(
              width: deviceSize.width - 45,
              child: Drawer(
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: new NetworkImage(
                                "https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?size=626&ext=jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      // Navigator.pushNamed(
                                      //     context, '/login-page');
                                      Alert(
                                          context: context,
                                          title: "เข้าสู่ระบบ",
                                          content: Column(
                                            children: <Widget>[
                                              Form(
                                                key: _formKey,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    TextFormField(
                                                      validator: (value) {
                                                        if (value.isEmpty) {
                                                          return "กรุณากรอก อีเมล";
                                                        }

                                                        return null;
                                                      },
                                                      // validator: (value) {
                                                      //   if (value.isEmpty) {
                                                      //     return 'กรุณากรอก อีเมล';
                                                      //   }
                                                      //   // if (login != null) {
                                                      //   //   if (login.success ==
                                                      //   //       0) {
                                                      //   //     return login.message;
                                                      //   //   }
                                                      //   // }
                                                      //   // if (login.success ==
                                                      //   //     0) {
                                                      //   //   if (login.message ==
                                                      //   //       "อีเมล หรือ รหัสผ่าน ไม่ถูกต้อง") {
                                                      //   //     return login.message;
                                                      //   //   }
                                                      //   // }
                                                      //   return null;
                                                      // },

                                                      // onChanged: (String value){
                                                      //   // print(value);
                                                      //   if(value.isEmpty){

                                                      //   }else{
                                                      //     print(value);
                                                      //     return null;
                                                      //   }
                                                      // },
                                                      controller: _ctrlEmail,
                                                      decoration:
                                                          InputDecoration(
                                                        icon: Icon(Icons
                                                            .account_circle),
                                                        labelText: 'อีเมล',
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      // onChanged: (String text){
                                                      //   print(text);
                                                      //   return null;
                                                      // },
                                                      validator: (value) {
                                                        // print(value);
                                                        if (value.isEmpty) {
                                                          return 'กรุณากรอก รหัสผ่าน';
                                                        }
                                                        // if (login != null) {
                                                        //   if (login.success ==
                                                        //       0) {
                                                        //     return login
                                                        //         .message;
                                                        //   }
                                                        // }
                                                        // if (login != null) {
                                                        //   if (login.success ==
                                                        //       0) {
                                                        //     return login.message;
                                                        //   }
                                                        // }
                                                        // if (login.success ==
                                                        //     0) {
                                                        //   return 'รหัสผ่านไม่ถูกต้อง';
                                                        // }

                                                        // if (login.success ==
                                                        //     0) {
                                                        //   // if (login.message
                                                        //   //     .contains(
                                                        //   //         "รหัสผ่านไม่ถูกต้อง")) {
                                                        //   //   return login
                                                        //   //       .message;
                                                        //   // }
                                                        //   return login.message;
                                                        // }
                                                        // if(login.message.contains("รหัสผ่านไม่ถูกต้อง")){
                                                        //   return login.message;
                                                        // }
                                                        // print("5555555595959");
                                                        // print(login.message);
                                                        // print(login.success);

                                                        return null;
                                                      },
                                                      controller: _ctrlPassword,
                                                      obscureText: true,
                                                      decoration:
                                                          InputDecoration(
                                                        icon: Icon(Icons.lock),
                                                        labelText: 'รหัสผ่าน',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 25,
                                              ),

                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: RoundedLoadingButton(
                                                  child: Text('เข้าสู่ระบบ',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  controller: _btnController,
                                                  onPressed: () async {
                                                    if (_formKey.currentState
                                                        .validate()) {
                                                      print(_ctrlEmail.text);
                                                      print(_ctrlPassword.text);

                                                      await logins(
                                                          _ctrlEmail.text,
                                                          _ctrlPassword.text);

                                                      print(login.success);
                                                      print(login.message);

                                                      if (login.success == 1) {
                                                        _btnController
                                                            .success();
                                                        _ctrlEmail.text = "";
                                                        _ctrlPassword.text = "";
                                                        SharedPreferences
                                                            preferences =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        preferences.setString(
                                                            "tokens",
                                                            login.token);
                                                        findUser();
                                                        Navigator.pop(context);
                                                      } else {
                                                        _btnController.reset();
                                                      }

                                                      // validateEmail(_ctrlEmail.text);
                                                      // validateEmail(
                                                      //     "อีเมล หรือ รหัสผ่าน ไม่ถูกต้อง");
                                                      // await logins(
                                                      //     _ctrlEmail.text,
                                                      //     _ctrlPassword.text);
                                                      // print(login.success);
                                                      // if (login.success == 1) {
                                                      //   print(login.token);
                                                      //   _btnController
                                                      //       .success();
                                                      // } else {
                                                      //   print(login.message);
                                                      //   _btnController.reset();
                                                      //   setState(() {});
                                                      // }

                                                      // print("yesssssss");
                                                      // Timer(Duration(), () {
                                                      //   // _btnController.success();
                                                      //   // _btnController.error();
                                                      // });
                                                      //  _btnController.success();

                                                    } else {
                                                      _btnController.reset();
                                                      print("noooooooo");
                                                      print(login.success);
                                                    }
                                                  },
                                                ),
                                              )

                                              // DialogButton(
                                              //   onPressed: () async {

                                              //     print("Login");
                                              //     print(_ctrlEmail.text);
                                              //     print(_ctrlPassword.text);

                                              //     if (_formKey.currentState
                                              //         .validate()) {
                                              //       print("pok");

                                              //       await logins(
                                              //           _ctrlEmail.text,
                                              //           _ctrlPassword.text);
                                              //       print("login.success = " +
                                              //           login.success
                                              //               .toString());
                                              //       // print("login.message = " +
                                              //       //     login.message);
                                              //       // print("login.token = " +
                                              //       //     login.token);

                                              //       if (login.success == 1) {
                                              //         _ctrlEmail.text = "";
                                              //         _ctrlPassword.text = "";
                                              //         SharedPreferences
                                              //             preferences =
                                              //             await SharedPreferences
                                              //                 .getInstance();
                                              //         preferences.setString(
                                              //             "tokens",
                                              //             login.token);
                                              //         findUser();
                                              //         Navigator.pop(context);
                                              //       } else {
                                              //         setState(() {});
                                              //       }
                                              //     }
                                              //   },
                                              //   child: Text(
                                              //     "เข้าสู่ระบบ",
                                              //     style: TextStyle(
                                              //         color: Colors.white,
                                              //         fontSize: 20),
                                              //   ),
                                              // )
                                            ],
                                          ),
                                          buttons: [
                                            DialogButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                "Facebook",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ]).show();
                                    },
                                    child: Text(
                                      'เข้าสู่ระบบ',
                                    ),
                                    style: ButtonStyle(
                                        side: MaterialStateProperty.all(
                                            BorderSide(
                                                width: 2, color: Colors.white)),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
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
                                        side: MaterialStateProperty.all(
                                            BorderSide(
                                                width: 2, color: Colors.white)),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 43)),
                                        textStyle: MaterialStateProperty.all(
                                            TextStyle(fontSize: 15)))),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: Column(
                                children: [
                                  Row(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.folder,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      title: Text('สูตรที่ซื้อ',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 23,
                              color: Colors.black)),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      title: Text('การแจ้งเตือน',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 23,
                              color: Colors.black)),
                      onTap: () {},
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.settings,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      title: Text('ตั้งค่า',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 23,
                              color: Colors.black)),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      title: Text('ออกจากระบบ',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 23,
                              color: Colors.black)),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
      body: (token == "")
          ? Container()
          : (newfeed == null)
              ? AlertDialog(
                  content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("กรุณารอสักครู่...   "),
                    CircularProgressIndicator()
                  ],
                ))
              : ListView.builder(
                  itemCount: newfeed.feeds.length,
                  itemBuilder: (context, index) => index < 0
                      ? new SizedBox(
                          child: AlertDialog(
                              content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("กรุณารอสักครู่...   "),
                              CircularProgressIndicator()
                            ],
                          )),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                                image: new NetworkImage(newfeed
                                                    .feeds[index]
                                                    .profileImage))),
                                      ),
                                      new SizedBox(
                                        width: 10.0,
                                      ),
                                      new Text(
                                        newfeed.feeds[index].aliasName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  new IconButton(
                                      icon: Icon(Icons.more_vert),
                                      onPressed: () {
                                        // print(
                                        //     "more_vert123" + index.toString());
                                      })
                                ],
                              ),
                            ),

                            //2nd row
                            Stack(
                              children: [
                                // Flexible(
                                // fit: FlexFit.loose,
                                GestureDetector(
                                  onTap: () {
                                    // print(newfeed.feeds[index].profileImage.toString());
                                    // Navigator.pushNamed(context, '/showfood-page',arguments: newfeed.feeds[index].rid);
                                    // print(newfeed.feeds[index].);
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                      return ShowFood(newfeed.feeds[index]);
                                    }));
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Container(
                                      width: deviceSize.width,
                                      height: 300,
                                      child: ClipRRect(
                                        borderRadius:
                                            new BorderRadius.circular(24.0),
                                        child: Image(
                                          fit: BoxFit.cover,
                                          // alignment: Alignment.topRight,
                                          image: NetworkImage(
                                              newfeed.feeds[index].image),
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
                                  child: Container(
                                    height: 60.0,
                                    width: deviceSize.width,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          new BorderRadius.circular(24.0),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black,
                                          Colors.black12,
                                        ],
                                        begin: Alignment.bottomCenter,
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
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            newfeed.feeds[index].recipeName,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 16.0,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 16.0,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 16.0,
                                              ),
                                              Icon(
                                                Icons.star_half,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 16.0,
                                              ),
                                              Icon(
                                                Icons.star_border,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 16.0,
                                              ),
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              Text(
                                                "(คะแนน 55)",
                                                style: TextStyle(
                                                    color: Colors.grey),
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

                            //3rd row
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 12.0, 16.0, 12.0),
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
                                      Icon(Icons.share, color: Colors.black),
                                    ],
                                  ),
                                  Icon(Icons.bookmark_border,
                                      color: Colors.black),
                                ],
                              ),
                            ),
                            //5th row
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 0, 16.0, 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  new Container(
                                    height: 40.0,
                                    width: 40.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage(newfeed
                                                .feeds[index].profileImage))),
                                  ),
                                  new SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: new TextField(
                                      keyboardType: TextInputType.multiline,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                "1 วันที่แล้ว",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                ),
      //   floatingActionButton: FloatingActionButton(
      //   onPressed: ()  {

      //   },
      //   child: Icon(Icons.add),
      //   // backgroundColor: Colors.green,
      // ),
    );
  }
}
