import 'package:easy_cook/models/login/login_model.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FeedPage extends StatefulWidget {
  const FeedPage({Key key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
    super.initState();
    findUser();
  }

  String token = ""; //โทเคน
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");

      if (token != "") {
        getMyAccounts();
      }
    });
  }

  //user
  MyAccount datas;
  DataAc dataUser;
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

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFf3f5f9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: Text('Easy Cook'),
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
                                                      controller: _ctrlEmail,
                                                      decoration:
                                                          InputDecoration(
                                                        icon: Icon(Icons
                                                            .account_circle),
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
                                                    } else {
                                                      _btnController.reset();
                                                      print("noooooooo");
                                                      print(login.success);
                                                    }
                                                  },
                                                ),
                                              )
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 3.0, bottom: 10),
                  //   child: Text(
                  //     "Easy Cook",
                  //     style:
                  //         TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  // Container(
                  //     height: 50,
                  //     decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(30),
                  //         border: Border.all(color: Colors.grey)),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: TextField(
                  //         decoration: InputDecoration(
                  //             hintText: "Find a food or Restaur",
                  //             prefixIcon: Icon(
                  //               Icons.search,
                  //               color: Colors.indigo,
                  //             ),
                  //             suffixIcon: Icon(
                  //               Icons.add_road_rounded,
                  //               color: Colors.grey,
                  //             ),
                  //             focusedBorder: InputBorder.none,
                  //             enabledBorder: InputBorder.none,
                  //             errorBorder: InputBorder.none,
                  //             disabledBorder: InputBorder.none),
                  //       ),
                  //     )),
                  // SizedBox(
                  //   height: 25,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "สูตรอาหารยอดนิยม1",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_forward_rounded, color: Colors.indigo)
                        // Text(
                        //   "ดูทั้งหมด",
                        //   style: TextStyle(
                        //       fontSize: 20, fontWeight: FontWeight.normal),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                      height: 250,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return _foodCard_1(context);
                          })),

                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "สูตรอาหารยอดนิยม",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_forward_rounded, color: Colors.indigo)
                        // Text(
                        //   "ดูทั้งหมด",
                        //   style: TextStyle(
                        //       fontSize: 20, fontWeight: FontWeight.normal),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                      height: 250,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return _foodCard_2(context);
                          })),

                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "วัตถุดิบแนะนำยอดนิยม",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_forward_rounded, color: Colors.indigo)
                        // Text(
                        //   "ดูทั้งหมด",
                        //   style: TextStyle(
                        //       fontSize: 20, fontWeight: FontWeight.normal),
                        // ),
                      ],
                    ),
                  ),
                  ingredients(),

                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "สูตรอาหารยอดนิยม",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_forward_rounded, color: Colors.indigo)
                        // Text(
                        //   "ดูทั้งหมด",
                        //   style: TextStyle(
                        //       fontSize: 20, fontWeight: FontWeight.normal),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                      height: 325,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return _foodCard_3(context);
                          })),

                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "แนะนำเซฟ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_forward_rounded, color: Colors.indigo)
                        // Text(
                        //   "ดูทั้งหมด",
                        //   style: TextStyle(
                        //       fontSize: 20, fontWeight: FontWeight.normal),
                        // ),
                      ],
                    ),
                  ),

                  Container(
                      height: 135,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return _introduce_safe_Card(context);
                          })),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "สูตรล่าสุด",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_forward_rounded, color: Colors.indigo)
                      ],
                    ),
                  ),

                  Container(
                      height: 580,
                      child: ListView.builder(
                          // scrollDirection: Axis.vertical,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return _foodCard_latest(context);
                          })),

                  // Container(
                  //     height: 330,
                  //     child: ListView.builder(
                  //         scrollDirection: Axis.vertical,
                  //         itemCount: 5,
                  //         itemBuilder: (context, index) {
                  //           return _foodCardSlim_1(context);
                  //         })),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _foodCard_1(context) {
    return Container(
      // height: 500,
      width: 200,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      new Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    "https://placeimg.com/640/480/any"))),
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      new Text(
                        "เซฟปก",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        // print("more_vert" + index.toString());
                      })
                ],
              ),
            ),
            Container(
              height: 125,
              width: 250,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://www.fatfeedfun.com/wp-content/uploads/2018/09/easy-food_003790-e1537459041930.jpg"),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Text(
                          "ต้มยำกุ้งสด",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "4.2",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                              Icon(
                                Icons.star_half,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                              Icon(
                                Icons.star_border,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                            ],
                          ),
                          Text(
                            "(12)",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    "\$25",
                    style: TextStyle(
                        color: Colors.indigo, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(10),
      ),
    );
  }

  Widget _foodCard_2(context) {
    return Container(
      // height: 500,
      width: 200,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      new Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    "https://placeimg.com/640/480/any"))),
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      new Text(
                        "เซฟปก",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        // print("more_vert" + index.toString());
                      })
                ],
              ),
            ),
            Container(
              height: 125,
              width: 250,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://images.unsplash.com/photo-1484723091739-30a097e8f929?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Text(
                          "ต้มยำกุ้งสด",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "4.2",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                              Icon(
                                Icons.star_half,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                              Icon(
                                Icons.star_border,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                            ],
                          ),
                          Text(
                            "(12)",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    "\$25",
                    style: TextStyle(
                        color: Colors.indigo, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(10),
      ),
    );
  }

  Padding ingredients() {
    return Padding(
      padding: const EdgeInsets.only(left: 13, right: 13, top: 18, bottom: 18),
      child: Container(
        height: 150,
        padding: EdgeInsets.only(left: 18, right: 18, top: 22, bottom: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: NetworkImage(
                  "https://ed.edtfiles-media.com/ud/news/1/155/463477/1_5-850x567.jpg"),
              fit: BoxFit.cover),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Text(
                      'เนื้อ',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                Text(
                  'ดูเพิ่มเติม >',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w100),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _foodCard_3(context) {
    return Container(
      // height: 500,
      width: 280,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      new Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    "https://placeimg.com/640/480/any"))),
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      new Text(
                        "เซฟปก",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        // print("more_vert" + index.toString());
                      })
                ],
              ),
            ),
            Container(
              height: 200,
              width: 280,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://www.thairestaurantphuket.com/blog/wp-content/uploads/2017/07/%E0%B8%97%E0%B8%AD%E0%B8%94%E0%B8%A1%E0%B8%B1%E0%B8%99%E0%B8%81%E0%B8%B8%E0%B9%89%E0%B8%87.jpg"),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Text(
                          "ต้มยำกุ้งสด",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "4.2",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                              Icon(
                                Icons.star_half,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                              Icon(
                                Icons.star_border,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                            ],
                          ),
                          Text(
                            "(12)",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    "\$25",
                    style: TextStyle(
                        color: Colors.indigo, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(10),
      ),
    );
  }

  Widget _introduce_safe_Card(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Container(
        // height: 500,
        // width: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Container(
                  height: 65.0,
                  width: 65.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(
                              "https://placeimg.com/640/480/any"))),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "เซฟปก",
                  style: TextStyle(fontWeight: FontWeight.normal),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: 90,
                  height: 25,
                  child: MaterialButton(
                    splashColor: Colors.grey,
                    color: Colors.white,
                    onPressed: () {
                      print("ติดตาม");
                    },
                    child: Text(
                      '+ ติดตาม',
                      style: TextStyle(color: Colors.blue),
                    ),
                    shape: StadiumBorder(
                        side: BorderSide(width: 1, color: Colors.blue)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _foodCard_latest(context) {
    return Container(
      // height: 500,
      width: 280,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      new Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    "https://placeimg.com/640/480/any"))),
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      new Text(
                        "เซฟปก",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        // print("more_vert" + index.toString());
                      })
                ],
              ),
            ),
            Container(
              height: 200,
              // width: 500,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://www.thairestaurantphuket.com/blog/wp-content/uploads/2017/07/%E0%B8%97%E0%B8%AD%E0%B8%94%E0%B8%A1%E0%B8%B1%E0%B8%99%E0%B8%81%E0%B8%B8%E0%B9%89%E0%B8%87.jpg"),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Text(
                          "ต้มยำกุ้งสด",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "4.2",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                              Icon(
                                Icons.star_half,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                              Icon(
                                Icons.star_border,
                                color: Theme.of(context).primaryColor,
                                size: 16.0,
                              ),
                            ],
                          ),
                          Text(
                            "(12)",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    "\$25",
                    style: TextStyle(
                        color: Colors.indigo, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(10),
      ),
    );
  }

  // Widget _foodCardSlim_1(context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Container(
  //       color: Colors.transparent,
  //       child: Column(
  //         children: [
  //           Row(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Container(
  //                   height: 80,
  //                   width: 80,
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(10),
  //                       image: DecorationImage(
  //                           image: NetworkImage(
  //                               "https://images.unsplash.com/photo-1484723091739-30a097e8f929?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
  //                           fit: BoxFit.cover)),
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               Row(
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         "ต้ำยำกุ้ง",
  //                         style: TextStyle(
  //                             color: Colors.grey, fontWeight: FontWeight.bold),
  //                       ),
  //                       Text(
  //                         "Italian Recipe for you",
  //                         style: TextStyle(color: Colors.grey),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     width: 50,
  //                   ),
  //                   Text(
  //                     "ฟรี",
  //                     style: TextStyle(
  //                         color: Colors.indigo, fontWeight: FontWeight.bold),
  //                   )
  //                 ],
  //               ),
  //             ],
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.only(right: 8.0, left: 8.0),
  //             child: Divider(
  //               height: 2,
  //               color: Colors.grey,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
