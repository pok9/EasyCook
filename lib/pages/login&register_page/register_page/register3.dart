import 'dart:convert';
import 'dart:io';

import 'package:easy_cook/class/xxx_token_class.dart';
import 'package:easy_cook/models/register/register2_model.dart';
// import 'package:easy_cook/slidepage.dart';
import 'package:easy_cook/style/utiltties.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage3 extends StatefulWidget {
  RegisterPage3({Key key}) : super(key: key);

  @override
  _RegisterPage3State createState() => _RegisterPage3State();
}

// Future<String> tokens() async {
//   token = await Token_jwt().getTokens();
// }

Future<Register2Model> registers2(
    String token, String name_surname, String alias_name) async {
  // final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signin";
  final String apiUrl =
      "http://apifood.comsciproject.com/pjUsers/signupNewStep3";

  print("token" + token);
  var data = {"name_surname": name_surname, "alias_name": alias_name};
  print(jsonEncode(data));
  final response = await http.post(Uri.parse(apiUrl),
      body: jsonEncode(data),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      });

  print("toke==" + token);
  print("response.statusCode = " + response.statusCode.toString());
  if (response.statusCode == 200) {
    final String responseString = response.body;

    return register2ModelFromJson(responseString);
  } else {
    return null;
  }
}

class _RegisterPage3State extends State<RegisterPage3> {
  String token = "";

  TextEditingController _ctrlFullName = TextEditingController();
  TextEditingController _ctrlNickName = TextEditingController();

  @override
  void initState() {
    super.initState();
    findToken();
  }

  Future<Null> findToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
    });
    // token = await Token_jwt().getTokens();
    // setState(() {});
  }

  // _RegisterPage3State() {
  //   tokens();
  // }

  int checkNickname = 0;
  Widget _buildNicknameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: Text(
            'นามแฝง',
            style: kLabelStyle,
          ),
        ),
        // SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft, //ให้มาอยู่ตรงกลาง
          // decoration: kBoxDecorationStyle, //กรอบ

          height: 80.0,

          child: TextFormField(
            controller: _ctrlNickName,
            keyboardType: TextInputType.name,
            onChanged: (value) {
              checkNickname = 1;
            },
            validator: (value) {
              if (checkNickname == 1) {
                if (value == null || value.isEmpty || value.trim() == "") {
                  return '*กรุณาป้อนนามแฝง';
                }
              }
              return null;
            },
            style: TextStyle(
              color: Colors.white,
              // fontFamily: 'OpenSans',
            ),
            maxLength: 30,
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
                Icons.person,
                color: Colors.white,
              ),

              hintText: 'ป้อนนามแฝงคุณ',
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  int checFullName = 0;
  Widget _buildFullNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: Text(
            'ชื่อ-นามสกุล',
            style: kLabelStyle,
          ),
        ),
        // SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft, //ให้มาอยู่ตรงกลาง
          // decoration: kBoxDecorationStyle, //กรอบ

          height: 80.0,

          child: TextFormField(
            controller: _ctrlFullName,
            keyboardType: TextInputType.name,
            onChanged: (value) {
              checFullName = 1;
            },
            validator: (value) {
              if (checFullName == 1) {
                if (value == null || value.isEmpty || value.trim() == "") {
                  return '*กรุณาป้อนชื่อ-นามสกุล';
                }
              }

              return null;
            },
            maxLength: 50,
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
                Icons.person,
                color: Colors.white,
              ),

              hintText: 'ป้อนชื่อ-นามสกุลของคุณ',
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  showdialog(context) {
  return showDialog(
      context: context,
      builder: (contex) {
        return AlertDialog(
            content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("กรุณารอสักครู่...   "), CircularProgressIndicator()],
        ));
      });
}
  Widget _buildConfirmBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          print("ยืนยัน");
          
          checkNickname = 1;
          checFullName = 1;
          if (_formKey.currentState.validate()) {
            print(_ctrlFullName.text);
            print(_ctrlNickName.text);
            // registers2

            if (_ctrlFullName.text != '' && _ctrlNickName.text != '') {
              showdialog(context);
              var str = await registers2(
                  token, _ctrlFullName.text, _ctrlNickName.text);
              print("str ==" + str.success.toString());
              Navigator.pop(context);
              if (str.success == 1) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/slide-page', (Route<dynamic> route) => false);
               
              }
            }
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color(0xFF73AEF5),
        child: Text(
          'ยืนยัน',
          style: TextStyle(
            color: Colors.red[50],
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            // fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            // autovalidate: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blueAccent,
                        Colors.blueAccent,
                        Colors.blueAccent,
                        Colors.blueAccent,
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9],
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 120.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'ตั้งชื่อ',
                          style: TextStyle(
                            color: Colors.white,
                            // fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        SizedBox(height: 30.0),
                        // _buildNicknameTF(),
                        _buildNicknameTF(),
                        SizedBox(
                          height: 20.0,
                        ),
                        _buildFullNameTF(),
                        SizedBox(
                          height: 20.0,
                        ),

                        // _buildNameTF(),
                        // SizedBox(
                        //   height: 20.0,
                        // ),

                        _buildConfirmBtn(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
