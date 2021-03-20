import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class test2 extends StatefulWidget {
  test2({Key key}) : super(key: key);

  @override
  _test2State createState() => _test2State();
}

final String appTitle = "Expense App";
// FilePickerResult result;

class _test2State extends State<test2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('www'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  // FilePickerResult result = await FilePicker.platform.pickFiles();
                  // if (result != null) {
                  //   File file = File(result.files.single.path);
                  //   print(file);
                  // } else {
                  //   // User canceled the picker
                  // }
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
                      )),
                ),
              ),
              // ),
            ],
          ),
        ));
  }
}
