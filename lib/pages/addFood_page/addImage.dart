import 'dart:io';

import 'package:easy_cook/class/addFood_addImage_class.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

class AddFood_AddImagePage extends StatefulWidget {
  AddFood_AddImagePage({Key key}) : super(key: key);

  @override
  _AddFood_AddImagePageState createState() => _AddFood_AddImagePageState();
}

class _AddFood_AddImagePageState extends State<AddFood_AddImagePage> {
  // final _picker = ImagePicker();
  var img;
  var pickedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มรูป'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                FilePickerResult result =
                    await FilePicker.platform.pickFiles(type: FileType.image);

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
                //     await _picker.getImage(source: ImageSource.gallery);

                // img = File(pickedFile.path);

                // // print()
                // // print();
                // // print("pickedFile = "+pickedFile.);
                // AddImage addImage = new AddImage(
                //   img,
                //   "image"
                // );
                // Navigator.pop(context, addImage);
                // setState(() {});
              },
              child: Container(
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'เพิ่ม รูปภาพ จากคลัง',
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
                // pickedFile =
                //     await _picker.getImage(source: ImageSource.camera);

                // img = File(pickedFile.path);

                // print(img);
                // // print("pickedFile = "+pickedFile.);
                // AddImage addImage = new AddImage(
                //   img,
                //   "image"
                // );
                // Navigator.pop(context, addImage);
                // setState(() {});
              },
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
          ],
        ),
      ),
    );
  }
}
