import 'package:easy_cook/models/cancelAccount/cancelAccountModel.dart';
import 'package:easy_cook/models/login/login_model.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/slidepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DeleteAccountPage extends StatefulWidget {
  // const DeleteAccountPage({ Key? key }) : super(key: key);

  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  TextEditingController yourpassword = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  String token = ""; //โทเคน
  String email = "";
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
      email = preferences.getString("email");
      print("token = ${token}");

      if (token != "") {
        getMyAccounts();
      }
    });
  }

  Future<LoginModel> logins(String email, String password) async {
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
  MyAccount datas;
  DataMyAccount dataUser;
  Future<Null> getMyAccounts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      final String responseString = response.body;

      datas = myAccountFromJson(responseString);
      dataUser = datas.data[0];
      print(dataUser.userId);

      setState(() {});
    } else {
      return null;
    }
  }

  final _formKey = GlobalKey<FormState>();
  //dialog รอ
  showdialog(context) {
    return showDialog(
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
  }

  //แจ้งเตือนตอนกดโพส
  showdialogPost(context, String txt) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "แจ้งเตือน",
              style: TextStyle(color: Colors.red),
            ),
            content: Text(txt),
            actions: [
              TextButton(
                child: Text(
                  "ตกลง",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ศูนย์ช่วยเหลือ'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            icon: Icon(Icons.clear),
          ),
        ),
        body: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueGrey,
              centerTitle: true,
              title: Text("ลบบัญชี"),
            ),
            body: (dataUser == null)
                ? Container()
                : Form(
                    key: _formKey,
                    child: AlertDialog(
                      title: Text('ลบบัญชี'),
                      content: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 15),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                          'ก่อนที่คุณจะใช้บัญชีของคุณอย่างถาวร โปรดป้อนรหัสผ่านของคุณ')),
                                ],
                              ),
                            ),
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(dataUser.profileImage),
                              radius: 30,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(dataUser.aliasName),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text("รหัสผ่าน"),
                              ],
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'ป้อนรหัส';
                                }
                                return null;
                              },
                              obscureText: true,
                              controller: yourpassword,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  hintText: 'ใส่รหัสผ่านของคุณ'),
                            )
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: new Container(
                                padding: new EdgeInsets.all(1.0),
                                decoration: new BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: new TextButton(
                                  onPressed: () async {
                                    // print(loginModel.success);

                                    if (_formKey.currentState.validate()) {
                                      showdialog(context);

                                      LoginModel loginModel = await logins(
                                          email, yourpassword.text);
                                      Navigator.pop(context);
                                      if (loginModel.success == 1) {
                                        showDialog(
                                          barrierColor: Colors.black26,
                                          context: context,
                                          builder: (context) {
                                            return CustomAlertDialog(
                                              title: "ลบบัญชี",
                                              description:
                                                  "คุณแน่ใจใช่ไหมที่จะลบบัญชีนี้",
                                              token: this.token,
                                              // rid: dataFood.rid,
                                            );
                                          },
                                        );
                                      } else {
                                        showdialogPost(
                                            context, loginModel.message);
                                      }
                                    }
                                  },
                                  child: Text(
                                    'ลบ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontFamily: 'helvetica_neue_light',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )));
  }
}

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({this.title, this.description, this.token});

  final String title, description, token;

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  Future<CancelAccoutModel> cancelAccoutFuction(String token) async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjUsers/cancleAccout";

    // print(ingredientName);
    // print(amount);
    // print(step);

    // print(jsonEncode(data));
    final response = await http.post(Uri.parse(apiUrl),
        // body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    if (response.statusCode == 200) {
      final String responseString = response.body;

      return cancelAccoutModelFromJson(responseString);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 15),
          Text(
            "${widget.title}",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Text("${widget.description}"),
          SizedBox(height: 20),
          Divider(
            height: 1,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              highlightColor: Colors.grey[200],
              onTap: () async {
                Navigator.pop(context);

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("กรุณารอสักครู่...   "),
                        CircularProgressIndicator()
                      ],
                    ));
                  },
                );

                CancelAccoutModel cancelAccount =
                    await cancelAccoutFuction(this.widget.token);
                Navigator.pop(context);
                if (cancelAccount.success == 1) {
                  showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                            title: "ลบสำเร็จ",
                            description: "คุณได้ทำการลบบัญชีนี้แล้ว",
                            image:
                                'https://i.pinimg.com/originals/06/ae/07/06ae072fb343a704ee80c2c55d2da80a.gif',
                            colors: Colors.lightGreen,
                            index: 1,
                          ));
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                            title: "ลบไม่สำเร็จ",
                            description:
                                "ระบบไม่เสถียร โปรดลบบัญชีใหม่อีกครั้ง",
                            image:
                                'https://media2.giphy.com/media/JT7Td5xRqkvHQvTdEu/200w.gif?cid=82a1493b44ucr1schfqvrvs0ha03z0moh5l2746rdxxq8ebl&rid=200w.gif&ct=g',
                            colors: Colors.redAccent,
                            index: 0,
                          ));
                }
              },
              child: Center(
                child: Text(
                  "ยืนยัน",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
              highlightColor: Colors.grey[200],
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text(
                  "ยกเลิก",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText, image;
  final Color colors;
  final int index;

  CustomDialog({
    this.title,
    this.description,
    this.buttonText,
    this.image,
    this.colors,
    this.index,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 100, bottom: 16, left: 16, right: 16),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                description,
                style: TextStyle(color: Colors.grey.shade800, fontSize: 16.0),
              ),
              SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: colors,
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      if (index == 1) {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.setString("tokens", "");
                        preferences.setString("email", "");
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => SlidePage(),
                            ),
                            (route) => false);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "เข้าใจแล้ว",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 50,
            backgroundImage: NetworkImage(this.image),
          ),
        )
      ],
    );
  }
}
