import 'dart:math';

import 'package:flutter/material.dart';

class test3 extends StatefulWidget {
  test3({Key key}) : super(key: key);

  @override
  _test3State createState() => _test3State();
}

class _test3State extends State<test3> {
  
   double get randHeight => Random().nextInt(100).toDouble();

  List<Widget> _randomChildren;

  // Children with random heights - You can build your widgets of unknown heights here
  // I'm just passing the context in case if any widgets built here needs  access to context based data like Theme or MediaQuery
  List<Widget> _randomHeightWidgets(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _randomChildren ??= List.generate(1, (index) {
      // final height = randHeight.clamp(
      //   500.0,
      //   MediaQuery.of(context).size.width, // simply using MediaQuery to demonstrate usage of context
      // );
      return Container(
        // color: Colors.primaries[index],
        height: 400,
        child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: size.height * 0.30,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?size=626&ext=jpg"),
                              fit: BoxFit.cover),
                        ),
                        child: Column(
                          children: [
                            // SizedBox(
                            //   height: 36,
                            // ),
                            SizedBox(
                              height: 10,
                            ),

                            CircleAvatar(
                              radius: 48,
                              backgroundImage:
                                  NetworkImage("https://i.pravatar.cc/300"),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            MaterialButton(
                              splashColor: Colors.white,
                              color: Colors.blue,
                              onPressed: () {
                                print("ติดตาม");
                              },
                              child: Text(
                                'แก้ไขโปรไฟล์',
                                style: TextStyle(color: Colors.white),
                              ),
                              shape: StadiumBorder(),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Expanded(child: Container()),
                            Container(
                              height: 64,
                              color: Colors.black.withOpacity(0.4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: 110,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'โพสต์',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "1",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 110,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'ติดตาม',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "2",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 110,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'กำลังติดตาม',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "3",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18, right: 18, top: 18, bottom: 18),
                    child: Container(
                      // height: 150,
                      padding: EdgeInsets.only(
                          left: 18, right: 18, top: 22, bottom: 22),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://png.pngtree.com/thumb_back/fw800/back_our/20190628/ourmid/pngtree-blue-background-with-geometric-forms-image_280879.jpg"),
                            fit: BoxFit.cover),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "กระเป๋าหลัก()",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(.7),
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                "20,600",
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          // RaisedButton(
                          //   onPressed: () {},
                          //   elevation: 0,
                          //   padding: EdgeInsets.all(12),
                          //   child: Text(
                          //     "+",
                          //     style:
                          //         TextStyle(color: Color(0xff1B1D28), fontSize: 22),
                          //   ),
                          //   shape: CircleBorder(),
                          //   color: Color(0xffFFAC30),
                          // ),
                          Column(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints.tightFor(
                                    width: 100, height: 35),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.white),
                                  child: Text(
                                    'เติมเงิน',
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints.tightFor(
                                    width: 100, height: 35),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.white),
                                  child: Text(
                                    'ถอนเงิน',
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Container(
                  //   constraints: BoxConstraints.expand(height: 50),
                  //   child: TabBar(tabs: [
                  //     Tab(text: "Home"),
                  //     Tab(text: "Articles"),
                  //     Tab(text: "User"),
                  //   ]),
                  // ),
                  // createChildren()
                ],
              )
      );
    });

    return _randomChildren;
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Persistent AppBar that never scrolls
      appBar: AppBar(
        title: Text('AppBar'),
        elevation: 0.0,
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          // allows you to build a list of elements that would be scrolled away till the body reached the top
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  _randomHeightWidgets(context),
                ),
              ),
            ];
          },
          // You tab view goes here
          body: Column(
            children: <Widget>[
              TabBar(
                tabs: [
                  Tab( child: Text(
                    "feed",
                    style: TextStyle(color: Colors.black),
                  ),),
                  Tab( child: Text(
                    "body",
                    style: TextStyle(color: Colors.black),
                  ),),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    GridView.count(
                      padding: EdgeInsets.zero,
                      crossAxisCount: 3,
                      children: Colors.primaries.map((color) {
                        return Container(color: color, height: 150.0);
                      }).toList(),
                    ),
                    ListView(
                      padding: EdgeInsets.zero,
                      children: Colors.primaries.map((color) {
                        return Container(color: color, height: 150.0);
                      }).toList(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
