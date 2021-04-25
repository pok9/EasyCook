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
              padding: const EdgeInsets.only(left: 18, right: 18, top: 34),
              child: Container(
                padding:
                    EdgeInsets.only(left: 18, right: 18, top: 22, bottom: 22),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffF1F3F6)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "20,600",
                          style: TextStyle(
                              fontSize: 24,
                              color: Color(0xff171822),
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Current Balance",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xff3A4276).withOpacity(.4),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    RaisedButton(
                      onPressed: () {},
                      elevation: 0,
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "+",
                        style:
                            TextStyle(color: Color(0xff1B1D28), fontSize: 22),
                      ),
                      shape: CircleBorder(),
                      color: Color(0xffFFAC30),
                    )
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
