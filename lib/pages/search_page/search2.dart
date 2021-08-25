import 'package:easy_cook/models/myBuy/mybuy.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/search/searchIngred_model.dart';
import 'package:easy_cook/models/search/searchRecipe_model.dart';
import 'package:easy_cook/models/search/searchUsername_model.dart';
import 'package:easy_cook/models/search/tranlate_languageModel/tranlate_languageModel.dart';
import 'package:easy_cook/pages/buyFood_page/recipe_purchase_page.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:easy_cook/pages/search_page/searchIngredient/searchIngredient_page.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

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
      if (token != "" && token != null) {
        getMyAccounts();

        getMybuy();
      }
    });
  }

  //ข้อมูลตัวเอง
  DataMyAccount dataAcUser;
  Future<Null> getMyAccounts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        dataAcUser = myAccountFromJson(responseString).data[0];
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
    imageTranslationResPath = [];
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/searchIngredient/" +
            ingredient;

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        dataIngredient = searchIngredModelFromJson(responseString).data;
        for (int i = 0; i < dataIngredient.length; i++) {
          dataIngredientName.add(dataIngredient[i].ingredientName);
        }
        for (int i = 0; i < dataIngredientName.length; i++) {
          tranlate_language(dataIngredient[i].ingredientName);
        }
      });
    } else {
      // flag = true;
      return null;
    }
  }

  TranlateLanguageModel translationRes;
  List<String> imageTranslationResPath = [];
  void tranlate_language(String input) async {
    var translation = await translator.translate(input, from: 'th', to: 'en');
    print(translation);

    final String apiUrl =
        "https://api.pexels.com/v1/search?query=${translation}&per_page=1";

    final response = await http.get(Uri.parse(apiUrl), headers: {
      "Content-Type": "application/json",
      "Authorization":
          "563492ad6f91700001000001b188747699b94c359b127e9ce347ea08"
    });

    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        translationRes = tranlateLanguageModelFromJson(responseString);

        if (translationRes.totalResults > 0) {
          imageTranslationResPath.add(translationRes.photos[0].src.original);
        } else {
          imageTranslationResPath.add("");
        }
      });
    } else {
      // flag = true;
      return null;
    }
  }

  List<Mybuy> dataMybuy;
  List<String> checkBuy = [];
  Future<Null> getMybuy() async {
    checkBuy = [];
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/mybuy";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("responseFeed_follow = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          final String responseString = response.body;

          dataMybuy = mybuyFromJson(responseString);
          for (var item in dataMybuy) {
            print(item.recipeId);
            checkBuy.add(item.recipeId.toString());
          }
        });
    } else {
      return null;
    }
  }

  bool isText = false;
  final translator = GoogleTranslator();
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
                    autofocus: true,
                    onTap: () {},
                    onChanged: (String text) {
                      if (text != "") {
                        getSearchRecipeNames(text);
                        getSearchUserNames(text);
                        getSearchIngredient(text);
                        isText = true;
                      } else {
                        setState(() {
                          isText = false;
                          dataRecipe = [];
                          dataUser = [];
                          dataIngredientName = Set();
                        });
                      }

                      // });
                    },
                    decoration: InputDecoration(
                      hintText: "ค้นหา...",
                      contentPadding: const EdgeInsets.only(left: 24.0),
                      border: InputBorder.none,
                      enabled: true,
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
            body: (isText == false)
                ? Container()
                : TabBarView(children: [
                    (dataRecipe == null)
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                            ),
                          )
                        : ListView.builder(
                            itemCount: dataRecipe.length,
                            itemBuilder: (context, index) => Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (dataRecipe[index].price == 0) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ShowFood(
                                                    dataRecipe[index].rid)),
                                          );
                                        } else {
                                          if (dataAcUser == null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RecipePurchasePage(
                                                        req_rid:
                                                            dataRecipe[index]
                                                                .rid,
                                                      )),
                                            );
                                          } else {
                                            if (dataAcUser.userId ==
                                                    dataRecipe[index].userId ||
                                                checkBuy.indexOf(
                                                        dataRecipe[index]
                                                            .rid
                                                            .toString()) >=
                                                    0) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShowFood(
                                                            dataRecipe[index]
                                                                .rid)),
                                              );
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RecipePurchasePage(
                                                          req_rid:
                                                              dataRecipe[index]
                                                                  .rid,
                                                        )),
                                              );
                                            }
                                          }
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 16, 16, 0),
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  width: deviceSize.width,
                                                  height: 220,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(15.0),
                                                    child: Image(
                                                      fit: BoxFit.cover,
                                                      // alignment: Alignment.topRight,
                                                      image: NetworkImage(
                                                          dataRecipe[index]
                                                              .image), ////////////////////////////////////////////////////////
                                                    ),
                                                  ),
                                                ),
                                                (dataRecipe[index].price == 0)
                                                    ? Container()
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 8,
                                                                right: 8),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Stack(
                                                              children: [
                                                                (dataAcUser.userId ==
                                                                        dataRecipe[index]
                                                                            .userId)
                                                                    ? Container()
                                                                    : CircleAvatar(
                                                                        backgroundColor:
                                                                            Colors.white,
                                                                        radius:
                                                                            16,
                                                                      ),
                                                                Positioned(
                                                                  top: 1,
                                                                  right: 1,
                                                                  child:
                                                                      Container(
                                                                    height: 30,
                                                                    width: 30,
                                                                    child: (dataAcUser ==
                                                                            null)
                                                                        ? Image.network(
                                                                            "https://image.flaticon.com/icons/png/512/1177/1177428.png")
                                                                        : (dataAcUser.userId ==
                                                                                dataRecipe[index].userId)
                                                                            ? Container()
                                                                            : (checkBuy.indexOf(dataRecipe[index].rid.toString()) >= 0)
                                                                                ? Image.network("https://image.flaticon.com/icons/png/512/1053/1053171.png")
                                                                                : Image.network("https://image.flaticon.com/icons/png/512/1177/1177428.png"),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, bottom: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                      dataRecipe[index]
                                                          .recipeName,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    // flex: 1,
                                                    child: (dataRecipe[index]
                                                                .score ==
                                                            0)
                                                        ? Container()
                                                        : Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Icon(
                                                                Icons.star,
                                                                color:
                                                                    Colors.blue,
                                                                size: 18,
                                                              ),
                                                              Text(dataRecipe[
                                                                          index]
                                                                      .score
                                                                      .toString() +
                                                                  "/5")
                                                            ],
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
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
                                                              dataRecipe[index]
                                                                  .profileImage))),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(dataRecipe[index]
                                                        .nameSurname +
                                                    "(${dataRecipe[index].aliasName})")
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    )
                                  ],
                                )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: ListView.builder(
                        itemCount: (dataUser == null) ? 0 : dataUser.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
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
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchIngredient(
                                        nameIngredient:
                                            dataIngredientName.elementAt(index),
                                      )),
                            );
                          },
                          leading: (imageTranslationResPath.isEmpty)
                              ? null
                              : (imageTranslationResPath.length !=
                                      dataIngredientName.length)
                                  ? null
                                  : (imageTranslationResPath[index] == "")
                                      ? null
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              imageTranslationResPath[index]),
                                        ),
                          title: Text(dataIngredientName.elementAt(index)),
                        );
                      },
                    )
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
