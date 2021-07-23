// import 'dart:html';

// import 'dart:io';

import 'package:easy_cook/models/login/login_model.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _ctrlEmail = TextEditingController(); //email
  TextEditingController _ctrlPassword = TextEditingController(); // password

  final _formKey = GlobalKey<FormState>(); //การตรวจสอบความถูกต้อง

  ButtonState stateOnlyText = ButtonState.idle;

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
          "อีเมล หรือ รหัสผ่านไม่ถูกต้อง",
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
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min, //autoSize
        children: [
          _getCloseButton(context),
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
        stateOnlyText = ButtonState.success;
        Navigator.pop(context);
      } else {
        // if (_formKey.currentState.validate()) {}
        stateOnlyText = ButtonState.fail;

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
