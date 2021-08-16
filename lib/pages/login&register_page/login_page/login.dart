// import 'dart:html';

// import 'dart:io';

import 'dart:convert';

import 'package:easy_cook/models/login/login_model.dart';
import 'package:easy_cook/slidepage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  int close;
  LoginPage({this.close});

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _ctrlEmail = TextEditingController(); //email
  TextEditingController _ctrlPassword = TextEditingController(); // password

  final _formKey = GlobalKey<FormState>(); //การตรวจสอบความถูกต้อง

  ButtonState stateOnlyText = ButtonState.idle;

  String textFail = "";
  Widget buildCustomButton() {
    var progressTextButton = ProgressButton(
      stateWidgets: {
        ButtonState.idle: Text(
          "เข้าสู่ระบบ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.loading: Text(
          "กรุณารอสักครู่",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.fail: Text(
          textFail,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.success: Text(
          "เข้าสู่ระบบสำเร็จ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        )
      },
      stateColors: {
        ButtonState.idle: Colors.blue,
        ButtonState.loading: Colors.blue.shade300,
        ButtonState.fail: Colors.red.shade300,
        ButtonState.success: Colors.green.shade400,
      },
      onPressed: onPressedCustomButton,
      state: stateOnlyText,
      padding: EdgeInsets.all(8.0),
      radius: 5.0,
    );
    return progressTextButton;
  }

  _getCloseButton(context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        alignment: FractionalOffset.topRight,
        child: GestureDetector(
          child: Icon(
            Icons.clear,
            color: Colors.grey,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  LoginModel login;
  Future<Null> logins(String email, String password) async {
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

  bool hidePassword = true;

  String test = "";

  getTokenFirebase(String token) async {
    String tokenFirebase = await FirebaseMessaging.instance.getToken(
        vapidKey:
            "BC5Y9rRxIQizOB9jx5GuFuK9HK-XkB0NreHveINUNby-tvNdZklyAI0tY_P4u50aYhEcvQW65lzaEdPJF3rygzw");
    print("tokenFirebaseLogin ===>>> $tokenFirebase");
    updateTokenLogin(tokenFirebase, token);
  }

  Future<Null> updateTokenLogin(String tokenFirebase, String token) async {
    print("tokenFirebase = ${tokenFirebase} ; token = ${token}");
    final String apiUrl = "http://apifood.comsciproject.com/pjNoti/updateToken";

    var data = {
      "token_noti": tokenFirebase,
    };

    print(data);

    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });
    print("responseUpdateTokenFirebase = ${response.statusCode}");
    print("response.body = ${response.body}");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min, //autoSize
        children: [
          (this.widget.close == null) ? _getCloseButton(context) : Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'เข้าสู่ระบบ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
          Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'กรุณากรอก อีเมล';
                      }

                      // if (login != null) {
                      //   if (login.success == 0) {
                      //     return login.message;
                      //   }
                      // }

                      return null;
                    },
                    controller: _ctrlEmail,
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_circle),
                      labelText: 'อีเมล',
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'กรุณากรอก รหัสผ่าน';
                      }
                      // if (login != null) {
                      //   if (login.success == 0) {
                      //     return login.message;
                      //   }
                      // }

                      return null;
                    },
                    controller: _ctrlPassword,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'รหัสผ่าน',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          child: Icon(
                            hidePassword == true
                                ? FontAwesomeIcons.solidEye
                                : FontAwesomeIcons.solidEyeSlash,
                            size: 18,
                          ),
                        )),
                  ),
                ],
              )),
          SizedBox(
            height: 30,
          ),
          Container(width: 220, height: 45, child: buildCustomButton()),
          DialogButton(
            height: 45,
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Facebook",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  void onPressedCustomButton() async {
    if (_formKey.currentState.validate()) {
      stateOnlyText = ButtonState.loading;
      setState(() {});
      await logins(_ctrlEmail.text, _ctrlPassword.text);

      if (login.success == 1) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
 
                    
                      
        preferences.setString("tokens", login.token);
        preferences.setString("email", _ctrlEmail.text);

        ///////////////////////// insert swith user //////////////////////////////
        List<String> listEmail =
            (preferences.getStringList("listEmail") == null)
                ? []
                : preferences.getStringList("listEmail");

        bool searchEmail = listEmail.any((e) => e.contains(_ctrlEmail.text));

        if (!searchEmail) {
          listEmail.add(_ctrlEmail.text);
          preferences.setStringList("listEmail", listEmail);

          // print("sss ===>>> ${preferences.getStringList("listPassword")}");
          List<String> listPassword =
              (preferences.getStringList("listPassword") == null)
                  ? []
                  : preferences.getStringList("listPassword");
          listPassword.add(_ctrlPassword.text);
          preferences.setStringList("listPassword", listPassword);
        }
        ///////////////////////// insert swith user //////////////////////////////

        getTokenFirebase(preferences.getString("tokens"));
        stateOnlyText = ButtonState.success;
        // Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => SlidePage(),
            ),
            (route) => false);
      } else {
        // if (_formKey.currentState.validate()) {}
        if (login.token != null) {
          textFail = login.token;
          stateOnlyText = ButtonState.fail;
        } else {
          textFail = "อีเมล หรือ รหัสผ่านไม่ถูกต้อง";
          stateOnlyText = ButtonState.fail;
        }

        Future.delayed(Duration(seconds: 2), () {
          stateOnlyText = ButtonState.idle;
          setState(() {});
        });
      }
    } else {
      print("false 5555");
      print(_ctrlEmail.text);
      print(_ctrlPassword.text);
    }

    setState(() {});
  }
}
