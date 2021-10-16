import 'package:easy_cook/models/myBuy/mybuy.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/search/searchIngred_model.dart';
import 'package:easy_cook/models/showfood/showfood_model.dart';
import 'package:easy_cook/pages/buyFood_page/recipe_purchase_page.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood/showFood.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ShowIngredientPage extends StatefulWidget {
  final String nameIngredient;
  final String image;

  const ShowIngredientPage({Key key,this.nameIngredient,this.image}) : super(key: key);

  @override
  _ShowIngredientPageState createState() => _ShowIngredientPageState();
}

class _ShowIngredientPageState extends State<ShowIngredientPage> {
  @override
  void initState() {
    super.initState();
    findToken();
    getSearchIngredient(this.widget.nameIngredient);
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

  List<DataIngredient> dataIngredient;

  Future<Null> getSearchIngredient(String ingredient) async {
    dataIngredient = [];
    listDataFood = {};
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/searchIngredient/" +
            ingredient;

    final response = await http.get(Uri.parse(apiUrl));
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;
        print("pok test");
        // dataRecipe = searchRecipeNameFromJson(responseString).data;
        dataIngredient = searchIngredModelFromJson(responseString).data;

        for (int i = 0; i < dataIngredient.length; i++) {
          getPost(dataIngredient[i].rid);
        }
      });
    } else {
      // flag = true;
      return null;
    }
  }

  //ข้อมูลสูตรอาหารที่ค้นหา
  ShowFoods dataFood;

  Set<ShowFoods> listDataFood = Set();

  //ดึงข้อมูลสูตรอาหารที่ค้นหา
  Future<Null> getPost(int req_rid) async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/getPost/" + req_rid.toString();
    // print("xxlToken = " + token);
    final response = await http.get(Uri.parse(apiUrl));
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;
        dataFood = showFoodsFromJson(responseString);
        listDataFood.add(dataFood);
      });
    } else {
      return null;
    }
  }

  
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text(this.widget.nameIngredient),
                  pinned: true,
                  expandedHeight: 180.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      this.widget.image, 
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate(List.generate(
                        listDataFood.length,
                        (index) => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (listDataFood.elementAt(index).price == 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowFood(
                                            listDataFood.elementAt(index).rid)),
                                  );
                                } else {
                                  if (dataAcUser == null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RecipePurchasePage(
                                                req_rid: listDataFood
                                                    .elementAt(index)
                                                    .rid,
                                              )),
                                    );
                                  } else {
                                    if (dataAcUser.userId ==
                                            listDataFood
                                                .elementAt(index)
                                                .userId ||
                                        checkBuy.indexOf(listDataFood
                                                .elementAt(index)
                                                .rid
                                                .toString()) >=
                                            0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ShowFood(
                                                listDataFood
                                                    .elementAt(index)
                                                    .rid)),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RecipePurchasePage(
                                                  req_rid: listDataFood
                                                      .elementAt(index)
                                                      .rid,
                                                )),
                                      ).then((value) {
                                        getMybuy();
                                      });
                                    }
                                  }
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: deviceSize.width,
                                          height: 220,
                                          child: ClipRRect(
                                            borderRadius:
                                                new BorderRadius.circular(15.0),
                                            child: Image(
                                              fit: BoxFit.cover,
                                              // alignment: Alignment.topRight,
                                              image: NetworkImage(listDataFood
                                                  .elementAt(index)
                                                  .image), ////////////////////////////////////////////////////////
                                            ),
                                          ),
                                        ),
                                        (listDataFood.elementAt(index).price ==
                                                0)
                                            ? Container()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8, right: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundColor:
                                                              Colors.white,
                                                          radius: 16,
                                                        ),
                                                        Positioned(
                                                          top: 1,
                                                          right: 1,
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            child: (dataAcUser ==
                                                                    null)
                                                                ? Image.network(
                                                                    "https://image.flaticon.com/icons/png/512/1177/1177428.png")
                                                                : (dataAcUser
                                                                            .userId ==
                                                                        listDataFood
                                                                            .elementAt(
                                                                                index)
                                                                            .userId)
                                                                    ? Container()
                                                                    : (checkBuy.indexOf(listDataFood.elementAt(index).rid.toString()) >=
                                                                            0)
                                                                        ? Image.network(
                                                                            "https://image.flaticon.com/icons/png/512/1053/1053171.png")
                                                                        : Image.network(
                                                                            "https://image.flaticon.com/icons/png/512/1177/1177428.png"),
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
                                          Text(
                                            listDataFood
                                                .elementAt(index)
                                                .recipeName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          Expanded(
                                            // flex: 1,
                                            child: Container()
                                          ),
                                          (listDataFood
                                                        .elementAt(index)
                                                        .score ==
                                                    0)
                                                ? Container()
                                                : Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.blue,
                                                        size: 18,
                                                      ),
                                                      Text(listDataFood
                                                          .elementAt(index)
                                                          .score
                                                          .toString()+"/5(${listDataFood
                                                          .elementAt(index)
                                                          .count})")
                                                    ],
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
                                                      listDataFood
                                                          .elementAt(index)
                                                          .profileImage))),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(listDataFood
                                                  .elementAt(index)
                                                  .nameSurname +
                                              "(${listDataFood.elementAt(index).aliasName})",maxLines: 1,style: TextStyle(),),
                                        )
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
                        ))))
              ],
            ),
          );
  }
}
