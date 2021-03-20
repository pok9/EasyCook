// import 'dart:html';

// import 'package:file_picker/file_picker.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:easy_cook/pages/video_items.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
// import 'package:flutter/services.dart';

class test extends StatefulWidget {
  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Easy Cook'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Expanded(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: VideoItems(
                videoPlayerController: VideoPlayerController.network(
                    "https://apifood.comsciproject.com/uploadHowto\\2021-03-18T062007796Z-y2mate.com - Bruno Mars Anderson Paak Silk Sonic  Leave the Door Open Official Video_1080p.mp4"),
                looping: true,
                autoplay: false,
              ),
            ),
          )
          ),
          AspectRatio(
            aspectRatio: 3 / 2,
            child: VideoItems(
              videoPlayerController: VideoPlayerController.network(
                  "https://apifood.comsciproject.com/uploadHowto\\2021-03-18T062007796Z-y2mate.com - Bruno Mars Anderson Paak Silk Sonic  Leave the Door Open Official Video_1080p.mp4"),
              looping: true,
              autoplay: false,
            ),
          ),
        ],
      ),
    );
  }
}
