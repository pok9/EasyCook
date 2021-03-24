// import 'dart:html';

import 'package:easy_cook/pages/video_items.dart';
import 'package:easy_cook/style/utiltties.dart';
import 'package:flutter/material.dart';
import 'package:easy_cook/models/profile/newFeedsProfile_model.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_cook/models/showfood/showfood_model.dart';
import 'package:video_player/video_player.dart';

class ShowFood extends StatefulWidget {
  var newfeed;
  ShowFood(var newfeed) {
    this.newfeed = newfeed;
  }
  // ShowFood({Key key}) : super(key: key);

  @override
  _ShowFoodState createState() => _ShowFoodState(newfeed);
}

String token = ""; //โทเคน

//showfood
ShowFoods dataFood;
List<Ingredient> dataIngredient;
List<Howto> dataHowto;

class _ShowFoodState extends State<ShowFood> {
  Feed _newfeed;
  _ShowFoodState(var newfeed) {
    this._newfeed = newfeed;
  }
  @override
  void initState() {
    super.initState();
    findUser();
    getPost();
    // print(dataHowto[0].description);
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
    });
  }

  Future<Null> getPost() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/getPost/" +
        _newfeed.rid.toString();

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;
        dataFood = showFoodsFromJson(responseString);
        dataIngredient = dataFood.ingredient;
        dataHowto = dataFood.howto;
        // dataIngredient = dataFood.ingredient[];
        // print(dataIngredient[0].ingredientName);

        // print(dataFood.date);
        // showFoodFromJson
        // datas = myAccountFromJson(responseString);
        // dataUser = datas.data[0];
      });
    } else {
      return null;
    }
  }

  List<Widget> _buildList() {
    List<List<TextEditingController>> controllers =
        <List<TextEditingController>>[];
    int i;
    // if (controllers.length < 5) {
    //   for (i = controllers.length; i < 5; i++) {
    //     var ctl = <TextEditingController>[];
    //     ctl.add(TextEditingController());
    //     // ctl.add(TextEditingController());
    //     controllers.add(ctl);
    //   }
    // }

    //  if (5 < controllers.length) {
    for (i = 0; i < dataIngredient.length; i++) {
      var ctl = <TextEditingController>[];
      ctl.add(TextEditingController());
      // ctl.add(TextEditingController());
      controllers.add(ctl);
    }
    // }

    i = 0;

    return controllers.map<Widget>((List<TextEditingController> controller) {
      int displayNumber = i;
      i++;

      return Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(
            (displayNumber + 1).toString() +
                ". " +
                dataIngredient[displayNumber].ingredientName +
                "\t" +
                dataIngredient[displayNumber].amount,
            // style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            style: kHintTextStyle2,
          ),
        ),
      );
    }).toList(); // แปลงเป็นlist
  }

  List<Widget> _buildList2() {
    List<List<TextEditingController>> controllers2 =
        <List<TextEditingController>>[];
    int i;
    // if (controllers.length < 5) {
    for (i = 0; i < dataHowto.length; i++) {
      var ctl = <TextEditingController>[];
      ctl.add(TextEditingController());
      // ctl.add(TextEditingController());
      controllers2.add(ctl);
    }
    // }

    i = 0;

    return controllers2.map<Widget>((List<TextEditingController> controller) {
      int displayNumber = i;
      i++;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Card(
              child: Text(
                (displayNumber + 1).toString() +
                    ". " +
                    dataHowto[displayNumber].description,
                // style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                style: kHintTextStyle2,
              ),
            ),
          ),
          (lookupMimeType(dataHowto[displayNumber].pathFile)[0] == "i")
              ? Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.network(
                    dataHowto[displayNumber].pathFile,
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                )
              : Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AspectRatio(
                      aspectRatio: 6 / 3,
                      child: VideoItems(
                        videoPlayerController: VideoPlayerController.network(
                            dataHowto[displayNumber].pathFile),
                        looping: true,
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

  // final List<Widget> ingredient = [
  //   Row(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
  //         child: Text(
  //           "1.",
  //           style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
  //         ),
  //       ),
  //       Text(
  //         "พริกไทย",
  //         style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
  //       ),
  //       SizedBox(
  //         width: 30,
  //       ),
  //       Text(
  //         "1 กรัม",
  //         style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
  //       ),
  //     ],
  //   ),
  //   Row(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
  //         child: Text(
  //           "2.",
  //           style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
  //         ),
  //       ),
  //       Text(
  //         "เกลือ",
  //         style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
  //       ),
  //       SizedBox(
  //         width: 30,
  //       ),
  //       Text(
  //         "1 กรัม",
  //         style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
  //       ),
  //     ],
  //   ),
  //   Row(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
  //         child: Text(
  //           "3.",
  //           style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
  //         ),
  //       ),
  //       Text(
  //         "ผักกาด",
  //         style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
  //       ),
  //       SizedBox(
  //         width: 30,
  //       ),
  //       Text(
  //         "1 กรัม",
  //         style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
  //       ),
  //     ],
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    int arge = ModalRoute.of(context).settings.arguments;

    final List<Widget> test = _buildList();
    final List<Widget> test2 = _buildList2();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(),
      ),
      body: (token == "")
          ? Container()
          : ListView(
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 270,
                          width: 500,
                          color: Colors.white24,
                        ),
                        Container(
                            height: 200,
                            width: 500,
                            child: Image.network(
                              _newfeed.image,
                              fit: BoxFit.cover,
                            )),
                        Positioned(
                          top: 100,
                          left: 120,
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 75,
                              backgroundImage:
                                  NetworkImage(_newfeed.profileImage),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 210,
                          left: 240,
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.grey[300],
                            child: Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                    Text(
                      _newfeed.aliasName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Text(_newfeed.recipeName, style: kHintTextStyle3),
                    // Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: Container(

                    //       height: 200,
                    //       width: 300,
                    //       child: Image.network(
                    //         _newfeed.image,
                    //         fit: BoxFit.cover,
                    //       )),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: 300,
                        height: 200,
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(24.0),
                          child: Image(
                            fit: BoxFit.cover,
                            // alignment: Alignment.topRight,
                            image: NetworkImage(_newfeed.image),
                          ),
                        ),
                      ),
                    ),

                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),

                    Text(
                      "ส่วนผสม",
                      style: kHintTextStyle3,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: test,
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Text(
                      "วิธีทำ",
                      style: kHintTextStyle3,
                    ),
                    ListView(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: test2,
                    ),
                    // Text(
                    //   "วิธีทำ",
                    //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    // ),
                    // ListView(
                    //   padding: EdgeInsets.all(0),
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   children: ingredient,
                    // ),

                    //  SliverFillRemaining(
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       border: Border.all(color: Colors.grey),
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     margin: const EdgeInsets.all(10),
                    //     padding: const EdgeInsets.all(10),
                    //     child: ListView.separated(
                    //       physics: NeverScrollableScrollPhysics(),
                    //       itemCount: 5,
                    //       separatorBuilder: (ctx, index) => Divider(),
                    //       itemBuilder: (ctx,index) => ListTile(
                    //         leading: CircleAvatar(
                    //           child: Text('# ${(index + 1)}'),
                    //         ),
                    //         title: Text(
                    //           "4"
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ],
            ),
    );
  }
}
