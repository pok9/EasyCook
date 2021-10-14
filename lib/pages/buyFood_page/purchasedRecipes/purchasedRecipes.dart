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
  // @override
  // void initState() {
  //   findUser();
  // }

  String token = ""; //โทเคน
  // Future<Null> findUser() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();

  //   setState(() {
  //     token = preferences.getString("tokens");
  //     print("token = ${token}");

  //     if (token != "") {
  //       getMybuy();
  //     }
  //   });
  // }

  List<Mybuy> dataMybuy;
  // Future<Null> getMybuy() async {
  //   final String apiUrl = "http://apifood.comsciproject.com/pjPost/mybuy";

  //   final response = await http
  //       .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
  //   print("responseFeed_follow = " + response.statusCode.toString());
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       final String responseString = response.body;

  //       dataMybuy = mybuyFromJson(responseString);
  //     });
  //   } else {
  //     return null;
  //   }
  // }

  int _value = 1;

  bool reverse = false;

  Future<bool> loadList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    token = preferences.getString("tokens");

    // if (token != "" ) {
    //   getMybuy();
    // }
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/mybuy";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      dataMybuy = mybuyFromJson(responseString);
    } else {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf3f5f9),
      appBar: AppBar(
        title: Text('สูตรที่ซื้อ'),
      ),
      body: FutureBuilder(
        future: loadList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return (dataMybuy.length == 0)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                            child:
                                Image.asset("assets/splash/hamberger.png")),
                        SizedBox(height: 30,),
                        Text(
                          "คุณยังไม่ได้ซื้อสูตรอาหาร",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      ],
                    ),
                  )
                : ListView(
                    children: [
                      (dataMybuy.length <= 1)
                          ? Container()
                          : Row(
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
                      ListView.builder(
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
                                color: Colors.white,
                                height: 165,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Card(
                                          semanticContainer: true,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          child: Container(
                                            height: 154,
                                            child: Image.network(
                                              dataMybuy[index].image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          elevation: 5,
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    dataMybuy[index].recipeName,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
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
                                                  Text(dataMybuy[index]
                                                      .foodCategory),
                                                ],
                                              ),
                                            ),
                                            Expanded(child: Container()),
                                            Divider(
                                              color: Colors.black,
                                            ),
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
                                                Expanded(
                                                  child: Text(
                                                    dataMybuy[index].aliasName,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
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
                        },
                      )
                    ],
                  );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
