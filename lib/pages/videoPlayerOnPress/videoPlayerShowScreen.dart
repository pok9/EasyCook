// import 'package:chewie/chewie.dart';
import 'package:easy_cook/pages/customVideoProgressIndicator.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerShowScreen extends StatefulWidget {
  var path;
  int index;
  VideoPlayerShowScreen({Key key, this.path, this.index}) : super(key: key);

  @override
  _VideoPlayerShowScreenState createState() => _VideoPlayerShowScreenState();
}

class _VideoPlayerShowScreenState extends State<VideoPlayerShowScreen> {
  VideoPlayerController _controller;
  // ChewieController _chewieController;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    if (widget.index == 0) {
      if (this.widget.path.runtimeType == String) {
        print(11111);

        _controller = (this.widget.path.substring(0, 4) == "http")
            ? VideoPlayerController.network(
                this.widget.path,
              )
            : VideoPlayerController.file(
                this.widget.path,
              );
      } else {
        print(22222);
        _controller = VideoPlayerController.file(
          this.widget.path,
        );
      }
    } else {
      try {
        _controller = (this.widget.path.path.substring(0, 4) == "http")
            ? VideoPlayerController.network(
                this.widget.path.path,
              )
            : VideoPlayerController.file(
                this.widget.path,
              );
      } catch (e) {
        _controller = VideoPlayerController.file(
          this.widget.path,
        );
      }
    }

    _initializeVideoPlayerFuture = _controller.initialize();

    super.initState();
  }

  @override
  void dispose() {
    print("DisposeShowScreen");
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoPlayer(_controller),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Center(
                  child: CircularProgressIndicator(),
                )),
          );
        }
      },
    );
  }
}
