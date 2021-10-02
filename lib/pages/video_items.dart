import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoItems extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoplay;
  final int addfood_showfood;

  // VideoItems({Key key}) : super(key: key);
  VideoItems(
      {@required this.videoPlayerController,
      this.looping,
      this.autoplay,
      this.addfood_showfood,
      Key key})
      : super(key: key);

  @override
  _VideoItemsState createState() => _VideoItemsState();
}

class _VideoItemsState extends State<VideoItems> {

  ChewieController _chewieController;
  int count = 0;

  @override
  void initState() {
     super.initState();
    // TODO: implement initState
     if (mounted) {
    
      print(11111111);
     
      _chewieController = ChewieController(
          videoPlayerController: widget.videoPlayerController,
          // aspectRatio: 30 / 15,
          // aspectRatio: 16 / 9,
          // aspectRatio: 3 / 2,
          // aspectRatio: 1,
          aspectRatio: widget.videoPlayerController.value.aspectRatio,
          autoInitialize: true,
          autoPlay: widget.autoplay,
          looping: widget.looping,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          );
         
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print(3333333);
    count++;
    // widget.videoPlayerController?.pause();

    if (widget.addfood_showfood == 0) {
      // widget.videoPlayerController?.pause();
      // widget.videoPlayerController?.dispose();//---
      widget.videoPlayerController.pause();
      widget.videoPlayerController.dispose(); //---
    } else if ((widget.addfood_showfood == 1)) {
      widget.videoPlayerController?.dispose();
    } else if (widget.addfood_showfood == 2) {
      //editFood
      try {
        widget.videoPlayerController.pause();
      } catch (e) {
        print(e);
      }
    }

    _chewieController?.dispose();

    // widget.videoPlayerController?.dispose();
    // _chewieController?.dispose();
    super.dispose();
    // widget.videoPlayerController.pause();
  }

  @override
  Widget build(BuildContext context) {
    print(2222222);
    count++;
    return 
    Chewie(
      controller: _chewieController,
    );
  }
}
