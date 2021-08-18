import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:easy_cook/class/addFood_addImage_class.dart';
import 'package:easy_cook/models/addFood/addIngredientsArray_model.dart';
import 'package:easy_cook/models/addFood/addhowto_model.dart';
import 'package:easy_cook/models/addFood/createPost_model.dart';
import 'package:easy_cook/models/addFood/uploadhowtofile_model.dart';

import 'package:easy_cook/pages/addFood_page/addImage.dart';
import 'package:easy_cook/pages/addFood_page/addImageOrVideo.dart';
import 'package:easy_cook/pages/showFood&User_page/editFood_page/editFood.dart';
import 'package:easy_cook/pages/video_items.dart';
import 'package:easy_cook/style/utiltties.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({
    this.ingredient_row_start = 1,
    this.howto_row_start = 1, //ทดสอบ
  });
  final int ingredient_row_start; //จำนวนแถวส่วนผสมตั้งต้น
  final int howto_row_start; //ทดสอบ
  @override
  _AddFoodPageState createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  //vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv ==== 1.CreatePostModel(สร้างโพส(success,recipeId )) ==== vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv/
// CreatePostModel
  var mimeTypeData;
  Future<CreatePostModel> createPosts(
      String tokens,
      File image,
      String recipe_name,
      String price,
      String suitable_for,
      String take_time,
      String food_category,
      String description) async {
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
    imageUploadRequest.fields['suitable_for'] = suitable_for;
    imageUploadRequest.fields['take_time'] = take_time;
    imageUploadRequest.fields['food_category'] = food_category;
    imageUploadRequest.fields['description'] = description;

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
      print("token => " + this.token);
    });
  }
  //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^/

  //*******************************************************************************************************/
  // String valueChoosePeople = "1 คน";
  // List listPeopleItem = [
  //   "1 คน",
  //   "2 คน",
  //   "3 คน",
  //   "4 คน",
  //   "5 คน",
  //   "6 คน",
  //   "7 คน",
  //   "8 คน",
  //   "9 คน",
  //   "10 คน",
  //   "มากกว่า 10 คน",
  //   "มากกว่า 50 คน",
  //   "มากกว่า 100 คน"
  // ];

  // String valueChooseTime = "ภายใน 3 นาที";
  // List listTimeItem = [
  //   "ภายใน 3 นาที",
  //   "ภายใน 5 นาที",
  //   "ภายใน 10 นาที",
  //   "ภายใน 15 นาที",
  //   "ภายใน 30 นาที",
  //   "ภายใน 60 นาที",
  //   "ภายใน 90 นาที",
  //   "ภายใน 2 ชั่วโมง",
  //   "มากกว่า 2 ชั่วโมง",
  // ];

  // String valueChooseFood = "เมนูน้ำ";
  // List listFoodItem = [
  //   "เมนูน้ำ",
  //   "เมนูต้ม",
  //   "เมนูสุขภาพ",
  //   "เมนูนิ่ง",
  //   "เมนูตุ่น",
  //   "เมนูทอด",
  // ];

  TextEditingController _ctrlPrice = TextEditingController()
    ..text = '0.00'; //ราคา

  TextEditingController _ctrlPriceCopy = TextEditingController()..text = '0.00';

  //########################################################################################################/

  List<List<double>> data = <List<double>>[];

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
        key: ValueKey('${displayNumber - 1}'),
        padding: const EdgeInsets.only(left: 10, bottom: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.import_export_outlined),
            ),
            Expanded(
              child: TextField(
                controller: ctl_ingredient_row[displayNumber - 1][0],
                onChanged: (text) {
                  print(
                      'Left:' + ctl_ingredient_row[displayNumber - 1][0].text);
                },
                decoration: InputDecoration(
                  contentPadding:
                      new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: "ส่วนผสม",
                  hintStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 1,
            ),
            Expanded(
              child: TextField(
                controller: ctl_ingredient_row[displayNumber - 1][1],
                onChanged: (text) {
                  print(
                      'Right:' + ctl_ingredient_row[displayNumber - 1][1].text);
                },
                decoration: InputDecoration(
                  contentPadding:
                      new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                  filled: true,
                  fillColor: Color(0xfff3f3f4),
                  hintText: "จำนวน",
                  hintStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    borderSide: BorderSide.none,
                  ),
                  // suffixIcon: IconButton(
                  //   icon: Icon(Icons.clear),
                  //   onPressed: () {
                  //     setState(() {
                  //       ingredient_row--;
                  //       ctl_ingredient_row.remove(controller);
                  //       if (ctl_ingredient_row.length == 0) {
                  //         this.ingredient_row = 1;
                  //       }
                  //       print('controllers ${ctl_ingredient_row.length}');
                  //     });
                  //   },
                  // ),
                ),
              ),
            ),
            IconButton(
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
            )
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
        key: ValueKey('${displayNumber - 1}'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        // elevation: 5,
        margin: EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.import_export_outlined),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      //   child: TextFormField(
                      //     minLines: 2,
                      // keyboardType: TextInputType.multiline,
                      // maxLines: null,
                      //     controller: controller2,
                      //     onChanged: (text) {
                      //       print(text + "${displayNumber}.");
                      //     },
                      //     decoration: InputDecoration(
                      //       contentPadding: new EdgeInsets.symmetric(
                      //           vertical: 5.0, horizontal: 10),
                      //       filled: true,
                      //       fillColor: Colors.grey.shade200,

                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(0),
                      //         borderSide: BorderSide.none,
                      //       ),
                      //       hintText: "วิธีทำ",
                      //       hintStyle: TextStyle(
                      //           fontSize: 16,
                      //           // fontWeight: FontWeight.bold,
                      //           color: Colors.grey),
                      //     ),
                      //   ),
                      child: TextFormField(
                        controller: controller2,
                        // maxLength: 60,
                        minLines: 2,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xfff3f3f4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "วิธีทำ",
                          hintStyle: TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                  (imageHowto[displayNumber - 1].toString() ==
                          File('').toString())
                      ? Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              height: 75,
                              color: Color(0xfff3f3f4),
                              child: IconButton(
                                  iconSize: 30,
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.grey.shade700,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new AddImageOrViderPage()),
                                    ).then((value) {
                                      if (value != null) {
                                        imageHowto[displayNumber - 1] =
                                            value.image;

                                        setState(() {});
                                      }
                                    });
                                  }),
                            ),
                          ))
                      : Container(),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      print("${displayNumber}");

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
                  : Row(
                      children: [
                        Expanded(
                            // flex: 3,
                            child: (imageHowto[displayNumber - 1].toString() ==
                                    File('').toString())
                                ? Container()
                                : (lookupMimeType(imageHowto[displayNumber - 1]
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
                                              selectedBorderColor: Colors.grey,
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
                                                              new AddImageOrViderPage()),
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
                                                                onPressed: () {
                                                                  setState(() {
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
                                    // :Container()
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: AspectRatio(
                                            // aspectRatio: 16 / 9,
                                            // aspectRatio: 3/2,
                                            aspectRatio: 1,
                                            child: Container(
                                              //     child: VideoPlayerScreen(
                                              //       videoPlayerController:
                                              //           VideoPlayerController.file(
                                              //               imageHowto[
                                              //                   displayNumber - 1]),
                                              //       looping: false,
                                              //       autoplay: false,
                                              //     ),
                                              child: VideoItems(
                                                videoPlayerController:
                                                    VideoPlayerController.file(
                                                        imageHowto[
                                                            displayNumber - 1]),
                                                // videoPlayerController:
                                                //     VideoPlayerController.network(
                                                //         'https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4'),
                                                looping: false,
                                                autoplay: false,
                                                addfood_showfoo: 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                      ],
                    ),
              // Divider(
              //   color: Colors.black,
              // )
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
  final List<int> _items = List<int>.generate(50, (int index) => index);

  bool clearNameFood = true;
  bool clearDesciptionFood = true;

  String _selectPeoples;
  List<People> _peoples;

  String _selectTimes;
  List<Time> _times;

  String _selectCategorys;
  List<Category> _categorys;

  String _selectPrices;
  List<Price> _prices;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    var screen = MediaQuery.of(context).size; //ขนาดของหน้าจอ

    final List<Widget> ingredient = _buildListingredient();
    print("ingredient.lrngth = ${ingredient.length}");

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
                  final CreatePostModel postsData = await createPosts(
                      token,
                      addImage[0].image,
                      _ctrlNameFood.text,
                      _ctrlPrice.text,
                      _selectPeoples,
                      _selectTimes,
                      _selectCategorys,
                      _ctrlExplain.text);

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

                  print(
                      "postsData.success = ${postsData.success} ingredientsData.success = ${ingredientsData.success} howtoData.success = ${howtoData.success}");

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
                (addImage.length == 0)
                    ? Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Container(
                            color: Colors.grey.shade500,
                            height: 300,
                            width: screen.width,
                            child: TextButton.icon(
                              icon: Icon(Icons.camera_alt),
                              label: Text('รูปภาพอาหาร'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new AddImagePage()),
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
                        margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      )
                    : Container(
                        constraints: new BoxConstraints.expand(
                          height: 350.0,
                        ),
                        alignment: Alignment.bottomRight,
                        margin: EdgeInsets.fromLTRB(1, 0, 1, 0),
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
                                      builder: (context) => new AddImagePage()),
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
                  child: Row(
                    children: [
                      Text(
                        "ชื่อสูตรอาหาร",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: TextFormField(
                    maxLength: 30,
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                    controller: _ctrlNameFood,
                    decoration: InputDecoration(
                      suffixIcon: (clearNameFood)
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  _ctrlNameFood.text = "";
                                  clearNameFood = true;
                                });
                              },
                              icon: Icon(Icons.clear),
                            ),
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10),
                      errorText: _validate ? 'โปรดใส่ชื่อเมนู' : null,
                      filled: true,
                      fillColor: Color(0xfff3f3f4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "ชื่อเมนู",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value.length > 0) {
                          clearNameFood = false;
                          _validate = false;
                        } else {
                          clearNameFood = true;
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Row(
                    children: [
                      Text(
                        "คำอธิบาย",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: TextFormField(
                    controller: _ctrlExplain,
                    // maxLength: 60,
                    minLines: 4,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      suffixIcon: (clearDesciptionFood)
                          ? null
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _ctrlExplain.text = "";
                                    clearDesciptionFood = true;
                                  });
                                },
                                icon: Icon(Icons.clear),
                              ),
                            ),
                      filled: true,
                      fillColor: Color(0xfff3f3f4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "บอกเราเกี่ยวกับสูตรอาหารนี้",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value.length > 0) {
                          clearDesciptionFood = false;
                        } else {
                          clearDesciptionFood = true;
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Row(
                    children: [
                      Text(
                        "เพิ่มแท็กสูตรอาหาร",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    children: [
                      Text(
                        "สำหรับ",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: peopleWidgets.toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    children: [
                      Text(
                        "เวลา",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: timeWidgets.toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    children: [
                      Text(
                        "หมวดหมู่อาหาร",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: categoryWidgets.toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    children: [
                      Text(
                        "ราคา",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: priceWidgets.toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                //   child: Table(
                //     border: TableBorder.all(),
                //     textDirection: TextDirection.ltr,
                //     children: [
                //       TableRow(children: [
                //         Padding(
                //           padding: const EdgeInsets.all(15.0),
                //           child: Text('สำหรับ'),
                //         ),
                //         Container(
                //           width: 300.0,
                //           padding: EdgeInsets.only(left: 16, right: 16),
                //           child: DropdownButtonHideUnderline(
                //             child: DropdownButton(
                //               // hint: Text('1 คน'),
                //               isExpanded: true,
                //               underline: SizedBox(),
                //               value: valueChoosePeople,
                //               onChanged: (newValue) {
                //                 setState(() {
                //                   valueChoosePeople = newValue;
                //                 });
                //               },
                //               items: listPeopleItem.map((valueItem) {
                //                 return DropdownMenuItem(
                //                   value: valueItem,
                //                   child: Text(valueItem),
                //                 );
                //               }).toList(),
                //             ),
                //           ),
                //         ),
                //       ]),
                //       TableRow(children: [
                //         Padding(
                //           padding: const EdgeInsets.all(15.0),
                //           child: Text('เวลา'),
                //         ),
                //         Container(
                //           padding: EdgeInsets.only(left: 16, right: 16),
                //           child: DropdownButton(
                //             isExpanded: true,
                //             underline: SizedBox(),
                //             value: valueChooseTime,
                //             onChanged: (newValue) {
                //               setState(() {
                //                 valueChooseTime = newValue;
                //               });
                //             },
                //             items: listTimeItem.map((valueItem) {
                //               return DropdownMenuItem(
                //                 value: valueItem,
                //                 child: Text(valueItem),
                //               );
                //             }).toList(),
                //           ),
                //         ),
                //       ]),
                //       TableRow(children: [
                //         Padding(
                //           padding: const EdgeInsets.all(15.0),
                //           child: Text('หมวดหมู่อาหาร'),
                //         ),
                //         Container(
                //           padding: EdgeInsets.only(left: 16, right: 16),
                //           child: DropdownButton(
                //             isExpanded: true,
                //             underline: SizedBox(),
                //             value: valueChooseFood,
                //             onChanged: (newValue) {
                //               setState(() {
                //                 valueChooseFood = newValue;
                //               });
                //             },
                //             items: listFoodItem.map((valueItem) {
                //               return DropdownMenuItem(
                //                 value: valueItem,
                //                 child: Text(valueItem),
                //               );
                //             }).toList(),
                //           ),
                //         ),
                //       ]),
                //       TableRow(children: [
                //         Padding(
                //           padding: const EdgeInsets.all(15.0),
                //           child: Text('ราคา(\u0E3F)'),
                //         ),
                //         Container(
                //           padding: EdgeInsets.only(left: 16, right: 16),
                //           child: TextField(
                //             controller: _ctrlPrice,
                //             keyboardType: TextInputType.number,
                //             decoration: InputDecoration(
                //               border: InputBorder.none,
                //             ),
                //           ),
                //         ),
                //       ]),
                //     ],
                //   ),
                // ),
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
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ReorderableListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: ingredient,
                  onReorder: (int oldIndex, int newIndex) {
                    if (newIndex > oldIndex) {
                      newIndex = newIndex - 1;
                    }

                    final dragIngredient_row =
                        ctl_ingredient_row.removeAt(oldIndex);
                    setState(() {
                      ctl_ingredient_row.insert(newIndex, dragIngredient_row);
                    });
                  },
                ),
                // ListView(
                //     padding: EdgeInsets.all(0),
                //     shrinkWrap: true,
                //     physics: NeverScrollableScrollPhysics(),
                //     children: ingredient),
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
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ReorderableListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: howto,
                  onReorder: (int oldIndex, int newIndex) {
                    if (newIndex > oldIndex) {
                      newIndex = newIndex - 1;
                    }

                    final dragHowto_row = ctl_howto_row.removeAt(oldIndex);

                    final dragImageHowto = imageHowto.removeAt(oldIndex);

                    setState(() {
                      ctl_howto_row.insert(newIndex, dragHowto_row);
                      imageHowto.insert(newIndex, dragImageHowto);
                    });
                  },
                ),
                // ListView(
                //   padding: EdgeInsets.all(0),
                //   shrinkWrap: true,
                //   physics: NeverScrollableScrollPhysics(),
                //   children: howto,
                // ),
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
    

    findUser();

    ingredient_row = widget.ingredient_row_start;
    howto_row = widget.howto_row_start;

    _selectPeoples = "1 คน";
    _peoples = <People>[
      const People('1 คน'),
      const People('2 คน'),
      const People('3 คน'),
      const People('4 คน'),
      const People('5 คน'),
      const People('6 คน'),
      const People('7 คน'),
      const People('8 คน'),
      const People('9 คน'),
      const People('10 คน'),
      const People('มากกว่า 10 คน'),
      const People('มากกว่า 50 คน'),
      const People('มากกว่า 100 คน'),
    ];

    _selectTimes = "ภายใน 3 นาที";
    _times = <Time>[
      const Time('ภายใน 3 นาที'),
      const Time('ภายใน 5 นาที'),
      const Time('ภายใน 10 นาที'),
      const Time('ภายใน 15 นาที'),
      const Time('ภายใน 30 นาที'),
      const Time('ภายใน 60 นาที'),
      const Time('ภายใน 90 นาที'),
      const Time('ภายใน 2 ชั่วโมง'),
      const Time('มากกว่า 2 ชั่วโมง'),
    ];

    _selectCategorys = "ไม่ระบุ";
    _categorys = <Category>[
      const Category('ไม่ระบุ'),
      const Category('เมนูน้ำ'),
      const Category('เมนูต้ม'),
      const Category('เมนูสุขภาพ'),
      const Category('เมนูนึ่ง'),
      const Category('เมนูตุ่น'),
      const Category('เมนูทอด'),
    ];

    _selectPrices = "ฟรี";
    _prices = <Price>[
      Price('ฟรี'),
      Price('ระบุราคา'),
    ];

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("wwwwww");
    // for (int i = 0; i < imageHowto.length; i++) {
    //   VideoPlayerController.file(imageHowto[i]).dispose();
    // }
    super.dispose();
  }

  Iterable<Widget> get peopleWidgets sync* {
    for (People people in _peoples) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          backgroundColor: Color(0xfff3f3f4),
          avatar: CircleAvatar(
            child: Icon(Icons.person),
          ),
          label: Text(
            people.name,
            style: TextStyle(
                color: (_selectPeoples.contains(people.name))
                    ? Colors.white
                    : Colors.black),
          ),
          selected: _selectPeoples.contains(people.name),
          onSelected: (bool selected) {
            setState(() {
              _selectPeoples = people.name;
            });
          },
        ),
      );
    }
  }

  Iterable<Widget> get timeWidgets sync* {
    for (Time time in _times) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          backgroundColor: Color(0xfff3f3f4),
          avatar: CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(
              Icons.access_time_outlined,
              color: Colors.amber,
            ),
          ),
          label: Text(
            time.name,
            style: TextStyle(
                color: (_selectTimes.contains(time.name))
                    ? Colors.white
                    : Colors.black),
          ),
          selected: _selectTimes.contains(time.name),
          onSelected: (bool selected) {
            setState(() {
              _selectTimes = time.name;
            });
          },
        ),
      );
    }
  }

  Iterable<Widget> get categoryWidgets sync* {
    for (Category category in _categorys) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          backgroundColor: Color(0xfff3f3f4),
          avatar: CircleAvatar(
            backgroundColor: Colors.pink,
            child: Icon(
              Icons.food_bank,
              // color: Colors.amber,
            ),
          ),
          label: Text(
            category.name,
            style: TextStyle(
                color: (_selectCategorys.contains(category.name))
                    ? Colors.white
                    : Colors.black),
          ),
          selected: _selectCategorys.contains(category.name),
          onSelected: (bool selected) {
            setState(() {
              _selectCategorys = category.name;
            });
          },
        ),
      );
    }
  }

  Iterable<Widget> get priceWidgets sync* {
    for (Price price in _prices) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          backgroundColor: Color(0xfff3f3f4),
          avatar: CircleAvatar(
            backgroundColor: Colors.amberAccent,
            child: Icon(
              Icons.monetization_on,
              color: Colors.white,
            ),
          ),
          label: Text(
            (price.name == "ฟรี" || price.name == "ระบุราคา")
                ? price.name
                : price.name + " บาท",
            style: TextStyle(
                color: (_selectPrices.contains(price.name))
                    ? Colors.white
                    : Colors.black),
          ),
          selected: _selectPrices.contains(price.name),
          onSelected: (bool selected) {
            setState(() {
              _selectPrices = price.name;

              if (_selectPrices != "ฟรี") {
                _tripEditModalBottomSheet(context);
              } else {
                _prices[1] = Price('ระบุราคา');
                _ctrlPrice.text = "0.00";
                _ctrlPriceCopy.text = "0.00";
              }
            });
          },
        ),
      );
    }
  }

  void _tripEditModalBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => SingleChildScrollView(
              child: Container(
                color: Color(0xFF737373),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: _buildBottomNavigationMenu(context),
              ),
            ));
  }

  Container _buildBottomNavigationMenu(context) {
    return Container(

        // height: (MediaQuery.of(context).viewInsets.bottom != 0) ? MediaQuery.of(context).size.height * .60 : MediaQuery.of(context).size.height * .30,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(30),
                topRight: const Radius.circular(30))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "ระบุราคา(บาท)",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                          if (_ctrlPriceCopy.text == "0.00") {
                            _ctrlPrice.text = "0.00";
                            _selectPrices = "ฟรี";
                            _prices[1] = Price('ระบุราคา');
                          }
                        });
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.blue,
                        size: 25,
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(7),
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}')),
                    // FilteringTextInputFormatter.allow(RegExp('[1234567890.0]')),
                    // FilteringTextInputFormatter.deny('..')

                    //   FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: _ctrlPrice,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    labelText: 'ราคา',
                  ),
                  autofocus: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  // padding: EdgeInsets.all(20),

                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          Navigator.pop(context);
                          _ctrlPriceCopy.text = _ctrlPrice.text;
                          if (_ctrlPriceCopy.text == "0.00" ||
                              _ctrlPriceCopy.text == "" ||
                              double.parse(_ctrlPrice.text) == 0) {
                            _ctrlPrice.text = "0.00";
                            _ctrlPriceCopy.text == "0.00";
                            _selectPrices = "ฟรี";
                            _prices[1] = Price('ระบุราคา');
                          } else {
                            _prices[1] = Price('${_ctrlPrice.text}');
                            _selectPrices = _ctrlPrice.text;
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ตกลง',
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
              ),
            ],
          ),
        ));
  }
}

class People {
  const People(this.name);
  final String name;
}

class Time {
  const Time(this.name);
  final String name;
}

class Category {
  const Category(this.name);
  final String name;
}

class Price {
  const Price(this.name);
  final String name;
}
