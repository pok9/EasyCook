// import 'dart:html';

import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/search/searchRecipe_model.dart';
import 'package:easy_cook/models/search/searchUsername_model.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:easy_cook/pages/profile_page/xxx_profile.dart';
import 'package:easy_cook/pages/search_page/category/category.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
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
bool textFocus = false;

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
                    autofocus: textFocus,
                    onTap: () {
                      textFocus = true;
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
                          print("back pop");
                          body = true;
                          textFocus = false;
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
                        if (text == "") {
                          body = true;
                          // Navigator.pop(context);
                        }
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
                              child: Text("สูตรอาหาร"),
                            ),
                          ),
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("ผู้ใช้"),
                            ),
                          ),
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("วัตถุดิบ"),
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      print("index = " + index.toString());
                                      print(dataRecipe[index]);
                                      // Navigator.pushReplacement(context, newRoute)
                                      Navigator.push(context,
                                          CupertinoPageRoute(
                                              builder: (context) {
                                        return ShowFood(dataRecipe[index].rid);
                                      }));
                                    },
                                    child: Container(
                                      child: FittedBox(
                                        child: Material(
                                          color: Colors.white,
                                          elevation: 5.0,
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

                            if (dataAcUser.userId == dataUser[index].userId) {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return ProfilePage();
                              }));
                            } else {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return ProfileUser(
                                  dataUser[index].userId,
                                );
                              }));
                            }
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
                                  child: Text("สูตรอาหาร"),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("ผู้ใช้"),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("วัตถุดิบ"),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ))
              : DefaultTabController(
                  length: 2,
                  child: new Scaffold(
                    appBar: new PreferredSize(
                      preferredSize: Size.fromHeight(40),
                      child: new Container(
                        color: Colors.white70,
                        child: new SafeArea(
                          child: Column(
                            children: <Widget>[
                              new Expanded(child: new Container()),
                              new TabBar(
                                tabs: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Text(
                                      "หมวดหมู่",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  new Text(
                                    "Cart",
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    body: new TabBarView(
                      children: <Widget>[
                        ListView(
                          children: [
                            dividerTextCustom("ส่วนผสม"),
                            Container(
                              height: 75,
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: GridView.count(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 5,
                                  children: [
                                    MenuFeature(
                                      iconAsset:
                                          "https://image.flaticon.com/icons/png/128/5019/5019495.png",
                                      name: "เมนูน้ำ",
                                    ),
                                    MenuFeature(
                                      iconAsset:
                                          "https://image.flaticon.com/icons/png/128/5019/5019495.png",
                                      name: "เมนูสุขภาพ",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            dividerTextCustom("หมวดหมู่"),
                            Container(
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: GridView.count(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    crossAxisCount: 5,
                                    children: List.generate(6, (index) {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            GestureDetector(
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.black,
                                                backgroundImage:
                                                    AssetImage(iconFood[index]),
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
                              ),
                            ),
                            dividerTextCustom("หมวดหมู่"),
                            Container(
                              height: 75,
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: GridView.count(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    crossAxisCount: 5,
                                    children: List.generate(1, (index) {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            GestureDetector(
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.black,
                                                backgroundImage:
                                                    AssetImage(iconFood[index]),
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
                              ),
                            ),
                            dividerTextCustom("หมวดหมู่"),
                            Container(
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: GridView.count(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    crossAxisCount: 5,
                                    children: List.generate(6, (index) {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            GestureDetector(
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.black,
                                                backgroundImage:
                                                    AssetImage(iconFood[index]),
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
                              ),
                            ),
                            dividerTextCustom("หมวดหมู่"),
                            Container(
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: GridView.count(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    crossAxisCount: 5,
                                    children: List.generate(6, (index) {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            GestureDetector(
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.black,
                                                backgroundImage:
                                                    AssetImage(iconFood[index]),
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
                              ),
                            ),
                          ],
                        ),
                        new Column(
                          children: <Widget>[new Text("Cart Page")],
                        )
                      ],
                    ),
                  ),
                ),
    );
  }

  Padding dividerTextCustom(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: <Widget>[
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: Divider(
                color: Colors.black,
                height: 36,
              )),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: Divider(
                color: Colors.black,
                height: 36,
              )),
        ),
      ]),
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
      Row(
        children: [
          Container(
              child: Text(
            dataRecipe[index].score.toString(),
            style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
            ),
          )),
          RatingBarIndicator(
            rating: dataRecipe[index].score.toDouble(),
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.blue,
            ),
            itemCount: 5,
            itemSize: 15,
            direction: Axis.horizontal,
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
      ),
      // Padding(
      //   padding: const EdgeInsets.only(left: 8.0),
      //   child: Container(
      //       child: Row(
      //     children: <Widget>[
      //       Container(
      //           child: Text(
      //         dataRecipe[index].score.toString(),
      //         style: TextStyle(
      //           color: Colors.black54,
      //           fontSize: 18.0,
      //         ),
      //       )),
      //       Container(
      //         child: Icon(
      //           FontAwesomeIcons.solidStar,
      //           color: Colors.amber,
      //           size: 15.0,
      //         ),
      //       ),
      //       Container(
      //         child: Icon(
      //           FontAwesomeIcons.solidStar,
      //           color: Colors.amber,
      //           size: 15.0,
      //         ),
      //       ),
      //       Container(
      //         child: Icon(
      //           FontAwesomeIcons.solidStar,
      //           color: Colors.amber,
      //           size: 15.0,
      //         ),
      //       ),
      //       Container(
      //         child: Icon(
      //           FontAwesomeIcons.solidStarHalf,
      //           color: Colors.amber,
      //           size: 15.0,
      //         ),
      //       ),
      //       Container(
      //           child: Text(
      //         "(50)",
      //         style: TextStyle(
      //           color: Colors.black54,
      //           fontSize: 18.0,
      //         ),
      //       )),
      //     ],
      //   )),
      // ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new Text(
                dataRecipe[index].aliasName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              new Text(
                dataRecipe[index].nameSurname,
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          )
        ],
      ),
    ],
  );
}

class MenuFeature extends StatelessWidget {
  final String iconAsset;
  final String name;
  MenuFeature({this.iconAsset, this.name});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(name);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Category(
                    categoryName: name,
                    categoryFoodImage: "https://www.mama.co.th/imgadmins/img_product_cate/big/cate_big_20180409150840.jpg",
                  )),
        );
      },
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
              // style: TextStyle(fontSize: 16, ),
            )
          ],
        ),
      ),
    );
  }
}
