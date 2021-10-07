import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easy_cook/models/topup&withdraw/topup/topupQRcodeModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
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
    var data = {"amount": this.widget.amount_to_fill};

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
      downloadFile(filename, imgUrl);
      
      // responseImgUrl = await http.get(Uri.parse("https://unsplash.com/photos/iEJVyyevw-U/download?force=true"));

      // print(responseImgUrl.body);

      // downloadFile("myimage.jpg",
      //     "https://unsplash.com/photos/iEJVyyevw-U/download?force=true");

      // downloadFile(filename, imgUrl);
      // print(imgUrl);
    } else {
      return null;
    }
  }

  File imageFile;

  String QRimage1, QRimage2, QRimage3, QRimage4;
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

    downloading = false;
    progressString = "Completed";
    imageFile = File("${dir.path}/${filename}");
   
    imageFile.readAsString().then((String contents) {
      // print(contents);

      int indexBase64 = contents.indexOf('base64,');
      print('indexBase64, = $indexBase64');
      int indexBase64End = contents.indexOf('/>', indexBase64);
      print('indexBase64End, = $indexBase64End');
      QRimage1 = contents.substring(indexBase64 + 7, indexBase64End - 2);

      indexBase64 = contents.indexOf('base64,', indexBase64End);
      print('indexBase64, = $indexBase64');
      indexBase64End = contents.indexOf('/>', indexBase64);
      print('indexBase64End, = $indexBase64End');
      QRimage2 = contents.substring(indexBase64 + 7, indexBase64End - 2);

      indexBase64 = contents.indexOf('base64,', indexBase64End);
      print('indexBase64, = $indexBase64');
      indexBase64End = contents.indexOf('/>', indexBase64);
      print('indexBase64End, = $indexBase64End');
      QRimage3 = contents.substring(indexBase64 + 7, indexBase64End - 2);
      QRimage3 = QRimage3.replaceAll("&#43;", "+");

      indexBase64 = contents.indexOf('base64,', indexBase64End);
      print('indexBase64, = $indexBase64');
      indexBase64End = contents.indexOf('/>', indexBase64);
      print('indexBase64End, = $indexBase64End');
      QRimage4 = contents.substring(indexBase64 + 7, indexBase64End - 2);

      setState(() {});
    });

    // print(imageFile);

    print("Download completed");
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('QR เติมเงิน'),
        ),
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
                          "กำลังโหลดรูปภาพ $progressString",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              : (QRimage1 == null && QRimage2 == null)
                  ? Container()

                  // : ListView(children: [Text(subText)],)

                  : ListView(
                      children: [
                        DisplayPictureScreen(
                          imageAnalysed: QRimage1,
                          index: 1,
                        ),
                        DisplayPictureScreen(
                          imageAnalysed: QRimage2,
                          index: 2,
                        ),
                        DisplayPictureScreen(
                          imageAnalysed: QRimage3,
                          index: 3,
                        ),
                        // RaisedButton(onPressed: () {
                        //   _save();
                        // })
                        Container(
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _save();
                              },
                              label: Text('ดาวน์โหลด QR Code'),
                              icon: Icon(Icons.download),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                              ),
                            )),
                        Container(
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            child: ElevatedButton.icon(
                              onPressed:  () => _onShare(context),
                              // {
                              //   // Share.share("test");
                              //   // print(QRimage3);
                              //   // Share.shareFiles(
                              //   //   ['assets/logoSearch/baked.png'],
                              //   //   text: "QR Code",
                                  
                              //   // );
                              //   Share.shareFiles(['${directory.path}/image.jpg'], text: 'QR Code');
                              // },
                              label: Text('แชร์'),
                              icon: Icon(Icons.share),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                              ),
                            )),
                      ],
                    ),
        ));
  }
  
  _onShare(BuildContext context) async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
    final RenderBox box = context.findRenderObject() as RenderBox;
    final directory = await getApplicationDocumentsDirectory();
     await Share.shareFiles(['${directory.path}/testImage3.jpg'],
          text: "QR Code",

          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  _save() async {
    final directory = await getApplicationDocumentsDirectory();
    File fileImg = File('${directory.path}/testImage3.jpg');

    Uint8List bytes = fileImg.readAsBytesSync();

    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(bytes),
        quality: 60, name: "QrCode_${DateTime.now().millisecondsSinceEpoch}");
    print(result);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("ดาวน์โหลด QR Code เสร็จแล้ว"),
    ));
  }
}

class DisplayPictureScreen extends StatefulWidget {
  final String imageAnalysed;
  final int index;
  const DisplayPictureScreen({Key key, this.imageAnalysed, this.index})
      : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  File fileImg;
  bool isLoading = true;

  void writeFile() async {
    final decodedBytes = base64Decode(widget.imageAnalysed);
    final directory = await getApplicationDocumentsDirectory();
    fileImg = File('${directory.path}/testImage${this.widget.index}.jpg');
    print(fileImg.path);
    fileImg.writeAsBytesSync(List.from(decodedBytes));

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      writeFile();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : (this.widget.index == 2)
            ? Container(
                width: sizeScreen.width, height: 75, child: Image.file(fileImg))
            : Padding(
                padding: (this.widget.index == 1)
                    ? const EdgeInsets.fromLTRB(8, 8, 8, 0)
                    : const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Image.file(fileImg),
              );
  }
}
