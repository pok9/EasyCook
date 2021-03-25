import 'dart:convert';

import 'package:easy_cook/class/token_class.dart';
import 'package:easy_cook/models/login/login_model.dart';
import 'package:easy_cook/pages/addFood_page/addFood.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:easy_cook/pages/register_page/register.dart';
import 'package:easy_cook/pages/register_page/register2.dart';
import 'package:easy_cook/slidepage.dart';
import 'package:easy_cook/style/utiltties.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../style/utiltties.dart';
import '../../class/token_class.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

// showdialog(){

// }
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

class _LoginPageState extends State<LoginPage> {
  // final storage = new FlutterSecureStorage();

  LoginModel _login;

  bool _rememberMe = false;

  TextEditingController _ctrlEmail = TextEditingController();
  TextEditingController _ctrlPassword = TextEditingController();

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'อีเมล์',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft, //ให้มาอยู่ตรงกลาง
          decoration: kBoxDecorationStyle, //กรอบ
          height: 60.0,
          child: TextField(
            controller: _ctrlEmail,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'ป้อนอีเมล์ของคุณ',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'รหัสผ่าน',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _ctrlPassword,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'ป้อนรหัสผ่านของคุณ',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'ลืมรหัสผ่าน?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'จดจำฉัน',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          showdialog(context);
          // if(_login == null){
          //    showdialog(context);
          // }
          final String email = _ctrlEmail.text;
          final String password = _ctrlPassword.text;

          final LoginModel login = await logins(email, password);

          // setState(() {
          _login = login;

          print(login);
          print("ssssssssss" + _login.success.toString());
          // });
          // var data;
          if (_login.success == 1) {
            // showdialog(context);
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setString("tokens", _login.token);

            //Token
            //  Token_jwt().storeToken(_login.token);-------------------------------------------------------

            // DBService service = new DBService();
            // Token_jwt token_jwt = new Token_jwt();
            // token_jwt.token = _login.token;
            // var data = token_jwt.Token_jwtMap();
            // service.insertData(data);
            ///////////////////////////////
            Navigator.pushNamedAndRemoveUntil(
                context, '/slide-page', (route) => false);
            // Navigator.pushReplacement(
            //   context,
            //   new MaterialPageRoute(
            //       /*check()*/
            //       builder: (context) =>
            //           new SlidePage()), /////////////////////////////////////////////////////////////////////////////////
            // ).then((value) {
            //   /* if (value == null) {
            //       } else {

            //         proList.add(value);
            //       }*/
            //   setState(() {});
            // });
          } else {
            print(_login.token);
            setState(() {});
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color(0xFF73AEF5),
        child: Text(
          'เข้าสู่ระบบ',
          style: TextStyle(
            color: Colors.red[50],
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- หรือ -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'ลงชื่อเข้าใช้ด้วย',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/slide-page', (Route<dynamic> route) => false);
            },
            AssetImage(
              'assets/logos/facebook.jpg',
            ),
          ),
          // _buildSocialBtn(
          //   () => print('Login with Google'),
          //   AssetImage(
          //     'assets/logos/google.jpg',
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '/register-page');
        Navigator.pushNamedAndRemoveUntil(
            context, '/register-page', (Route<dynamic> route) => false);
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'ไม่มีบัญชี? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'ลงชื่อ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                      Colors.blueGrey,
                      Colors.blueAccent,
                      Colors.blueGrey,
                      Colors.blue,
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
                        'เข้าสู่ระบบ',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildEmailTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      _buildForgotPasswordBtn(),
                      _buildRememberMeCheckbox(),
                      _buildLoginBtn(),
                      _buildSignInWithText(),
                      _buildSocialBtnRow(),
                      _buildSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
