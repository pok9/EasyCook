import 'dart:convert';
// import 'dart:ffi';
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
import 'package:easy_cook/slidepage.dart';
import 'package:easy_cook/style/utiltties.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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

    var streamedResponse = await imageUploadRequest.send();

    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final String responseString = response.body;

      return createPostModelFromJson(responseString);
    } else {
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

    // List<st>
    var data = {
      "recipe_ID": recipe_ID,
      "ingredientName": ingredientName,
      "amount": amount,
      "step": step
    };

    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

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

    var data = {
      "recipe_ID": recipe_ID,
      "description": description,
      "step": step,
      "path_file": path_file,
      "type_file": type_file
    };

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

  TextEditingController _ctrlPrice = TextEditingController(); //ราคา

  TextEditingController _ctrlPriceCopy = TextEditingController();

  //########################################################################################################/

  List<List<double>> data = <List<double>>[];

  //*******************************************************************************************************/
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
        padding: const EdgeInsets.only(left: 10, bottom: 1, right: 10),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                setState(() {
                  ingredient_row--;
                  ctl_ingredient_row.remove(controller);
                  if (ctl_ingredient_row.length == 0) {
                    this.ingredient_row = 1;
                  }
                });
              },
            ),
          ],
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
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: "เช่น " +
                        exampleIngredient_row1[(displayNumber - 1) % 6],
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
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10),
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
              // IconButton(
              //   icon: Icon(Icons.clear),
              //   onPressed: () {
              //     setState(() {
              //       ingredient_row--;
              //       ctl_ingredient_row.remove(controller);
              //       if (ctl_ingredient_row.length == 0) {
              //         this.ingredient_row = 1;
              //       }
              //     });
              //   },
              // )
            ],
          ),
        ),
      );
    }).toList(); // แปลงเป็นlist
  }
  //########################################################################################################/

  //*******************************************************************************************************/

  List<String> exampleHowto_row = [
    "เริ่มจากเตรียมหมักหมู เตรียมเครื่องหมัก โดยผสม กะปิ น้ำตาลปึก น้ำมันหอย และ น้ำปลา ผสมให้ละลายเข้ากัน จากนั้นนำเครื่องหมักไปคลุกกับหมูสามชั้นที่เตรียมเอาไว้ หมักในตู้เย็น 1 คืน",
    "ตั้งกระทะน้ำมัน ความร้อนอ่อน ใส่ ใบมะกรูดลงไปทอด ให้กรอบ และ นำมาพักให้เย็น จากนั้นพริกแห้งลงไปทอดในน้ำมันเดียวกัน ด้วยไฟอ่อนๆ ให้สุกกรอบ และ ก็นำมาพักเช้นกัน",
    "เร่งไปปานกลาง นำหมูสามชั้นที่หมักลงไปทอด โดยทอดให้สุกประมาณ 60 % ให้นำขึ้นมาพักให้เย็น",
    "เปลี่ยนน้ำมันใหม่ เร่งไฟให้แรงและร้อน ใส่หมูลงไปทอด ให้เหลืองสุก นำขึ้มมาพักให้สะเด็ดน้ำมัน",
    "เพียงเท่านี้ก็เสร็จสิ้นหมูทอดกะปิ แสนอร่อย กินกับข้าวเหนียว"
  ];
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
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
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
                                      // Navigator.push(
                                      //   context,
                                      //   new MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           new AddImageOrViderPage()),
                                      // ).then((value) {
                                      //   if (value != null) {
                                      //     imageHowto[displayNumber - 1] =
                                      //         value.image;

                                      //     setState(() {});
                                      //   }
                                      // });

                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                ListTile(
                                                  leading: new Icon(
                                                    Icons.photo_camera_back,
                                                    color: Colors.blue,
                                                  ),
                                                  title: new Text(
                                                      'รูปภาพในมือถือ'),
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    pickCropImage(
                                                        imageHowto,
                                                        "addPictueHowto",
                                                        displayNumber - 1);
                                                  },
                                                ),
                                                ListTile(
                                                  leading: new Icon(
                                                      Icons.camera_alt_outlined,
                                                      color: Colors.blue),
                                                  title: new Text('ถ่ายรูปภาพ'),
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    captureImage(
                                                        imageHowto,
                                                        "addPictueHowto",
                                                        displayNumber - 1);
                                                  },
                                                ),
                                                ListTile(
                                                  leading: new Icon(
                                                      Icons
                                                          .video_collection_outlined,
                                                      color: Colors.blue),
                                                  title: new Text(
                                                      'เพิ่ม วิดีโอ จากคลัง'),
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    pickCropVideo(imageHowto,
                                                        displayNumber - 1);
                                                  },
                                                ),
                                                ListTile(
                                                  leading: new Icon(
                                                      Icons
                                                          .video_camera_back_outlined,
                                                      color: Colors.blue),
                                                  title: new Text('ถ่ายวิดีโอ'),
                                                  onTap: () async {
                                                    Navigator.pop(context);

                                                    captureVideo(imageHowto,
                                                        displayNumber - 1);
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    }),
                              ),
                            ))
                        : Container(),
                    // IconButton(
                    //   icon: Icon(Icons.clear),
                    //   onPressed: () {
                    //     howto_row--;
                    //     ctl_howto_row.remove(controller2);
                    //     imageHowto.remove(imageHowto[displayNumber - 1]);

                    //     if (ctl_howto_row.length == 0) {
                    //       howto_row = 1;
                    //     }

                    //     setState(() {});
                    //   },
                    // ),
                  ],
                ),
                (imageHowto[displayNumber - 1].toString() ==
                        File('').toString())
                    ? Container()
                    : Row(
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
                                                      // Navigator.push(
                                                      //   context,
                                                      //   new MaterialPageRoute(
                                                      //       builder: (context) =>
                                                      //           new AddImageOrViderPage()),
                                                      // ).then((value) {
                                                      //   if (value != null) {
                                                      //     setState(() {
                                                      //       imageHowto[
                                                      //           displayNumber -
                                                      //               1] = value
                                                      //           .image;
                                                      //     });
                                                      //   }
                                                      // });
                                                      showModalBottomSheet(
                                                          context: context,
                                                          builder: (context) {
                                                            return Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <
                                                                  Widget>[
                                                                ListTile(
                                                                  leading:
                                                                      new Icon(
                                                                    Icons.photo,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  title: new Text(
                                                                      'รูปภาพในมือถือ'),
                                                                  onTap:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);
                                                                    pickCropImage(
                                                                        imageHowto,
                                                                        "addPictueHowto",
                                                                        displayNumber -
                                                                            1);
                                                                  },
                                                                ),
                                                                ListTile(
                                                                  leading: new Icon(
                                                                      Icons
                                                                          .camera_alt_outlined,
                                                                      color: Colors
                                                                          .blue),
                                                                  title: new Text(
                                                                      'ถ่ายรูปภาพ'),
                                                                  onTap:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);
                                                                    captureImage(
                                                                        imageHowto,
                                                                        "addPictueHowto",
                                                                        displayNumber -
                                                                            1);
                                                                  },
                                                                ),
                                                              ],
                                                            );
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
                                            alignment: Alignment.center,
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

  final picker = ImagePicker();
  File imageFile;

  pickCropImage(var addImageModel, String mode, int index) async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      PlatformFile file = result.files.first;

      imageFile = File(file.path);
      cropImage(addImageModel, mode, index);
    } else {}
  }

  captureImage(var addImageModel, String mode, int index) async {
    var image = await picker.getImage(source: ImageSource.camera);

    if (image != null) {
      imageFile = File(image.path);
      cropImage(addImageModel, mode, index);
    }
  }

  cropImage(var addImageModel, String mode, int index) async {
    File croppedFile = await ImageCropper.cropImage(
        aspectRatio: CropAspectRatio(ratioX: 10, ratioY: 9),
        sourcePath: imageFile.path,
        // aspectRatioPresets: [
        //   CropAspectRatioPreset.square,
        //   CropAspectRatioPreset.ratio3x2,
        //   CropAspectRatioPreset.original,
        //   CropAspectRatioPreset.ratio4x3,
        //   CropAspectRatioPreset.ratio16x9
        // ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: Color(0xffc69f50),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
          // hideBottomControls: true,
        ));
    if (croppedFile != null) {
      setState(() {
        imageFile = croppedFile;
        AddImage addImageModels = new AddImage(File(imageFile.path));
        // Navigator.pop(context, addImage);

        setState(() {
          // // addImage.removeAt(0);
          // if(addImage.isEmpty){
          //   addImage.add(addImageModel);
          // }else{
          //   addImage[0] = addImageModel;
          // }

          print(mode);
          if (mode == "addPictue") {
            addImageModel.add(addImageModels);
          } else if (mode == "editPictue") {
            addImageModel[index] = addImageModels;
          }
          else if (mode == "addPictueHowto") {
            addImageModel[index] = addImageModels.image;
          }
        });
      });
    }
  }

  pickCropVideo(var addImageModel, int index) async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      PlatformFile file = result.files.first;

      AddImage addImage = new AddImage(File(file.path));
      addImageModel[index] = addImage.image;
    }

    setState(() {});
  }

  captureVideo(var addImageModel, int index) async {
    var image = await picker.getVideo(source: ImageSource.camera);

    AddImage addImage = new AddImage(File(image.path));
    addImageModel[index] = addImage.image;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    var screen = MediaQuery.of(context).size; //ขนาดของหน้าจอ

    final List<Widget> ingredient = _buildListingredient();

    final List<Widget> howto = _buildhowto();

    return Scaffold(
      backgroundColor: Color(0xFFf3f5f9),
      appBar: AppBar(
        title: Text('เขียนสูตรอาหาร'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (addImage.length != 0 ||
                _ctrlNameFood.text != "" ||
                _ctrlExplain.text != "" ||
                _ctrlPrice.text != "0.00" ||
                ctl_ingredient_row.length != 1 ||
                ctl_howto_row.length != 1 ||
                ctl_ingredient_row[0][0].text != "" ||
                ctl_ingredient_row[0][1].text != "" ||
                ctl_howto_row[0].text != "" ||
                imageHowto[0].path != "") {
              showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                        title: "ยังไม่ได้บันทึกการเปลี่ยนแปลง",
                        description:
                            "คุณมีการเปลี่ยนแปลงที่ยังไม่ได้บันทึก แน่ใจไหมว่าต้องการยกเลิก",
                      ));
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                String text = "";
                bool check = true;
                if (_ctrlNameFood.text.length == 0) {
                  check = false;
                  _validate = true;
                }
                //เช็ครูปภาพอาหาร
                if (addImage.length == 0) {
                  text += "กรุณาเพิ่มรูปภาพปกอาหาร";
                }

                if (_ctrlNameFood.text == "") {
                  text += "\nกรุณาเพิ่มชื่อเมนูอาหาร";
                }

                //เช็คส่วนผสม
                for (int i = 0; i < ctl_ingredient_row.length; i++) {
                  if (ctl_ingredient_row[i][0].text == "") {
                    text += "\nกรุณกรอกส่วนผสมให้ครบ";
                    break;
                  }
                }

                int checkCtl_howto_row = 0, checkimageHowto = 0;
                for (int i = 0; i < howto.length; i++) {
                  if (ctl_howto_row[i].text == "" && checkCtl_howto_row == 0) {
                    text += "\nกรุณกรอกวิธีทำ";
                    checkCtl_howto_row = 1;
                  }
                  if (imageHowto[i].toString() == File('').toString() &&
                      checkimageHowto == 0) {
                    text += "และรูปภาพวิธีทำ";
                    checkimageHowto = 1;
                  }

                  if (checkCtl_howto_row == 1 && checkimageHowto == 1) {
                    break;
                  }
                }

                if (text != "") {
                  showdialogPost(context, text);
                  check = false;
                }
                if (check) {
                  showdialog(context);

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
                    ingredientName_step.add((i + 1).toString());
                  }
                  // for (var i = 0; i < amount.length; i++) {
                  //   ingredientName_step.add((i + 1).toString());
                  // }

                  AddIngredientsArrayModel ingredientsData =
                      await addIngredients(postsData.recipeId.toString(),
                          ingredientName, amount, ingredientName_step, token);

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
                    // Navigator.pushNamedAndRemoveUntil(
                    //     context, '/slide-page', (route) => false);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => SlidePage()),
                        ModalRoute.withName('/'));
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
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            leading: new Icon(
                                                Icons.photo_camera_back,
                                                color: Colors.blue),
                                            title: new Text('รูปภาพในมือถือ'),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              pickCropImage(
                                                  addImage, "addPictue", 0);
                                            },
                                          ),
                                          ListTile(
                                            leading: new Icon(
                                                Icons.camera_alt_outlined,
                                                color: Colors.blue),
                                            title: new Text('ถ่ายรูปภาพ'),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              captureImage(
                                                  addImage, "addPictue", 0);
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                // Navigator.push(
                                //   context,
                                //   new MaterialPageRoute(
                                //       builder: (context) => new AddImagePage()),
                                // ).then((value) {
                                //   if (value != null) {
                                //     setState(() {
                                //       addImage.add(value);
                                //     });
                                //   }
                                // });
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
                                // Navigator.push(
                                //   context,
                                //   new MaterialPageRoute(
                                //       builder: (context) => new AddImagePage()),
                                // ).then((value) {
                                //   if (value != null) {
                                //     addImage.removeAt(0);
                                //     setState(() {
                                //       addImage.add(value);
                                //     });
                                //   }
                                // });

                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            leading: new Icon(
                                                Icons.photo_camera_back,
                                                color: Colors.blue),
                                            title: new Text('รูปภาพในมือถือ'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              pickCropImage(
                                                  addImage, "editPictue", 0);
                                            },
                                          ),
                                          ListTile(
                                            leading: new Icon(
                                                Icons.camera_alt_outlined,
                                                color: Colors.blue),
                                            title: new Text('ถ่ายรูปภาพ'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              captureImage(
                                                  addImage, "editPictue", 0);
                                              // captureImage();
                                            },
                                          ),
                                        ],
                                      );
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
                FractionallySizedBox(
                  widthFactor: 1,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: () {
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
      const Category('เมนูตุ๋น'),
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
                    labelText: '0.00',
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
