import 'dart:async';

import 'package:easy_cook/pages/videoOnPress/videoOnPress2.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoOnPress extends StatefulWidget {
  var path;
  VideoOnPress({Key key, this.path}) : super(key: key);

  @override
  _VideoOnPressState createState() => _VideoOnPressState();
}

class _VideoOnPressState extends State<VideoOnPress> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.

    print(widget.path.runtimeType);
    if ((widget.path.runtimeType == String)) {
      try {
        _controller = (widget.path.substring(0, 4) == "http")
            ? VideoPlayerController.network(
                this.widget.path,
              )
            : VideoPlayerController.asset(this.widget.path);
      } catch (e) {
        if (widget.path.path.substring(0, 4) == "http") {
          _controller = VideoPlayerController.network(
            this.widget.path.path,
          );
        } else {
          _controller = VideoPlayerController.file(this.widget.path);
        }
      }
    } else {
      _controller = (this.widget.path.path.substring(0, 4) == "http") ? VideoPlayerController.network(this.widget.path.path) : VideoPlayerController.file(this.widget.path);
      
    }

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    // _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the video.
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,

              // Use the VideoPlayer widget to display the video.
              child: Stack(
                children: [
                  VideoPlayer(_controller),
                  InkWell(
                    onTap: () {},
                    child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 50),
                        reverseDuration: Duration(milliseconds: 200),
                        child: Container(
                          color: Colors.black38,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 17),
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        VideoOnPress2(
                                                          path:
                                                            this.widget.path,
                                                        )));
                                      },
                                      icon: Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 50.0,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
