import 'package:easy_cook/style/utiltties.dart';
import 'package:flutter/material.dart';
import 'package:sliver_fab/sliver_fab.dart';

class test extends StatelessWidget {
  const test({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFab(
      floatingWidget: Container(
        height: 100,
        width: 100,
        child: ClipOval(
          child: Image.network(
            'https://saosuay.com/wp-content/uploads/2020/07/%E0%B8%AA%E0%B8%B2%E0%B8%A7%E0%B8%A1%E0%B8%AB%E0%B8%B2%E0%B8%A5%E0%B8%B1%E0%B8%A2-7-819x1024.jpg',
            fit: BoxFit.fill,
          ),
        ),
        decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 8.0)),
      ),
      expandedHeight: 256.0,
      floatingPosition: FloatingPosition(top: -20, left: 150),
      slivers: [
        SliverAppBar(
          title: Text('Example 1'),
          pinned: true,
          expandedHeight: 256.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.asset(
              'assets/images/camera.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        // CustomScrollView(
        //   slivers: [

        //   ],
        // ),
        SliverList(
            delegate: SliverChildListDelegate(List.generate(
                1,
                (index) => Column(
                      children: [
                        Container(
                          height: 50,
                          width: 500,
                          color: Colors.white24,
                        ),
                        Text(
                          "เซฟปก",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Text("ต้มยำกุ้ง", style: kHintTextStyle3),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            width: 300,
                            height: 200,
                            child: ClipRRect(
                              borderRadius: new BorderRadius.circular(24.0),
                              child: Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://lumiere-a.akamaihd.net/v1/images/sa_pixar_virtualbg_coco_16x9_9ccd7110.jpeg"),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Text(
                          "ส่วนผสม",
                          style: kHintTextStyle3,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          // children: test,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Text(
                          "วิธีทำ",
                          style: kHintTextStyle3,
                        ),
                        ListView(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          // children: test2,
                        ),

                        SizedBox(height: 500,)
                      ],
                    )))
            // delegate: SliverChildListDelegate([
            //   Column(
            //     children: [
            //       Stack(
            //         children: [
            //           Container(
            //             height: 55,
            //             width: 500,
            //             color: Colors.white24,
            //           ),
            //           // Container(
            //           //     height: 200,
            //           //     width: 500,
            //           //     child: Image.network(
            //           //       "https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?size=626&ext=jpg",
            //           //       fit: BoxFit.cover,
            //           //     )),
            //           // Positioned(
            //           //   top: 100,
            //           //   left: 120,
            //           //   child: CircleAvatar(
            //           //     radius: 80,
            //           //     backgroundColor: Colors.white,
            //           //     child: CircleAvatar(
            //           //       radius: 75,
            //           //       backgroundImage: NetworkImage("https://saosuay.com/wp-content/uploads/2020/07/%E0%B8%AA%E0%B8%B2%E0%B8%A7%E0%B8%A1%E0%B8%AB%E0%B8%B2%E0%B8%A5%E0%B8%B1%E0%B8%A2-7-819x1024.jpg"),
            //           //     ),
            //           //   ),
            //           // ),
            //           // Positioned(
            //           //   top: 210,
            //           //   left: 240,
            //           //   child: CircleAvatar(
            //           //     radius: 22,
            //           //     backgroundColor: Colors.grey[300],
            //           //     child: IconButton(
            //           //       icon: const Icon(Icons.add),
            //           //       color: Colors.black,
            //           //       onPressed: () {
            //           //         setState(() {});
            //           //       },
            //           //     ),
            //           //   ),
            //           // )
            //         ],
            //       ),
            //       Text(
            //         "เซฟปก",
            //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            //       ),
            //       Divider(
            //         thickness: 1,
            //         color: Colors.grey,
            //       ),
            //       Text("ต้มยำกุ้ง", style: kHintTextStyle3),
            //       Padding(
            //         padding: const EdgeInsets.all(16.0),
            //         child: Container(
            //           width: 300,
            //           height: 200,
            //           child: ClipRRect(
            //             borderRadius: new BorderRadius.circular(24.0),
            //             child: Image(
            //               fit: BoxFit.cover,
            //               image: NetworkImage("https://lumiere-a.akamaihd.net/v1/images/sa_pixar_virtualbg_coco_16x9_9ccd7110.jpeg"),
            //             ),
            //           ),
            //         ),
            //       ),
            //       Divider(
            //         thickness: 1,
            //         color: Colors.grey,
            //       ),
            //       Text(
            //         "ส่วนผสม",
            //         style: kHintTextStyle3,
            //       ),
            //       SizedBox(
            //         height: 10,
            //       ),
            //       ListView(
            //         padding: EdgeInsets.all(0),
            //         shrinkWrap: true,
            //         physics: NeverScrollableScrollPhysics(),
            //         // children: test,
            //       ),
            //       Divider(
            //         thickness: 1,
            //         color: Colors.grey,
            //       ),
            //       Text(
            //         "วิธีทำ",
            //         style: kHintTextStyle3,
            //       ),
            //       ListView(
            //         padding: EdgeInsets.all(0),
            //         shrinkWrap: true,
            //         physics: NeverScrollableScrollPhysics(),
            //         // children: test2,
            //       ),
            //     ],
            //   ),
            // ]
            // ),
            )
      ],
    );
  }
}
