import 'dart:convert';
// import 'dart:ffi';

import 'package:easy_cook/models/deleteFood&editFood/deleteFood.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/report/addReport/addReport_model.dart';
import 'package:easy_cook/models/showfood/commentFood_model/getCommentPost_model.dart';

import 'package:easy_cook/models/showfood/scoreFood/getScoreFoodModel.dart';
import 'package:easy_cook/models/showfood/scoreFood/scoreFoodInputModel.dart';

import 'package:easy_cook/models/showfood/showfood_model.dart';
import 'package:easy_cook/pages/login&register_page/login_page/login.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:easy_cook/pages/showFood&User_page/commentFood.dart/commentFood.dart';
import 'package:easy_cook/pages/showFood&User_page/editFood_page/editFood.dart';
import 'package:easy_cook/pages/showFood&User_page/reportFood&User&Commnt/reportFood.dart';

import 'package:easy_cook/pages/showFood&User_page/review_page/review.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';

import 'package:easy_cook/pages/video_items.dart';
import 'package:easy_cook/slidepage.dart';
import 'package:easy_cook/style/utiltties.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class ShowFood extends StatefulWidget {
  // const test({Key key}) : super(key: key);
  var req_rid;
  ShowFood(this.req_rid);

  @override
  _ShowFoodState createState() => _ShowFoodState(req_rid);
}

class _ShowFoodState extends State<ShowFood> {
  var req_rid;
  _ShowFoodState(this.req_rid);

  // @override
  // void initState() {
  //   super.initState();
  //   findUser();
  //   getCommentPosts();
  //   getPost();
  // }

  double ratings = 0.0;
  @override
  void dispose() {
    super.dispose();
    if (token != "") {
      if (dataFood.userId != dataMyAccont.userId && ratings != 0.0) {
        insertNotificationData(
            dataFood.userId.toString(),
            dataMyAccont.aliasName,
            "ให้คะแนนสูตรอาหาร ${dataFood.recipeName} ของคุณ",
            dataFood.rid.toString(),
            dataMyAccont.userId.toString(),
            "scorefood");
      }
    }
  }

  //แสดงคอมเมนต์
  List<GetCommentPostModel> dataGetCommentPost;
  Future<List<GetCommentPostModel>> getCommentPosts() async {
    //3
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/getComment/" +
            req_rid.toString();

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // setState(() {
      final String responseString = response.body;

      return getCommentPostModelFromJson(responseString).reversed.toList();
      // });
    } else {
      return null;
    }
  }

  String token = ""; //โทเคน
  //ดึง token
  Future<String> findUser() async {
    //1
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // setState(() {

    //   if (token != "" && token != null) {
    //     getMyAccounts();
    //     getcoreFood();
    //   }
    // });

    return preferences.getString("tokens");
  }

  //ให้คะแนนสูตรอาหาร
  Future<ScoreFoodInputModel> scoreFoodInput(double score, String token) async {
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/score";

    var data = {
      "recipe_ID": this.req_rid,
      "score": score,
    };

    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    if (response.statusCode == 200) {
      final String responseString = response.body;

      return scoreFoodInputModelFromJson(responseString);
    } else {
      return null;
    }
  }

  //แสดงคะแนนที่เรารีวิว
  GetScoreFoodModel dataGetScoreFood;
  Future<GetScoreFoodModel> getScoreFood() async {
    //5
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/getMyScore/" +
            req_rid.toString();

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      return getScoreFoodModelFromJson(responseString);
    } else {
      return null;
    }
  }

  //user
  MyAccount datas;
  DataMyAccount dataMyAccont;
  Future<MyAccount> getMyAccounts() async {
    //4
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      return myAccountFromJson(responseString);
    } else {
      return null;
    }
  }

  //ข้อมูลสูตรอาหารที่ค้นหา
  ShowFoods dataFood;
  //ข้อมูลวัตถุดิบ
  List<Ingredient> dataIngredient;
  //ข้อมูลวัตถุดิบ
  List<Howto> dataHowto;
  //ดึงข้อมูลสูตรอาหารที่ค้นหา
  Future<ShowFoods> getPost() async {
    //2
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/getPost/" + req_rid.toString();

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final String responseString = response.body;

      return showFoodsFromJson(responseString);
    } else {
      return null;
    }
  }

  //=================================================================================

  List<Widget> _ingredientList() {
    List<List<TextEditingController>> controllers =
        <List<TextEditingController>>[];
    int i;
    if (0 < dataIngredient.length) {
      for (i = 0; i < dataIngredient.length; i++) {
        var ctl = <TextEditingController>[];
        ctl.add(TextEditingController());

        controllers.add(ctl);
      }
    }

    i = 0;

    return controllers.map<Widget>((List<TextEditingController> controller) {
      int displayNumber = i;
      i++;

      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                (displayNumber + 1).toString() +
                    ". " +
                    dataIngredient[displayNumber].ingredientName +
                    "\t" +
                    dataIngredient[displayNumber].amount,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                    fontSize: 17,
                    color: Colors.black,
                    decoration: TextDecoration.none),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Divider(
                height: 2,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }).toList(); // แปลงเป็นlist
  }

  List<Widget> _howtoList1() {
    List<List<TextEditingController>> controllers2 =
        <List<TextEditingController>>[];
    int i;
    if (0 < dataHowto.length) {
      for (i = 0; i < dataHowto.length; i++) {
        var ctl = <TextEditingController>[];
        ctl.add(TextEditingController());

        controllers2.add(ctl);
      }
    }

    i = 0;

    return controllers2.map<Widget>((List<TextEditingController> controller) {
      int displayNumber = i;
      i++;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  child: Text("$i"),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    dataHowto[displayNumber].description,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: 'OpenSans',
                        fontSize: 17,
                        color: Colors.black,
                        decoration: TextDecoration.none),
                  ),
                ),
              ],
            ),
          ),
          (lookupMimeType(dataHowto[displayNumber].pathFile)[0] == "i")
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    constraints: new BoxConstraints.expand(
                      height: 350.0,
                    ),
                    alignment: Alignment.bottomRight,
                    padding: new EdgeInsets.only(right: 10, bottom: 8.0),
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: NetworkImage(dataHowto[displayNumber].pathFile),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                )
              : Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AspectRatio(
                      // aspectRatio: 3 / 2,
                      // aspectRatio: 16 / 9,
                      aspectRatio: 1,
                      child: VideoItems(
                        videoPlayerController: VideoPlayerController.network(
                            dataHowto[displayNumber].pathFile),
                        looping: false,
                        autoplay: false,
                        addfood_showfood: 0,
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                )
        ],
      );
    }).toList(); // แปลงเป็นlist
  }

  List<Widget> _howtoList2() {
    List<List<TextEditingController>> controllers2 =
        <List<TextEditingController>>[];
    int i;
    if (0 < dataHowto.length) {
      for (i = 0; i < dataHowto.length; i++) {
        var ctl = <TextEditingController>[];
        ctl.add(TextEditingController());

        controllers2.add(ctl);
      }
    }

    i = 0;

    return controllers2.map<Widget>((List<TextEditingController> controller) {
      int displayNumber = i;
      i++;

      return ListTile(
        title: Row(
          children: [
            CircleAvatar(
              radius: 10,
              child: Text("$i"),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(child: Text(dataHowto[displayNumber].description)),
          ],
        ),
      );
    }).toList(); // แปลงเป็นlist
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

    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data), headers: {"Content-Type": "application/json"});
  }

  int indexHowTo = 0;
  List<String> actionDropdown = ['แก้ไขสูตรอาหาร', 'ลบสูตรอาหาร'];
  List<bool> _isSelected = [true, false, false];

  Future<AddReport> addReport(String userTarget_ID, String type_report,
      String recipe_ID, String title, String description, String image) async {
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/addReport";

    var data = {
      "userTarget_ID": userTarget_ID,
      "type_report": type_report,
      "recipe_ID": recipe_ID,
      "title": title,
      "description": description,
      "image": image
    };

    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    if (response.statusCode == 200) {
      final String responseString = response.body;

      return addReportFromJson(responseString);
    } else {
      return null;
    }
  }

  AlertDialog alertDialog_successful_or_unsuccessful(
      String reportText1, Color color, String reportText2) {
    return AlertDialog(
      title: Text(reportText1, style: TextStyle(color: Colors.white)),
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
      backgroundColor: color,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      content: Text(reportText2, style: TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: findUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          token = snapshot.data;
          return FutureBuilder(
            future: getPost(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                dataFood = snapshot.data;
                dataIngredient = dataFood.ingredient;
                dataHowto = dataFood.howto;
                final List<Widget> ingredient =
                    dataIngredient == null ? [] : _ingredientList();

                final List<Widget> howto1 =
                    dataHowto == null ? [] : _howtoList1();
                final List<Widget> howto2 =
                    dataHowto == null ? [] : _howtoList2();
                return FutureBuilder(
                  future: getCommentPosts(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      dataGetCommentPost = snapshot.data;
                      return FutureBuilder(
                        future: getMyAccounts(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Scaffold(
                                body: Center(
                              child: CircularProgressIndicator(),
                            ));
                          }
                          if (snapshot.hasData) {
                            datas = snapshot.data;
                            dataMyAccont = datas.data[0];
                            return FutureBuilder(
                              future: getScoreFood(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  dataGetScoreFood = snapshot.data;
                                  return buildBody(ingredient, howto1, howto2);
                                }
                                return Scaffold(
                                    body: Center(
                                  child: CircularProgressIndicator(),
                                ));
                              },
                            );
                          }
                          return buildBody(ingredient, howto1, howto2);
                        },
                      );
                    }
                    return Scaffold(
                        body: Center(
                      child: CircularProgressIndicator(),
                    ));
                  },
                );
                ;
              }
              return Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              ));
            },
          );
        }
        return Scaffold(
            body: Center(
          child: CircularProgressIndicator(),
        ));
      },
    );

    // return dataFood == null
    //     ? Material(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             SizedBox(height: 20),
    //             CircularProgressIndicator()
    //           ],
    //         ),
    //       )

    // SliverFab(
    //     floatingWidget: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Container(
    //           height: 100,
    //           width: 100,
    //           child: ClipOval(
    //             child: Image.network(
    //               dataFood.profileImage,
    //               fit: BoxFit.fill,
    //             ),
    //           ),
    //           decoration: BoxDecoration(
    //               color: Colors.grey,
    //               shape: BoxShape.circle,
    //               border: Border.all(color: Colors.white, width: 8.0)),
    //         ),
    //       ],
    //     ),
    //     expandedHeight: 256.0,
    //     floatingPosition: FloatingPosition(top: -20, left: 150),
    //     slivers: [
    //       SliverAppBar(
    //         title:
    //             Text(dataFood.recipeName + " " + this.req_rid.toString()),
    //         actions: [
    //           (dataMyAccont == null || dataFood == null)
    //               ? Container()
    //               : (dataMyAccont.userId != dataFood.userId)
    //                   ? (dataMyAccont.userStatus == 0)
    //                       ? Container()
    //                       : PopupMenuButton(
    //                           child: Center(
    //                               child: Padding(
    //                             padding: const EdgeInsets.only(right: 20),
    //                             child: Icon(Icons.more_horiz_outlined),
    //                           )),
    //                           onSelected: (value) {
    //                             if (value == 1) {
    //                               showDialog(
    //                                   context: context,
    //                                   builder: (BuildContext context) {
    //                                     return ReportFood();
    //                                   }).then((value) async {
    //                                 if (value != null) {
    //                                   showDialog(
    //                                       context: context,
    //                                       builder: (contex) {
    //                                         return AlertDialog(
    //                                             content: Row(
    //                                           mainAxisAlignment:
    //                                               MainAxisAlignment.center,
    //                                           children: [
    //                                             Text(
    //                                                 "กรุณารอสักครู่...   "),
    //                                             CircularProgressIndicator()
    //                                           ],
    //                                         ));
    //                                       });

    //                                   AddReport dataAddReport =
    //                                       await addReport(
    //                                           dataFood.userId.toString(),
    //                                           "food",
    //                                           dataFood.rid.toString(),
    //                                           "รายงานสูตรอาหาร",
    //                                           value[0],
    //                                           value[1]);

    //                                   Navigator.pop(context);
    //                                   String reportText1;
    //                                   String reportText2;
    //                                   Color color;
    //                                   if (dataAddReport.success == 1) {
    //                                     reportText1 = "รายงานสำเร็จ";
    //                                     reportText2 =
    //                                         "ขอบคุณสำหรับการรายงาน";
    //                                     color = Colors.green;
    //                                   } else {
    //                                     reportText1 = "รายงานไม่สำเร็จ";
    //                                     reportText2 =
    //                                         "โปรดรายงานใหม่ในภายหลัง";
    //                                     color = Colors.red;
    //                                   }
    //                                   showDialog(
    //                                       context: context,
    //                                       builder: (BuildContext context) {
    //                                         Future.delayed(
    //                                             Duration(
    //                                                 milliseconds: 1500),
    //                                             () {
    //                                           Navigator.of(context)
    //                                               .pop(true);
    //                                         });
    //                                         return alertDialog_successful_or_unsuccessful(
    //                                             reportText1,
    //                                             color,
    //                                             reportText2);
    //                                       });
    //                                 }
    //                               });
    //                             }
    //                           },
    //                           itemBuilder: (context) {
    //                             return [
    //                               PopupMenuItem(
    //                                 child: Row(
    //                                   children: [
    //                                     Icon(
    //                                       Icons.flag,
    //                                       color: Colors.black,
    //                                     ),
    //                                     SizedBox(
    //                                       width: 5,
    //                                     ),
    //                                     Text('รายงานสูตรอาหารนี้'),
    //                                   ],
    //                                 ),
    //                                 value: 1,
    //                               ),
    //                             ];
    //                           })
    //                   : PopupMenuButton(
    //                       child: Center(
    //                           child: Padding(
    //                         padding: const EdgeInsets.only(right: 20),
    //                         child: Icon(Icons.more_horiz_outlined),
    //                       )),
    //                       onSelected: (value) {
    //                         if (value == 0) {
    //                           Navigator.push(
    //                             context,
    //                             MaterialPageRoute(
    //                                 builder: (context) => EditFoodPage(
    //                                     rid: dataFood.rid,
    //                                     uid: dataFood.userId,
    //                                     recipeName: dataFood.recipeName,
    //                                     description: dataFood.description,
    //                                     imageFood: dataFood.image,
    //                                     suitableFor: dataFood.suitableFor,
    //                                     takeTime: dataFood.takeTime,
    //                                     foodCategory: dataFood.foodCategory,
    //                                     price: dataFood.price.toString(),
    //                                     dataIngredient: dataIngredient,
    //                                     dataHowto: dataHowto,)),
    //                           ).then((value){
    //                             getPost();
    //                           });
    //                         } else if (value == 1) {
    //                           showDialog(
    //                             barrierColor: Colors.black26,
    //                             context: context,
    //                             builder: (context) {
    //                               return CustomAlertDialog(
    //                                 title: "ลบสูตรอาหาร",
    //                                 description:
    //                                     "คุณแน่ใจใช่ไหมที่จะลบสูตรอาหารนี้",
    //                                 token: this.token,
    //                                 recipe_ID: this.req_rid,
    //                               );
    //                             },
    //                           );
    //                         }
    //                       },
    //                       itemBuilder: (context) {
    //                         return List.generate(2, (index) {
    //                           return PopupMenuItem(
    //                             value: index,
    //                             child: Text(actionDropdown[index]),
    //                           );
    //                         });
    //                       },
    //                     ),
    //         ],
    //         pinned: true,
    //         expandedHeight: 256.0,
    //         flexibleSpace: FlexibleSpaceBar(
    //           background: Image.network(
    //             dataFood.image,
    //             fit: BoxFit.cover,
    //           ),
    //         ),
    //       ),
    //       SliverList(
    //           delegate: SliverChildListDelegate([
    //         Container(
    //           color: Color(0xFFf3f5f9),
    //           child: Column(
    //             children: [
    //               Container(height: 50, width: 500, color: Colors.white),
    //               Card(
    //                 margin:
    //                     EdgeInsets.zero, //ปรับระยะขอบการ์ดให้ติดขอบทุกด้าน
    //                 //ปรับขอบการ์ด
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(0),
    //                 ),
    //                 color: Colors.white,
    //                 child: Column(
    //                   children: [
    //                     Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: [
    //                           Text(dataFood.aliasName,
    //                               style: TextStyle(
    //                                 fontWeight: FontWeight.normal,
    //                                 fontFamily: 'OpenSans',
    //                                 fontSize: 20,
    //                                 color: Colors.black,
    //                                 decoration: TextDecoration.none,
    //                               )),
    //                         ],
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child: Row(
    //                         children: [
    //                           Expanded(
    //                             child: Text(
    //                               dataFood.description,
    //                               textAlign: TextAlign.justify,
    //                               style: TextStyle(
    //                                 fontWeight: FontWeight.normal,
    //                                 fontFamily: 'OpenSans',
    //                                 fontSize: 15,
    //                                 color: Colors.black,
    //                                 decoration: TextDecoration.none,
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     Divider(
    //                       thickness: 1,
    //                       color: Colors.grey,
    //                     ),
    //                     (dataFood.score == null)
    //                         ? Container()
    //                         : Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: Row(
    //                               crossAxisAlignment:
    //                                   CrossAxisAlignment.end,
    //                               children: [
    //                                 Icon(
    //                                   Icons.star,
    //                                   color: Colors.blue,
    //                                   size: 17,
    //                                 ),
    //                                 SizedBox(
    //                                   width: 1,
    //                                 ),
    //                                 Text(dataFood.score.toString() + "/5 (${dataFood.count})")
    //                               ],
    //                             ),
    //                           ),
    //                     Text(
    //                       dataFood.recipeName,
    //                       style: TextStyle(
    //                         fontWeight: FontWeight.normal,
    //                         fontFamily: 'OpenSans',
    //                         fontSize: 25,
    //                         color: Colors.black,
    //                         decoration: TextDecoration.none,
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.all(16.0),
    //                       child: Container(
    //                         width: 300,
    //                         height: 200,
    //                         child: ClipRRect(
    //                           borderRadius: new BorderRadius.circular(24.0),
    //                           child: Image(
    //                             fit: BoxFit.contain,
    //                             image: NetworkImage(dataFood.image),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     Divider(
    //                       thickness: 1,
    //                       color: Colors.grey.shade400,
    //                     ),
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                       children: [
    //                         Column(
    //                           children: [
    //                             Icon(
    //                               Icons.person,
    //                               color: Colors.grey,
    //                               size: 30.0,
    //                             ),
    //                             SizedBox(
    //                               height: 5,
    //                             ),
    //                             Text(
    //                               dataFood.suitableFor,
    //                               style: TextStyle(
    //                                 fontWeight: FontWeight.normal,
    //                                 fontFamily: 'OpenSans',
    //                                 fontSize: 12,
    //                                 color: Colors.grey.shade600,
    //                                 decoration: TextDecoration.none,
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                         Column(
    //                           children: [
    //                             Icon(
    //                               Icons.watch_later_outlined,
    //                               color: Colors.grey,
    //                               size: 30.0,
    //                             ),
    //                             SizedBox(
    //                               height: 5,
    //                             ),
    //                             Text(
    //                               dataFood.takeTime,
    //                               style: TextStyle(
    //                                 fontWeight: FontWeight.normal,
    //                                 fontFamily: 'OpenSans',
    //                                 fontSize: 12,
    //                                 color: Colors.grey.shade600,
    //                                 decoration: TextDecoration.none,
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                         Column(
    //                           children: [
    //                             Icon(
    //                               Icons.food_bank,
    //                               color: Colors.grey,
    //                               size: 30.0,
    //                             ),
    //                             SizedBox(
    //                               height: 5,
    //                             ),
    //                             Text(
    //                               dataFood.foodCategory,
    //                               style: TextStyle(
    //                                 fontWeight: FontWeight.normal,
    //                                 fontFamily: 'OpenSans',
    //                                 fontSize: 12,
    //                                 color: Colors.grey.shade600,
    //                                 decoration: TextDecoration.none,
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ],
    //                     ),
    //                     SizedBox(
    //                       height: 5,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 5,
    //               ),
    //               Card(
    //                 margin:
    //                     EdgeInsets.zero, //ปรับระยะขอบการ์ดให้ติดขอบทุกด้าน
    //                 //ปรับขอบการ์ด
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(0),
    //                 ),
    //                 color: Colors.white,
    //                 child: Column(
    //                   children: [
    //                     Row(
    //                       children: [
    //                         Padding(
    //                           padding: const EdgeInsets.only(left: 10),
    //                           child: Text(
    //                             "ส่วนผสม",
    //                             style: TextStyle(
    //                               fontWeight: FontWeight.normal,
    //                               fontFamily: 'OpenSans',
    //                               fontSize: 25,
    //                               color: Colors.black,
    //                               decoration: TextDecoration.none,
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                     SizedBox(
    //                       height: 15,
    //                     ),
    //                     ListView(
    //                       padding: EdgeInsets.all(0),
    //                       shrinkWrap: true,
    //                       physics: NeverScrollableScrollPhysics(),
    //                       children: ingredient,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 5,
    //               ),
    //               Card(
    //                 margin:
    //                     EdgeInsets.zero, //ปรับระยะขอบการ์ดให้ติดขอบทุกด้าน
    //                 //ปรับขอบการ์ด
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(0),
    //                 ),
    //                 color: Colors.white,
    //                 child: Column(
    //                   children: [
    //                     Container(
    //                       height: 50,
    //                       // color: Colors.white,
    //                       child: Row(
    //                         mainAxisAlignment:
    //                             MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Padding(
    //                             padding: const EdgeInsets.only(left: 10),
    //                             child: Text(
    //                               "วิธีทำ",
    //                               style: TextStyle(
    //                                 fontWeight: FontWeight.normal,
    //                                 fontFamily: 'OpenSans',
    //                                 fontSize: 25,
    //                                 color: Colors.black,
    //                                 decoration: TextDecoration.none,
    //                               ),
    //                             ),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.all(4.0),
    //                             child: ToggleButtons(
    //                               children: <Widget>[
    //                                 Icon(Icons.image),
    //                                 Icon(Icons.list),
    //                                 Icon(Icons.list_alt),
    //                               ],
    //                               onPressed: (int index) {
    //                                 setState(() {
    //                                   _isSelected[0] = false;
    //                                   _isSelected[1] = false;
    //                                   _isSelected[2] = false;
    //                                   _isSelected[index] =
    //                                       !_isSelected[index];

    //                                   indexHowTo = index;
    //                                 });
    //                               },
    //                               isSelected: _isSelected,
    //                               borderColor: Colors.grey,
    //                               color: Colors.grey,
    //                               selectedColor: Colors.white,
    //                               fillColor: Colors.blue,
    //                               selectedBorderColor: Colors.grey,
    //                               borderRadius:
    //                                   BorderRadius.all(Radius.circular(10)),
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 5,
    //                     ),
    //                     ListView(
    //                       padding: EdgeInsets.all(0),
    //                       shrinkWrap: true,
    //                       physics: NeverScrollableScrollPhysics(),
    //                       children: (indexHowTo == 0) ? howto1 : howto2,
    //                     )
    //                   ],
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 5,
    //               ),
    //               Card(
    //                 margin:
    //                     EdgeInsets.zero, //ปรับระยะขอบการ์ดให้ติดขอบทุกด้าน
    //                 //ปรับขอบการ์ด
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(0),
    //                 ),
    //                 color: Colors.white,
    //                 child: Column(
    //                   children: [
    //                     Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child: Row(
    //                         children: [
    //                           Text(
    //                             "ให้คะแนน & แสดงความคิดเห็น",
    //                             style: TextStyle(
    //                                 color: Colors.black,
    //                                 fontSize: 20,
    //                                 fontWeight: FontWeight.bold),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 10,
    //                     ),
    //                     RatingBar.builder(
    //                       initialRating: (dataGetScoreFood == null)
    //                           ? 0
    //                           : dataGetScoreFood.score,
    //                       minRating: 0.5,
    //                       direction: Axis.horizontal,
    //                       allowHalfRating: true,
    //                       itemCount: 5,
    //                       itemPadding:
    //                           EdgeInsets.symmetric(horizontal: 4.0),
    //                       itemBuilder: (context, _) => Icon(
    //                         Icons.star,
    //                         // color: Colors.amber,
    //                         color: Colors.blue,
    //                       ),
    //                       onRatingUpdate: (rating) async {
    //                         if (token == "") {
    //                           showDialog(
    //                               context: context,
    //                               builder: (_) {
    //                                 return LoginPage();
    //                               }).then((value) {
    //                             if (value != null) {
    //                               this.findUser();
    //                             }

    //                             // Navigator.pop(context);
    //                           });
    //                         } else {
    //                           ratings = rating;
    //                           ScoreFoodInputModel scoreFoodInputModel =
    //                               await scoreFoodInput(rating, token);
    //                         }
    //                       },
    //                     ),
    //                     Divider(
    //                       indent: 60,
    //                       endIndent: 60,
    //                       color: Colors.teal.shade100,
    //                       thickness: 1.0,
    //                     ),
    //                     Column(
    //                       children: [
    //                         (dataGetCommentPost == null)
    //                             ? Container()
    //                             : (dataGetCommentPost.length == 0)
    //                                 ? Container()
    //                                 : Padding(
    //                                     padding:
    //                                         const EdgeInsets.only(left: 8),
    //                                     child: Row(
    //                                       children: [
    //                                         TextButton(
    //                                             onPressed: () {
    //                                               if (dataMyAccont ==
    //                                                   null) {
    //                                                 showDialog(
    //                                                     context: context,
    //                                                     builder: (_) {
    //                                                       return LoginPage();
    //                                                     }).then((value) {
    //                                                   if (value != null) {
    //                                                     this.findUser();
    //                                                   }

    //                                                   // Navigator.pop(context);
    //                                                 });
    //                                               } else {
    //                                                 Navigator.push(
    //                                                     context,
    //                                                     MaterialPageRoute(
    //                                                         builder: (context) =>
    //                                                             CommentFood(
    //                                                               autoFocus:
    //                                                                   false,
    //                                                               dataFood:
    //                                                                   dataFood,
    //                                                             ))).then(
    //                                                     (value) => this
    //                                                         .getCommentPosts());
    //                                               }
    //                                             },
    //                                             child: Text(
    //                                                 "ดูความเห็นทั้งหมด")),
    //                                       ],
    //                                     ),
    //                                   ),
    //                         (token == "")
    //                             ? Container()
    //                             : (dataMyAccont == null ||
    //                                     dataGetCommentPost == null)
    //                                 ? Center(
    //                                     child: CircularProgressIndicator())
    //                                 : ListView.builder(
    //                                     padding: EdgeInsets.only(top: 0),
    //                                     shrinkWrap: true,
    //                                     physics:
    //                                         NeverScrollableScrollPhysics(),
    //                                     itemCount: (dataGetCommentPost ==
    //                                             null)
    //                                         ? 0
    //                                         : dataGetCommentPost.length > 3
    //                                             ? 3
    //                                             : dataGetCommentPost.length,
    //                                     itemBuilder: (context, index) {
    //                                       return ListTile(
    //                                         isThreeLine: true,
    //                                         leading: CircleAvatar(
    //                                           backgroundImage: NetworkImage(
    //                                               dataGetCommentPost[index]
    //                                                   .profileImage),
    //                                         ),
    //                                         title: Padding(
    //                                           padding:
    //                                               const EdgeInsets.fromLTRB(
    //                                                   0, 10, 0, 0),
    //                                           child: Text(
    //                                             dataGetCommentPost[index]
    //                                                 .aliasName,
    //                                             style: TextStyle(
    //                                                 fontWeight:
    //                                                     FontWeight.bold,
    //                                                 color: (dataGetCommentPost[
    //                                                                 index]
    //                                                             .userStatus ==
    //                                                         0)
    //                                                     ? Colors.red
    //                                                     : (dataGetCommentPost[
    //                                                                     index]
    //                                                                 .userId ==
    //                                                             dataMyAccont
    //                                                                 .userId)
    //                                                         ? Colors.blue
    //                                                         : Colors.black),
    //                                           ),
    //                                         ),
    //                                         subtitle: Text(
    //                                           '${dataGetCommentPost[index].datetime}\n\n${dataGetCommentPost[index].commentDetail}',
    //                                           textAlign: TextAlign.justify,
    //                                           style: TextStyle(
    //                                             fontWeight:
    //                                                 FontWeight.normal,
    //                                             fontFamily: 'OpenSans',
    //                                             fontSize: 12,
    //                                             color: Colors.black,
    //                                             decoration:
    //                                                 TextDecoration.none,
    //                                           ),
    //                                         ),
    //                                         dense: true,
    //                                         // trailing: Text('Horse'),
    //                                       );
    //                                     }),
    //                       ],
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.all(5),
    //                       child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: [
    //                           (dataMyAccont == null)
    //                               ? CircleAvatar(
    //                                   child:
    //                                       Icon(Icons.account_box_outlined),
    //                                 )
    //                               : CircleAvatar(
    //                                   backgroundImage: NetworkImage(
    //                                       dataMyAccont.profileImage),
    //                                 ),
    //                           SizedBox(
    //                             width: 5,
    //                           ),
    //                           ElevatedButton(
    //                             style: ElevatedButton.styleFrom(
    //                               side: BorderSide(
    //                                   width: 2, color: Colors.blue),
    //                               primary: Colors.white,
    //                               shape: RoundedRectangleBorder(
    //                                   borderRadius:
    //                                       BorderRadius.circular(30)),
    //                             ),
    //                             onPressed: () {
    //                               if (dataMyAccont == null) {
    //                                 showDialog(
    //                                     context: context,
    //                                     builder: (_) {
    //                                       return LoginPage();
    //                                     }).then((value) {
    //                                   if (value != null) {
    //                                     this.findUser();
    //                                   }

    //                                   // Navigator.pop(context);
    //                                 });
    //                               } else {
    //                                 Navigator.push(
    //                                     context,
    //                                     MaterialPageRoute(
    //                                         builder: (context) =>
    //                                             CommentFood(
    //                                               autoFocus: true,
    //                                               dataFood: dataFood,
    //                                             ))).then(
    //                                     (value) => this.getCommentPosts());
    //                               }
    //                             },
    //                             child: Container(
    //                               width: MediaQuery.of(context).size.width -
    //                                   100,
    //                               height: 50,
    //                               child: Row(
    //                                 children: [
    //                                   Center(
    //                                       child: Text(
    //                                     'แสดงความคิดเห็น...',
    //                                     style: TextStyle(
    //                                         color: Colors.black54,
    //                                         fontSize: 16),
    //                                   )),
    //                                 ],
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         )
    //       ]))
    //     ],
    //   );
  }

  Widget buildBody(
      List<Widget> ingredient, List<Widget> howto1, List<Widget> howto2) {
    return SliverFab(
      floatingWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            child: ClipOval(
              child: Image.network(
                dataFood.profileImage,
                fit: BoxFit.fill,
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 8.0)),
          ),
        ],
      ),
      expandedHeight: 256.0,
      floatingPosition: FloatingPosition(top: -20, left: 150),
      slivers: [
        SliverAppBar(
          title: Text(dataFood.recipeName + " " + this.req_rid.toString()),
          actions: [
            (dataMyAccont == null || dataFood == null)
                ? Container()
                : (dataMyAccont.userId != dataFood.userId)
                    ? (dataMyAccont.userStatus == 0)
                        ? Container()
                        : PopupMenuButton(
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Icon(Icons.more_horiz_outlined),
                            )),
                            onSelected: (value) {
                              if (value == 1) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ReportFood();
                                    }).then((value) async {
                                  if (value != null) {
                                    showDialog(
                                        context: context,
                                        builder: (contex) {
                                          return AlertDialog(
                                              content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("กรุณารอสักครู่...   "),
                                              CircularProgressIndicator()
                                            ],
                                          ));
                                        });

                                    AddReport dataAddReport = await addReport(
                                        dataFood.userId.toString(),
                                        "food",
                                        dataFood.rid.toString(),
                                        "รายงานสูตรอาหาร",
                                        value[0],
                                        value[1]);

                                    Navigator.pop(context);
                                    String reportText1;
                                    String reportText2;
                                    Color color;
                                    if (dataAddReport.success == 1) {
                                      reportText1 = "รายงานสำเร็จ";
                                      reportText2 = "ขอบคุณสำหรับการรายงาน";
                                      color = Colors.green;
                                    } else {
                                      reportText1 = "รายงานไม่สำเร็จ";
                                      reportText2 = "โปรดรายงานใหม่ในภายหลัง";
                                      color = Colors.red;
                                    }
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          Future.delayed(
                                              Duration(milliseconds: 1500), () {
                                            Navigator.of(context).pop(true);
                                          });
                                          return alertDialog_successful_or_unsuccessful(
                                              reportText1, color, reportText2);
                                        });
                                  }
                                });
                              }
                            },
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.flag,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('รายงานสูตรอาหารนี้'),
                                    ],
                                  ),
                                  value: 1,
                                ),
                              ];
                            })
                    : PopupMenuButton(
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(Icons.more_horiz_outlined),
                        )),
                        onSelected: (value) {
                          if (value == 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditFoodPage(
                                        rid: dataFood.rid,
                                        uid: dataFood.userId,
                                        recipeName: dataFood.recipeName,
                                        description: dataFood.description,
                                        imageFood: dataFood.image,
                                        suitableFor: dataFood.suitableFor,
                                        takeTime: dataFood.takeTime,
                                        foodCategory: dataFood.foodCategory,
                                        price: dataFood.price.toString(),
                                        dataIngredient: dataIngredient,
                                        dataHowto: dataHowto,
                                      )),
                            ).then((value) {
                              getPost();
                            });
                          } else if (value == 1) {
                            showDialog(
                              barrierColor: Colors.black26,
                              context: context,
                              builder: (context) {
                                return CustomAlertDialog(
                                  title: "ลบสูตรอาหาร",
                                  description:
                                      "คุณแน่ใจใช่ไหมที่จะลบสูตรอาหารนี้",
                                  token: this.token,
                                  recipe_ID: this.req_rid,
                                );
                              },
                            );
                          }
                        },
                        itemBuilder: (context) {
                          return List.generate(2, (index) {
                            return PopupMenuItem(
                              value: index,
                              child: Text(actionDropdown[index]),
                            );
                          });
                        },
                      ),
          ],
          pinned: true,
          expandedHeight: 256.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              dataFood.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            color: Color(0xFFf3f5f9),
            child: Column(
              children: [
                Container(height: 50, width: 500, color: Colors.white),
                Card(
                  margin: EdgeInsets.zero, //ปรับระยะขอบการ์ดให้ติดขอบทุกด้าน
                  //ปรับขอบการ์ด
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(dataFood.aliasName,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                dataFood.description,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'OpenSans',
                                  fontSize: 15,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      (dataFood.score == null)
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.blue,
                                    size: 17,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Text(dataFood.score.toString() +
                                      "/5 (${dataFood.count})")
                                ],
                              ),
                            ),
                      Text(
                        dataFood.recipeName,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'OpenSans',
                          fontSize: 25,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: 300,
                          height: 200,
                          child: ClipRRect(
                            borderRadius: new BorderRadius.circular(24.0),
                            child: Image(
                              fit: BoxFit.contain,
                              image: NetworkImage(dataFood.image),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey.shade400,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 30.0,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                dataFood.suitableFor,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'OpenSans',
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.watch_later_outlined,
                                color: Colors.grey,
                                size: 30.0,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                dataFood.takeTime,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'OpenSans',
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.food_bank,
                                color: Colors.grey,
                                size: 30.0,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                dataFood.foodCategory,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'OpenSans',
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Card(
                  margin: EdgeInsets.zero, //ปรับระยะขอบการ์ดให้ติดขอบทุกด้าน
                  //ปรับขอบการ์ด
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "ส่วนผสม",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontFamily: 'OpenSans',
                                fontSize: 25,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ListView(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: ingredient,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Card(
                  margin: EdgeInsets.zero, //ปรับระยะขอบการ์ดให้ติดขอบทุกด้าน
                  //ปรับขอบการ์ด
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        // color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "วิธีทำ",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'OpenSans',
                                  fontSize: 25,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ToggleButtons(
                                children: <Widget>[
                                  Icon(Icons.image),
                                  Icon(Icons.list),
                                  Icon(Icons.list_alt),
                                ],
                                onPressed: (int index) {
                                  setState(() {
                                    _isSelected[0] = false;
                                    _isSelected[1] = false;
                                    _isSelected[2] = false;
                                    _isSelected[index] = !_isSelected[index];

                                    indexHowTo = index;
                                  });
                                },
                                isSelected: _isSelected,
                                borderColor: Colors.grey,
                                color: Colors.grey,
                                selectedColor: Colors.white,
                                fillColor: Colors.blue,
                                selectedBorderColor: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ListView(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: (indexHowTo == 0) ? howto1 : howto2,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Card(
                  margin: EdgeInsets.zero, //ปรับระยะขอบการ์ดให้ติดขอบทุกด้าน
                  //ปรับขอบการ์ด
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "ให้คะแนน & แสดงความคิดเห็น",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RatingBar.builder(
                        initialRating: (dataGetScoreFood == null)
                            ? 0
                            : dataGetScoreFood.score,
                        minRating: 0.5,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          // color: Colors.amber,
                          color: Colors.blue,
                        ),
                        onRatingUpdate: (rating) async {
                          if (token == "") {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return LoginPage();
                                }).then((value) {
                              if (value != null) {
                                this.findUser();
                              }

                              // Navigator.pop(context);
                            });
                          } else {
                            ratings = rating;
                            ScoreFoodInputModel scoreFoodInputModel =
                                await scoreFoodInput(rating, token);
                          }
                        },
                      ),
                      Divider(
                        indent: 60,
                        endIndent: 60,
                        color: Colors.teal.shade100,
                        thickness: 1.0,
                      ),
                      Column(
                        children: [
                          (dataGetCommentPost.length == 0)
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Row(
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            if (dataMyAccont == null) {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return LoginPage();
                                                  }).then((value) {
                                                if (value != null) {
                                                  this.findUser();
                                                }

                                                // Navigator.pop(context);
                                              });
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CommentFood(
                                                            autoFocus: false,
                                                            dataFood: dataFood,
                                                          ))).then((value) =>
                                                  this.getCommentPosts());
                                            }
                                          },
                                          child: Text("ดูความเห็นทั้งหมด")),
                                    ],
                                  ),
                                ),
                          (token == "")
                              ? Container()
                              : (dataMyAccont == null ||
                                      dataGetCommentPost == null)
                                  ? Center(child: CircularProgressIndicator())
                                  : ListView.builder(
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
                                            if (dataMyAccont == null) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfileUser(
                                                          reqUid:
                                                              dataGetCommentPost[
                                                                      index]
                                                                  .userId,
                                                        )),
                                              );
                                            } else if ((dataMyAccont.userId ==
                                                dataGetCommentPost[index]
                                                    .userId)) {
                                              Navigator.push(context,
                                                  CupertinoPageRoute(
                                                      builder: (context) {
                                                return ProfilePage();
                                              }));
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfileUser(
                                                          reqUid:
                                                              dataGetCommentPost[
                                                                      index]
                                                                  .userId,
                                                        )),
                                              );
                                            }
                                          },
                                          isThreeLine: true,
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                dataGetCommentPost[index]
                                                    .profileImage),
                                          ),
                                          title: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            child: Text(
                                              dataGetCommentPost[index]
                                                  .aliasName,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      (dataGetCommentPost[index]
                                                                  .userStatus ==
                                                              0)
                                                          ? Colors.red
                                                          : (dataGetCommentPost[
                                                                          index]
                                                                      .userId ==
                                                                  dataMyAccont
                                                                      .userId)
                                                              ? Colors.blue
                                                              : Colors.black),
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${dataGetCommentPost[index].datetime}\n\n${dataGetCommentPost[index].commentDetail}',
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'OpenSans',
                                              fontSize: 12,
                                              color: Colors.black,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                          dense: true,
                                          // trailing: Text('Horse'),
                                        );
                                      }),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (dataMyAccont == null)
                                ? CircleAvatar(
                                    child: Icon(Icons.account_box_outlined),
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(dataMyAccont.profileImage),
                                  ),
                            SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(width: 2, color: Colors.blue),
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              onPressed: () {
                                if (dataMyAccont == null) {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return LoginPage();
                                      }).then((value) {
                                    if (value != null) {
                                      this.findUser();
                                    }

                                    // Navigator.pop(context);
                                  });
                                } else {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CommentFood(
                                                    autoFocus: true,
                                                    dataFood: dataFood,
                                                  )))
                                      .then((value) => this.getCommentPosts());
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width - 100,
                                height: 50,
                                child: Row(
                                  children: [
                                    Center(
                                        child: Text(
                                      'แสดงความคิดเห็น...',
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 16),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]))
      ],
    );
  }
}

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog(
      {this.title, this.description, this.token, this.recipe_ID});

  final String title, description, token;
  final int recipe_ID;

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  Future<DeleteRecipeModel> deleteMyFood(String token, int recipe_ID) async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/deleteRecipe";
    var data = {
      "recipe_ID": recipe_ID,
    };
    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    if (response.statusCode == 200) {
      final String responseString = response.body;

      return deleteRecipeModelFromJson(responseString);
    } else {
      return null;
    }
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
                DeleteRecipeModel deleteData = await deleteMyFood(
                    this.widget.token, this.widget.recipe_ID);

                if (deleteData.success == 1) {
                  showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                            title: "ลบสูตรอาหารสำเร็จ",
                            description: "คุณได้ทำการลบสูตรอาหารนี้แล้ว",
                            image:
                                "https://i.pinimg.com/originals/06/ae/07/06ae072fb343a704ee80c2c55d2da80a.gif",
                          ));
                  await new Future.delayed(const Duration(milliseconds: 1600));
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                            title: "ลบสูตรอาหารไม่สำเร็จ",
                            description: "${deleteData.message}",
                            image:
                                "https://media2.giphy.com/media/JT7Td5xRqkvHQvTdEu/200w.gif?cid=82a1493b44ucr1schfqvrvs0ha03z0moh5l2746rdxxq8ebl&rid=200w.gif&ct=g",
                          ));
                  await new Future.delayed(const Duration(seconds: 3));
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
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
  final String title, description;
  final String image;

  CustomDialog({this.title, this.description, this.image});
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
                height: 30.0,
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
