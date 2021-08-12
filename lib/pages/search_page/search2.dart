import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/search/searchIngred_model.dart';
import 'package:easy_cook/models/search/searchRecipe_model.dart';
import 'package:easy_cook/models/search/searchUsername_model.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:easy_cook/pages/search_page/searchIngredient/searchIngredient_page.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage2 extends StatefulWidget {
  @override
  _SearchPage2State createState() => _SearchPage2State();
}

class _SearchPage2State extends State<SearchPage2> {
  @override
  void initState() {
    super.initState();
    findToken();
  }

  String token = ""; //โทเคน
  Future<Null> findToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
      if (token != "") {
        getMyAccounts();
      }
    });
  }

  //ข้อมูลตัวเอง
  DataMyAccount dataAcUser;
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

  //ข้อมูลสูตรอาหาร
  List<DataRecipe> dataRecipe;
  Future<Null> getSearchRecipeNames(String recipName) async {
    dataRecipe = [];
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/searchRecipeName/" + recipName;

    final response = await http.get(Uri.parse(apiUrl));
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        dataRecipe = searchRecipeNameFromJson(responseString).data;
      });
    } else {
      // flag = true;
      return null;
    }
  }

  //ข้อมูลผู้ใช้
  List<DataUser> dataUser;
  Future<Null> getSearchUserNames(String userName) async {
    dataUser = [];
    final String apiUrl =
        "http://apifood.comsciproject.com/pjUsers/searchUser/" + userName;

    final response = await http.get(Uri.parse(apiUrl));

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

  //ข้อมูลวัตถุดิบ
  List<DataIngredient> dataIngredient;
  Set<String> dataIngredientName = Set();
  Future<Null> getSearchIngredient(String ingredient) async {
    dataIngredient = [];
    dataIngredientName = Set();
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/searchIngredient/" +
            ingredient;

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;
        print("pok test");
        // dataRecipe = searchRecipeNameFromJson(responseString).data;
        dataIngredient = searchIngredModelFromJson(responseString).data;
        for (int i = 0; i < dataIngredient.length; i++) {
          dataIngredientName.add(dataIngredient[i].ingredientName);
        }
      });
    } else {
      // flag = true;
      return null;
    }
  }

  
  @override
  Widget build(BuildContext context) {
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
                    autofocus: true,
                    onTap: () {
                      // textFocus = true;
                      // if (body == true) {
                      //   // Navigator.pushNamed(context, '/search-page');
                      //   body = false;
                      //   Navigator.push(
                      //     context,
                      //     new MaterialPageRoute(
                      //         builder: (context) => new SearchPage()),
                      //   ).then((value) {

                      //     print("back pop");
                      //     body = true;
                      //     textFocus = false;
                      //     setState(() {});
                      //   });
                      // }
                      // //
                      // //
                      // print(body);
                      // setState(() {});
                    },
                    onChanged: (String text) {
                      // setState(() {
                      //   if (text == "") {
                      //     body = true;

                      //   }
                      if (text != "") {
                        getSearchRecipeNames(text);
                        getSearchUserNames(text);
                        getSearchIngredient(text);
                      } else {
                        setState(() {
                          dataRecipe = [];
                          dataUser = [];
                          dataIngredientName = Set();
                        });
                      }

                      // });
                    },
                    // controller: _controller,
                    decoration: InputDecoration(
                      hintText: "ค้นหา...",
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
                  print(dataRecipe.length);
                },
              ),
            ],
          ),
        ),
      ),
      body: DefaultTabController(
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
                  itemCount: (dataRecipe == null) ? 0 : dataRecipe.length,
                  itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            print("index = " + index.toString());
                            print(dataRecipe[index]);
                            // Navigator.pushReplacement(context, newRoute)
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (context) {
                              return ShowFood(dataRecipe[index].rid);
                            }));
                          },
                          child: Container(
                            child: FittedBox(
                              child: Material(
                                color: Colors.white,
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(24.0),
                                shadowColor: Color(0x802196F3),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
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
                                            new BorderRadius.circular(24.0),
                                        child: Image(
                                          fit: BoxFit.cover,
                                          alignment: Alignment.topRight,
                                          image: NetworkImage(
                                              dataRecipe[index].image),
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
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ListView.builder(
                  itemCount: (dataUser == null) ? 0 : dataUser.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // print("test = " + index.toString());
                        // print(dataUser[index].userId);
                        // print(dataUser[index].aliasName);
                        // print(dataUser[index].nameSurname);
                        // print(dataUser[index].profileImage);

                        if (token == "") {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            return ProfileUser(
                              dataUser[index].userId,
                            );
                          }));
                        } else if (dataAcUser.userId ==
                            dataUser[index].userId) {
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

              ListView.builder(
                itemCount: (dataIngredientName == null)
                    ? 0
                    : dataIngredientName.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchIngredient(
                                  nameIngredient:
                                      dataIngredientName.elementAt(index),
                                )),
                      );
                    },
                    title: Text(dataIngredientName.elementAt(index)),
                  );
                },
              )
              // Icon(Icons.ac_unit),
            ]),
          )),
    );
  }

  Widget myDetailsContainer3(List<DataRecipe> data, int index) {
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
        SizedBox(
          height: 50,
        ),
        Row(
          children: [
            new Container(
              height: 50.0,
              width: 50.0,
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
}
