import 'dart:io';

import 'package:easy_cook/class/addFood_addImage_class.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class test3 extends StatefulWidget {
  // test3({Key? key}) : super(key: key);

  @override
  _test3State createState() => _test3State();
}

class _test3State extends State<test3> {
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
        AddImage addImage = new AddImage(File(imageFile.path));
        Navigator.pop(context, addImage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มรูป'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.add),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: Column(
        children: [
          FlatButton(
              onPressed: pickCropImage,
              minWidth: 200,
              color: Color(0xffc69f50),
              child: Text(
                'Pick&Crop',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )),
          GestureDetector(
            onTap: captureImage,
            child: Container(
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'ถ่ายรูปภาพ ',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              FilePickerResult result =
                  await FilePicker.platform.pickFiles(type: FileType.video);

              if (result != null) {
                PlatformFile file = result.files.first;

                AddImage addImage = new AddImage(File(file.path));
                Navigator.pop(context, addImage);
                // print(file.name);
                // print(file.bytes);
                // print(file.size);
                // print(file.extension);
                // print(file.path);
              } else {
                // User canceled the picker
              }

              // pickedFile =
              //     await _picker.getVideo(source: ImageSource.gallery);
              // // img = await ImagePicker().getImage(
              // //     source: ImageSource.gallery);
              // img = File(pickedFile.path);
              // // String bit = base64Encode(img.readAsBytesSync());
              // // image.text = bit;

              // print(img);
              // AddImage addImage = new AddImage(
              //   img,
              //   "video"
              // );
              // Navigator.pop(context, addImage);
              // setState(() {});
            },
            child: Container(
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'เพิ่ม วิดีโอ จากคลัง',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              var image = await picker.getVideo(source: ImageSource.camera);

              AddImage addImage = new AddImage(File(image.path));
              Navigator.pop(context, addImage);

              // pickedFile =
              //     await _picker.getVideo(source: ImageSource.camera);

              // img = File(pickedFile.path);

              // print(img);
              // // print("pickedFile = "+pickedFile.);
              // AddImage addImage = new AddImage(
              //   img,
              //   "video"
              // );
              // Navigator.pop(context, addImage);
              // setState(() {});
            },
            child: Container(
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'ถ่ายวิดีโอ ',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
