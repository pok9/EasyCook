import 'dart:io';

import 'package:easy_cook/model/addFood_addImage_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddFood_AddImagePage extends StatefulWidget {
  AddFood_AddImagePage({Key key}) : super(key: key);

  @override
  _AddFood_AddImagePageState createState() => _AddFood_AddImagePageState();
}

class _AddFood_AddImagePageState extends State<AddFood_AddImagePage> {
  final _picker = ImagePicker();
  var img;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มรูปปกอาหาร'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pickedFile =
              await _picker.getImage(source: ImageSource.camera);
          // img = await ImagePicker().getImage(
          //     source: ImageSource.gallery);
          img = File(pickedFile.path);
          // String bit = base64Encode(img.readAsBytesSync());
          // image.text = bit;

          print(img);
          AddImage addImage = new AddImage(
            img,
          );
          Navigator.pop(context,addImage);
          setState(() {});
        },
        child: Icon(Icons.camera_alt),
        // backgroundColor: Colors.green,
      ),
    );
  }
}
