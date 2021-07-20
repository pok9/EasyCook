import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:easy_cook/models/login/login_model.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/pages/feed_page/notification_page/notification.dart';
import 'package:easy_cook/pages/login_page/login.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:easy_cook/style/utiltties.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  PageController pageController = PageController();
  int pageCount = 3;
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (!pageController.hasClients) {
        return;
      }
      if (pageController.page >= pageCount - 1) {
        pageController.animateToPage(0,
            duration: Duration(milliseconds: 1000),
            curve: Curves.fastLinearToSlowEaseIn);
      } else {
        pageController.nextPage(
            duration: Duration(milliseconds: 1000),
            curve: Curves.fastLinearToSlowEaseIn);
      }
    });
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
      // backgroundColor: Colors.white70,
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
                            Text(
                              datas.data[0].nameSurname,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.account_box_outlined,
                        color: Colors.blue,
                        size: 25,
                      ),
                      title: Text(
                        'บัญชีของฉัน',
                        style: GoogleFonts.kanit(
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                        ),
                        // style: TextStyle(
                        //     fontWeight: FontWeight.w300,
                        //     fontSize: 23,
                        //     color: Colors.black)
                      ),
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
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.folder_open_outlined,
                        color: Colors.blue,
                        size: 25,
                      ),
                      title: Text(
                        'สูตรที่ซื้อ',
                        style: GoogleFonts.kanit(
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                        ),
                        // style: TextStyle(
                        //     fontWeight: FontWeight.w300,
                        //     fontSize: 23,
                        //     color: Colors.black)
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Stack(
                        children: <Widget>[
                          new Icon(
                            Icons.notifications_none_outlined,
                            color: Colors.blue,
                            size: 25,
                          ),
                          new Positioned(
                            right: 0,
                            child: new Container(
                              padding: EdgeInsets.all(1),
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 13,
                                minHeight: 13,
                              ),
                              child: new Text(
                                '5',
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                      title: Text(
                        'การแจ้งเตือน',
                        style: GoogleFonts.kanit(
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationPage()),
                        );
                      },
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.settings,
                        color: Colors.blue,
                        size: 25,
                      ),
                      title: Text(
                        'ตั้งค่า',
                        style: GoogleFonts.kanit(
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                        ),
                        // style: TextStyle(
                        //     fontWeight: FontWeight.w300,
                        //     fontSize: 23,
                        //     color: Colors.black)
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        color: Colors.blue,
                        size: 25,
                      ),
                      title: Text(
                        'ออกจากระบบ',
                        style: GoogleFonts.kanit(
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                        ),
                        // style: TextStyle(
                        //     fontWeight: FontWeight.w300,
                        //     fontSize: 23,
                        //     color: Colors.black)
                      ),
                      onTap: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.setString("tokens", "");
                        // Navigator.pushNamedAndRemoveUntil(
                        //     context, '/slide-page', (Route<dynamic> route) => false);
                        // findUser();
                        // setState(() {});
                        this.findUser();
                        Navigator.pop(context);
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
                      child: Container(
                        height: 210,
                        child: DrawerHeader(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: new NetworkImage(
                                  "https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?size=626&ext=jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return LoginPage();
                                        }).then((value) {
                                      findUser();
                                      // Navigator.pop(context);
                                    });
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          'ลืมรหัสผ่าน',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        )),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      body: Container(
        child: ListView(
          children: [
            LimitedBox(
              maxHeight: 250,
              child: Stack(
                children: [
                  PageView(
                    controller: pageController,
                    children: [
                      AdsSlideCard(
                        slideImage:
                            "https://cdn.1112.com/1112/public/images/mobileapp/categories/pizza.png",
                      ),
                      AdsSlideCard(
                        slideImage:
                            "https://img.buzzfeed.com/thumbnailer-prod-us-east-1/video-api/assets/165384.jpg",
                      ),
                      AdsSlideCard(
                        slideImage:
                            "https://scm-assets.constant.co/scm/unilever/e9dc924f238fa6cc29465942875fe8f0/f9f93df5-dfe0-4c78-98ff-a05380282039.jpg",
                      )
                    ],
                  ),
                  Positioned(
                    bottom: 18.0,
                    left: 0.0,
                    right: 0.0,
                    child: Center(
                      child: SlideIndicator(
                        pageController: pageController,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children: [
                  MenuFeature(
                    iconAsset:
                        "https://image.flaticon.com/icons/png/128/5019/5019495.png",
                    name: "test",
                  ),
                  MenuFeature(
                    iconAsset:
                        "https://image.flaticon.com/icons/png/128/5019/5019428.png",
                    name: "test",
                  ),
                  MenuFeature(
                    iconAsset:
                        "https://image.flaticon.com/icons/png/128/5019/5019512.png",
                    name: "test",
                  ),
                  MenuFeature(
                    iconAsset:
                        "https://image.flaticon.com/icons/png/128/5019/5019453.png",
                    name: "test",
                  ),
                  MenuFeature(
                    iconAsset:
                        "https://image.flaticon.com/icons/png/128/5019/5019437.png",
                    name: "test",
                  ),
                  MenuFeature(
                    iconAsset:
                        "https://image.flaticon.com/icons/png/512/5019/5019349.png",
                    name: "test",
                  ),
                  MenuFeature(
                    iconAsset:
                        "https://image.flaticon.com/icons/png/128/5019/5019501.png",
                    name: "test",
                  ),
                  MenuFeature(
                    iconAsset:
                        "https://image.flaticon.com/icons/png/128/5018/5018006.png",
                    name: "test",
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DividerCutom(),
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
                    ],
                  ),
                ),
                Container(
                    height: 300,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return _foodCard_1(context);
                        })),
                DividerCutom(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "สูตรอาหารยอดนิยม2",
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
                    height: 300,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return _foodCard_2(context);
                        })),
                DividerCutom(),
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
                DividerCutom(),
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
                DividerCutom(),
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
                          return _introduce_safe_Card(context, index);
                        })),
                DividerCutom(),
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

                // Container(
                //     // height: 580,
                //     child: ListView.builder(
                //         // scrollDirection: Axis.vertical,
                //         shrinkWrap: true,
                //         physics: NeverScrollableScrollPhysics(),
                //         itemCount: 3,
                //         itemBuilder: (context, index) {
                //           return _foodCard_4(context);
                //         })),

                GridView.builder(
                    // scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      mainAxisExtent: 262,
                      // childAspectRatio: (deviceSize.width/deviceSize.height),
                      // crossAxisSpacing: 0,
                      // mainAxisSpacing: 0
                    ),
                    itemCount: 5,
                    itemBuilder: (BuildContext ctx, index) {
                      return Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                    "https://helpx.adobe.com/content/dam/help/en/photoshop/using/convert-color-image-black-white/jcr_content/main-pars/before_and_after/image-before/Landscape-Color.jpg"))),
                                      ),
                                      new SizedBox(
                                        width: 10.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8, 0, 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            new Text(
                                              "test",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold),
                                            ),
                                            new Text(
                                              "1 นาทีที่แล้ว",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 0, 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "ผัดกะเพราหมูสับไข่ดาวไม่สุกพิเศษwefwefwefascascascsa",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // SizedBox(height: 19,),
                            
                            Container(
                              height: 164,
                              // width: 500,
                              decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(50),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "https://helpx.adobe.com/content/dam/help/en/photoshop/using/convert-color-image-black-white/jcr_content/main-pars/before_and_after/image-before/Landscape-Color.jpg"),
                                      fit: BoxFit.cover)),
                            ),
                          ],
                        ),
                      
                      );
                    }),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Padding DividerCutom() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Container(
        color: Colors.grey[300],
        height: 8,
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
              height: 160,
              // width: 250,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://apifood.comsciproject.com/uploadPost/2021-06-19T144016088Z-image_cropper_1624113521886.jpg"),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "ผัดกะเพราพิเศษใส่ไข่สูตรผีบอก ณ.ขอนแก่นasdasdasdasasdas",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
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
            ),
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
              height: 160,
              // width: 250,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://apifood.comsciproject.com/uploadPost/2021-06-19T144016088Z-image_cropper_1624113521886.jpg"),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "ผัดกะเพราพิเศษใส่ไข่สูตรผีบอก ณ.ขอนแก่นasdasdasdasasdas",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "\$25",
                    style: TextStyle(
                        color: Colors.indigo, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
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
      width: 250,
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
              height: 210,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://apifood.comsciproject.com/uploadPost/2021-06-19T144016088Z-image_cropper_1624113521886.jpg"),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "ผัดกะเพราพิเศษใส่ไข่สูตรผีบอก ณ.ขอนแก่นasdasdasdasasdasasdasdasd",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
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
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "\$25",
                    style: TextStyle(
                        color: Colors.indigo, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
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

  Widget _introduce_safe_Card(context, index) {
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
                  "เซฟปก $index",
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
}

class SlideIndicator extends AnimatedWidget {
  final PageController pageController;
  SlideIndicator({this.pageController}) : super(listenable: pageController);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(3, buildIndicator),
    );
  }

  Widget buildIndicator(int index) {
    // print("build $index ");

    double select = max(
        0.0,
        1.0 -
            ((pageController.page ?? pageController.initialPage) - index)
                .abs());
    double decrease = 10 * select;

    // print("decrease = ${decrease}");
    return Container(
      width: 30,
      child: Center(
        child: Container(
          width: 20 - decrease,
          height: 4,
          decoration: BoxDecoration(
              color: decrease > 1.0 ? Colors.blue : Colors.black,
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

class AdsSlideCard extends StatelessWidget {
  final String slideImage;
  AdsSlideCard({this.slideImage});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              slideImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class MenuFeature extends StatelessWidget {
  final String iconAsset;
  final String name;
  MenuFeature({this.iconAsset, this.name});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Image.network(iconAsset),
            ),
            Text(
              name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

class PromoteShopCard extends StatelessWidget {
  final String image;
  PromoteShopCard({this.image});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width -
            MediaQuery.of(context).size.width / 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
