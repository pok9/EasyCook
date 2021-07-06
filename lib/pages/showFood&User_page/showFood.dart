import 'package:easy_cook/models/showfood/showfood_model.dart';
import 'package:easy_cook/pages/showFood&User_page/editFood_page/editFood.dart';
import 'package:easy_cook/pages/showFood&User_page/review_page/review.dart';

import 'package:easy_cook/pages/video_items.dart';
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
    getPost();
  }

  String token = ""; //โทเคน
  //ดึง token
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
    });
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
        ? Scaffold()
        : SliverFab(
            floatingWidget: Container(
              height: 100,
              width: 100,
              child: ClipOval(
                child: Image.network(
                  "https://i.pinimg.com/originals/b7/bd/14/b7bd145d8d7202b93f90d52f921721c3.jpg", //////////////////////////////////
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
                title: Text(dataFood.recipeName),
                actions: [
                  PopupMenuButton(
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
                                                "ชื่อเล่นasdfsad", ///////////////////////////
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
                                                'Now, the row first asks the logo to lay out, and then asks the icon to lay out. The Icon, like the logo, is happy to take on a reasonable size (also 24 pixels, not coincidentally, since both FlutterLogo and Icon honor the ambient IconTheme). This leaves some room left over, and now the row tells the text exactly how wide to be: the exact width of the remaining space. The text, now happy to comply to a reasonable request, wraps the text within that width, and you end up with a paragraph split over several lines.',
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
                                                'มากกว่า 100 คน',
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
                                                'มากกว่า 2 ชั่วโมง',
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
                                                'เมนูน้ำสุขภาพ',
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
                                              "รีวิว",
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      RatingBar.builder(
                                        initialRating: 0,
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
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                          showDialog(
                                              context: context,
                                              builder: (_) {
                                                return ReviewPage(rating);
                                              });
                                        },
                                      ),
                                      Divider(
                                        indent: 60,
                                        endIndent: 60,
                                        color: Colors.teal.shade100,
                                        thickness: 1.0,
                                      ),
                                      ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              "https://static.wikia.nocookie.net/characters/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20171118221229"),
                                        ),
                                        title: Row(
                                          children: [
                                            Text(
                                              '1Horse',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            RatingBarIndicator(
                                              rating: 2.5,
                                              itemBuilder: (context, index) =>
                                                  Icon(
                                                Icons.star,
                                                color: Colors.blue,
                                              ),
                                              itemCount: 5,
                                              itemSize: 15.0,
                                              direction: Axis.horizontal,
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          'Now, the row first asks the logo to lay out, and then asks the icon to lay out. The Icon, like the logo, is happy to take on a reasonable size (also 24 pixels, not coincidentally, since both FlutterLogo and Icon honor the ambient IconTheme). This leaves some room left over, and now the row tells the text exactly how wide to be: the exact width of the remaining space. The text, now happy to comply to a reasonable request, wraps the text within that width, and you end up with a paragraph split over several lines.',
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
                                        isThreeLine: true,
                                        // trailing: Text('Horse'),
                                      ),
                                      ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              "https://static.wikia.nocookie.net/characters/images/a/a6/Rick_Sanchez.png/revision/latest?cb=20171118221229"),
                                        ),
                                        title: Row(
                                          children: [
                                            Text(
                                              '1Horseqwerw',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            RatingBarIndicator(
                                              rating: 2.5,
                                              itemBuilder: (context, index) =>
                                                  Icon(
                                                Icons.star,
                                                color: Colors.blue,
                                              ),
                                              itemCount: 5,
                                              itemSize: 15.0,
                                              direction: Axis.horizontal,
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          'Now, the row first asks the logo to lay out, and then asks the icon to lay out. The Icon, like the logo, is happy to take on a reasonable size (also 24 pixels, not coincidentally, since both FlutterLogo and Icon honor the ambient IconTheme). This leaves some room left over, and now the row tells the text exactly how wide to be: the exact width of the remaining space. The text, now happy to comply to a reasonable request, wraps the text within that width, and you end up with a paragraph split over several lines.',
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
