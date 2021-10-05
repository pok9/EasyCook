import 'package:easy_cook/models/showfood/showfood_model.dart';
import 'package:easy_cook/pages/videoOnPress/videoOnPress.dart';
import 'package:easy_cook/pages/video_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';

class OnTapHowtoShowFood extends StatefulWidget {
  OnTapHowtoShowFood({this.index,this.dataHowto, Key key}) : super(key: key);
  int index;
  List<Howto> dataHowto;
  @override
  _OnTapHowtoShowFoodState createState() => _OnTapHowtoShowFoodState();
}

class _OnTapHowtoShowFoodState extends State<OnTapHowtoShowFood> {
  
  var controller;
  int currentpage = 0;

  @override
  void initState() {
    print("onTap ==> ${this.widget.index}");
    controller = PageController(initialPage:this.widget.index );
    currentpage = this.widget.index;
    // TODO: implement initState
    
    super.initState();
    controller.addListener(() {
      setState(() {
        currentpage = controller.page.toInt();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("กดออก");
//     flutterTts.setCompletionHandler(() {
//   setState(() {

//   });
// });
    flutterTts.stop();
    super.dispose();
  }

  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    // speak() async {
    //     await flutterTts.speak("Hello");
    // }
    Future _speak(String text) async {
      await flutterTts.setLanguage("th-TH");
      await flutterTts.speak(text);
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(child: Container()),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.clear)),
              ],
            ),

            // Expanded(
            //     child: PageView.builder(
            //         controller: controller,
            //         itemCount: this.widget.dataHowto.length,
            //         itemBuilder: (context, index) {
            //           return Padding(
            //             padding: const EdgeInsets.symmetric(
            //                 horizontal: 20, vertical: 110),
            //             child: Card(
            //               elevation: 6.0,
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(20)),
            //               color: Colors.white,
            //               child: Container(
            //                 decoration: BoxDecoration(
            //                     image: DecorationImage(
            //                         image: NetworkImage(this
            //                             .widget
            //                             .dataHowto[index]
            //                             .pathFile))),
            //               ),
            //             ),
            //           );
            //         })),
            Container(
              color: Colors.white,
              height: size.height * 0.85,
              child: PageView.builder(
                  // shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  controller: controller,
                  itemCount: this.widget.dataHowto.length,
                  itemBuilder: (context, index) {
                    return ListView(
                      children: [
                        //  Card(
                        //   elevation: 6.0,
                        //   shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(20)),
                        //   color: Colors.white,
                        //   child:
                        // ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: CircleAvatar(
                                  radius: 10,
                                  child: Text("${index + 1}"),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  this.widget.dataHowto[index].description,
                                  // "fasdfasdufajsjofaosidjfiasodjfiadsfosadjifoadsiofjioasdjfijiojsadfjiosadfuiashudfhASDFIOASDIFOJIJSADOFJIOASDOIFJASOIDJFOOIFJDSOIIFAJPOSDFJOIAJSDIOFOIJFDSAOIJFPOIASJDIOFJIOASDJIOFsdauifhuisahduifhuiasdhfuihasduhfuihsadufhuisasdifiuhsadiufhiusadhfuisadufuisaduhfiaiusdhfuihasdufhuiahsduifuiahsdiufhiuovfiuasbyifoyaisyfiuoasyiufoyoiuasyvbyiuafybiaoviabsyivobyfsdbyifuysbioyy",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      //fontFamily: 'OpenSans',
                                      fontSize: 17,
                                      color: Colors.black,
                                      decoration: TextDecoration.none),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: (lookupMimeType(this
                                      .widget
                                      .dataHowto[index]
                                      .pathFile)[0] ==
                                  "i")
                              ? Container(
                                  height: 300,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(this
                                              .widget
                                              .dataHowto[index]
                                              .pathFile))),
                                )
                              : 
                              Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: VideoOnPress(path: this
                                                .widget
                                                .dataHowto[index]
                                                .pathFile),
                                    // AspectRatio(
                                    //   // aspectRatio: 3 / 2,
                                    //   // aspectRatio: 16 / 9,
                                    //   aspectRatio: 1,
                                    //   child: VideoItems(
                                    //     videoPlayerController:
                                    //         VideoPlayerController.network(this
                                    //             .widget
                                    //             .dataHowto[index]
                                    //             .pathFile),
                                    //     looping: false,
                                    //     autoplay: false,
                                    //     addfood_showfood: 0,
                                    //   ),
                                    // ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  margin: EdgeInsets.all(10),
                                ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => _speak(
                                    this.widget.dataHowto[index].description),
                                icon: Icon(
                                  Icons.speaker,
                                  color: Colors.blue,
                                  size: 50,
                                )),
                          ],
                        )
                      ],
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                        height: 30,
                        width: 60,
                        color: Colors.grey.shade500,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                              child: Text(
                            "${currentpage + 1}/${this.widget.dataHowto.length}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
