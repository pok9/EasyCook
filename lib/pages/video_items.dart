import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoItems extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoplay;
  final int addfood_showfoo;

  // VideoItems({Key key}) : super(key: key);
  VideoItems(
      {@required this.videoPlayerController,
      this.looping,
      this.autoplay,
      this.addfood_showfoo,
      Key key})
      : super(key: key);

  @override
  _VideoItemsState createState() => _VideoItemsState();
}

class _VideoItemsState extends State<VideoItems> {
  ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        // aspectRatio: 30 / 15,
        // aspectRatio: 16 / 9,
        aspectRatio: 3 / 2,
        // aspectRatio: 1,
        // aspectRatio: widget.videoPlayerController.value.aspectRatio,
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
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose


    
    // widget.videoPlayerController?.pause();

    if(widget.addfood_showfoo == 0){
      widget.videoPlayerController?.pause();
    }else{
      widget.videoPlayerController?.dispose();
    }
   
   _chewieController?.dispose();

    // widget.videoPlayerController?.dispose();
    // _chewieController?.dispose();
    super.dispose();
    // widget.videoPlayerController.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }
}
