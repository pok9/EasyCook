import 'package:flutter/material.dart';

class TopupPage extends StatefulWidget {
  // const TopupPage({ Key? key }) : super(key: key);

  @override
  _TopupPageState createState() => _TopupPageState();
}

class _TopupPageState extends State<TopupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("บัตรเครดิต/บัตรเดบิต"),),
      body: Column(
        children: [
          Text("Credit / Debit"),
          
        ],
      ),
    );
  }
}