import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easy_cook/models/topup&withdraw/topup/topupQRcodeModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TopupQRcodePage extends StatefulWidget {
  double amount_to_fill;
  TopupQRcodePage({this.amount_to_fill});

  @override
  _TopupQRcodePageState createState() => _TopupQRcodePageState();
}

class _TopupQRcodePageState extends State<TopupQRcodePage> {
  bool downloading = false;
  var progressString = "";

  @override
  void initState() {
    super.initState();
    findUser();
  }

  String token = ""; //โทเคน
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
      if (token != "" && token != null) {
        topupQr(this.widget.amount_to_fill);
      }
    });
  }

  // var responseImgUrl;

  Future<Null> topupQr(double amount) async {
    final String apiUrl = "https://apifood.comsciproject.com/pjUsers/topup_qr";

    // List<st>
    var data = {"amount": 50};

    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    if (response.statusCode == 200) {
      final String responseString = response.body;
      TopupQrModel dataTopupQrModel = topupQrModelFromJson(responseString);
      String filename = dataTopupQrModel.filename;
      String imgUrl = dataTopupQrModel.qrCode;
      // print("imgUrl => ${imgUrl}");
      // downloadFile(filename, imgUrl);
      // responseImgUrl = await http.get(Uri.parse("https://unsplash.com/photos/iEJVyyevw-U/download?force=true"));
      
      // print(responseImgUrl.body);
    

      downloadFile("myimage.jpg",
          "https://unsplash.com/photos/iEJVyyevw-U/download?force=true");

      // downloadFile(filename, imgUrl);
      print(imgUrl);
    } else {
      return null;
    }
  }

  File imageFile;

  Future<void> downloadFile(String filename, String imgUrl) async {
    Dio dio = Dio();
    var dir = await getApplicationDocumentsDirectory();
    try {
      // print("dir.path => ${dir.path}/");
      await dio.download(imgUrl, "${dir.path}/${filename}",
          onReceiveProgress: (rec, total) {
        // print("Rec: $rec , Total: $total");

        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
      imageFile = File("${dir.path}/${filename}");

      print(imageFile.runtimeType);
      print(imageFile.path);
    });

    print("Download completed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('QR เติมเงิน'),
        ),
        // body: (imageFile == null)
        //     ? Container()
        //     : SvgPicture.asset(
        //         "/data/user/0/com.example.easy_cook/app_flutter/qrcode_test.svg",
        //         placeholderBuilder: (BuildContext context) => Container(
        //             padding: const EdgeInsets.all(30.0),
        //             child: const CircularProgressIndicator()),
        //       ),
        body: Center(
          child: downloading
              ? Container(
                  height: 120.0,
                  width: 200,
                  child: Card(
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Downloading File $progressString",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              : (imageFile == null)
                  ? Container()
                  : Image.file((imageFile))
                  // : SvgPicture.file(
                  //     imageFile,
                  //     height: 50,
                  //     width: 50,
                  //     placeholderBuilder: (BuildContext context) => Container(
                  //         padding: const EdgeInsets.all(30.0),
                  //         child: Column(
                  //           children: [
                  //             Text(imageFile.path),
                  //             const CircularProgressIndicator(),
                  //           ],
                  //         )),
                  //   ),
          // : Container(child: Image.file(imageFile,fit: BoxFit.cover,))
          // : Text(responseImgUrl.body)
        ));
  }
}
