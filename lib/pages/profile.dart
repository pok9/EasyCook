import 'package:easy_cook/database/db_service.dart';
import 'package:flutter/material.dart';
import 'package:easy_cook/pages/login.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffe433e68), Color(0xfffaa449)],
  ).createShader(Rect.fromLTRB(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('โปรไฟล์'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () async {
              var service = DBService();
              await service.deleteAllData();
              // print("delete = "+delete);
              // Navigator.pushReplacement(
              //   context,
              //   new MaterialPageRoute(
              //       /*check()*/
              //       builder: (context) =>
              //           new LoginPage()), /////////////////////////////////////////////////////////////////////////////////
              // ).then((value) {
              //   /* if (value == null) {
              //     } else {

              //       proList.add(value);
              //     }*/
              //   setState(() {});
              // });
              Navigator.pushNamed(context, '/login-page');
            },
          )
        ],
        /*backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'ตั้งค่า',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            foreground: Paint()..shader = linearGradient,
          ),
        ),
        centerTitle: true,
        leading: Icon(
          Icons.arrow_back,
          color: Colors.grey,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              Icons.more_horiz,
              color: Colors.grey,
            ),
          )
        ],*/
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xffe43e68), const Color(0xfffaa449)],
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                        "https://variety.teenee.com/foodforbrain/img8/241131.jpg"),
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'วันรุ่นซิมบัพเว',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      foreground: Paint()..shader = linearGradient,
                    ),
                  ),
                  Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xffe43e68),
                              const Color(0xfffaa449),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            'แก้ไขโปรไฟล์',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '10',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          'โพสต์',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '1.2M',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          'ผู้ติดตาม',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '132',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          'กำลังติดตาม',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xffe43e68),
                            const Color(0xfffaa449),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 70,
                      width: 370, //ฟิกค่าไว้ก่อน
                      child: Center(
                        child: Text(
                          'ยอดเงิน 1,999 บาท',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xffe43e68),
                                const Color(0xfffaa449),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 70,
                          width: 180, //ฟิกค่าไว้ก่อน
                          child: Center(
                            child: Text(
                              'เติมเงิน',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xffe43e68),
                                const Color(0xfffaa449),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 70,
                          width: 180, //ฟิกค่าไว้ก่อน
                          child: Center(
                            child: Text(
                              'ถอนเงิน',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //1st row
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              new Container(
                                height: 40.0,
                                width: 40.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(
                                            "https://variety.teenee.com/foodforbrain/img8/241131.jpg"))),
                              ),
                              new SizedBox(
                                width: 10.0,
                              ),
                              new Text(
                                "วัยรุ่น ซิมบัพเว",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          new IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                //print("more_vert" + index.toString());
                              })
                        ],
                      ),
                    ),

                    //2nd row
                    Flexible(
                      fit: FlexFit.loose,
                      child: new Image.network(
                        //รูปอาหาร
                        "https://www.japancheckin.com/wp-content/uploads/2018/12/6336ebda10e4418f6b9b316134fb9ed7_s.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),

                    //3rd row
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.favorite_border,
                                color: Colors.black,
                              ),
                              new SizedBox(
                                width: 16.0,
                              ),
                              Icon(Icons.chat_bubble_outline,
                                  color: Colors.black),
                              new SizedBox(
                                width: 16.0,
                              ),
                              Icon(Icons.share, color: Colors.black),
                            ],
                          ),
                          Icon(Icons.bookmark_border, color: Colors.black),
                        ],
                      ),
                    ),

                    //4th row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Liked by pawankumar, pk and 528,331 others",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    //5th row
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          new Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new NetworkImage(
                                        "https://variety.teenee.com/foodforbrain/img8/241131.jpg"))),
                          ),
                          new SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: new TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: "เพิ่ม คอมเมนต์...",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //6th row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "1 วันที่แล้ว",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ), //เส่น hr
        ],
      ),
    );
  }
}
