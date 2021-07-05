// import 'dart:html';
import 'dart:io';

import 'package:easy_cook/class/addFood_addImage_class.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:flutter/material.dart';

import '../addFood_page/addImage.dart';

class EditProfilePage extends StatefulWidget {
  // EditProfilePage({Key key}) : super(key: key);

  DataAc data_DataAc;
  EditProfilePage(this.data_DataAc);

  @override
  _EditProfilePageState createState() =>
      _EditProfilePageState(this.data_DataAc);
}

class _EditProfilePageState extends State<EditProfilePage> {
  DataAc _data_DataAc;
  _EditProfilePageState(DataAc data_DataAc) {
    // this._data_DataAc = data_DataAc;
    _data_DataAc = data_DataAc;
    _imageProfile = data_DataAc.profileImage;
    ctrl_name1.text = data_DataAc.aliasName;
    ctrl_name2.text = data_DataAc.nameSurname;
  }

  String _imageProfile;
  TextEditingController ctrl_name1 = TextEditingController();
  TextEditingController ctrl_name2 = TextEditingController();

  bool isObscurePassword = true; //password

  List<AddImage> addImageProfile = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            if (_imageProfile != "" &&
                _data_DataAc.aliasName == ctrl_name1.text &&
                _data_DataAc.nameSurname == ctrl_name2.text) {
              Navigator.pop(context);
            } else {
              showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                        title: "ยังไม่ได้บันทึกการเปลี่ยนแปลง",
                        description:
                            "คุณมีการเปลี่ยนแปลงที่ยังไม่ได้บันทึก แน่ใจไหมว่าต้องการยกเลิก",
                      ));
            }
          },
        ),
        title: Text('แก้ไขโปรไฟล์'),
        actions: [
          IconButton(
            onPressed: () {
              print(ctrl_name1.text);
              print(ctrl_name2.text);
            },
            icon: Icon(
              Icons.done,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                            )
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: (_imageProfile != "")
                                ? NetworkImage(this._imageProfile)
                                : FileImage(addImageProfile[0].image),
                          )),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.white),
                            color: Colors.blue,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new AddImagePage()),
                              ).then((value) {
                                if (value != null) {
                                  print(value);
                                  this.addImageProfile = [];
                                  this.addImageProfile.add(value);
                                  this._imageProfile = "";
                                  setState(() {});
                                }
                              });
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                          // child: Icon(
                          //   Icons.edit,
                          //   color: Colors.white,
                          // ),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              buildTextField("ชื่อนามแฝง", "เซฟปก", false, ctrl_name1),
              buildTextField("ชื่อ-นามสุกล", "เซฟปก", false, ctrl_name2),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder,
      bool isPasswordTextFiele, TextEditingController textCTL) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: textCTL,
        obscureText: isPasswordTextFiele ? isObscurePassword : false,
        decoration: InputDecoration(
            suffix: isPasswordTextFiele
                ? IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }
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
                      "ไม่ใช่",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("ใช่"),
                  ),
                ],
              ),
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: FlatButton(
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //     child: Text("ไม่ใช่"),
              //   ),
              // ),
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: FlatButton(
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //     child: Text("ใช่"),
              //   ),
              // )
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
