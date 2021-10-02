import 'dart:convert';

import 'package:easy_cook/models/register/register_model.dart';
import 'package:easy_cook/style/utiltties.dart';
import 'package:email_validator/email_validator.dart' as email_validator;
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

Future<RegisterModel> registers(String email, String password) async {
  // final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signin";
  final String apiUrl =
      "http://apifood.comsciproject.com/pjUsers/signupNewStep1";

  final response = await http
      .post(Uri.parse(apiUrl), body: {"email": email, "password": password});

  if (response.statusCode == 200) {
    final String responseString = response.body;

    return registerModelFromJson(responseString);
  } else {
    return null;
  }
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _ctrlEmail = TextEditingController();
  TextEditingController _ctrlPassword = TextEditingController();
  TextEditingController _ctrlCheckPassword = TextEditingController();

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);

  String isEmail = "";
  int checkEmail = 0;
  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: Text(
            'อีเมล์',
            style: kLabelStyle,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft, //ให้มาอยู่ตรงกลาง
          // decoration: kBoxDecorationStyle, //กรอบ

          height: 80.0,

          child: TextFormField(
            onChanged: (value) {
              checkEmail = 1;
            },
            validator: (value) {
              return (checkEmail == 0)
                  ? null
                  : email_validator.EmailValidator.validate(value)
                      ? (isEmail != "")
                          ? isEmail
                          : null
                      : "*กรุณาป้อนอีเมล์ของคุณ";
            },
            controller: _ctrlEmail,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(
                  r'[a-zA-Z0-9]\_*\-*\!*\@*\#*\$*\%*\(*\)*\+*\|*\~*\=*\\*\`*\{*\}*\[*\]*\:*\”*\;*\<*\>*\?*\,*\.*\/*')),
              // FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
              // FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9 _-]')),
              FilteringTextInputFormatter.deny(RegExp('[ ]')),
            ],
            style: TextStyle(
              color: Colors.white,
              // fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 13.0, color: Colors.pink[50]),
              // border: InputBorder.none,

              border: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.white, width: 1)),
              contentPadding: EdgeInsets.only(top: 38.0),
              filled: true,
              fillColor: Color(0xFF6CA8F1),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),

              hintText: 'ป้อนอีเมล์ของคุณ',
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  int chechPassword = 0;
  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: Text(
            'รหัสผ่าน',
            style: kLabelStyle,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft, //ให้มาอยู่ตรงกลาง
          // decoration: kBoxDecorationStyle, //กรอบ

          height: 80.0,

          child: TextFormField(
            onChanged: (value) {
              chechPassword = 1;
            },
            validator: (value) {
              if (chechPassword == 1) {
                if (value == null || value.isEmpty) {
                  return '*กรุณาป้อนรหัสผ่าน';
                } else if (value.length < 6) {
                  return '*รหัสผ่านควรมีความยาวอย่างน้อย 6 ตัวอักษร';
                } 
              }

              return null;
            },
            controller: _ctrlPassword,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(
                  r'[a-zA-Z0-9]\_*\-*\!*\@*\#*\$*\%*\(*\)*\+*\|*\~*\=*\\*\`*\{*\}*\[*\]*\:*\”*\;*\<*\>*\?*\,*\.*\/*')),
              // FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
              // FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9 _-]')),
              FilteringTextInputFormatter.deny(RegExp('[ ]')),
            ],
            style: TextStyle(
              color: Colors.white,
              // fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 13.0, color: Colors.pink[50]),
              // border: InputBorder.none,
              border: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.white, width: 1)),
              contentPadding: EdgeInsets.only(top: 38.0),
              filled: true,
              fillColor: Color(0xFF6CA8F1),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'ป้อนรหัสผ่านของคุณ',
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  int checkPasswordConfirm = 0;
  Widget _buildPasswordTFconfirm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: Text(
            'ยืนยันรหัสผ่าน',
            style: kLabelStyle,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft, //ให้มาอยู่ตรงกลาง
          // decoration: kBoxDecorationStyle, //กรอบ

          height: 80.0,

          child: TextFormField(
            onChanged: (value) {
              checkPasswordConfirm = 1;
            },
            validator: (value) {
              if (checkPasswordConfirm == 1) {
                if (value == null || value.isEmpty) {
                  return '*กรุณาป้อนยืนยันรหัสผ่าน';
                } else if (value != _ctrlPassword.text) {
                  return '*รหัสผ่านไม่ตรงกัน';
                }
              }

              return null;
            },
            controller: _ctrlCheckPassword,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(
                  r'[a-zA-Z0-9]\_*\-*\!*\@*\#*\$*\%*\(*\)*\+*\|*\~*\=*\\*\`*\{*\}*\[*\]*\:*\”*\;*\<*\>*\?*\,*\.*\/*')),
              // FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
              // FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9 _-]')),
              FilteringTextInputFormatter.deny(RegExp('[ ]')),
            ],
            style: TextStyle(
              color: Colors.white,
              // fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 13.0, color: Colors.pink[50]),
              // border: InputBorder.none,
              border: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.white, width: 1)),
              contentPadding: EdgeInsets.only(top: 38.0),
              filled: true,
              fillColor: Color(0xFF6CA8F1),
              prefixIcon: Icon(
                Icons.verified_user,
                color: Colors.white,
              ),
              hintText: 'ยืนยันรหัสผ่านของคุณ',
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          isEmail = "";
          checkEmail = 1;
          chechPassword = 1;
          checkPasswordConfirm = 1;
          if (_formKey.currentState.validate()) {
            print(_ctrlPassword.text);
            print(_ctrlCheckPassword.text);

            if (_ctrlEmail.text != '' &&
                _ctrlPassword.text == _ctrlCheckPassword.text &&
                _ctrlPassword.text != '') {
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
              final RegisterModel response =
                  await registers(_ctrlEmail.text, _ctrlPassword.text);
              Navigator.pop(context);
              print(response.success);
              print(response.token);

              if (response.success == 1) {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.setString("tokens", response.token);
                preferences.setString("email", _ctrlEmail.text);

                ///////////////////////// insert swith user //////////////////////////////
                List<String> listEmail =
                    (preferences.getStringList("listEmail") == null)
                        ? []
                        : preferences.getStringList("listEmail");

                bool searchEmail =
                    listEmail.any((e) => e.contains(_ctrlEmail.text));

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

                Navigator.pushNamedAndRemoveUntil(context, '/register2-page',
                    (Route<dynamic> route) => false);
              } else {
                isEmail = "*"+response.message;
                if (_formKey.currentState.validate()) {}
                print(response.message);
              }
            } else {
              print("false");
            }
            print("goto register2");
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          primary: Color(0xFF73AEF5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: EdgeInsets.all(10.0),
        ),
        child: Text(
          'สมัครสมาชิก',
          style: TextStyle(
            color: Colors.red[50],
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            // fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildCancelBtn() {
    return Container(
        // padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5.0,
            primary: Colors.blueGrey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: EdgeInsets.all(10.0),
          ),
          onPressed: () {
            print("ยกเลิก");
            Navigator.pop(context);
          },
          child: Text(
            'ยกเลิก',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
              // fontFamily: 'OpenSans',
            ),
          ),
        ));
  }

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

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // Container(
    //         height: double.infinity,
    //         width: double.infinity,
    //         decoration: BoxDecoration(
    //           gradient: LinearGradient(
    //             begin: Alignment.topCenter,
    //             end: Alignment.bottomCenter,
    //             colors: [
    //               Colors.blueAccent,
    //               Colors.blueAccent,
    //               Colors.blueAccent,
    //               Colors.blueAccent,
    //             ],
    //             stops: [0.1, 0.4, 0.7, 0.9],
    //           ),
    //         ),
    //       ),
    return Scaffold(
      body: Container(
        color: Colors.blueAccent,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'สมัครสมาชิก',
                    style: TextStyle(
                      color: Colors.white,
                      // fontFamily: 'OpenSans',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  _buildEmailTF(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildPasswordTF(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildPasswordTFconfirm(),
                  SizedBox(
                    height: 30.0,
                  ),
                  _buildRegisterBtn(),
                  _buildCancelBtn()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
