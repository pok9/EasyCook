import 'package:easy_cook/models/showfood/showfood_model.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:http/http.dart' as http;

class ShowFoodStory extends StatefulWidget {
  int rid;

  ShowFoodStory({this.rid});
  @override
  _ShowFoodStoryState createState() => _ShowFoodStoryState();
}

class _ShowFoodStoryState extends State<ShowFoodStory> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
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
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/getPost/" +
        this.widget.rid.toString();

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final String responseString = response.body;

      return showFoodsFromJson(responseString);
    } else {
      return null;
    }
  }

  List<StoryItem> _howtoList3() {
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

    return controllers2
        .map<StoryItem>((List<TextEditingController> controller) {
      int displayNumber = i;
      i++;

      return (lookupMimeType(dataHowto[displayNumber].pathFile)[0] == "i")
          ? StoryItem.inlineImage(
              url: "${dataHowto[displayNumber].pathFile}",
              controller: storyController,
              caption: Text(
                "${dataHowto[displayNumber].description}",
                style: TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.black54,
                  fontSize: 17,
                ),
              ),
            )
          : StoryItem.pageVideo("${dataHowto[displayNumber].pathFile}",
              controller: storyController,
              caption: "${dataHowto[displayNumber].description}");
      // return ListTile(
      //   title: Row(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.only(top: 1),
      //         child: CircleAvatar(
      //           radius: 10,
      //           child: Text("$i"),
      //         ),
      //       ),
      //       SizedBox(
      //         width: 5,
      //       ),
      //       Expanded(child: Text(dataHowto[displayNumber].description)),
      //     ],
      //   ),
      // );
    }).toList(); // แปลงเป็นlist
  }

  String getTimeDifferenceFromNow(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inSeconds < 5) {
      return "เมื่อสักครู่.";
    } else if (difference.inMinutes < 1) {
      return "${difference.inSeconds} วินาที.";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes} นาที.";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} ชั่วโมง.";
    } else {
      return "${difference.inDays} วัน.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPost(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          dataFood = snapshot.data;
          dataIngredient = dataFood.ingredient;
          dataHowto = dataFood.howto;
          final List<StoryItem> howto3 = dataHowto == null ? [] : _howtoList3();
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white, width: 5),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            children: [
              Stack(
                children: [
                  Container(
                    
                    
                    height: 400,
                    child: StoryView(
                      storyItems: howto3,
                      onStoryShow: (s) {
                        print(s);
                      },
                      onComplete: () {
                        print("Completed a cycle");
                      },
                      progressPosition: ProgressPosition.top,
                      repeat: false,
                      controller: storyController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowFood(this.widget.rid)),
                        );
                      },
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                // margin: EdgeInsets.all(100.0),
                                height: 32.0,
                                width: 32.0,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                              ),
                              Positioned(
                                top: 1,
                                right: 1,
                                child: new Container(
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: new NetworkImage(
                                              "${dataFood.image}"))),
                                ),
                              ),
                            ],
                          ),
                          new SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "${dataFood.recipeName} ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: getTimeDifferenceFromNow(
                                                dataFood.date),
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  // child: Text(
                                  //   "${dataFood.recipeName} ",
                                  //   style: TextStyle(
                                  //       fontWeight: FontWeight.bold,
                                  //       color: Colors.white),
                                  // ),
                                ),
                                // Text(
                                //   "${getTimeDifferenceFromNow(dataFood.date)}",
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.normal,
                                //       color: Colors.grey),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
