import 'package:flutter/material.dart';

class EditFoodPage extends StatefulWidget {
  // EditFoodPage({Key? key}) : super(key: key);

  @override
  _EditFoodPageState createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขสูตรอาหาร'),
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}
