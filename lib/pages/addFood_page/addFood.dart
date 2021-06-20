import 'dart:convert';
import 'dart:io';

import 'package:easy_cook/class/addFood_addImage_class.dart';
import 'package:easy_cook/models/addFood/addIngredientsArray_model.dart';
import 'package:easy_cook/models/addFood/addhowto_model.dart';
import 'package:easy_cook/models/addFood/createPost_model.dart';
import 'package:easy_cook/models/addFood/uploadhowtofile_model.dart';

import 'package:easy_cook/pages/addFood_page/addImage.dart';
import 'package:easy_cook/pages/addFood_page/addImageOrVideo.dart';
import 'package:easy_cook/pages/video_items.dart';
import 'package:easy_cook/style/utiltties.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'xxx_addImageORvideo_class.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class test extends StatefulWidget {
  const test({
    this.ingredient_row_start = 1,
    this.howto_row_start = 1, //ทดสอบ
  });
  final int ingredient_row_start; //จำนวนแถวส่วนผสมตั้งต้น
  final int howto_row_start; //ทดสอบ
  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  //vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv ==== 1.CreatePostModel(สร้างโพส(success,recipeId )) ==== vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv/
// CreatePostModel
  var mimeTypeData;
  Future<CreatePostModel> createPosts(
      String tokens, File image, String recipe_name, String price) async {
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/createPost";

    mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(apiUrl));

    final file = await http.MultipartFile.fromPath('image', image.path,
        contentType: new MediaType(mimeTypeData[0], mimeTypeData[1]));

    imageUploadRequest.files.add(file);
    imageUploadRequest.fields['token'] = tokens;
    imageUploadRequest.fields['recipe_name'] = recipe_name;
    imageUploadRequest.fields['price'] = price;

    print("error0000000");
    var streamedResponse = await imageUploadRequest.send();
    print("error1111111");
    var response = await http.Response.fromStream(streamedResponse);
    print("erro222222");

    if (response.statusCode == 200) {
      final String responseString = response.body;

      return createPostModelFromJson(responseString);
    } else {
      print("error");
      return null;
    }
  }
  //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^/

//vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv ==== 2.addIngredients(เพิ่มส่วนผสม) ==== vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv/
  Future<AddIngredientsArrayModel> addIngredients(
      String recipe_ID,
      List<String> ingredientName,
      List<String> amount,
      List<String> step,
      String token) async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/addIngredientsArray";

    print(ingredientName);
    print(amount);
    print(step);

    // List<st>
    var data = {
      "recipe_ID": recipe_ID,
      "ingredientName": ingredientName,
      "amount": amount,
      "step": step
    };
    print("jsonEncode(data) = " + jsonEncode(data));
    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    // print( );
    // addIngredientsArrayModelFromJson
    // print("addIngredients======");
    print("addIngredients======" + (response.statusCode.toString()));
    // print("addIngredients======"+(response));
    if (response.statusCode == 200) {
      final String responseString = response.body;

      return addIngredientsArrayModelFromJson(responseString);
    } else {
      return null;
    }
  }
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^/

//vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv ==== 3.addloadHowtoFiles ==== vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv/
  Future<UploadHowtoFileModels> addloadHowtoFiles(File image) async {
    // final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signin";
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/uploadHowtoFile";

    mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(apiUrl));

    final images = await http.MultipartFile.fromPath('file', image.path,
        contentType: new MediaType(mimeTypeData[0], mimeTypeData[1]));

    imageUploadRequest.files.add(images);

    var streamedResponse = await imageUploadRequest.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final String responseString = response.body;
      return uploadHowtoFileModelsFromJson(responseString);
    } else {
      return null;
    }
  }
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^/

//vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv ==== 4.addHowtos ==== vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv/
  Future<AddHowtoArrayModels> addHowtos(
      String recipe_ID,
      List<String> description,
      List<String> step,
      List<String> path_file,
      List<String> type_file,
      String token) async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/addHowtoArray";

    // print(ingredientName);
    // print(amount);
    // print(step);
    var data = {
      "recipe_ID": recipe_ID,
      "description": description,
      "step": step,
      "path_file": path_file,
      "type_file": type_file
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

      return addHowtoArrayModelsFromJson(responseString);
    } else {
      return null;
    }
  }

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^/

//########################------------คั้นกลาง---------------##############################################################

  //vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv ==== Token ==== vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv/
  //Token
  String token = "";
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("tokens");
    });
  }
  //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^/

  //*******************************************************************************************************/
  String valueChoosePeople = "1 คน";
  List listPeopleItem = [
    "1 คน",
    "2 คน",
    "3 คน",
    "4 คน",
    "5 คน",
    "6 คน",
    "7 คน",
    "8 คน",
    "9 คน",
    "10 คน",
    "มากกว่า 10 คน",
    "มากกว่า 50 คน",
    "มากกว่า 100 คน"
  ];

  String valueChooseTime = "ภายใน 3 นาที";
  List listTimeItem = [
    "ภายใน 3 นาที",
    "ภายใน 5 นาที",
    "ภายใน 10 นาที",
    "ภายใน 15 นาที",
    "ภายใน 30 นาที",
    "ภายใน 60 นาที",
    "ภายใน 90 นาที",
    "ภายใน 2 ชั่วโมง",
    "มากกว่า 2 ชั่วโมง",
  ];

  String valueChooseFood = "เมนูน้ำ";
  List listFoodItem = [
    "เมนูน้ำ",
    "เมนูต้ม",
    "เมนูสุขภาพ",
    "เมนูนิ่ง",
    "เมนูตุ่น",
    "เมนูทอด",
  ];

  TextEditingController _ctrlPrice = TextEditingController()
    ..text = 'ฟรี'; //ราคา

  //########################################################################################################/

  //*******************************************************************************************************/
  int ingredient_row = 0; //จำนวนแถวส่วนผสม
  List<List<TextEditingController>> ctl_ingredient_row =
      <List<TextEditingController>>[];
  List<Widget> _buildListingredient() {
    int i;
    if (ctl_ingredient_row.length < ingredient_row) {
      for (i = ctl_ingredient_row.length; i < ingredient_row; i++) {
        var ctl = <TextEditingController>[];
        ctl.add(TextEditingController());
        ctl.add(TextEditingController());
        ctl_ingredient_row.add(ctl);
      }
    }

    i = 0;

    return ctl_ingredient_row
        .map<Widget>((List<TextEditingController> controller) {
      int displayNumber = i + 1;
      i++;

      return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                "${displayNumber}.",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: ctl_ingredient_row[displayNumber - 1][0],
                onChanged: (text) {
                  print(
                      'Left:' + ctl_ingredient_row[displayNumber - 1][0].text);
                },
                decoration: InputDecoration(
                  hintText: "ส่วนผสมที่ $displayNumber",
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: ctl_ingredient_row[displayNumber - 1][1],
                onChanged: (text) {
                  print(
                      'Right:' + ctl_ingredient_row[displayNumber - 1][1].text);
                },
                decoration: InputDecoration(
                  hintText: "จำนวนที่ $displayNumber",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        ingredient_row--;
                        ctl_ingredient_row.remove(controller);
                        if (ctl_ingredient_row.length == 0) {
                          this.ingredient_row = 1;
                        }
                        print('controllers ${ctl_ingredient_row.length}');
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList(); // แปลงเป็นlist
  }
  //########################################################################################################/

  //*******************************************************************************************************/
  int howto_row = 0; //จำนวนแถววิธีทำ
  List<TextEditingController> ctl_howto_row = <TextEditingController>[]; //ทดสอบ
  List<File> imageHowto = <File>[];

  List<Widget> _buildhowto() {
    //ทดเสอบ

    int i;
    if (ctl_howto_row.length < howto_row) {
      for (i = ctl_howto_row.length; i < howto_row; i++) {
        ctl_howto_row.add(TextEditingController());
        imageHowto.add(File(''));
      }
    }

    i = 0;

    return ctl_howto_row.map<Widget>((TextEditingController controller2) {
      int displayNumber = i + 1;
      i++;
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        // elevation: 5,
        margin: EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      "${displayNumber}.",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      controller: controller2,
                      onChanged: (text) {
                        print(text + "${displayNumber}.");
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "วิธีทำที่ $displayNumber",
                      ),
                    ),
                  ),
                  (imageHowto[displayNumber - 1].toString() ==
                          File('').toString())
                      ? Expanded(
                          flex: 2,
                          child: IconButton(
                              iconSize: 100,
                              icon: Image.asset('assets/images/dot.png'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new test3()),
                                ).then((value) {
                                  if (value != null) {
                                    imageHowto[displayNumber - 1] = value.image;

                                    setState(() {});
                                  }
                                });
                              }))
                      : Container(),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      print("${displayNumber}");
                      // if (lookupMimeType(
                      //         imageHowto[displayNumber - 1].path)[0] !=
                      //     "i") {
                      //   // VideoPlayerController.file(image2[displayNumber - 1])
                      //   //     .setVolume(0);

                      //   // image2[displayNumber - 1] = null;
                      //   print("มันคือ วิดีโอออออออ11111111");

                      //   // print(VideoPlayerController.file(
                      //   //         image2[displayNumber - 1])
                      //   //     .value
                      //   //     .isPlaying);
                      //   // print(VideoPlayerController.file(
                      //   //         image2[displayNumber - 1])
                      //   //     .play());
                      //   // print(displayNumber - 1);

                      //   print("มันคือ วิดีโอออออออ222222");
                      //   setState(() {});
                      // }
                      howto_row--;
                      ctl_howto_row.remove(controller2);
                      imageHowto.remove(imageHowto[displayNumber - 1]);

                      if (ctl_howto_row.length == 0) {
                        howto_row = 1;
                      }
                      print('controllers2.length =  ${ctl_howto_row.length}');
                      setState(() {});
                    },
                  ),
                ],
              ),
              (imageHowto[displayNumber - 1].toString() == File('').toString())
                  ? Container()
                  : Container(
                      height: 350,
                      child: Row(
                        children: [
                          Expanded(
                              // flex: 3,
                              child: (imageHowto[displayNumber - 1]
                                          .toString() ==
                                      File('').toString())
                                  ? Container()
                                  : (lookupMimeType(
                                              imageHowto[displayNumber - 1]
                                                  .path)[0] ==
                                          "i")
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 20, 0, 0),
                                          child: Container(
                                              constraints:
                                                  new BoxConstraints.expand(
                                                height: 350.0,
                                              ),
                                              alignment: Alignment.bottomRight,
                                              padding: new EdgeInsets.only(
                                                  right: 10, bottom: 8.0),
                                              decoration: new BoxDecoration(
                                                image: new DecorationImage(
                                                  image: FileImage(imageHowto[
                                                      displayNumber - 1]),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: ToggleButtons(
                                                color: Colors.black
                                                    .withOpacity(0.60),
                                                selectedColor: Colors.black,
                                                selectedBorderColor:
                                                    Colors.grey,
                                                // fillColor: Color(0xFF6200EE).withOpacity(0.08),
                                                splashColor: Colors.blue,
                                                hoverColor: Color(0xFF6200EE)
                                                    .withOpacity(0.04),
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                constraints: BoxConstraints(
                                                    minHeight: 30.0),
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.camera_alt,
                                                      ),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      Text("แก้ไข")
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.delete),
                                                      Text("ลบ")
                                                    ],
                                                  ),
                                                ],
                                                isSelected: [true, true],
                                                onPressed: (int index) {
                                                  setState(() {
                                                    if (index == 0) {
                                                      Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (context) =>
                                                                new test3()),
                                                      ).then((value) {
                                                        if (value != null) {
                                                          setState(() {
                                                            imageHowto[
                                                                displayNumber -
                                                                    1] = value
                                                                .image;
                                                          });
                                                        }
                                                      });
                                                    } else if (index == 1) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'ยืนยัน'),
                                                              content: const Text(
                                                                  'คุณต้องการลบรูปนี้ ?'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          'Cancel'),
                                                                  child:
                                                                      const Text(
                                                                    'ยกเลิก',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      print(
                                                                          imageHowto);
                                                                      imageHowto[
                                                                          displayNumber -
                                                                              1] = File(
                                                                          '');

                                                                      Navigator.pop(
                                                                          context);
                                                                    });
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'ตกลง',
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    }
                                                  });
                                                },
                                              )),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 0),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: AspectRatio(
                                              aspectRatio: 1,
                                              child: Container(
                                                child: VideoItems(
                                                  videoPlayerController:
                                                      VideoPlayerController
                                                          .file(imageHowto[
                                                              displayNumber -
                                                                  1]),
                                                  looping: false,
                                                  autoplay: false,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                        ],
                      ),
                    ),
              Divider(
                color: Colors.black,
              )
            ],
          ),
        ),
      );
    }).toList(); // แปลงเป็นlist
  }

  //########################################################################################################/

  List<AddImage> addImage = []; //รูปหน้าปก สูตรอาหาร
  var _ctrlNameFood = TextEditingController(); //ชื่อสูตรอาหาร
  var _ctrlExplain = TextEditingController(); //อธิบายสูตรอาหาร

  //แจ้งเตือนตอนกดโพส
  showdialogPost(context, String txt) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "แจ้งเตือน",
              style: TextStyle(color: Colors.red),
            ),
            content: Text(txt),
            actions: [
              TextButton(
                child: Text(
                  "ตกลง",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  //dialog รอ
  showdialog(context) {
    return showDialog(
        context: context,
        builder: (contex) {
          return AlertDialog(
              content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("กรุณารอสักครู่...   "),
              CircularProgressIndicator()
            ],
          ));
        });
  }

  bool _validate = false;
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size; //ขนาดของหน้าจอ

    final List<Widget> ingredient = _buildListingredient();
    final List<Widget> howto = _buildhowto();

    // final transformationController = TransformationController();

    return Scaffold(
      backgroundColor: Color(0xFFf3f5f9),
      appBar: AppBar(
        title: Text('เขียนสูตรอาหาร'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                String text = "";
                bool check = true;
                if (_ctrlNameFood.text.length == 0) {
                  // print("_ctrlNameFood.text.length" +
                  //     _ctrlNameFood.text.length.toString());
                  check = false;
                  _validate = true;
                }
                //เช็ครูปภาพอาหาร
                if (addImage.length == 0) {
                  text += "กรุณาเพิ่มรูปภาพปกอาหาร";
                }
                //เช็คส่วนผสม
                if (ingredient.length == 1) {
                  //   print("ส่วนผสม = " + ingredient.length.toString());
                  //   print();
                  if (ctl_ingredient_row[0][0].text == "") {
                    text += "\nกรุณกรอกส่วนผสม";
                  }
                }
                if (howto.length == 1) {
                  if (imageHowto[0].toString() == File('').toString()) {
                    text += "\nกรุณกรอกวิธีทำกับภาพรูปวิธีทำ";
                  }
                }

                if (text != "") {
                  showdialogPost(context, text);
                  check = false;
                }
                if (check) {
                  showdialog(context);
                  print("โทเคน = " + token);
                  print("รูปภาพปกอาหาร= ${addImage[0].image}");
                  print("ชื่อสูตรอาหาร" + _ctrlNameFood.text);
                  print("ราคา" + _ctrlPrice.text);

                  //createPost
                  final CreatePostModel postsData = await createPosts(token,
                      addImage[0].image, _ctrlNameFood.text, _ctrlPrice.text);

                  // print(postsData.success);
                  // print(postsData.recipeId);

                  //ingredient
                  List<String> ingredientName = [];
                  List<String> amount = [];
                  List<String> ingredientName_step = [];

                  for (var i = 0; i < ctl_ingredient_row.length; i++) {
                    if (ctl_ingredient_row[i][0].text == "") {
                      continue;
                    }
                    ingredientName.add(ctl_ingredient_row[i][0].text);
                    amount.add(ctl_ingredient_row[i][1].text);
                  }
                  for (var i = 0; i < amount.length; i++) {
                    ingredientName_step.add((i + 1).toString());
                  }

                  AddIngredientsArrayModel ingredientsData =
                      await addIngredients(postsData.recipeId.toString(),
                          ingredientName, amount, ingredientName_step, token);

                  // print("success_ingredientsData = ${ingredientsData.success}");

                  //how to
                  List<String> description_howto = [];
                  List<String> path_file = [];
                  List<String> howto_step = [];
                  List<String> type_file = [];

                  var mimeTypeData;
                  for (var i = 0; i < ctl_howto_row.length; i++) {
                    description_howto.add(ctl_howto_row[i].text);

                    howto_step.add((i + 1).toString());

                    UploadHowtoFileModels imageData =
                        await addloadHowtoFiles(imageHowto[i]);

                    path_file.add(imageData.path);
                    type_file.add(imageData.type);
                  }

                  AddHowtoArrayModels howtoData = await addHowtos(
                      postsData.recipeId.toString(),
                      description_howto,
                      howto_step,
                      path_file,
                      type_file,
                      token);

                  if (postsData.success == 1 &&
                      ingredientsData.success == 1 &&
                      howtoData.success == 1) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/slide-page', (route) => false);
                  }
                }
                setState(() {});
              },
              child: Text('โพสต์'),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
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
                  child: TextField(
                    maxLength: 30,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                    controller: _ctrlNameFood,
                    decoration: InputDecoration(
                      errorText: _validate ? 'โปรดใส่ชื่อเมนู' : null,
                      filled: true,
                      fillColor: Color(0xFFFAFAFA),
                      border: OutlineInputBorder(),
                      hintText: "ชื่อเมนู",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    onChanged: (value) {
                      if (value.length > 0) {
                        setState(() {
                          _validate = false;
                        });
                      }
                    },
                  ),
                ),
                (addImage.length == 0)
                    ? Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Container(
                            color: Colors.grey,
                            height: 300,
                            width: screen.width,
                            child: TextButton.icon(
                              icon: Icon(Icons.camera_alt),
                              label: Text('รูปภาพอาหาร'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new test2()),
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      addImage.add(value);
                                    });
                                  }
                                });
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                            )),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      )
                    : Container(
                        constraints: new BoxConstraints.expand(
                          height: 350.0,
                        ),
                        alignment: Alignment.bottomRight,
                        padding: new EdgeInsets.only(right: 10, bottom: 8.0),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: FileImage(addImage[0].image),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: ToggleButtons(
                          color: Colors.black.withOpacity(0.60),
                          selectedColor: Colors.black,
                          selectedBorderColor: Colors.grey,
                          splashColor: Colors.blue,
                          hoverColor: Color(0xFF6200EE).withOpacity(0.04),
                          borderRadius: BorderRadius.circular(20.0),
                          constraints: BoxConstraints(minHeight: 30.0),
                          children: <Widget>[
                            Row(
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                ),
                                SizedBox(
                                  width: 1,
                                ),
                                Text("แก้ไข")
                              ],
                            ),
                            Row(
                              children: [Icon(Icons.delete), Text("ลบ")],
                            ),
                          ],
                          isSelected: [true, true],
                          onPressed: (int index) {
                            setState(() {
                              if (index == 0) {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new test2()),
                                ).then((value) {
                                  if (value != null) {
                                    addImage.removeAt(0);
                                    setState(() {
                                      addImage.add(value);
                                    });
                                  }
                                });
                              } else if (index == 1) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('ยืนยัน'),
                                        content:
                                            const Text('คุณต้องการลบรูปนี้ ?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text(
                                              'ยกเลิก',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                addImage.removeAt(0);
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: const Text(
                                              'ตกลง',
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              }
                            });
                          },
                        )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _ctrlExplain,
                    maxLength: 60,
                    minLines: 4,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFFAFAFA),
                      border: OutlineInputBorder(),
                      hintText: "อธิบายสูตรอาหาร",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Table(
                    border: TableBorder.all(),
                    textDirection: TextDirection.ltr,
                    children: [
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('สำหรับ'),
                        ),
                        Container(
                          width: 300.0,
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              // hint: Text('1 คน'),
                              isExpanded: true,
                              underline: SizedBox(),
                              value: valueChoosePeople,
                              onChanged: (newValue) {
                                setState(() {
                                  valueChoosePeople = newValue;
                                });
                              },
                              items: listPeopleItem.map((valueItem) {
                                return DropdownMenuItem(
                                  value: valueItem,
                                  child: Text(valueItem),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('เวลา'),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: DropdownButton(
                            isExpanded: true,
                            underline: SizedBox(),
                            value: valueChooseTime,
                            onChanged: (newValue) {
                              setState(() {
                                valueChooseTime = newValue;
                              });
                            },
                            items: listTimeItem.map((valueItem) {
                              return DropdownMenuItem(
                                value: valueItem,
                                child: Text(valueItem),
                              );
                            }).toList(),
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('หมวดหมู่อาหาร'),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: DropdownButton(
                            isExpanded: true,
                            underline: SizedBox(),
                            value: valueChooseFood,
                            onChanged: (newValue) {
                              setState(() {
                                valueChooseFood = newValue;
                              });
                            },
                            items: listFoodItem.map((valueItem) {
                              return DropdownMenuItem(
                                value: valueItem,
                                child: Text(valueItem),
                              );
                            }).toList(),
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('ราคา(\u0E3F)'),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: TextField(
                            controller: _ctrlPrice,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            margin: EdgeInsets.all(0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "ส่วนผสม",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ListView(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: ingredient),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: () {
                      print('Button pressed');
                      setState(() {
                        ingredient_row++;
                      });
                    },
                    child: Text('เพิ่มส่วนผสม'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            margin: EdgeInsets.all(0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "วิธีทำ",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ListView(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: howto,
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: () {
                      print('Button pressed');
                      setState(() {
                        howto_row++;
                      });
                    },
                    child: Text('เพิ่ม วิธีทำ'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
    ingredient_row = widget.ingredient_row_start;
    howto_row = widget.howto_row_start;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  // @override
  // void didUpdateWidget(test oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }
}
