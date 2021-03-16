// import 'dart:html';
// import 'dart:html';
import 'dart:io';

// import 'package:dio/dio.dart';
import 'package:easy_cook/class/addFood_addImage_class.dart';
import 'package:easy_cook/class/token_class.dart';
import 'package:easy_cook/database/db_service.dart';
import 'package:easy_cook/models/register2_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


import 'addFood_addImage.dart';

class RegisterPage2 extends StatefulWidget {
  RegisterPage2({Key key}) : super(key: key);

  @override
  _RegisterPage2State createState() => _RegisterPage2State();
}

String token = "";

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


Future<Register2Model> registers(String tokens, File profile_image) async {
  // final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signin";
  final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signupNewStep1";

  

  // final response = await http
  //     .post(Uri.parse(apiUrl), body: map);
    
  // print(response.statusCode);

  // var request = http.MultipartRequest('POST',Uri.parse(apiUrl));

  Map<String, dynamic> requestBody = <String,dynamic>{
     'token':tokens,
    'profile_image' : profile_image
  };

  // Map<String, File> requestBody2 = <String,File>{
     
  // };

 

  
  


  // FormData formData = new FormData.from({
  //   "token": tokens,
  //  "profile_image": profile_image
  // });


  
  // final response = await http.post(Url.p, data: formData);
  // final response = await http
  //     .post(Uri.parse(apiUrl), body: );

  // print(response.statusCode);
  // if (response.statusCode == 200) {
  //   final String responseString = response.body;

  //   return register2ModelFromJson(responseString);
  // } else {
  //   return null;
  // }

  // dio.post(apiUrl,data: )
  // FormData formData = new FormData.from(
  //   "token": tokens,
  //   "profile_image": profile_image,
  // );
  

// FormData formData = new FormData.from({
//    "token": tokens,
//    "profile_image": profile_image
// });

//   response = await dio.post()
  
  

  // if (response.statusCode == 200) {
  //   final String responseString = response.body;

  //   return register2ModelFromJson(responseString);
  // } else {
  //   return null;
  // }
}

class _RegisterPage2State extends State<RegisterPage2> {
  List<AddImage> addImage = List<AddImage>();

  _RegisterPage2State(){
    // getToken();
    print("token = " + token);
  }

  Widget _buildAddPicturetBtn() {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 0.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          print("length = " + addImage.length.toString());
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new AddFood_AddImagePage()),
          ).then((value) {
            if (value != null) {
              print(value);
              addImage.add(value);
              setState(() {});
            }
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
            fontFamily: 'OpenSans',
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
          print("length = " + addImage.length.toString());
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new AddFood_AddImagePage()),
          ).then((value) {
            if (value != null) {
              print(value);
              addImage[0].image = value.image;
              setState(() {});
            }
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
            fontFamily: 'OpenSans',
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
            fontFamily: 'OpenSans',
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
        final Register2Model response =  await registers(token,addImage[0].image);
        // print(response.success);

          print(token);
          print("ถัดไป");
          print(addImage[0].image);
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
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
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
                      Colors.blueGrey,
                      Colors.blueAccent,
                      Colors.blueGrey,
                      Colors.blue,
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
                          fontFamily: 'OpenSans',
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
