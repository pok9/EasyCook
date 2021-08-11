import 'dart:convert';
import 'dart:io';

import 'package:easy_cook/class/addFood_addImage_class.dart';
import 'package:easy_cook/models/report/addReport_model.dart';
import 'package:easy_cook/models/report/addreportImage_model.dart';
import 'package:easy_cook/models/showfood/showfood_model.dart';
import 'package:easy_cook/pages/addFood_page/addImage.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';

class ReportFood extends StatefulWidget {
  // const ReportFood({ Key? key }) : super(key: key);

  //ข้อมูลสูตรอาหารที่ค้นหา
  ShowFoods dataFood;

  ReportFood({this.dataFood});

  @override
  _ReportFoodState createState() => _ReportFoodState();
}

class _ReportFoodState extends State<ReportFood> {
  @override
  void initState() {
    super.initState();
    findUser();
  }

  String token = ""; //โทเคน
  //ดึง token
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
    });
  }

  List<Exercise> exercises = [
    Exercise(name: 'ละเมิดสิทธิ์ของฉัน'),
    Exercise(name: 'อื่นๆ'),
  ];
  int _selected;

  bool isSelect = false;

  AddImage image;

  TextEditingController otherCtl = new TextEditingController();


  //อัปโหลดรูปภาพ
  Future<String> addreportImage(File image) async {
    // final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signin";
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/addreportImage";

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
      return addReportImageModelFromJson(responseString).path;
    } else {
      return null;
    }
  }
  

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

    print(jsonEncode(data));
    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final String responseString = response.body;

      return addReportFromJson(responseString);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("รายงานสูตรอาหาร"),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      actions: <Widget>[
        TextButton(
          child: const Text('ยกเลิก'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        (isSelect)
            ? (_selected == 1 && (otherCtl.text == "" && image == null))
                ? Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      'รายงาน',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : TextButton(
                    child: const Text(
                      'รายงาน',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () async {

                      String description;
                      String path = "";

                      if (image != null) {
                        path = await addreportImage(this.image.image);
                      }
                      
                      
                      
                      
                      
                      
                      // print(path);

                      // print("userTarget_ID => ${this.widget.dataFood.userId}");
                      // print("type_report => recipe");
                      // print("recipe_ID => ${this.widget.dataFood.rid}");
                      // print("title => รายงานสูตรอาหาร");

                      if (_selected != 1) {
                        print("description => ${exercises[_selected].name}");
                        description = exercises[_selected].name;
                      } else if (otherCtl.text != "" && otherCtl != null) {
                        print("description => ${otherCtl.text}");
                        description = otherCtl.text;
                      } else {
                        // print("description => $description");
                        // description =
                      }
                      print(path);


                      List<String> arrValue = []; 

                      arrValue.add(exercises[_selected].name);
                      arrValue.add(path);

                      Navigator.pop(context,arrValue);

                      // AddReport dataAddReport = await addReport(
                      //     this.widget.dataFood.userId.toString(),
                      //     "food",
                      //     this.widget.dataFood.rid.toString(),
                      //     "รายงานสูตรอาหาร",
                      //     description,
                      //     path);

                      // Navigator.of(context).pop(true);
                      // String reportText1;
                      // String reportText2;
                      // Color color;

                      // if (dataAddReport.success == 1) {
                      //   reportText1 = "รายงานสำเร็จ";
                      //   reportText2 = "ขอบคุณสำหรับการรายงาน";
                      //   color = Colors.green;
                      // } else {
                      //   reportText1 = "รายงานไม่สำเร็จ";
                      //   reportText2 = "โปรดรายงานใหม่ในภายหลัง";
                      //   color = Colors.red;
                      // }
                      // showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       Future.delayed(Duration(milliseconds: 1500), () {
                      //         Navigator.of(context).pop(true);
                      //         Navigator.of(context).pop(true);
                      //         // Navigator.pop(context);
                      //       });
                      //       return alertDialog_successful_or_unsuccessful(
                      //           reportText1, color, reportText2);
                      //     });

                      // Navigator.pop(context);
                    },
                  )
            : Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  'รายงาน',
                  style: TextStyle(color: Colors.grey),
                ),
              )
      ],
      content: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: exercises.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RadioListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          title: Text(exercises[index].name),
                          value: index,
                          groupValue: _selected,
                          onChanged: (value) {
                            setState(() {
                              isSelect = true;
                              _selected = index;
                            });
                          });
                    }),
              ),
              (_selected != 1)
                  ? Container()
                  : TextFormField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: otherCtl,
                      autofocus: false,
                      maxLines: 1,
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.multiline,
                      decoration: new InputDecoration(
                        filled: true,
                        fillColor: Color(0xfff3f3f4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "โปรดระบุ",
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    (image == null)
                        ? Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey.shade200,
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
                                            new AddImagePage()),
                                  ).then((value) {
                                    if (value != null) {
                                      image = value;
                                      setState(() {});
                                    }
                                  });
                                }),
                          )
                        : Container(
                            height: 100,
                            width: 100,
                            child: Image.file(image.image),
                          ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              ' หากเป็นเจ้าของลิขสิทธิ์สูตรอาหารนี้และเชื่อว่ามีการโพสสูตรอาหารที่คุณไม่ได้รับอนุญาต โปรดดำเนินการตาม ',
                          style: TextStyle(fontSize: 14)),
                      TextSpan(
                          text: 'คำแนะนำเหล่านี้',
                          style: TextStyle(fontSize: 14, color: Colors.blue)),
                      TextSpan(
                          text: ' เพื่อส่งการแจ้งเตื่อนการละเมิดลิขสิทธิ์ ',
                          style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
}

class Exercise {
  String name;
  Exercise({this.name});
}
