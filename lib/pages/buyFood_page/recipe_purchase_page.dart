import 'dart:convert';

import 'package:easy_cook/models/buyFood/buyFood.dart';
import 'package:easy_cook/models/category/category_model.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/showfood/showfood_model.dart';
import 'package:easy_cook/pages/login&register_page/login_page/login.dart';

import 'package:easy_cook/pages/showFood&User_page/showFood.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RecipePurchasePage extends StatefulWidget {
  // const RecipePurchasePage({ Key? key }) : super(key: key);
  // CategoryModel categoryFood;
  // RecipePurchasePage({this.categoryFood});

  int req_rid;
  RecipePurchasePage({this.req_rid});

  @override
  _RecipePurchasePageState createState() => _RecipePurchasePageState();
}

class _RecipePurchasePageState extends State<RecipePurchasePage> {
  var numberFormat = NumberFormat("#,###");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
    getPost();
  }

  String token = ""; //โทเคน
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
      if (token != "") {
        getMyAccounts();
      }
    });
  }

  //user
  MyAccount datas;
  DataAc myDataUser;
  Future<Null> getMyAccounts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      final String responseString = response.body;

      datas = myAccountFromJson(responseString);
      myDataUser = datas.data[0];

      setState(() {});
    } else {
      return null;
    }
  }

  //ข้อมูลสูตรอาหารที่ค้นหา
  ShowFoods dataFood;
  //ดึงข้อมูลสูตรอาหารที่ค้นหา
  Future<Null> getPost() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/getPost/${this.widget.req_rid}";
    // print("xxlToken = " + token);
    final response = await http.get(Uri.parse(apiUrl));
    print("getPostresponse = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;
        dataFood = showFoodsFromJson(responseString);
      });
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (dataFood == null)
        ? Scaffold()
        : Scaffold(
            backgroundColor: Colors.grey,
            appBar: AppBar(
              title: Text(dataFood.recipeName),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                  child: Hero(
                    tag: dataFood.rid,
                    child: Image.network(
                      dataFood.image,
                      height: size.height * 0.27,
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dataFood.recipeName,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      RatingBarIndicator(
                                        rating: 3,
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: Colors.blue,
                                        ),
                                        itemCount: 5,
                                        itemSize: 20.5,
                                        direction: Axis.horizontal,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("24 reviews")
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(dataFood.profileImage),
                                        radius: 15,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          dataFood.aliasName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                              Text(
                                "\฿${numberFormat.format(dataFood.price)}",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  dataFood.description,
                                  style: TextStyle(height: 1.5),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.1,
                        ),
                        Container(
                          // padding: EdgeInsets.all(20),
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (token != "") {
                                  showDialog(
                                    barrierColor: Colors.black26,
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialog(
                                        title: "ซื้อสูตรอาหาร",
                                        description:
                                            "คุณแน่ใจใช่ไหมที่จะซื้อสูตรอาหารนี้",
                                        token: this.token,
                                        rid: dataFood.rid,
                                        foodOwner_userId:
                                            dataFood.userId.toString(),
                                        myDataUser: myDataUser.userId.toString(),
                                      );
                                    },
                                  );
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return LoginPage();
                                      }).then((value) {
                                    // findUser();
                                  });
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.food_bank,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'ซื้อสูตรอาหาร',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog(
      {this.title,
      this.description,
      this.token,
      this.rid,
      this.foodOwner_userId,
      this.myDataUser});

  final String title, description, token;
  //foodOwner_userId => userId ของเจ้าของสูตร
  final String foodOwner_userId;
  //myDataUser => userId ของเราเอง ที่เข้ามาดูสูตรนี้
  final String myDataUser;
  final int rid;

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  Future<BuyFood> buyFood(String token, int recipe_ID) async {
    print('press');
    print(token);
    print(recipe_ID);

    final String apiUrl = "http://apifood.comsciproject.com/pjPost/buy";
    var data = {
      "rid": recipe_ID,
    };

    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    print("addIngredients======" + (response.statusCode.toString()));
    // print("addIngredients======"+(response));
    if (response.statusCode == 200) {
      final String responseString = response.body;

      return buyFoodFromJson(responseString);
    } else {
      return null;
    }
  }

  Future<Null> insertNotificationData(
    String my_ID,
    String state,
    String description,
    String recipe_ID,
    String from_userid,
  ) async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjNoti/insertNotificationData";

    // List<st>
    var data = {
      "my_ID": my_ID,
      "state": state,
      "description": description,
      "recipe_ID": recipe_ID,
      "from_userid": from_userid,
    };
    print("jsonEncode(data)InsertNotificationData = " + jsonEncode(data));
    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data), headers: {"Content-Type": "application/json"});

    print("response.statusCodeInsertNotificationData => ${response.statusCode}");
    print("response.bodyInsertNotificationData => ${response.body}");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 15),
          Text(
            "${widget.title}",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Text("${widget.description}"),
          SizedBox(height: 20),
          Divider(
            height: 1,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              highlightColor: Colors.grey[200],
              onTap: () async {
                Navigator.pop(context);

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("กรุณารอสักครู่...   "),
                        CircularProgressIndicator()
                      ],
                    ));
                  },
                );

                BuyFood dataBuyFood =
                    await buyFood(this.widget.token, this.widget.rid);

                Navigator.pop(context);
                print(dataBuyFood.success);
                if (dataBuyFood.success == 1) {
                  insertNotificationData(
                      this.widget.foodOwner_userId,
                      "test tiiel ซื้อสูตอาหาร",
                      "this description ซื้อสูตรอาหาร",
                      this.widget.rid.toString(),
                      this.widget.myDataUser);
                  showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                            title: "ซื้อสำเร็จ",
                            description:
                                "คุณได้ทำการซื้อสูตรอาหารนี้แล้ว เข้าไปดูสูตรอาหารได้ที่ \"สูตรที่ซื้อ\"",
                            image:
                                'https://i.pinimg.com/originals/06/ae/07/06ae072fb343a704ee80c2c55d2da80a.gif',
                            colors: Colors.lightGreen,
                            index: 1,
                            rid: this.widget.rid,
                          ));
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                            title: "ซื้อไม่สำเร็จ",
                            description: dataBuyFood.message,
                            image:
                                'https://media2.giphy.com/media/JT7Td5xRqkvHQvTdEu/200w.gif?cid=82a1493b44ucr1schfqvrvs0ha03z0moh5l2746rdxxq8ebl&rid=200w.gif&ct=g',
                            colors: Colors.redAccent,
                            index: 0,
                          ));
                }
              },
              child: Center(
                child: Text(
                  "ยืนยัน",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
              highlightColor: Colors.grey[200],
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text(
                  "ยกเลิก",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText, image;
  final Color colors;
  final int index;
  final int rid;

  CustomDialog(
      {this.title,
      this.description,
      this.buttonText,
      this.image,
      this.colors,
      this.index,
      this.rid});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 100, bottom: 16, left: 16, right: 16),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                description,
                style: TextStyle(color: Colors.grey.shade800, fontSize: 16.0),
              ),
              SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: colors,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if (index == 1) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "เข้าใจแล้ว",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 50,
            backgroundImage: NetworkImage(this.image),
          ),
        )
      ],
    );
  }
}
