// import 'dart:html';

// import 'dart:io';

import 'dart:convert';

import 'package:easy_cook/models/login/login_model.dart';
import 'package:easy_cook/slidepage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:email_validator/email_validator.dart' as email_validator;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class LoginPage extends StatefulWidget {
  int close;
  int closeFacebook;
  String token;
  LoginPage({this.close, this.closeFacebook, this.token});

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

  String userID, email, alias_name, name_surname, profile_image;
  var facebookSignIn = AuthBlock.facebookSignIns;

  LoginModel loginFacebook;
  Future<Null> loginFacebooks(
      String userID, email, alias_name, name_surname, profile_image) async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjUsers/loginFacebook";

    var data = {
      "userID": userID,
      "email": email,
      "name_surname": alias_name,
      "alias_name": name_surname,
      "profile_image": profile_image
    };

    print(jsonEncode(data));

    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data), headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      final String responseString = response.body;
      print("responseStringFacebook => $responseString");
      loginFacebook = loginModelFromJson(responseString);
    } else {
      return null;
    }
  }

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

  int checkEmail = 0;
  int checkPassword = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // padding: (this.widget.close == 1) ? EdgeInsets.only(top:MediaQuery.of(context).size.height / 2 - 250) : EdgeInsets.only(top:MediaQuery.of(context).size.height / 2 - 250),
      padding:
          EdgeInsets.only(top: MediaQuery.of(context).size.height / 2 - 250),
// Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2 - 130));
      // (this.widget.close == 1) ? : Container();
      //  padding: EdgeInsets.only(top:
      // //  MediaQuery.of(context).size.height.hasFo ?
      //                   MediaQuery.of(context).size.height / 2 - 250 // adjust values according to your need
      //                   // : MediaQuery.of(context).size.height / 2 - 130
      //                   ),
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min, //autoSize
          children: [
            (this.widget.close == null)
                ? _getCloseButton(context)
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'เข้าสู่ระบบ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        checkEmail = 1;
                      },
                      validator: (value) {
                        return (checkEmail == 0)
                            ? null
                            : (value.trim() == "" || value.length == 0)
                                ? "*กรุณากรอก อีเมล"
                                : email_validator.EmailValidator.validate(value)
                                    ? null
                                    : "*อีเมลไม่ถูกต้อง ";
                      },
                      // validator: (value) {
                      //   if (value.isEmpty) {
                      //     return '*กรุณากรอก อีเมล';
                      //   }

                      //   return null;
                      // },
                      controller: _ctrlEmail,
                      decoration: InputDecoration(
                        icon: Icon(Icons.account_circle),
                        labelText: 'อีเมล',
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        checkPassword = 1;
                      },
                      validator: (value) {
                        if(checkPassword == 1){
                          if (value.isEmpty) {
                          return '*กรุณากรอก รหัสผ่าน';
                        }
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
            SizedBox(
              height: 15,
            ),
            (this.widget.closeFacebook == 0)
                ? Container()
                : Container(
                    width: 220,
                    height: 45,
                    child: SignInButton(Buttons.Facebook,
                        text: "เข้าสู่ระบบ ด้วย Facebook", onPressed: () async {
                      final FacebookLoginResult result =
                          await facebookSignIn.logIn(['email']);

                      switch (result.status) {
                        case FacebookLoginStatus.loggedIn:
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("กรุณารอสักครู่...   "),
                                    CircularProgressIndicator()
                                  ],
                                ));
                              });
                          final FacebookAccessToken accessToken =
                              result.accessToken;

                          final graphResponse = await http.get(
                              // Uri.parse('https://graph.facebook.com/v2.12/me?fields=first_name,picture&access_token=${accessToken.token}'));
                              Uri.parse(
                                  'https://graph.facebook.com/v11.0/me?fields=name,first_name,last_name,email,picture.width(800).height(800)&access_token=${accessToken.token}'));
                          final profile = jsonDecode(graphResponse.body);
                          print(profile);
                          setState(() {
                            userID = profile['id'];
                            email = profile['email'];
                            name_surname = profile['first_name'];
                            alias_name = profile['last_name'];
                            profile_image = profile['picture']['data']['url'];

                            LoginFacebookMD(userID, email, alias_name,
                                name_surname, profile_image);

                            // print("loginFacebook.success => ${loginFacebook.success}");

                            print("userID => $userID");
                            print("email => $email");
                            print("name_surname => $name_surname");
                            print("alias_name => $alias_name");
                            print("profile_image => $profile_image");
                          });

                          print('''
           Logged in!
           
           Token: ${accessToken.token}
           User id: ${accessToken.userId}
           Expires: ${accessToken.expires}
           Permissions: ${accessToken.permissions}
           Declined permissions: ${accessToken.declinedPermissions}
           ''');
                          break;
                        case FacebookLoginStatus.cancelledByUser:
                          print('Login cancelled by the user.');
                          break;
                        case FacebookLoginStatus.error:
                          print('Something went wrong with the login process.\n'
                              'Here\'s the error Facebook gave us: ${result.errorMessage}');
                          break;
                      }
                    }),
                  )
          ],
        ),
      ),
    );
  }

  void onPressedCustomButton() async {
    checkEmail = 1;
    checkPassword = 1;
    if (_formKey.currentState.validate()) {
      stateOnlyText = ButtonState.loading;
      setState(() {});
      await logins(_ctrlEmail.text, _ctrlPassword.text);

      if (login.success == 1) {
        if (this.widget.token != "") {
          updateTokenExit();
        }

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

  void LoginFacebookMD(
      String userID, email, alias_name, name_surname, profile_image) async {
    await loginFacebooks(
        userID, email, alias_name, name_surname, profile_image);
    print("loginFacebook.success => ${loginFacebook.success}");
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Navigator.pop(context);
    preferences.setString("tokens", loginFacebook.token);
    preferences.setString("email", email);

    getTokenFirebase(preferences.getString("tokens"));
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => SlidePage(),
        ),
        (route) => false);
  }

  // static Future<Null> _logOut() async {
  //   await facebookSignIn.logOut();
  // }
}

//Static valiable FacebookLogin
class AuthBlock {
  static final FacebookLogin facebookSignIns = new FacebookLogin();
}
