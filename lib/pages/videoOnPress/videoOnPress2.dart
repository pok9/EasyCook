import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoOnPress2 extends StatefulWidget {
  var path;
  VideoOnPress2({Key key, this.path}) : super(key: key);

  @override
  _VideoOnPress2State createState() => _VideoOnPress2State();
}

class _VideoOnPress2State extends State<VideoOnPress2> {
  var _betterPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    if ((widget.path.runtimeType == String)) {
      try {
        _betterPlayerController = (widget.path.substring(0, 4) == "http")
            ? BetterPlayer.network(widget.path,
                betterPlayerConfiguration: BetterPlayerConfiguration(
                  autoPlay: true,
                ))
            : BetterPlayer.file(widget.path,
                betterPlayerConfiguration: BetterPlayerConfiguration(
                  autoPlay: true,
                ));
      } catch (e) {
        BetterPlayer.file(widget.path,
                betterPlayerConfiguration: BetterPlayerConfiguration(
                  autoPlay: true,
                ));
        
      }
    }else{
      print(0000000000);
      if(widget.path.path.substring(0, 4) == "http"){
print(111111111111111);
          _betterPlayerController = BetterPlayer.network(widget.path.path,
            betterPlayerConfiguration: BetterPlayerConfiguration(
              autoPlay: true,
            ));
        }else{
          print(222222222222222222);
          _betterPlayerController = BetterPlayer.file(widget.path.path,
            betterPlayerConfiguration: BetterPlayerConfiguration(
              autoPlay: true,
            ));
        }
    }

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _betterPlayerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _betterPlayerController;
  }
}
