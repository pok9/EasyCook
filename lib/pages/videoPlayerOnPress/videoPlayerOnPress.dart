import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerOnPress extends StatefulWidget {
  var path;
  VideoPlayerOnPress({ Key key ,this.path}) : super(key: key);

  @override
  _VideoPlayerOnPressState createState() => _VideoPlayerOnPressState();
}

class _VideoPlayerOnPressState extends State<VideoPlayerOnPress> {
  BetterPlayer _betterPlayerController;
  Future<void> _initializeVideoPlayerFuture;
   @override
  void initState() {
    // TODO: implement initState
    if ((widget.path.runtimeType == String)) {
      try {
        _betterPlayerController = (widget.path.substring(0, 4) == "http")
            ? BetterPlayer.network(widget.path,
                betterPlayerConfiguration: BetterPlayerConfiguration(
                  autoPlay: true,
                  aspectRatio: 1
                ))
            : BetterPlayer.file(widget.path,
                betterPlayerConfiguration: BetterPlayerConfiguration(
                  autoPlay: true,
                  aspectRatio: 1
                ));
      } catch (e) {
        _betterPlayerController = BetterPlayer.file(widget.path,
                betterPlayerConfiguration: BetterPlayerConfiguration(
                  autoPlay: true,
                  aspectRatio: 1
                ));
        
      }
    }else{
      print(0000000000);
      if(widget.path.path.substring(0, 4) == "http"){
print(111111111111111);
          _betterPlayerController = BetterPlayer.network(widget.path.path,
            betterPlayerConfiguration: BetterPlayerConfiguration(
              autoPlay: true,
              aspectRatio: 1
            ));
        }else{
          print(222222222222222222);
          _betterPlayerController = BetterPlayer.file(widget.path.path,
            betterPlayerConfiguration: BetterPlayerConfiguration(
              autoPlay: true,
              aspectRatio: 1
            ));
        }
    }
   
    super.initState();
  }

   @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    print("pokDispose");
    _betterPlayerController.controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     return Padding(
       padding: const EdgeInsets.all(8.0),
       child: _betterPlayerController,
     );
  }
}