import 'package:easy_cook/models/myBuy/mybuy.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood/showFood.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PurchasedRecipes extends StatefulWidget {
  // const PurchasedRecipes({ Key? key }) : super(key: key);

  @override
  _PurchasedRecipesState createState() => _PurchasedRecipesState();
}

class _PurchasedRecipesState extends State<PurchasedRecipes> {
  @override
  void initState() {
    findUser();
  }

  String token = ""; //โทเคน
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
      print("token = ${token}");

      if (token != "") {
        getMybuy();
      }
    });
  }

  List<Mybuy> dataMybuy;
  Future<Null> getMybuy() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/mybuy";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("responseFeed_follow = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        dataMybuy = mybuyFromJson(responseString);
      });
    } else {
      return null;
    }
  }

  int _value = 1;

  bool reverse = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สูตรที่ซื้อ'),
      ),
      body: ListView(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                child: DropdownButton(
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                      if (_value == 1) {
                        this.reverse = false;
                      } else {
                        this.reverse = true;
                      }
                    });
                  },
                  value: _value,
                  items: [
                    DropdownMenuItem(
                      child: Text("สูตรที่ซื้อ (ล่าสุด)"),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("สูตรที่ซื้อ (เก่าสุด)"),
                      value: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          (dataMybuy == null)
              ? Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  reverse: this.reverse,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: dataMybuy.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ShowFood(dataMybuy[index].recipeId)),
                        );
                      },
                      child: Card(
                        child: Container(
                          color: Colors.grey[100],
                          height: 165,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Container(
                                      height: 154,
                                      child: Image.network(
                                        dataMybuy[index].image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    elevation: 5,
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              dataMybuy[index].recipeName,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.food_bank,
                                              color: Colors.grey,
                                              size: 15,
                                            ),
                                            SizedBox(
                                              width: 1,
                                            ),
                                            Text(dataMybuy[index].foodCategory),
                                          ],
                                        ),
                                      ),
                                      Expanded(child: Container()),
                                      Divider(color: Colors.black,),
                                      Row(
                                        children: [
                                          Container(
                                            height: 25.0,
                                            width: 25.0,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                        dataMybuy[index]
                                                            .profileImage))),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            dataMybuy[index].aliasName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                    // return Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 5.0),
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Padding(
                    //           padding: const EdgeInsets.fromLTRB(
                    //               5.0, 0.0, 0.0, 0.0),
                    //           child: Card(
                    //             semanticContainer: true,
                    //             clipBehavior: Clip.antiAliasWithSaveLayer,
                    //             child: Container(
                    //               height: 154,
                    //               child: Image.network(
                    //                 dataMybuy[index].image,
                    //                 fit: BoxFit.cover,
                    //               ),
                    //             ),
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(5.0),
                    //             ),
                    //             elevation: 5,
                    //           )),
                    //       Expanded(
                    //           flex: 2,
                    //           child: Padding(
                    //             padding: const EdgeInsets.fromLTRB(
                    //                 5.0, 10.0, 0.0, 0.0),
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: <Widget>[
                    //                 Text(
                    //                   dataMybuy[index].recipeName,
                    //                   maxLines: 2,
                    //                   overflow: TextOverflow.ellipsis,
                    //                   style: const TextStyle(
                    //                     fontWeight: FontWeight.w500,
                    //                     // fontSize: 20.0,
                    //                   ),
                    //                 ),

                    //                 Row(
                    //                   children: [
                    //                     new Container(
                    //                       height: 25.0,
                    //                       width: 25.0,
                    //                       decoration: new BoxDecoration(
                    //                           shape: BoxShape.circle,
                    //                           image: new DecorationImage(
                    //                               fit: BoxFit.fill,
                    //                               image: new NetworkImage(
                    //                                   "https://placeimg.com/640/480/any"))),
                    //                     ),
                    //                     new Text(
                    //                       "เซฟปก",
                    //                       style: TextStyle(
                    //                           fontWeight: FontWeight.w500),
                    //                     )
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //           )),
                    //       IconButton(onPressed: (){}, icon: Icon(
                    //         Icons.more_vert,
                    //         size: 16.0,
                    //       ))
                    //     ],
                    //   ),
                    // );
                  },
                )
        ],
      ),
    );
  }
}
