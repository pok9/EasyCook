import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class test2 extends StatefulWidget {
  @override
  _test2State createState() => _test2State();
}

class _test2State extends State<test2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFf3f5f9),
      appBar: AppBar(
        title: Text('เซฟปก'),
      ),
      body: SingleChildScrollView(
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 110,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'โพสต์',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ติดตาม',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'กำลังติดตาม',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12),
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
              padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
              child: Container(
                // height: 150,
                padding:
                    EdgeInsets.only(left: 18, right: 18, top: 22, bottom: 22),
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
                          constraints:
                              BoxConstraints.tightFor(width: 100, height: 35),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white
                            ),
                            child: Text('เติมเงิน',style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold),),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ConstrainedBox(
                          constraints:
                              BoxConstraints.tightFor(width: 100, height: 35),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white
                            ),
                            child: Text('ถอนเงิน',style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold),),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    
                    

                  ],
                ),
              ),
            ),
            
            
          ],
          
        ),
      ),
    );
  }
}
