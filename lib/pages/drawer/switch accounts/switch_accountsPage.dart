import 'dart:convert';

import 'package:easy_cook/models/login/login_model.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/pages/login&register_page/login_page/login.dart';
import 'package:easy_cook/slidepage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SwitchAccountsPage extends StatefulWidget {
  @override
  _SwitchAccountsPageState createState() => _SwitchAccountsPageState();
}

class _SwitchAccountsPageState extends State<SwitchAccountsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fineStringList();

    findUser();
  }

  String token = ""; //โทเคน
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
      print("Token >>> $token");
      if (token != "" && token != null) {
        getMyAccounts();
      }
    });
  }

  // user
  MyAccount data_MyAccount;
  DataMyAccount data_DataAc;
  Future<Null> getMyAccounts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      data_MyAccount = myAccountFromJson(responseString);
      data_DataAc = data_MyAccount.data[0];
      print(data_DataAc.userId);

      setState(() {});
    } else {
      return null;
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  List<DataMyAccount> ListData_DataAc = [];
  // List tokenStringList = [];
  List<String> listEmail;
  List<String> listPassword;
  void fineStringList() async {
    ListData_DataAc = [];
    // tokenStringList = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    listEmail = preferences.getStringList("listEmail");
    print("listEmail =>  ${listEmail}");
    listPassword = preferences.getStringList("listPassword");
    print("listPassword =>  ${listPassword}");

    for (int i = 0; i < listEmail.length; i++) {
      LoginModel login = await logins_StringList(listEmail[i], listPassword[i]);
      print("login ==>> ${login.success}");
      if (login.success == 1) {
        data_DataAc_StringList = await getMyAccounts_StringList(login.token);
        ListData_DataAc.add(data_DataAc_StringList);
      } else {
        int index = listEmail.indexOf(listEmail[i]);
        print("index => $index");
        if (index > -1) {
          listEmail.removeAt(index);
          preferences.setStringList("listEmail", listEmail);
          print("listEmail =>  ${listEmail}");
          List<String> listPassword = preferences.getStringList("listPassword");
          listPassword.removeAt(index);
          preferences.setStringList("listPassword", listPassword);
          print("listPassword =>  ${listPassword}");
        }
      }
    }
    setState(() {});
  }

  Future<LoginModel> logins_StringList(String email, String password) async {
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

  //user
  MyAccount data_MyAccount_StringList;
  DataMyAccount data_DataAc_StringList;
  Future<DataMyAccount> getMyAccounts_StringList(String token) async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      data_MyAccount_StringList = myAccountFromJson(responseString);

      return data_MyAccount_StringList.data[0];
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("สลับบัญชี"),
      actions: [
        TextButton(
          child: const Text('ยกเลิก'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      content: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          width: double.maxFinite,
          child: Column(
            children: [
              (data_DataAc == null)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: ListData_DataAc.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                ListData_DataAc[index].profileImage),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(ListData_DataAc[index].aliasName),
                          ),
                          subtitle: Text(
                            ListData_DataAc[index].nameSurname,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'OpenSans',
                              fontSize: 12,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          trailing: (data_DataAc.userId ==
                                  ListData_DataAc[index].userId)
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 17),
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.blue,
                                    size: 15,
                                  ),
                                )
                              : null,
                          onTap: (data_DataAc.userId ==
                                  ListData_DataAc[index].userId)
                              ? null
                              : () => switchUser(index),
                        );
                      }),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/plus.png'),
                ),
                title: Text(
                  "เพิ่มบัญชี",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return LoginPage(
                          closeFacebook: 0,
                          token: token,
                        );
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void switchUser(int i) async {
    print(ListData_DataAc[i].email);
    int index = listEmail.indexOf(ListData_DataAc[i].email);

    print(listPassword[index]);

    await logins(ListData_DataAc[i].email, listPassword[index]);

    print(login.success);
    if (login.success == 1) {
      updateTokenExit();
      SharedPreferences preferences = await SharedPreferences.getInstance();

      preferences.setString("tokens", login.token);
      preferences.setString("email", ListData_DataAc[i].email);
      getTokenFirebase(preferences.getString("tokens"), i);
    }
  }

  getTokenFirebase(String token,int index) async {
    String tokenFirebase = await FirebaseMessaging.instance.getToken(
        vapidKey:
            "BC5Y9rRxIQizOB9jx5GuFuK9HK-XkB0NreHveINUNby-tvNdZklyAI0tY_P4u50aYhEcvQW65lzaEdPJF3rygzw");
    print("tokenFirebaseLogin ===>>> $tokenFirebase");
    updateTokenLogin(tokenFirebase, token,index);
  }

  Future<Null> updateTokenLogin(String tokenFirebase, String token,int index) async {
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
    // final snackBar = SnackBar(
    //   duration: Duration(milliseconds: 1400),
    //   content: const Text('สลับบัญชีแล้ว'),
    // );

    // ScaffoldMessenger.of(context).showSnackBar(snackBar);

    final snackBar = SnackBar(
      duration: Duration(milliseconds: 1400),
      elevation: 6.0,
      // backgroundColor: Configs.current.COLORS_PRIMARY,
      behavior: SnackBarBehavior.floating,
      content: Row(children: [
        CircleAvatar(radius: 20,backgroundImage: NetworkImage(ListData_DataAc[index].profileImage),),
        SizedBox(width: 10,),
        Text(
        "สลับบัญชี EasyCook เป็น ${ListData_DataAc[index].aliasName} แล้ว",
        style: TextStyle(color: Colors.white),
      )
      ],),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushAndRemoveUntil(
        context,
        // MaterialPageRoute(
        //   builder: (BuildContext context) => SlidePage(),
        // ),
        EnterExitRoute(exitPage: Container(), enterPage: SlidePage()),
        (route) => false);
    
    // Navigator.push(context,
    // EnterExitRoute(exitPage: Container(), enterPage: SlidePage()));

    print("responseUpdateTokenFirebase = ${response.statusCode}");
    print("response.body = ${response.body}");
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

  Future<Null> updateTokenExit() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjNoti/updateToken";

    var data = {
      "token_noti": null,
    };

    print(jsonEncode(data));

    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer ${this.token}",
          "Content-Type": "application/json"
        });
    print("responseUpdateTokenFirebase = ${response.statusCode}");
    print("response.body = ${response.body}");
  }
}

class EnterExitRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  EnterExitRoute({this.exitPage, this.enterPage})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              enterPage,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Stack(
                children: <Widget>[
                  SlideTransition(
                    position: new Tween<Offset>(
                      begin: const Offset(0.0, 0.0),
                      end: const Offset(-1.0, 0.0),
                    ).animate(animation),
                    child: exitPage,
                  ),
                  SlideTransition(
                    position: new Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: enterPage,
                  )
                ],
              ),
        );
}
