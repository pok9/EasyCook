// import 'dart:html';
import 'dart:convert';
import 'dart:io';

import 'package:easy_cook/class/addFood_addImage_class.dart';
import 'package:easy_cook/models/profile/editProfile/editName_model.dart';
import 'package:easy_cook/models/profile/editProfile/editProfile_model.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../addFood_page/addImage.dart';

class EditProfilePage extends StatefulWidget {
  // EditProfilePage({Key key}) : super(key: key);

  DataMyAccount data_DataAc;
  EditProfilePage(this.data_DataAc);

  @override
  _EditProfilePageState createState() =>
      _EditProfilePageState(this.data_DataAc);
}

class _EditProfilePageState extends State<EditProfilePage> {
  DataMyAccount _data_DataAc;
  _EditProfilePageState(DataMyAccount data_DataAc) {
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

  Future<EditProfile> editProfile(File image) async {
    // final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signin";
    final String apiUrl =
        "http://apifood.comsciproject.com/pjUsers/uploadProfile";

    var mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(apiUrl));

    final images = await http.MultipartFile.fromPath(
        'profile_image', image.path,
        contentType: new MediaType(mimeTypeData[0], mimeTypeData[1]));

    imageUploadRequest.files.add(images);
    imageUploadRequest.fields['token'] = token;

    var streamedResponse = await imageUploadRequest.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final String responseString = response.body;
      return editProfileFromJson(responseString);
    } else {
      return null;
    }
  }

  Future<EditName> editName(String name_surname, String alias_name) async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjUsers/editProfileName";

    var data = {"name_surname": name_surname, "alias_name": alias_name};
    print(data);
    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    print("respon = ${response.statusCode}");
    if (response.statusCode == 200) {
      final String responseString = response.body;
      print("responseString = ${responseString}");

      return editNameFromJson(responseString);
    } else {
      return null;
    }
  }

  final picker = ImagePicker();
  File imageFile;

  pickCropImage() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      PlatformFile file = result.files.first;

      imageFile = File(file.path);
      cropImage();
    } else {}
  }

  captureImage() async {
    var image = await picker.getImage(source: ImageSource.camera);

    if (image != null) {
      imageFile = File(image.path);
      cropImage();
    }
  }

  cropImage() async {
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

        this.addImageProfile = [];
        this.addImageProfile.add(addImageModels);
        this._imageProfile = "";
      });
    }
  }

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
            onPressed: () async {
              if (_data_DataAc.aliasName != ctrl_name1.text ||
                  _data_DataAc.nameSurname != ctrl_name2.text ||
                  _imageProfile == "") {
                if (_imageProfile == "") {
                  EditProfile editProfiles =
                      await editProfile(addImageProfile[0].image);
                }

                if (_data_DataAc.aliasName != ctrl_name1.text ||
                    _data_DataAc.nameSurname != ctrl_name2.text) {
                  EditName editNames =
                      await editName(ctrl_name2.text, ctrl_name1.text);
                }

                Navigator.pop(context);
              } else {
                Navigator.pop(context);
              }
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
                              // Navigator.push(
                              //   context,
                              //   new MaterialPageRoute(
                              //       builder: (context) => new AddImagePage()),
                              // ).then((value) {
                              //   if (value != null) {
                              //     print(value);
                              //     this.addImageProfile = [];
                              //     this.addImageProfile.add(value);
                              //     this._imageProfile = "";
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
                                              color: Colors.blue),
                                          title: new Text('รูปภาพในมือถือ'),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            pickCropImage();
                                          },
                                        ),
                                        ListTile(
                                          leading: new Icon(
                                              Icons.camera_alt_outlined,
                                              color: Colors.blue),
                                          title: new Text('ถ่ายรูปภาพ'),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            captureImage();
                                          },
                                        ),
                                      ],
                                    );
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
              buildTextField(
                  "ชื่อนามแฝง", _data_DataAc.aliasName, false, ctrl_name1),
              buildTextField(
                  "ชื่อ-นามสุกล", _data_DataAc.nameSurname, false, ctrl_name2),
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
