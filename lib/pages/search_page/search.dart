import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/search/searchRecipe_model.dart';
import 'package:easy_cook/models/search/searchUsername_model.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood2.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:easy_cook/models/search/searchRecipe_model.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

String token = ""; //โทเคน

//ข้อมูลสูตรอาหาร
List<Datum> dataRecipe;

//ข้อมูลผู้ใช้
List<DataUser> dataUser;

//ข้อมูลตัวเอง
DataAc dataAcUser;

bool body = true;

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    findToken();
    // print("ttttt = "+token);
  }

  Future<Null> getMyAccounts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        dataAcUser = myAccountFromJson(responseString).data[0];
        // dataAcUser = datas.data[0];
      });
    } else {
      return null;
    }
  }

  Future<Null> findToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
      getMyAccounts();
    });
  }

  Future<Null> getSearchRecipeNames(String recipName) async {
    dataRecipe = [];
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/searchRecipeName/" + recipName;

    print("token = " + token);
    final response = await http.get(Uri.parse(apiUrl));
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        // dataRecipe = searchRecipeNameFromJson(responseString).data;
        dataRecipe = searchRecipeNameFromJson(responseString).data;
        // dataRecipe = searchRecipeNameFromJson(responseString).data;
        // print(dataRecipe[0].recipeName);
        // datas = myAccountFromJson(responseString);
        // dataUser = datas.data[0];
      });
    } else {
      // flag = true;
      return null;
    }
  }

  Future<Null> getSearchUserNames(String userName) async {
    dataUser = [];
    final String apiUrl =
        "http://apifood.comsciproject.com/pjUsers/searchUser/" + userName;

    print("token = " + token);
    final response = await http.get(Uri.parse(apiUrl));
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        // dataRecipe = searchRecipeNameFromJson(responseString).data;
        dataUser = searchUserNameFromJson(responseString).data;
      });
    } else {
      // flag = true;
      return null;
    }
  }

  TextEditingController _controller = TextEditingController();
  var menuFood = [
    'เมนูน้ำ',
    'เมนูต้ม',
    'เมนูสุขภาพ',
    'เมนูนึ่ง',
    'เมนูตุ๋น',
    'เมนูทอด'
  ];
  var iconFood = [
    'assets/logos/drink.png',
    'assets/logos/pot.png',
    'assets/logos/vegetables.png',
    'assets/logos/steam.png',
    'assets/logos/stew.png',
    'assets/logos/fried.png'
  ];
  // _search() {}

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFf3f5f9),
      appBar: AppBar(
        title: Text('ค้นหา'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 12.0, bottom: 8.0), //กรอบ search
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: TextFormField(
                    onTap: () {
                      if (body == true) {
                        // Navigator.pushNamed(context, '/search-page');
                        body = false;
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new SearchPage()),
                        ).then((value) {
                          // if (value != null) {
                          //   image2[displayNumber - 1] = value.image;
                          //   // typeImage2[displayNumber - 1] = value.type;
                          //   // print("value.type = " + value.type);
                          //
                          // }
                          body = true;
                          setState(() {});
                        });
                      }
                      //
                      //
                      print(body);
                      setState(() {});
                    },
                    onChanged: (String text) {
                      setState(() {
                        // if (text == "") {
                        //   body = true;
                        // }
                        getSearchRecipeNames(text);
                        getSearchUserNames(text);
                      });
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: "ค้นหา",
                        contentPadding: const EdgeInsets.only(left: 24.0),
                        border: InputBorder.none,
                        enabled: true,
                        // filled: true
                        ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  // await getSearchRecipeNames();
                },
                // onPressed: () {
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => SearchRecipeName(_controller.text)));
                //   Navigator.pushNamed(context, '/searchRecipeName',arguments: _controller.text);
                //   Navigator.pushNamedAndRemoveUntil(context, '/searchRecipeName', (route) => false);
                // },
              ),
            ],
          ),
        ),
      ),

      // drawer: Container(
      //   width: deviceSize.width - 45,
      //   child: Drawer(
      //     child: ListView(
      //       children: [
      //         GestureDetector(
      //           onTap: () {},
      //           child: DrawerHeader(
      //             decoration: BoxDecoration(
      //               image: DecorationImage(
      //                 image: new NetworkImage(
      //                     "https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?size=626&ext=jpg"),
      //                 fit: BoxFit.cover,
      //               ),
      //             ),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     TextButton(
      //                         onPressed: () {
      //                           Navigator.pushNamed(context, '/login-page');
      //                         },
      //                         child: Text(
      //                           'เข้าสู่ระบบ',
      //                         ),
      //                         style: ButtonStyle(
      //                             side: MaterialStateProperty.all(BorderSide(
      //                                 width: 2, color: Colors.white)),
      //                             foregroundColor:
      //                                 MaterialStateProperty.all(Colors.white),
      //                             padding: MaterialStateProperty.all(
      //                                 EdgeInsets.symmetric(
      //                                     vertical: 10, horizontal: 50)),
      //                             textStyle: MaterialStateProperty.all(
      //                                 TextStyle(fontSize: 15)))),
      //                     TextButton(
      //                         onPressed: () {
      //                           Navigator.pushNamed(context, '/register-page');
      //                         },
      //                         child: Text(
      //                           'สมัครสมาชิก',
      //                         ),
      //                         style: ButtonStyle(
      //                             side: MaterialStateProperty.all(BorderSide(
      //                                 width: 2, color: Colors.white)),
      //                             foregroundColor:
      //                                 MaterialStateProperty.all(Colors.white),
      //                             padding: MaterialStateProperty.all(
      //                                 EdgeInsets.symmetric(
      //                                     vertical: 10, horizontal: 43)),
      //                             textStyle: MaterialStateProperty.all(
      //                                 TextStyle(fontSize: 15)))),
      //                   ],
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
      //                   child: Column(
      //                     children: [
      //                       Row(),
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //         ListTile(
      //           leading: Icon(
      //             Icons.folder,
      //             color: Colors.cyan,
      //             size: 30,
      //           ),
      //           title: Text('สูตรที่ซื้อ',
      //               style: TextStyle(
      //                   fontWeight: FontWeight.w300,
      //                   fontSize: 23,
      //                   color: Colors.black)),
      //           onTap: () {},
      //         ),
      //         ListTile(
      //           leading: Icon(
      //             Icons.notifications,
      //             color: Colors.cyan,
      //             size: 30,
      //           ),
      //           title: Text('การแจ้งเตือน',
      //               style: TextStyle(
      //                   fontWeight: FontWeight.w300,
      //                   fontSize: 23,
      //                   color: Colors.black)),
      //           onTap: () {},
      //         ),
      //         Divider(
      //           thickness: 0.5,
      //           color: Colors.grey,
      //         ),
      //         ListTile(
      //           leading: Icon(
      //             Icons.settings,
      //             color: Colors.cyan,
      //             size: 30,
      //           ),
      //           title: Text('ตั้งค่า',
      //               style: TextStyle(
      //                   fontWeight: FontWeight.w300,
      //                   fontSize: 23,
      //                   color: Colors.black)),
      //           onTap: () {},
      //         ),
      //         ListTile(
      //           leading: Icon(
      //             Icons.exit_to_app,
      //             color: Colors.cyan,
      //             size: 30,
      //           ),
      //           title: Text('ออกจากระบบ',
      //               style: TextStyle(
      //                   fontWeight: FontWeight.w300,
      //                   fontSize: 23,
      //                   color: Colors.black)),
      //           onTap: () {},
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: (_controller.text != "")
          ? DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(50.0),
                  child: AppBar(
                    // backgroundColor: Colors.redAccent,
                    elevation: 0,
                    bottom: TabBar(
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.white,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            color: Colors.grey[50]),
                        tabs: [
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("ค้นชื่อสูตรอาหาร"),
                            ),
                          ),
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("ค้นชื่อผู้ใช้"),
                            ),
                          ),
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("ค้นชื่อวัตถุดิบ"),
                            ),
                          ),
                        ]),
                  ),
                ),
                body: TabBarView(children: [
                  ListView.builder(
                      itemCount: dataRecipe.length,
                      itemBuilder: (context, index) => (index < 0)
                          ? new SizedBox(
                              child: Container(),
                            )
                          : (dataRecipe == null)
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      print("index = " + index.toString());
                                      print(dataRecipe[index]);
                                      // Navigator.pushReplacement(context, newRoute)
                                      Navigator.push(context,
                                          CupertinoPageRoute(
                                              builder: (context) {
                                        return ShowFood(dataRecipe[index]);
                                      }));
                                    },
                                    child: Container(
                                      child: FittedBox(
                                        child: Material(
                                          color: Colors.white,
                                          elevation: 14.0,
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                          shadowColor: Color(0x802196F3),
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0),
                                                  child: myDetailsContainer3(
                                                      dataRecipe, index),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              Container(
                                                width: 250,
                                                height: 180,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          24.0),
                                                  child: Image(
                                                    fit: BoxFit.cover,
                                                    alignment:
                                                        Alignment.topRight,
                                                    image: NetworkImage(
                                                        dataRecipe[index]
                                                            .image),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView.builder(
                      itemCount: dataUser.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            print("test = " + index.toString());
                            print(dataUser[index].userId);
                            print(dataUser[index].aliasName);
                            print(dataUser[index].nameSurname);
                            print(dataUser[index].profileImage);

                            // if (dataAcUser.userId == dataUser[index].userId) {
                            //   Navigator.pushNamedAndRemoveUntil(context, '/slide-page', (route) => false,arguments: 4);
                            // } else {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return ProfileUser(
                                    dataUser[index],
                                   );
                              }));
                            // }
                          },
                          child: ListTile(
                            title: Text(dataUser[index].aliasName),
                            subtitle: Text(dataUser[index].nameSurname),
                            leading: Container(
                              height: 40.0,
                              width: 40.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(
                                          dataUser[index].profileImage))),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Icon(Icons.movie),
                  Icon(Icons.games),
                ]),
              ))
          : (body == false)
              ? DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(50.0),
                      child: AppBar(
                        // backgroundColor: Colors.redAccent,
                        elevation: 0,
                        bottom: TabBar(
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.white,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                color: Colors.grey[50]),
                            tabs: [
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("ค้นชื่อสูตรอาหาร"),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("ค้นชื่อผู้ใช้"),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("ค้นชื่อวัตถุดิบ"),
                                ),
                              ),
                            ]),
                      ),
                    ),
                    // body: TabBarView(children: [
                    //   Icon(Icons.apps),
                    //   Icon(Icons.movie),
                    //   Icon(Icons.games),
                    // ]),
                  ))
              : GridView.count(
                  crossAxisCount: 4,
                  children: List.generate(6, (index) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.black,
                              backgroundImage: AssetImage(iconFood[index]),
                            ),
                          ),
                          Text(
                            menuFood[index],
                            // style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                    );
                  })),
    );
  }
}

Widget myDetailsContainer3(List<Datum> data, int index) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
            child: Text(
          dataRecipe[index].recipeName,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        )),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
            child: Row(
          children: <Widget>[
            Container(
                child: Text(
              dataRecipe[index].score.toString(),
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStarHalf,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
                child: Text(
              "(50)",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
          ],
        )),
      ),
      SizedBox(
        height: 50,
      ),
      Row(
        children: [
          new Container(
            height: 70.0,
            width: 70.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(dataRecipe[index].profileImage))),
          ),
          new SizedBox(
            width: 10.0,
          ),
          new Text(
            dataRecipe[index].aliasName,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    ],
  );
}
