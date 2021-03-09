import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class test2 extends StatefulWidget {
  test2({Key key}) : super(key: key);

  @override
  _test2State createState() => _test2State();
}

final String appTitle = "Expense App";

class _test2State extends State<test2> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          
        ),
      ),
      appBar: AppBar(
      
      ), 
    );
  }
}
