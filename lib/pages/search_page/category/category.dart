import 'package:easy_cook/models/category/category_model.dart';
import 'package:easy_cook/pages/recipeArchive_page/recipeArchive.dart';
import 'package:easy_cook/pages/recipe_purchase_page/recipe_purchase_page.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    getCategoryFood();
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
    return (categoryFood == null)
        ? Material(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text(
                //   "Initialization",
                //   style: TextStyle(
                //     fontSize: 32,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
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
                    background: Image.network(
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
                                                  categoryFood:
                                                      categoryFood[index],
                                                )),
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 200,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.white,
                                                height: 200,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(4, 4, 0, 0),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  categoryFood[
                                                                          index]
                                                                      .recipeName,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          (categoryFood[index]
                                                                      .price ==
                                                                  0)
                                                              ? Container()
                                                              : Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 5),
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child: Text(
                                                                              "\฿${numberFormat.format(categoryFood[index].price)}",
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textAlign: TextAlign.left,
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red)))
                                                                    ],
                                                                  ),
                                                                )
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(4, 0, 4, 0),
                                                      child: Divider(
                                                        height: 1,
                                                        thickness: 1,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Text(
                                                            categoryFood[index]
                                                                .description,
                                                            maxLines: 4,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ))
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(4, 0, 4, 0),
                                                      child: Divider(
                                                        height: 1,
                                                        thickness: 1,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(4, 0, 0, 8),
                                                      child: Row(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    categoryFood[
                                                                            index]
                                                                        .profileImage),
                                                            radius: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              categoryFood[
                                                                      index]
                                                                  .aliasName,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.white,
                                                height: 200,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Hero(
                                                    tag:
                                                        categoryFood[index].rid,
                                                    child: Image.network(
                                                      categoryFood[index].image,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
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
