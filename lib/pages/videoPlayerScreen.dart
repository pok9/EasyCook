import 'package:chewie/chewie.dart';
import 'package:easy_cook/pages/customVideoProgressIndicator.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  var path;
  int index;
  VideoPlayerScreen({Key key, this.path, this.index}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  ChewieController _chewieController;
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
    }else{
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

    _controller.addListener(() {
      setState(() {
        print("12312312312312");
      });
    });
    _initializeVideoPlayerFuture = _controller.initialize();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  bool tap = false;

  Future forward5Seconds() async =>
      goToPosition((currentPosition) => currentPosition + Duration(seconds: 5));

  Future rewind5Seconds() async =>
      goToPosition((currentPosition) => currentPosition - Duration(seconds: 5));

  Future goToPosition(
    Duration Function(Duration currentPosition) builder,
  ) async {
    final currentPosition = await _controller.position;
    final newPosition = builder(currentPosition);

    await _controller.seekTo(newPosition);
  }

  Future reset() async {
    await _controller.seekTo(Duration(seconds: 0));
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.position.inMilliseconds ==
        _controller.value.duration.inMilliseconds) {
      setState(() {
        tap = false;
      });
    }
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
                      InkWell(
                        onTap: () {
                          setState(() {
                            tap = !tap;
                          });
                        },
                        child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 50),
                            reverseDuration: Duration(milliseconds: 200),
                            child: (tap)
                                ? Container()
                                : Container(
                                    color: Colors.black26,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: IconButton(
                                            onPressed: rewind5Seconds,
                                            icon: Icon(
                                              Icons.replay_5,
                                              color: Colors.white,
                                              size: 35.0,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 17),
                                          child: Center(
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    (_controller.value.position
                                                                .inMilliseconds ==
                                                            _controller
                                                                .value
                                                                .duration
                                                                .inMilliseconds)
                                                        ? reset()
                                                        : (_controller.value
                                                                .isPlaying)
                                                            ? _controller
                                                                .pause()
                                                            : _controller
                                                                .play();
                                                  });
                                                },
                                                icon: (_controller
                                                            .value
                                                            .position
                                                            .inMilliseconds ==
                                                        _controller
                                                            .value
                                                            .duration
                                                            .inMilliseconds)
                                                    ? Icon(
                                                        Icons.restart_alt,
                                                        color: Colors.white,
                                                        size: 50.0,
                                                      )
                                                    : (_controller
                                                            .value.isPlaying)
                                                        ? Icon(
                                                            Icons.pause,
                                                            color: Colors.white,
                                                            size: 50.0,
                                                          )
                                                        : Icon(
                                                            Icons.play_arrow,
                                                            color: Colors.white,
                                                            size: 50.0,
                                                          )),
                                          ),
                                        ),
                                        Center(
                                          child: IconButton(
                                            onPressed: forward5Seconds,
                                            icon: Icon(
                                              Icons.forward_5,
                                              color: Colors.white,
                                              size: 35.0,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                      ),
                      (tap)
                          ? Container()
                          : CustomVideoProgressIndicator(_controller,
                              allowScrubbing: true, timestamps: [Duration()]),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
