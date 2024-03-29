// import 'dart:html';
// import 'dart:html';
import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:dio/dio.dart';
import 'package:easy_cook/class/addFood_addImage_class.dart';


import 'package:easy_cook/models/register/register2_model.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage2 extends StatefulWidget {
  RegisterPage2({Key key}) : super(key: key);

  @override
  _RegisterPage2State createState() => _RegisterPage2State();
}

// Future<String> getToken() async {
//   var service = DBService();
//   var body = await service.readData();
//   body.forEach((token) {
//     // setState(() {
//       var tokenModel = Token_jwt();
//       print(token['id']);
//       print(token['token']);
//     // });
//   });
//   // return token['token'];
//   // return token[0]['token'];
//   token = body[0]['token'];
// }

Future<Register2Model> registers2(String tokens, File profile_image) async {
  // final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signin";
  final String apiUrl =
      "http://apifood.comsciproject.com/pjUsers/signupNewStep2";

  final mimeTypeData =
      lookupMimeType(profile_image.path, headerBytes: [0xFF, 0xD8]).split('/');

  final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(apiUrl));

  final file = await http.MultipartFile.fromPath(
      'profile_image', profile_image.path,
      contentType: new MediaType(mimeTypeData[0], mimeTypeData[1]));
  imageUploadRequest.files.add(file);
  imageUploadRequest.fields['token'] = tokens;

  var streamedResponse = await imageUploadRequest.send();
  var response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 200) {
    final String responseString = response.body;

    return register2ModelFromJson(responseString);
  } else {
    return null;
  }
}

// Future<String> tokens() async {
//   token = await Token_jwt().getTokens();
// }
showdialog(context) {
  return showDialog(
      context: context,
      builder: (contex) {
        return AlertDialog(
            content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("กรุณารอสักครู่...   "), CircularProgressIndicator()],
        ));
      });
}

class _RegisterPage2State extends State<RegisterPage2> {
  String token = "";

  List<AddImage> addImage = [];
  @override
  void initState() {
    super.initState();
    findToken();
  }

  Future<Null> findToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
    });
    // token = await Token_jwt().getTokens();
    // setState(() {});
  }
  // _RegisterPage2State() {
  //   tokens();
  //   print("token = " + token);
  // }

  Widget _buildAddPicturetBtn() {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 0.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          // print("length = " + addImage.length.toString());--------------------------------------------------------------------------------------
          // Navigator.push(
          //   context,
          //   new MaterialPageRoute(builder: (context) => new AddImagePage()),
          // ).then((value) {
          //   if (value != null) {
          //     print(value);
          //     addImage.add(value);
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
                      leading:
                          new Icon(Icons.photo_camera_back, color: Colors.blue),
                      title: new Text('รูปภาพในมือถือ'),
                      onTap: () async {
                        Navigator.pop(context);
                        pickCropImage();
                      },
                    ),
                    ListTile(
                      leading: new Icon(Icons.camera_alt_outlined,
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
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color(0xFF73AEF5),
        child: Text(
          'เพิ่มรูปภาพ',
          style: TextStyle(
            color: Colors.red[50],
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            // fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildchangePicturetBtn() {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 0.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          // print("length = " + addImage.length.toString());--------------------------------------------------------------------------------------
          // Navigator.push(
          //   context,
          //   new MaterialPageRoute(builder: (context) => new AddImagePage()),
          // ).then((value) {
          //   if (value != null) {
          //     print(value);
          //     addImage[0].image = value.image;
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
                      leading:
                          new Icon(Icons.photo_camera_back, color: Colors.blue),
                      title: new Text('รูปภาพในมือถือ'),
                      onTap: () async {
                        Navigator.pop(context);
                        pickCropImage();
                      },
                    ),
                    ListTile(
                      leading: new Icon(Icons.camera_alt_outlined,
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
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color(0xFF73AEF5),
        child: Text(
          'เปลี่ยนรูปภาพ',
          style: TextStyle(
            color: Colors.red[50],
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            // fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSkipBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          showdialog(context);
          Navigator.pushNamed(context, '/register3-page');
          print("ข้าม");
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.blueGrey[300],
        child: Text(
          'ข้าม',
          style: TextStyle(
            color: Colors.red[50],
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            // fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildNextBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          showdialog(context);
          // final Register2Model response =  await registers(token,addImage[0].image);
          final Register2Model response =
              await registers2(token, addImage[0].image);

          if (response.success == 1) {
            print(token);
            print("ถัดไป");
            print(addImage[0].image);
            // Navigator.pushNamed(context, '/register3-page');
            Navigator.pushNamedAndRemoveUntil(
                context, '/register3-page', (Route<dynamic> route) => false);
          } else {
            print("error");
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.blueGrey[300],
        child: Text(
          'ถัดไป',
          style: TextStyle(
            color: Colors.red[50],
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            // fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
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
      cropStyle: CropStyle.circle,
        // aspectRatio: CropAspectRatio(ratioX: 10, ratioY: 9),
        sourcePath: imageFile.path,
        // // aspectRatioPresets: [
        // //   CropAspectRatioPreset.square,
        // //   CropAspectRatioPreset.ratio3x2,
        // //   CropAspectRatioPreset.original,
        // //   CropAspectRatioPreset.ratio4x3,
        // //   CropAspectRatioPreset.ratio16x9
        // // ],
        // androidUiSettings: AndroidUiSettings(
        //   toolbarTitle: 'Crop',
        //   toolbarColor: Color(0xffc69f50),
        //   toolbarWidgetColor: Colors.white,
        //   initAspectRatio: CropAspectRatioPreset.original,
        //   lockAspectRatio: true,
        //   // hideBottomControls: true,
        // )
        );
    if (croppedFile != null) {
      setState(() {
        imageFile = croppedFile;
        AddImage addImageModels = new AddImage(File(imageFile.path));

        this.addImage = [];
        this.addImage.add(addImageModels);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blueAccent,
                      Colors.blueAccent,
                      Colors.blueAccent,
                      Colors.blueAccent,
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'เพิ่มรูปโปรไฟล์',
                        style: TextStyle(
                          color: Colors.white,
                          // fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 60.0),
                      (addImage.length == 0)
                          ? CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                  "https://image.flaticon.com/icons/png/128/817/817382.png"),
                            )
                          : ClipOval(
                              child: Image.file(
                              addImage[0].image,
                              fit: BoxFit.cover,
                              width: 140.0,
                              height: 140.0,
                            )),
                      SizedBox(height: 60.0),
                      (addImage.length == 0)
                          ? (_buildAddPicturetBtn())
                          : (_buildchangePicturetBtn()),
                      (addImage.length == 0)
                          ? (_buildSkipBtn())
                          : (_buildNextBtn()),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
