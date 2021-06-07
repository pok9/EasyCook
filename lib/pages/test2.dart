import 'dart:io';

import 'package:easy_cook/class/addFood_addImage_class.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class test2 extends StatefulWidget {
  test2({Key key}) : super(key: key);

  @override
  _test2State createState() => _test2State();
}

class _test2State extends State<test2> {
  ImagePicker picker;
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
      backgroundColor: Color(0xffe5ded6),
      appBar: AppBar(
        backgroundColor: Color(0xffc69f50),
        centerTitle: true,
        title: Text(
          'Pick & Crop Image',
        ),
      ),
      body: Column(
        children: [
          // imageFile == null ? Container() : Image.file(imageFile),
          FlatButton(
              onPressed: pickCropImage,
              minWidth: 200,
              color: Color(0xffc69f50),
              child: Text(
                'Pick&Crop',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ))
        ],
      ),
    );
  }
}
