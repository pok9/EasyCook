import 'dart:convert';

import 'package:easy_cook/models/buyFood/buyFood.dart';
import 'package:easy_cook/models/category/category_model.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/showfood/commentFood_model/getCommentPost_model.dart';
import 'package:easy_cook/models/showfood/showfood_model.dart';
import 'package:easy_cook/pages/login&register_page/login_page/login.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';

import 'package:easy_cook/pages/showFood&User_page/XXX_showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:readmore/readmore.dart';
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
    getCommentPosts();
  }

  String token = ""; //โทเคน
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
      if (token != "" && token != null) {
        getMyAccounts();
      }
    });
  }

  //user
  MyAccount datas;
  DataMyAccount myDataUser;
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
        print(responseString);
        dataFood = showFoodsFromJson(responseString);
      });
    } else {
      return null;
    }
  }

  //แสดงคอมเมนต์
  List<GetCommentPostModel> dataGetCommentPost;
  Future<Null> getCommentPosts() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/getComment/" +
            this.widget.req_rid.toString();

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        dataGetCommentPost =
            getCommentPostModelFromJson(responseString).reversed.toList();
      });
    } else {
      return null;
    }
  }

  String getTimeDifferenceFromNow(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inSeconds < 5) {
      return "เมื่อสักครู่";
    } else if (difference.inMinutes < 1) {
      return "${difference.inSeconds} วินาที";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes} นาที";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} ชั่วโมง";
    } else {
      return "${difference.inDays} วัน";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (dataFood == null)
        ? Scaffold()
        : Scaffold(
            // backgroundColor: Colors.grey,
            appBar: AppBar(
              title: Text(dataFood.recipeName),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 24.0),
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 8,
                          child: Hero(
                            tag: dataFood.rid,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                dataFood.image,
                                height: size.height * 0.27,
                                fit: BoxFit.fill,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                dataFood.recipeName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "\฿${numberFormat.format(dataFood.price)}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    CupertinoPageRoute(builder: (context) {
                                  return ProfileUser(
                                    reqUid: dataFood.userId,
                                  );
                                }));
                              },
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(dataFood.profileImage),
                                radius: 15,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) {
                                    return ProfileUser(
                                      reqUid: dataFood.userId,
                                    );
                                  }));
                                },
                                child: Text(
                                  "${dataFood.nameSurname}(${dataFood.aliasName})",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            (dataFood.score == null)
                                ? Container()
                                : RatingBarIndicator(
                                    rating: dataFood.score,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.blue,
                                    ),
                                    itemCount: 5,
                                    itemSize: 16.0,
                                  ),
                            SizedBox(
                              width: 2,
                            ),
                            (dataFood.score == null)
                                ? Container()
                                : Text(dataFood.score.toString() +
                                    "/5(${dataFood.count})")
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 15,
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            Text(dataFood.suitableFor),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.watch_later_outlined,
                              color: Colors.grey,
                              size: 15,
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            Text(dataFood.takeTime),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.food_bank,
                              color: Colors.grey,
                              size: 15,
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            Text(dataFood.foodCategory),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 0.0),
                        child: Row(
                          children: [
                            Expanded(child: buildText(dataFood.description))
                          ],
                        ),
                      ),
                      (dataGetCommentPost == null)
                          ? Container()
                          : (dataGetCommentPost.isEmpty)
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Divider(
                                    thickness: 1,
                                  ),
                                ),
                      (dataGetCommentPost == null)
                          ? Container()
                          : (dataGetCommentPost.isEmpty)
                              ? Container()
                              : Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "ความคิดเห็น",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                      ListView.builder(
                          padding: EdgeInsets.only(top: 0),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: (dataGetCommentPost == null)
                              ? 0
                              : dataGetCommentPost.length > 3
                                  ? 3
                                  : dataGetCommentPost.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                if (myDataUser == null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileUser(
                                              reqUid: dataGetCommentPost[index]
                                                  .userId,
                                            )),
                                  );
                                } else if ((myDataUser.userId ==
                                    dataGetCommentPost[index].userId)) {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) {
                                    return ProfilePage();
                                  }));
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileUser(
                                              reqUid: dataGetCommentPost[index]
                                                  .userId,
                                            )),
                                  );
                                }
                              },
                              isThreeLine: true,
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    dataGetCommentPost[index].profileImage),
                              ),
                              title: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: RichText(
                                    text: TextSpan(
                                        text:
                                            dataGetCommentPost[index].aliasName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: (dataGetCommentPost[index]
                                                        .userStatus ==
                                                    0)
                                                ? Colors.red
                                                : (myDataUser == null)
                                                    ? Colors.black
                                                    : (dataGetCommentPost[index]
                                                                .userId ==
                                                            myDataUser.userId)
                                                        ? Colors.blue
                                                        : Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                '\n${getTimeDifferenceFromNow(DateTime.parse("${dataGetCommentPost[index].datetime}"))}\n',
                                            style: TextStyle(
                                                decoration: TextDecoration.none,
                                                // fontFamily: 'OpenSans',
                                                fontSize: 12.0,
                                                color: Colors.grey.shade600),
                                          )
                                        ]),
                                  )
                                  // Text(
                                  //   dataGetCommentPost[index].aliasName,
                                  //   style: TextStyle(
                                  //       fontWeight: FontWeight.bold,
                                  //       color: (dataGetCommentPost[index]
                                  //                   .userStatus ==
                                  //               0)
                                  //           ? Colors.red
                                  //           : (dataGetCommentPost[index].userId ==
                                  //                   data_DataAc.userId)
                                  //               ? Colors.blue
                                  //               : Colors.black),
                                  // ),
                                  ),
                              subtitle: buildTextComment(index),
                              dense: true,
                              // trailing: Text('Horse'),
                            );
                          })
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  color: Color(0xfff3f3f4),
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (token != "" && token != null) {
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
                                      recipeName: dataFood.recipeName,
                                      foodOwner_userId:
                                          dataFood.userId.toString(),
                                      myDataUser: myDataUser.userId.toString(),
                                      myNameUser: myDataUser.aliasName,
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
                )
              ],
            ),
          );
  }

  Widget buildText(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: ReadMoreText(
          text,
          trimLines: 4,
          trimMode: TrimMode.Line,
          trimCollapsedText: 'อ่านเพิ่มเติม',
          trimExpandedText: 'อ่านน้อยลง',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            // fontFamily: 'OpenSans',
            fontSize: 15,
            color: Colors.black,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget buildTextComment(int index) {
    // return TextSpan(
    //   text: '${dataGetCommentPost[index].commentDetail}',
    //   style: TextStyle(
    //       decoration: TextDecoration.none,
    //       fontFamily: 'OpenSans',
    //       fontSize: 12,
    //       color: Colors.black),
    // );
    return ReadMoreText(
      '${dataGetCommentPost[index].commentDetail}',
      trimLines: 8,
      trimMode: TrimMode.Line,
      trimCollapsedText: 'อ่านเพิ่มเติม',
      trimExpandedText: 'อ่านน้อยลง',
      style: TextStyle(
        fontWeight: FontWeight.normal,
        // fontFamily: 'OpenSans',
        fontSize: 13,
        color: Colors.black,
        decoration: TextDecoration.none,
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
      this.recipeName,
      this.foodOwner_userId,
      this.myDataUser,
      this.myNameUser});

  final String title, description, token, recipeName;
  //foodOwner_userId => userId ของเจ้าของสูตร
  final String foodOwner_userId;

  //myDataUser => userId ของเราเอง ที่เข้ามาดูสูตรนี้
  final String myDataUser;
  //myNameUser => ชื่อของเราที่เข้ามาซื้อสูต
  final String myNameUser;

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
    String status,
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
      "status": status
    };
    print("jsonEncode(data)InsertNotificationData = " + jsonEncode(data));
    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data), headers: {"Content-Type": "application/json"});

    print(
        "response.statusCodeInsertNotificationData => ${response.statusCode}");
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
                      this.widget.myNameUser,
                      "${this.widget.myNameUser} ได้ทำการซื้อสูตอาหาร  ${this.widget.recipeName} ของคุณแล้ว",
                      this.widget.rid.toString(),
                      this.widget.myDataUser,
                      "buy");
                  showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                            title: "ซื้อสำเร็จ",
                            description:
                                "คุณได้ทำการซื้อสูตรอาหารนี้แล้ว เข้าไปดูสูตรอาหารได้ที่ \"สูตรที่ซื้อ\"",
                            image:
                                'assets/logoNoti/correctGif.gif',
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
                                'assets/logoNoti/wrongGif.gif',
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
            backgroundImage: AssetImage(this.image),
          ),
        )
      ],
    );
  }
}
