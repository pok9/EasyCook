import 'package:easy_cook/models/showfood/showfood_model.dart';
import 'package:easy_cook/pages/video_items.dart';
import 'package:easy_cook/style/utiltties.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class ShowFood extends StatefulWidget {
  // const test({Key key}) : super(key: key);
  var newfeed;
  ShowFood(this.newfeed);

  @override
  _ShowFoodState createState() => _ShowFoodState(newfeed);
}

class _ShowFoodState extends State<ShowFood> {
  var _newfeed;
  _ShowFoodState(this._newfeed);

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
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/getPost/" +
        _newfeed.rid.toString();
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

  List<Widget> _buildList() {
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
            Text(
              (displayNumber + 1).toString() +
                  ". " +
                  dataIngredient[displayNumber].ingredientName +
                  "\t" +
                  dataIngredient[displayNumber].amount,
              style: TextStyle(fontWeight: FontWeight.normal,fontFamily: 'OpenSans', fontSize: 17,color: Colors.black,decoration: TextDecoration.none),
              // 
              // style: kHintTextStyle2,
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

  List<Widget> _buildList2() {
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
            child: Text(
              (displayNumber + 1).toString() +
                  ". " +
                  dataHowto[displayNumber].description,
              style: TextStyle(fontWeight: FontWeight.normal,fontFamily: 'OpenSans', fontSize: 17,color: Colors.black,decoration: TextDecoration.none),
              // style: kHintTextStyle2,
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
                      aspectRatio: 6 / 6,
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> ingredient = dataIngredient == null ? [] : _buildList();
    final List<Widget> howto = dataHowto == null ? [] : _buildList2();

    return SliverFab(
      floatingWidget: Container(
        height: 100,
        width: 100,
        child: ClipOval(
          child: Image.network(
            _newfeed.profileImage,
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
          title: Text(_newfeed.recipeName),
          pinned: true,
          expandedHeight: 256.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              _newfeed.image,
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
                            color: Colors.white24,
                          ),
                          Text(
                            _newfeed.aliasName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.black,
                                ),
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          Text(_newfeed.recipeName, style: kHintTextStyle3),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              width: 300,
                              height: 200,
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(24.0),
                                child: Image(
                                  fit: BoxFit.cover,
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
                            children: ingredient,
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
                            children: howto,
                          ),
                          SizedBox(
                            height: 25,
                          )
                        ],
                      ),
                    ))))
      ],
    );
  }
}
