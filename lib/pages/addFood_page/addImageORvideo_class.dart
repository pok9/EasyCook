import 'dart:io';

import 'package:easy_cook/class/addFood_addImage_class.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImageOrVideo extends StatefulWidget {
  AddImageOrVideo({Key key}) : super(key: key);

  @override
  _AddImageOrVideoState createState() => _AddImageOrVideoState();
}

class _AddImageOrVideoState extends State<AddImageOrVideo> {
  final picker = ImagePicker();
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
                var image = await picker.getImage(source: ImageSource.camera);

                AddImage addImage = new AddImage(File(image.path));
                Navigator.pop(context, addImage);

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
            SizedBox(
              height: 20,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var image = await picker.getImage(source: ImageSource.camera);

          AddImage addImage = new AddImage(File(image.path));
          Navigator.pop(context, addImage);
          // pickedFile = await _picker.getImage(source: ImageSource.camera);
          // // img = await ImagePicker().getImage(
          // //     source: ImageSource.gallery);
          // img = File(pickedFile.path);
          // // String bit = base64Encode(img.readAsBytesSync());
          // // image.text = bit;

          // print(img);
          // AddImage addImage = new AddImage(
          //   img,
          //   "image"
          // );
          // Navigator.pop(context, addImage);
          // setState(() {});
        },
        child: Icon(Icons.camera_alt),
        // backgroundColor: Colors.green,
      ),
    );
  }
}
