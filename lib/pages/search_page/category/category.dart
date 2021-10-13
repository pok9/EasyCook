import 'package:easy_cook/models/category/category_model.dart';
import 'package:easy_cook/models/myBuy/mybuy.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/pages/buyFood_page/recipe_purchase_page.dart';

import 'package:easy_cook/pages/showFood&User_page/XXX_showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood/showFood.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:http/http.dart' as http;

class Category extends StatefulWidget {
  String categoryName;
  String categoryFoodImage;

  Category({this.categoryName, this.categoryFoodImage});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
    getCategoryFood();
  }

  String token = ""; //โทเคน
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");

      print(token);
      if (token != "" && token != null) {
        getMyAccounts();
        getMybuy();
      }
    });
  }

  //user
  MyAccount datas;
  DataMyAccount dataUser;
  Future<Null> getMyAccounts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("responseFeed_follow = " + response.statusCode.toString());
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

  List<Mybuy> dataMybuy;
  List<String> checkBuy = [];
  Future<Null> getMybuy() async {
    checkBuy = [];
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/mybuy";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("responseFeed_follow = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        dataMybuy = mybuyFromJson(responseString);
        for (var item in dataMybuy) {
          print(item.recipeId);
          checkBuy.add(item.recipeId.toString());
        }
        print("checkBuy.indexOf() = ${checkBuy.indexOf("181") > 0}");
        print("checkBuy.length = ${checkBuy.length}");
        print(checkBuy);
        // print("set=====");
      });
    } else {
      return null;
    }
  }

  List<CategoryModel> categoryFood;
  Future<Null> getCategoryFood() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/searchWithCategory/" +
            this.widget.categoryName;

    final response = await http.get(Uri.parse(apiUrl));
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        if (responseString.contains("message")) {
          categoryFood = [];
        } else {
          categoryFood = categoryModelFromJson(responseString);
        }
      });
    } else {
      return null;
    }
  }

  var numberFormat = NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return (this.widget.categoryName == "" ||
            this.widget.categoryFoodImage == "" ||
            categoryFood == null)
        ? Material(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                CircularProgressIndicator()
              ],
            ),
          )
        : Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text(this.widget.categoryName),
                  pinned: true,
                  expandedHeight: 180.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      this.widget.categoryFoodImage, ///////////////////////////
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate(List.generate(
                        categoryFood.length,
                        (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: InkWell(
                                  onTap: () {
                                    if (categoryFood[index].price == 0) {
                                      print(categoryFood[index].rid);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ShowFood(
                                                categoryFood[index].rid)),
                                      );
                                    } else {
                                      if (dataUser == null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RecipePurchasePage(
                                                    req_rid:
                                                        categoryFood[index].rid,
                                                  )),
                                        );
                                      } else {
                                        if (dataUser.userId ==
                                                categoryFood[index].userId ||
                                            checkBuy.indexOf(categoryFood[index]
                                                    .rid
                                                    .toString()) >=
                                                0) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ShowFood(
                                                    categoryFood[index].rid)),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RecipePurchasePage(
                                                      req_rid:
                                                          categoryFood[index]
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
                                                    new BorderRadius.circular(
                                                        15.0),
                                                child: Image(
                                                  fit: BoxFit.cover,
                                                  // alignment: Alignment.topRight,
                                                  image: NetworkImage(categoryFood[
                                                          index]
                                                      .image), ////////////////////////////////////////////////////////
                                                ),
                                              ),
                                            ),
                                            (categoryFood[index].price == 0)
                                                ? Container()
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8, right: 8),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            (dataUser == null)
                                                                ? CircleAvatar(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    radius: 16,
                                                                  )
                                                                : (dataUser.userId ==
                                                                        categoryFood[index]
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
                                                              child: Container(
                                                                height: 30,
                                                                width: 30,
                                                                child: (dataUser ==
                                                                        null)
                                                                    ? Image.network(
                                                                        "https://image.flaticon.com/icons/png/512/1177/1177428.png")
                                                                    : (dataUser.userId ==
                                                                            categoryFood[index]
                                                                                .userId)
                                                                        ? Container()
                                                                        : (checkBuy.indexOf(categoryFood[index].rid.toString()) >=
                                                                                0)
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
                                                  categoryFood[index]
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
                                              (categoryFood[index].score == 0)
                                                  ? Container()
                                                  : Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.blue,
                                                          size: 18,
                                                        ),
                                                        Text(categoryFood[index]
                                                                .score
                                                                .toString() +
                                                            "/5(${categoryFood[index].count})")
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 8, 0, 8),
                                          child: Row(
                                            children: [
                                              new Container(
                                                height: 30.0,
                                                width: 30.0,
                                                decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: new DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: new NetworkImage(
                                                            categoryFood[index]
                                                                .profileImage))),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  categoryFood[index]
                                                          .nameSurname +
                                                      "(${categoryFood[index].aliasName})",
                                                  maxLines: 1,style: TextStyle(overflow: TextOverflow.ellipsis,),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ))))
              ],
            ),
          );
  }
}
