import 'package:easy_cook/models/showfood/showfood_model.dart';
import 'package:flutter/material.dart';

class OnTapHowtoShowFood extends StatefulWidget {
  OnTapHowtoShowFood({this.dataHowto, Key key}) : super(key: key);
  List<Howto> dataHowto;
  @override
  _OnTapHowtoShowFoodState createState() => _OnTapHowtoShowFoodState();
}

class _OnTapHowtoShowFoodState extends State<OnTapHowtoShowFood> {
  var controller = PageController();
  int currentpage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      setState(() {
        currentpage = controller.page.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    return Column(
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
                                      fontFamily: 'OpenSans',
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
                          child: Container(
                            height: 300,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(this
                                        .widget
                                        .dataHowto[index]
                                        .pathFile))),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(onPressed: () {
                              print("object");
                            }, icon: Icon(Icons.speaker,size: 50,)),
                          ],
                        )
                      ],
                    );
                  }),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ClipRRect(
            //       borderRadius: BorderRadius.circular(40),
            //       child: Container(
            //           height: 30,
            //           width: 60,
            //           color: Colors.grey.shade500,
            //           child: Padding(
            //             padding: const EdgeInsets.all(4.0),
            //             child: Center(
            //                 child: Text(
            //               "${currentpage + 1}/${this.widget.dataHowto.length}",
            //               style: TextStyle(
            //                   color: Colors.white,
            //                   fontWeight: FontWeight.bold,
            //                   fontSize: 15),
            //             )),
            //           )),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
