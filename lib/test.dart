import 'package:easy_cook/pages/video_items.dart';
import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:video_player/video_player.dart';

class test extends StatefulWidget {
  // test({Key? key}) : super(key: key);

  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InViewNotifierList(
      isInViewPortCondition:
          (double deltaTop, double deltaBottom, double vpHeight) {
        return deltaTop < (0.5 * vpHeight) && deltaBottom > (0.5 * vpHeight);
      },
      itemCount: 10,
      builder: (BuildContext context, int index) {
        return InViewNotifierWidget(
          id: '$index',
          builder: (BuildContext context, bool isInView, Widget child) {
            return Column(
              children: [
                Text(isInView ? '$isInView' : '$index $isInView'),
                Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: VideoItems(
                          videoPlayerController: VideoPlayerController.asset(
                              'assets/images/testVideo.mp4'),
                          looping: false,
                          autoplay: false,
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.only()),
              ],
            );
          },
        );
      },
    ));
  }
}
