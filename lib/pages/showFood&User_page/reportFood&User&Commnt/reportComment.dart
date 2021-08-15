import 'dart:io';

import 'package:easy_cook/class/addFood_addImage_class.dart';
import 'package:easy_cook/models/report/addReport/addreportImage_model.dart';
import 'package:easy_cook/pages/addFood_page/addImage.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ReportComment extends StatefulWidget {
  @override
  _ReportCommentState createState() => _ReportCommentState();
}

class _ReportCommentState extends State<ReportComment> {
  List<Exercise> exercises = [
    Exercise(name: 'การคุกคาม'),
    Exercise(name: 'การกลั่นแกล้ง'),
    Exercise(name: 'คำพูดแสดงความเกลียดชัง'),
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

  @override
  Widget build(BuildContext context) {
    
    return AlertDialog(
      title: Text("รายงานผู้ใช้"),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      actions: <Widget>[
        TextButton(
          child: const Text('ยกเลิก'),
          onPressed: () {
            Navigator.pop(context);
             Navigator.pop(context);
          },
        ),
        (isSelect)
            ? (_selected == exercises.length - 1 &&
                    (otherCtl.text == "" && image == null))
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
                      String description = "";
                      String path = "";

                      if (image != null) {
                        path = await addreportImage(this.image.image);
                      }

                      if (_selected != exercises.length - 1) {
                        print("description => ${exercises[_selected].name}");
                        description = exercises[_selected].name;
                      } else if (otherCtl.text != "" && otherCtl != null) {
                        print("description => ${otherCtl.text}");
                        description = otherCtl.text;
                      }
                      print(path);

                      List<String> arrValue = [];

                      arrValue.add(description);
                      arrValue.add(path);

                      Navigator.pop(context, arrValue);
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
              (_selected != exercises.length - 1)
                  ? Container()
                  : TextFormField(
                      controller: otherCtl,
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
                        hintText: "โปรดระบุ",
                        hintStyle: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
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
              // Padding(
              //   padding: const EdgeInsets.only(top: 8),
              //   child: Text.rich(
              //     TextSpan(
              //       children: <TextSpan>[
              //         TextSpan(
              //             text:
              //                 ' หากเป็นเจ้าของลิขสิทธิ์สูตรอาหารนี้และเชื่อว่ามีการโพสสูตรอาหารที่คุณไม่ได้รับอนุญาต โปรดดำเนินการตาม ',
              //             style: TextStyle(fontSize: 14)),
              //         TextSpan(
              //             text: 'คำแนะนำเหล่านี้',
              //             style: TextStyle(fontSize: 14, color: Colors.blue)),
              //         TextSpan(
              //             text: ' เพื่อส่งการแจ้งเตื่อนการละเมิดลิขสิทธิ์ ',
              //             style: TextStyle(fontSize: 14)),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class Exercise {
  String name;
  Exercise({this.name});
}
