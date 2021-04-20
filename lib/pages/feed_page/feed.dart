import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  // FeedPage({Key key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: Text('Easy Cook'),
        ),
      ),
    );
  }
}