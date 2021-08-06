import 'dart:convert';
import 'dart:ffi';

import 'package:easy_cook/models/deleteFood&editFood/deleteFood.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/showfood/commentFood_model.dart/getCommentPost_model.dart';
import 'package:easy_cook/models/showfood/scoreFood/getScoreFoodModel.dart';
import 'package:easy_cook/models/showfood/scoreFood/scoreFoodInputModel.dart';

import 'package:easy_cook/models/showfood/showfood_model.dart';
import 'package:easy_cook/pages/login&register_page/login_page/login.dart';
import 'package:easy_cook/pages/showFood&User_page/commentFood.dart/commentFood.dart';
import 'package:easy_cook/pages/showFood&User_page/editFood_page/editFood.dart';
import 'package:easy_cook/pages/showFood&User_page/review_page/review.dart';

import 'package:easy_cook/pages/video_items.dart';
import 'package:easy_cook/slidepage.dart';
import 'package:easy_cook/style/utiltties.dart';
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

  @override
  void initState() {
    super.initState();
    findUser();
    getCommentPosts();
    getPost();
  }

  //แสดงคอมเมนต์
  List<GetCommentPostModel> dataGetCommentPost;
  Future<Null> getCommentPosts() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/getComment/" +
            req_rid.toString();

    final response = await http.get(Uri.parse(apiUrl));
    print("response = " + response.statusCode.toString());
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

  String token = ""; //โทเคน
  //ดึง token
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");

      if (token != "") {
        getMyAccounts();
        getcoreFood();
      }
    });
  }

  //ให้คะแนนสูตรอาหาร
  Future<ScoreFoodInputModel> scoreFoodInput(
       double score, String token) async {
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/score";

    var data = {
      "recipe_ID": this.req_rid,
      "score": score,
    };

    print(jsonEncode(data));
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
  Future<Null> getcoreFood() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/getMyScore/" +
            req_rid.toString();

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        dataGetScoreFood = getScoreFoodModelFromJson(responseString);
      });
    } else {
      return null;
    }
  }

  //user
  MyAccount datas;
  DataAc dataMyAccont;
  Future<Null> getMyAccounts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        datas = myAccountFromJson(responseString);
        dataMyAccont = datas.data[0];
      });
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
  Future<Null> getPost() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/getPost/" + req_rid.toString();
    // print("xxlToken = " + token);
    final response = await http.get(Uri.parse(apiUrl));
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;
        dataFood = showFoodsFromJson(responseString);
        dataIngredient = dataFood.ingredient;
        dataHowto = dataFood.howto;
      });
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
            // Container(
            //   margin: EdgeInsets.all(5.0),
            //   decoration:
            //       BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
            // ),
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
                //
                // style: kHintTextStyle2,
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
        // ctl.add(TextEditingController());
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
                    // (displayNumber + 1).toString() +
                    //     ". " +
                    dataHowto[displayNumber].description,
                    // textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: 'OpenSans',
                        fontSize: 17,
                        color: Colors.black,
                        decoration: TextDecoration.none),
                    // style: kHintTextStyle2,
                  ),
                ),
              ],
            ),
            // child: Card(
            //   child: Text(
            //     (displayNumber + 1).toString() +
            //         ". " +
            //         dataHowto[displayNumber].description,
            //     // style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            //     style: kHintTextStyle2,
            //   ),
            // ),
          ),
          (lookupMimeType(dataHowto[displayNumber].pathFile)[0] == "i")
              // ? Card(
              //     semanticContainer: true,
              //     clipBehavior: Clip.antiAliasWithSaveLayer,
              //     child: Image.network(
              //       dataHowto[displayNumber].pathFile,
              //       fit: BoxFit.fill,
              //     ),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //     elevation: 5,
              //     margin: EdgeInsets.all(10),
              //   )
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
              // : Padding(
              //     padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              //     child: Align(
              //       alignment: Alignment.topCenter,
              //       child: AspectRatio(
              //         aspectRatio: 1,
              //         child: Container(
              //           child: VideoItems(
              //             videoPlayerController: VideoPlayerController.network(
              //                 dataHowto[displayNumber].pathFile),
              //             looping: false,
              //             autoplay: false,
              //           ),
              //         ),
              //       ),
              //     ),
              //   )
              : Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: VideoItems(
                        videoPlayerController: VideoPlayerController.network(
                            dataHowto[displayNumber].pathFile),
                        looping: false,
                        autoplay: false,
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                )
          // Card(
          //     child: Align(
          //       alignment: Alignment.bottomCenter,
          //       child: AspectRatio(
          //         aspectRatio: 6 / 3,
          //         child: VideoItems(
          //           videoPlayerController: VideoPlayerController.network(
          //               dataHowto[displayNumber].pathFile),
          //           looping: true,
          //           autoplay: false,
          //         ),
          //       ),
          //     ),
          //   )
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
        // ctl.add(TextEditingController());
        controllers2.add(ctl);
      }
    }

    i = 0;

    return controllers2.map<Widget>((List<TextEditingController> controller) {
      int displayNumber = i;
      i++;

      return ListTile(
        // selected: true,
        // leading: CircleAvatar(
        //   child: Text("$i"),
        // ),
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
        // subtitle: Text("Group Sub Category"),
        // onTap: () {},
      );
    }).toList(); // แปลงเป็นlist
  }

  int indexHowTo = 0;
  List<String> actionDropdown = ['แก้ไขสูตรอาหาร', 'ลบสูตรอาหาร'];
  List<bool> _isSelected = [true, false, false];
  @override
  Widget build(BuildContext context) {
    final List<Widget> ingredient =
        dataIngredient == null ? [] : _ingredientList();
    final List<Widget> howto1 = dataHowto == null ? [] : _howtoList1();
    final List<Widget> howto2 = dataHowto == null ? [] : _howtoList2();

    return dataFood == null
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
        : SliverFab(
            floatingWidget: Container(
              height: 100,
              width: 100,
              child: ClipOval(
                child: Image.network(
                  dataFood.profileImage, //////////////////////////////////
                  fit: BoxFit.fill,
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 8.0)),
            ),
            expandedHeight: 256.0,
            floatingPosition: FloatingPosition(top: -20, left: 150),
            slivers: [
              SliverAppBar(
                title: Text(dataFood.recipeName + this.req_rid.toString()),
                actions: [
                  (dataMyAccont == null || dataFood == null)
                      ? Container()
                      : (dataMyAccont.userId != dataFood.userId)
                          ? Container()
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
                                            dataFood.recipeName,
                                            dataFood.image,
                                            dataIngredient,
                                            dataHowto)),
                                  );
                                } else if (value == 1) {
                                  print("ลบสูตรอาหาร");
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
                    dataFood.image, ///////////////////////////
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // CustomScrollView(
              //   slivers: [

              //   ],
              // ),
              SliverList(
                  delegate: SliverChildListDelegate(List.generate(
                      1,
                      (index) => Container(
                            color: Color(0xFFf3f5f9),
                            child: Column(
                              children: [
                                Container(
                                    height: 50,
                                    width: 500,
                                    color: Colors.white),
                                Card(
                                  margin: EdgeInsets
                                      .zero, //ปรับระยะขอบการ์ดให้ติดขอบทุกด้าน
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                dataFood
                                                    .aliasName, ///////////////////////////
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  decoration:
                                                      TextDecoration.none,
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
                                                  decoration:
                                                      TextDecoration.none,
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
                                      Text(
                                        dataFood
                                            .recipeName, ////////////////////////////////
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
                                            borderRadius:
                                                new BorderRadius.circular(24.0),
                                            child: Image(
                                              fit: BoxFit.contain,
                                              image: NetworkImage(dataFood
                                                  .image), ///////////////////////
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Colors.grey.shade400,
                                      ),
                                      Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceAround,
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              Icon(
                                                Icons.person,
                                                color: Colors.grey,
                                                size: 30.0,
                                              ),
                                              Text(
                                                dataFood.suitableFor,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                  decoration:
                                                      TextDecoration.none,
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
                                              Text(
                                                dataFood.takeTime,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.grey,
                                                size: 30.0,
                                              ),
                                              Text(
                                                dataFood.foodCategory,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      // Divider(
                                      //   height: 1,
                                      //   thickness: 1,
                                      //   color: Colors.black,
                                      // ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Card(
                                  margin: EdgeInsets
                                      .zero, //ปรับระยะขอบการ์ดให้ติดขอบทุกด้าน
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
                                            padding:
                                                const EdgeInsets.only(left: 10),
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
                                      // Divider(
                                      //   thickness: 1,
                                      //   color: Colors.grey,
                                      // ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Card(
                                  margin: EdgeInsets
                                      .zero, //ปรับระยะขอบการ์ดให้ติดขอบทุกด้าน
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                "วิธีทำ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 25,
                                                  color: Colors.black,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
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
                                                    _isSelected[index] =
                                                        !_isSelected[index];

                                                    indexHowTo = index;
                                                  });
                                                },
                                                isSelected: _isSelected,
                                                borderColor: Colors.grey,
                                                color: Colors.grey,
                                                selectedColor: Colors.white,
                                                fillColor: Colors.blue,
                                                selectedBorderColor:
                                                    Colors.grey,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                            )
                                            // Padding(
                                            //   padding: const EdgeInsets.only(
                                            //       right: 40),
                                            //   child: Container(
                                            //     child: Row(
                                            //       children: [
                                            //         GestureDetector(
                                            //           onTap: () {
                                            //             indexHowTo = 0;
                                            //             print(indexHowTo);
                                            //             setState(() {});
                                            //           },
                                            //           child: Icon(
                                            //             (indexHowTo == 0)
                                            //                 ? Icons.contacts
                                            //                 : Icons
                                            //                     .contacts_outlined,
                                            //             color: Colors.black,
                                            //             size: 40.0,
                                            //             semanticLabel:
                                            //                 'Text to announce in accessibility modes',
                                            //           ),
                                            //         ),
                                            //         GestureDetector(
                                            //           onTap: () {
                                            //             indexHowTo = 1;
                                            //             print(indexHowTo);
                                            //             setState(() {});
                                            //           },
                                            //           child: Icon(
                                            //             (indexHowTo == 1)
                                            //                 ? Icons.contacts
                                            //                 : Icons
                                            //                     .contacts_outlined,
                                            //             color: Colors.black,
                                            //             size: 40.0,
                                            //             semanticLabel:
                                            //                 'Text to announce in accessibility modes',
                                            //           ),
                                            //         ),
                                            //       ],
                                            //     ),
                                            //   ),
                                            // ),
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
                                        children:
                                            (indexHowTo == 0) ? howto1 : howto2,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Card(
                                  margin: EdgeInsets
                                      .zero, //ปรับระยะขอบการ์ดให้ติดขอบทุกด้าน
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
                                        initialRating:
                                            (dataGetScoreFood == null)
                                                ? 0
                                                : dataGetScoreFood.score,
                                        minRating: 0.5,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          // color: Colors.amber,
                                          color: Colors.blue,
                                        ),
                                        onRatingUpdate: (rating) async {
                                        
                                         ScoreFoodInputModel scoreFoodInputModel = await scoreFoodInput(rating, token);

                                         print(scoreFoodInputModel.success);
                                          
                                        },
                                      ),
                                      Divider(
                                        indent: 60,
                                        endIndent: 60,
                                        color: Colors.teal.shade100,
                                        thickness: 1.0,
                                      ),
                                      ListView.builder(
                                          padding: EdgeInsets.only(top: 0),
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: (dataGetCommentPost ==
                                                  null)
                                              ? 0
                                              : dataGetCommentPost.length > 3
                                                  ? 3
                                                  : dataGetCommentPost.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              isThreeLine: true,
                                              leading: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    dataGetCommentPost[index]
                                                        .profileImage),
                                              ),
                                              title: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 0, 0),
                                                child: Text(
                                                  dataGetCommentPost[index]
                                                      .aliasName,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                              dense: true,
                                              // trailing: Text('Horse'),
                                            );
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            (dataMyAccont == null)
                                                ? CircleAvatar(
                                                    child: Icon(Icons
                                                        .account_box_outlined),
                                                  )
                                                : CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            dataMyAccont
                                                                .profileImage),
                                                  ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Colors.blue),
                                                primary: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
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
                                                          builder: (context) =>
                                                              CommentFood(
                                                                recipe_ID: this
                                                                    .widget
                                                                    .req_rid
                                                                    .toString(),
                                                              ))).then(
                                                      (value) => this
                                                          .getCommentPosts());
                                                }
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    100,
                                                height: 50,
                                                child: Row(
                                                  children: [
                                                    Center(
                                                        child: Text(
                                                      'แสดงความคิดเห็น...',
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 16),
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
                          ))))
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

    print("addIngredients======" + (response.statusCode.toString()));
    // print("addIngredients======"+(response));
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
                // print(deleteData.success);
                // print(deleteData.message);
                // Navigator.of(context).pop();
                // Navigator.of(context).pop();

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
                            description: " ",
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
