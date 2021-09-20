import 'package:easy_cook/models/feed/recommendRecipe/recommendRecipe.dart';
import 'package:easy_cook/models/myBuy/mybuy.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/pages/buyFood_page/recipe_purchase_page.dart';
import 'package:easy_cook/pages/showFood&User_page/XXX_showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RecommendPage extends StatefulWidget {
  @override
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();

    getRecommendRecipe();
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

  //user
  MyAccount data_MyAccount;
  DataMyAccount data_DataAc;
  Future<Null> getMyAccounts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          final String responseString = response.body;

          data_MyAccount = myAccountFromJson(responseString);
          data_DataAc = data_MyAccount.data[0];

          // checkFollowings();
        });
    } else {
      return null;
    }
  }

  List<RecommendRecipe> dataRecommendRecipe;

  Future<Null> getRecommendRecipe() async {
    //ฟิดที่เรากดติดตาม
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/recommendRecipe";

    final response = await http.get(Uri.parse(apiUrl));
    // print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          final String responseString = response.body;

          dataRecommendRecipe = recommendRecipeFromJson(responseString);
          if (token != "" && token != null) {
            getMybuy();
          }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("แนะนำสูตรอาหาร"),
        ),
        body: (dataRecommendRecipe == null)
            ? Container(
                height: 329,
              )
            : StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                itemCount: dataRecommendRecipe.length,
                itemBuilder: (context, index) {
                  // return Container(
                  //   decoration: BoxDecoration(
                  //       color: Colors.transparent,
                  //       borderRadius: BorderRadius.all(Radius.circular(15))),
                  //   child: FadeInImage.assetNetwork(
                  //     placeholder: 'assets/loadGif/loadding.gif',
                  //     image: dataRecommendRecipe[indx].image,
                  //     fit: BoxFit.cover,
                  //   ),
                  // );
                  return _recommendRecipeCard(
                      context, dataRecommendRecipe[index]);
                },
                staggeredTileBuilder: (int index) {
                  return StaggeredTile.count(1, index.isEven ? 1.2 : 1.5);
                },
              ));
  }

  Widget _recommendRecipeCard(context, RecommendRecipe dataRecommendRecipe) {
    return InkWell(
      onTap: () {
        if (data_DataAc != null) {
          if (dataRecommendRecipe.price == 0 ||
              dataRecommendRecipe.userId == data_DataAc.userId ||
              checkBuy.indexOf(dataRecommendRecipe.rid.toString()) >= 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShowFood(dataRecommendRecipe.rid)),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipePurchasePage(
                        req_rid: dataRecommendRecipe.rid,
                      )),
            ).then((value) {
              if (token != "" && token != null) {
                getMybuy();
              }
            });
          }
        } else {
          if (dataRecommendRecipe.price == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShowFood(dataRecommendRecipe.rid)),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipePurchasePage(
                        req_rid: dataRecommendRecipe.rid,
                      )),
            ).then((value) {
              if (token != "" && token != null) {
                getMybuy();
              }
            });
          }
        }
      },
      child: Container(
        width: 230,
        child: Stack(
          children: [
            Container(
              // height: 500,
              height: 300,
              width: 230,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(20)),
                clipBehavior: Clip.antiAlias,
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/loadGif/loadding.gif',
                  image: dataRecommendRecipe.image,
                  fit: BoxFit.cover,
                ),
                // child: Image.network(
                //   dataRecommendRecipe.image,
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            (dataRecommendRecipe.score == 0)
                ? Container()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.blue,
                          size: 20,
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        Text(
                          dataRecommendRecipe.score.toString(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          '(${dataRecommendRecipe.count})',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
            (dataRecommendRecipe.price == 0)
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(top: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Stack(
                          children: [
                            (data_DataAc == null)
                                ? CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 16,
                                  )
                                : (data_DataAc.userId ==
                                        dataRecommendRecipe.userId)
                                    ? Container()
                                    : CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 16,
                                      ),
                            Positioned(
                              top: 1,
                              right: 1,
                              child: Container(
                                height: 30,
                                width: 30,
                                child: (data_DataAc == null)
                                    ? Image.network(
                                        "https://image.flaticon.com/icons/png/512/1177/1177428.png")
                                    : (data_DataAc.userId ==
                                            dataRecommendRecipe.userId)
                                        ? Container()
                                        : (checkBuy.indexOf(dataRecommendRecipe
                                                    .rid
                                                    .toString()) >=
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
                  ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //       "testasdjasjdknkjaskdnjkasndkj",
                  //       style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20),
                  //     ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dataRecommendRecipe.recipeName,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            // margin: EdgeInsets.all(100.0),
                            height: 32.0,
                            width: 32.0,
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                          ),
                          Positioned(
                            top: 1,
                            right: 1,
                            child: new Container(
                              height: 30.0,
                              width: 30.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(
                                          dataRecommendRecipe.profileImage))),
                            ),
                          ),
                        ],
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      new Text(
                        dataRecommendRecipe.aliasName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
