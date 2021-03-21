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
  void initState() { 
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('www'),
        ),
        );
  }
}
