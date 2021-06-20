// import 'dart:html';

import 'package:easy_cook/models/login/login_model.dart';
import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>();

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
          "Fail",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.success: Text(
          "Success",
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: GestureDetector(
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
      ),
    );
  }

  // _getColButtons(context) {
  //   return [
  //     DialogButton(
  //       child: Text(
  //         "Continue",
  //         style: TextStyle(color: Colors.white, fontSize: 18),
  //       ),
  //       onPressed: () => Navigator.pop(context),
  //       color: Color.fromRGBO(0, 179, 134, 1.0),
  //     ),
  //     DialogButton(
  //       child: Text(
  //         "Cancel",
  //         style: TextStyle(color: Colors.white, fontSize: 18),
  //       ),
  //       onPressed: () => Navigator.pop(context),
  //       gradient: LinearGradient(colors: [
  //         Color.fromRGBO(116, 116, 191, 1.0),
  //         Color.fromRGBO(52, 138, 199, 1.0)
  //       ]),
  //     )
  //   ];
  // }

  Future<LoginModel> logins(String email, String password) async {
    // final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signin";

    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signin";

    final response = await http
        .post(Uri.parse(apiUrl), body: {"email": email, "password": password});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      return loginModelFromJson(responseString);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 400.0,
        child: Column(
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
                          return "กรุณากรอก อีเมล";
                        }

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

                        return null;
                      },
                      controller: _ctrlPassword,
                      // obscureText: hidePassword,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'รหัสผ่าน',
                        // suffixIcon:
                        //     GestureDetector(
                        //   onTap: () {
                        //     setState(() {
                        //       print(
                        //           "okkkkk");
                        //       // hidePassword =
                        //       //     !hidePassword;
                        //     });
                        //   },
                        //   child: Icon(
                        //     hidePassword ==
                        //             true
                        //         ? FontAwesomeIcons
                        //             .solidEye
                        //         : FontAwesomeIcons
                        //             .solidEyeSlash,
                        //     size: 18,
                        //   ),
                        // )
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 30,
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: RoundedLoadingButton(
            //     child:
            //         Text('เข้าสู่ระบบ', style: TextStyle(color: Colors.white)),
            //     // controller: _btnController,
            //     onPressed: () async {
            //       // if (_formKey.currentState
            //       //     .validate()) {
            //       //   print(_ctrlEmail.text);
            //       //   print(_ctrlPassword.text);

            //       //   await logins(
            //       //       _ctrlEmail.text,
            //       //       _ctrlPassword.text);

            //       //   print(login.success);
            //       //   print(login.message);

            //       //   if (login.success == 1) {
            //       //     _btnController
            //       //         .success();
            //       //     _ctrlEmail.text = "";
            //       //     _ctrlPassword.text = "";
            //       //     SharedPreferences
            //       //         preferences =
            //       //         await SharedPreferences
            //       //             .getInstance();
            //       //     preferences.setString(
            //       //         "tokens",
            //       //         login.token);
            //       //     findUser();
            //       //     Navigator.pop(context);
            //       //   } else {
            //       //     _btnController.reset();
            //       //   }
            //       // } else {
            //       //   _btnController.reset();
            //       //   print("noooooooo");
            //       //   print(login.success);
            //       // }
            //     },
            //   ),
            // ),
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
      ),
    );
  }

  void onPressedCustomButton() async {
    // Navigator.pop(context);
    // print("true 5555");

    if (_formKey.currentState.validate()) {
      stateOnlyText = ButtonState.loading;

      print("true 5555");
      print(_ctrlEmail.text);
      print(_ctrlPassword.text);

      LoginModel login = await logins(_ctrlEmail.text, _ctrlPassword.text);

      if (login.success == 1) {
        print("loginToken = " + login.token);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("tokens", login.token);
        stateOnlyText = ButtonState.success;
        Navigator.pop(context);
      } else {
        print("loginSuccess = " + login.success.toString());
        print("loginMessage = " + login.message);
        stateOnlyText = ButtonState.fail;
      }

      //   print(login.success);
      //   print(login.message);

      //   if (login.success == 1) {
      //     _btnController.success();
      //     _ctrlEmail.text = "";
      //     _ctrlPassword.text = "";
      //     SharedPreferences preferences = await SharedPreferences.getInstance();
      //     preferences.setString("tokens", login.token);
      //     findUser();
      //     Navigator.pop(context);
      //   } else {
      //     _btnController.reset();
      //   }
      // } else {
      //   _btnController.reset();
      //   print("noooooooo");
      //   print(login.success);
    } else {
      print("false 5555");
    }

    setState(() {});
    // setState(() {
    //   switch (stateOnlyText) {
    //     case ButtonState.idle:
    //       stateOnlyText = ButtonState.loading;
    //       break;
    //     case ButtonState.loading:
    //       stateOnlyText = ButtonState.fail;
    //       break;
    //     case ButtonState.success:
    //       stateOnlyText = ButtonState.idle;
    //       break;
    //     case ButtonState.fail:
    //       stateOnlyText = ButtonState.success;
    //       break;
    //   }
    // });
  }
}
