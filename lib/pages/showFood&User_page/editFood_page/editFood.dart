import 'dart:convert';
import 'dart:io';

import 'package:easy_cook/class/addFood_addImage_class.dart';
import 'package:easy_cook/models/addFood/uploadhowtofile_model.dart';
import 'package:easy_cook/models/showfood/editFood/editImageFoodModel.dart';
import 'package:easy_cook/models/showfood/showfood_model.dart';
import 'package:easy_cook/pages/addFood_page/addImage.dart';
import 'package:easy_cook/pages/addFood_page/addImageOrVideo.dart';
import 'package:easy_cook/style/utiltties.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import '../../video_items.dart';
import 'package:http_parser/http_parser.dart';

class EditFoodPage extends StatefulWidget {
  // EditFoodPage({Key? key}) : super(key: key);
  // const EditFoodPage({
  //   this.ingredient_row_start = 1,
  //   this.howto_row_start = 1, //ทดสอบ
  // });

  int rid;
  int uid;

  String recipeName;
  String imageFood;

  String suitableFor;
  String takeTime;
  String foodCategory;
  String price;

  String description;
  List<Ingredient> dataIngredient;
  List<Howto> dataHowto;
  EditFoodPage(
      {this.rid,
      this.uid,
      this.recipeName,
      this.imageFood,
      this.suitableFor,
      this.takeTime,
      this.foodCategory,
      this.price,
      this.description,
      this.dataIngredient,
      this.dataHowto});

  // final int ingredient_row_start; //จำนวนแถวส่วนผสมตั้งต้น
  // final int howto_row_start; //ทดสอบ
  @override
  _EditFoodPageState createState() => _EditFoodPageState(this.recipeName,
      this.imageFood, this.description, this.dataIngredient, this.dataHowto);
}

TextEditingController _ctrlPrice = TextEditingController()..text = 'ฟรี'; //ราคา

class _EditFoodPageState extends State<EditFoodPage> {
  _EditFoodPageState(String recipeName, String imageFood, String description,
      List<Ingredient> dataIngredient, List<Howto> dataHowto) {
    this._ctrlNameFood.text = recipeName;
    this._imageFood = imageFood;
    this._ctrlExplain.text = description;

    this.ingredient_row = dataIngredient.length;
    for (int i = 0; i < dataIngredient.length; i++) {
      var ctl = <TextEditingController>[];
      ctl.add(TextEditingController(text: dataIngredient[i].ingredientName));
      ctl.add(TextEditingController(text: dataIngredient[i].amount));
      ctl_ingredient_row.add(ctl);
    }

    this.howto_row = dataHowto.length;
    for (int i = 0; i < dataHowto.length; i++) {
      ctl_howto_row.add(TextEditingController(text: dataHowto[i].description));
      imageHowto.add(File(dataHowto[i].pathFile));
      print("dataHowto[i].pathFile = ${dataHowto[i].pathFile}");
      print("File = ${File(dataHowto[i].pathFile)}");
    }
  }

  var _ctrlNameFood = TextEditingController(); //ชื่อสูตรอาหาร
  var _ctrlExplain = TextEditingController(); //อธิบายสูตรอาหาร

  String _imageFood;
  List<AddImage> addImage = []; //รูปหน้าปก สูตรอาหาร

  List<String> exampleIngredient_row1 = [
    "หมูสามชั้น หั่นเป็นชั้นขนาดพอดีคำ",
    "กะปิ",
    "น้ำตาลปึก",
    "ซอสหอยนางรม",
    "น้ำปลา",
    "ใบมะกรูด",
    "พริกแห้ง"
  ];
  List<String> exampleIngredient_row2 = [
    "1 กิโลกรัม",
    "6 ช้อนโต้ะ",
    "6 ช้อนโต้ะ",
    "1 ช้อนโต้ะ",
    "1 ช้อนโต้ะ",
    "1 กำมือ",
    "1 กำมือ"
  ];

  int ingredient_row;
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
                decoration: InputDecoration(
                  contentPadding:
                      new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText:
                      "เช่น " + exampleIngredient_row1[(displayNumber - 1) % 6],
                  hintStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
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
                decoration: InputDecoration(
                  contentPadding:
                      new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                  filled: true,
                  fillColor: Color(0xfff3f3f4),
                  hintText: exampleIngredient_row2[(displayNumber - 1) % 6],
                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
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
            ),
          ],
        ),
      );
    }).toList(); // แปลงเป็นlist
  }

  List<String> exampleHowto_row = [
    "เริ่มจากเตรียมหมักหมู เตรียมเครื่องหมัก โดยผสม กะปิ น้ำตาลปึก น้ำมันหอย และ น้ำปลา ผสมให้ละลายเข้ากัน จากนั้นนำเครื่องหมักไปคลุกกับหมูสามชั้นที่เตรียมเอาไว้ หมักในตู้เย็น 1 คืน",
    "ตั้งกระทะน้ำมัน ความร้อนอ่อน ใส่ ใบมะกรูดลงไปทอด ให้กรอบ และ นำมาพักให้เย็น จากนั้นพริกแห้งลงไปทอดในน้ำมันเดียวกัน ด้วยไฟอ่อนๆ ให้สุกกรอบ และ ก็นำมาพักเช้นกัน",
    "เร่งไปปานกลาง นำหมูสามชั้นที่หมักลงไปทอด โดยทอดให้สุกประมาณ 60 % ให้นำขึ้นมาพักให้เย็น",
    "เปลี่ยนน้ำมันใหม่ เร่งไฟให้แรงและร้อน ใส่หมูลงไปทอด ให้เหลืองสุก นำขึ้มมาพักให้สะเด็ดน้ำมัน",
    "เพียงเท่านี้ก็เสร็จสิ้นหมูทอดกะปิ แสนอร่อย กินกับข้าวเหนียว"
  ];
  int howto_row; //จำนวนแถววิธีทำ
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
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.import_export_outlined),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: TextFormField(
                        controller: controller2,
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
                          hintText: exampleHowto_row[(displayNumber - 1) % 5],
                          hintStyle:
                              TextStyle(fontSize: 16, color: Colors.grey),
                        ),
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
                      howto_row--;
                      ctl_howto_row.remove(controller2);
                      imageHowto.remove(imageHowto[displayNumber - 1]);

                      if (ctl_howto_row.length == 0) {
                        howto_row = 1;
                      }

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
                                            0, 10, 0, 20),
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
                                                image: (imageHowto[
                                                                displayNumber -
                                                                    1]
                                                            .path
                                                            .substring(0, 4) ==
                                                        "http")
                                                    ? NetworkImage(imageHowto[
                                                            displayNumber - 1]
                                                        .path)
                                                    : FileImage(imageHowto[
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
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Container(
                                              child: VideoItems(
                                                videoPlayerController: (imageHowto[
                                                                displayNumber -
                                                                    1]
                                                            .path
                                                            .substring(0, 4) ==
                                                        "http")
                                                    ? VideoPlayerController
                                                        .network(imageHowto[
                                                                displayNumber -
                                                                    1]
                                                            .path)
                                                    : VideoPlayerController
                                                        .file(imageHowto[
                                                            displayNumber - 1]),
                                                looping: false,
                                                autoplay: false,
                                                addfood_showfood: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                      ],
                    ),
            ],
          ),
        ),
      );
    }).toList(); // แปลงเป็นlist
  }

  bool _validate = false;

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

  TextEditingController _ctrlPriceCopy = TextEditingController()..text = '0.00';

  Future<String> editImageFood(File image) async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/addImageRecipePost";

    var mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(apiUrl));

    final images = await http.MultipartFile.fromPath('image', image.path,
        contentType: new MediaType(mimeTypeData[0], mimeTypeData[1]));

    imageUploadRequest.files.add(images);

    var streamedResponse = await imageUploadRequest.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final String responseString = response.body;
      return editImageFoodModelFromJson(responseString).path;
    } else {
      return null;
    }
  }

  Future<Null> editRecipePost_Fuc(
      String recipe_name,
      image,
      String price,
      String suitable_for,
      take_time,
      food_category,
      description,
      int uid,
      rid) async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/editRecipePost";

    // List<st>
    var data = {
      "recipe_name": recipe_name,
      "image": image,
      "price": price,
      "suitable_for": suitable_for,
      "take_time": take_time,
      "food_category": food_category,
      "description": description,
      "uid": uid,
      "rid": rid
    };

    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    print(response.body);
  }

  Future<Null> editIngredient_Fuc(
      int rid,
      List<String> ingredientName,
      List<int> ingredients_ID,
      List<String> amount,
      List<String> ingredientName_step) async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/editIngredient";

    // List<st>
    var data = {
      "recipe_ID": rid,
      "ingredientName": ingredientName,
      "ingredients_ID": ingredients_ID,
      "amount": amount,
      "step": ingredientName_step
    };

    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    print(response.body);
  }

  Future<UploadHowtoFileModels> addloadHowtoFiles(File image) async {
    // final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signin";
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/uploadHowtoFile";

    var mimeTypeData =
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

  Future<Null> editHowto_Fuc(
      int rid,
      List<int> howto_ID,
      List<String> description_howto,
      List<String> path_file,
      List<String> type_file,
      List<String> howto_step) async {
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/editHowto";

    // List<st>
    var data = {
      "recipe_ID": rid,
      "howto_ID": howto_ID,
      "description": description_howto,
      "path_file": path_file,
      "type_file": type_file,
      "step": howto_step
    };

    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    print(response.body);
  }

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

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size; //ขนาดของหน้าจอ

    final List<Widget> ingredient = _buildListingredient();
    final List<Widget> howto = _buildhowto();
    return Scaffold(
      backgroundColor: Color(0xFFf3f5f9),
      appBar: AppBar(
        title: Text('แก้ไขสูตรอาหาร'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              print(
                  'dataIngredient.length => ${this.widget.dataIngredient.length}');
              print('this.ingredient_row => ${this.ingredient_row}');
              if (_selectPrices == "ฟรี") {
                _selectPrices = "0";
              }
              if (_imageFood != null &&
                  _ctrlNameFood.text == this.widget.recipeName &&
                  _ctrlExplain.text == this.widget.description &&
                  _selectPeoples == this.widget.suitableFor &&
                  _selectTimes == this.widget.takeTime &&
                  _selectCategorys == this.widget.foodCategory &&
                  _selectPrices == this.widget.price &&
                  this.widget.dataIngredient.length == this.ingredient_row &&
                  this.widget.dataHowto.length == this.howto_row) {
                print("กลับได้เลย");
                Navigator.pop(context);
              } else {
                print("กลับไม่ได้");
                showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                          title: "ยังไม่ได้บันทึกการเปลี่ยนแปลง",
                          description:
                              "คุณมีการเปลี่ยนแปลงที่ยังไม่ได้บันทึก แน่ใจไหมว่าต้องการยกเลิก",
                        ));
              }
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                String text = "";
                bool check = true;

                //   if (_selectPrices == "ฟรี") {
                //   _selectPrices = "0";
                // }
                //   if (_imageFood == null &&
                //     _ctrlNameFood.text != this.widget.recipeName &&
                //     _ctrlExplain.text != this.widget.description &&
                //     _selectPeoples != this.widget.suitableFor &&
                //     _selectTimes != this.widget.takeTime &&
                //     _selectCategorys != this.widget.foodCategory &&
                //     _selectPrices != this.widget.price){

                //     }

                //ชื่อเมนู
                String recipe_name;
                //รูปภาพ
                String image;
                //ราคา
                String price;
                //สำหรับ
                String suitable_for;
                //เวลา
                String take_time;
                //หมวดหมู่
                String food_category;
                //อธิบาย
                String description;

                //รูปอาหาร
                if (_imageFood != null) {
                  //รูปเก่าไม่ถูกเปลี่ยน
                  // print(true);
                  print("รูปเก่าไม่ถูกเปลี่ยน => $_imageFood");
                  image = _imageFood;
                } else {
                  if (addImage.length == 0) {
                    //ยังไม่มีรูปภาพอาหาร
                    // print("addImage.length => ${addImage.length}");
                    print("ยังไม่มีรูปภาพอาหาร");
                    text += "กรุณาเพิ่มรูปภาพปกอาหาร";
                  } else {
                    //รูปภาพถูกเปลี่ยนใหม่ <--
                    // print(false);
                    image = await editImageFood(addImage[0].image);
                    print("image = ${image}");
                    print("รูปภาพถูกเปลี่ยนใหม่");
                  }
                }

                //ชื่อเมนู
                if (_ctrlNameFood.text != "") {
                  print("ชื่อเมนู = " + _ctrlNameFood.text);
                  recipe_name = _ctrlNameFood.text;
                } else {
                  print("ยังไม่ใส่ชื่อเมนู");
                  text += "\nกรุณาเพิ่มชื่อเมนูอาหาร";
                }

                //คำอธิบาย
                print("คำอธิบาย => ${_ctrlExplain.text}");
                description = _ctrlExplain.text;

                //สำหรับ
                print("สำหรับ => ${_selectPeoples}");
                suitable_for = _selectPeoples;

                //เวลา
                print("เวลา => ${_selectTimes}");
                take_time = _selectTimes;

                //หมวดหมู่อาหาร
                print("หมวดหมู่อาหาร => ${_selectCategorys}");
                food_category = _selectCategorys;

                //ราคา
                print("ราคา => ${_selectPrices}");
                price = _selectPrices;

                //uid
                print("uid => ${this.widget.uid}");

                //rid
                print("rid => ${this.widget.rid}");

                //token
                print("token => ${token}");

                ///////////////////////////////////////////////////////////////////////////////////

                //ingredient
                List<String> ingredientName = [];
                List<int> ingredients_ID = [];
                List<String> amount = [];
                List<String> ingredientName_step = [];

                //ส่วนผสม
                for (int i = 0; i < ctl_ingredient_row.length; i++) {
                  if (ctl_ingredient_row[i][0].text == "") {
                    text += "\nกรุณกรอกส่วนผสมให้ครบ";
                    break;
                  }
                  ingredientName.add(ctl_ingredient_row[i][0].text);
                  amount.add(ctl_ingredient_row[i][1].text);

                  final index = this.widget.dataIngredient.indexWhere(
                      (element) =>
                          element.ingredientName ==
                          ctl_ingredient_row[i][0].text);
                  if (index > -1) {
                    ingredients_ID
                        .add(this.widget.dataIngredient[index].ingredientsId);
                  } else {
                    ingredients_ID.add(null);
                  }
                  ingredientName_step.add((i + 1).toString());
                }

                ///////////////////////////////////////////////////////////////////////////////////

                //how to
                List<int> howto_ID = [];
                List<String> description_howto = [];
                List<String> path_file = [];
                List<String> type_file = [];
                List<String> howto_step = [];

                for (var i = 0; i < ctl_howto_row.length; i++) {
                  if (ctl_howto_row[i].text == "") {
                    text += "\nกรุณกรอกวิธีทำ";
                    break;
                  }
                  if (imageHowto[i].toString() == File('').toString()) {
                    text += "\nกรุณเพิ่มรูปภาพวิธีทำ";
                    break;
                  }

                  final index = this.widget.dataHowto.indexWhere((element) =>
                      element.description == ctl_howto_row[i].text);

                  if (index > -1) {
                    howto_ID.add(this.widget.dataHowto[index].howtoId);
                  } else {
                    howto_ID.add(null);
                  }

                  description_howto.add(ctl_howto_row[i].text);

                  if (imageHowto[i].path.substring(0, 4) != "http") {
                    UploadHowtoFileModels imageData =
                        await addloadHowtoFiles(imageHowto[i]);
                    path_file.add(imageData.path);
                  } else {
                    path_file.add(imageHowto[i].path);
                  }

                  type_file
                      .add(lookupMimeType(imageHowto[i].path).split("/")[0]);

                  howto_step.add((i + 1).toString());
                }

                if (text != "") {
                  showdialogPost(context, text);
                  check = false;
                }
                if (check) {
                  showdialog(context);
                  await editRecipePost_Fuc(
                      recipe_name,
                      image,
                      price,
                      suitable_for,
                      take_time,
                      food_category,
                      description,
                      this.widget.uid,
                      this.widget.rid);
                  await editIngredient_Fuc(this.widget.rid, ingredientName,
                      ingredients_ID, amount, ingredientName_step);
                  await editHowto_Fuc(this.widget.rid, howto_ID,
                      description_howto, path_file, type_file, howto_step);
                  Navigator.pop(context);
                  Navigator.pop(context);
                }

                // //วิธีทำ
                // int checkCtl_howto_row = 0, checkimageHowto = 0;
                // for (int i = 0; i < howto.length; i++) {
                //   if (ctl_howto_row[i].text == "" && checkCtl_howto_row == 0) {
                //     print("กรุณกรอกวิธีทำ");
                //     checkCtl_howto_row = 1;
                //   }
                //   if (imageHowto[i].toString() == File('').toString() &&
                //       checkimageHowto == 0) {
                //     print("และรูปภาพวิธีทำ");
                //     checkimageHowto = 1;
                //   }

                //   if (checkCtl_howto_row == 1 && checkimageHowto == 1) {
                //     break;
                //   }
                // }
              },
              child: Text('แก้ไข'),
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
                (addImage.length == 0 && _imageFood == null)
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
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                          ),
                        ),
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
                        padding: new EdgeInsets.only(right: 10, bottom: 8.0),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: (_imageFood != null)
                                ? NetworkImage(_imageFood)
                                : FileImage(addImage[0].image),
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
                          children: [
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
                                    if (_imageFood != null) {
                                      _imageFood = null;
                                    } else {
                                      addImage.removeAt(0);
                                    }
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
                                                if (_imageFood != null) {
                                                  _imageFood = null;
                                                } else {
                                                  addImage.removeAt(0);
                                                }

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
                        ),
                      ),
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
                    style: TextStyle(color: Colors.black, fontSize: 20),
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
                      hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
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
                          children: priceWidgets.toList(),
                        ),
                      ),
                    ),
                  ],
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
                FractionallySizedBox(
                  widthFactor: 1,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: () {
                      setState(() {
                        ingredient_row++;
                      });
                    },
                    child: Text('เพิ่ม ส่วนผสม'),
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
    super.initState();
    findUser();

    _selectPeoples = this.widget.suitableFor;
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

    _selectTimes = this.widget.takeTime;
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

    _selectCategorys = this.widget.foodCategory;
    _categorys = <Category>[
      const Category('ไม่ระบุ'),
      const Category('เมนูน้ำ'),
      const Category('เมนูต้ม'),
      const Category('เมนูสุขภาพ'),
      const Category('เมนูนึ่ง'),
      const Category('เมนูตุ่น'),
      const Category('เมนูทอด'),
    ];

    // _selectPrices = "ฟรี";

    _prices = <Price>[
      Price('ฟรี'),
      Price('ระบุราคา'),
    ];
    if (this.widget.price != "0") {
      _selectPrices = this.widget.price;
      _prices[1] = Price('${this.widget.price}');
    } else {
      _selectPrices = "ฟรี";
    }
  }

  String token = ""; //โทเคน
  //ดึง token
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
                color: (_selectPeoples == people.name)
                    ? Colors.white
                    : Colors.black),
          ),
          selected: _selectPeoples == people.name,
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
                color:
                    (_selectTimes == time.name) ? Colors.white : Colors.black),
          ),
          selected: _selectTimes == time.name,
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
                color: (_selectCategorys == category.name)
                    ? Colors.white
                    : Colors.black),
          ),
          selected: _selectCategorys == category.name,
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

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;

  CustomDialog({this.title, this.description, this.buttonText, this.image});
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "อยู่หน้านี้ต่อ",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("ออกไปหน้าอื่น"),
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
            backgroundImage: NetworkImage(
                'https://media.giphy.com/media/Q81NcsY6YxK7jxnr4v/giphy.gif'),
          ),
        )
      ],
    );
  }
}
