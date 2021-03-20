import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Easy Cook'),
        ),
        body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => index < 0
              ? new SizedBox(
                  child: Container(),
                )
              : Column(
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
                                print("more_vert" + index.toString());
                              })
                        ],
                      ),
                    ),

                    //2nd row
                    Flexible(
                      fit: FlexFit.loose,
                      child: new Image.network(
                        //รูปอาหาร
                        "https://i.ytimg.com/vi/LQUhdrHYWSg/maxresdefault.jpg",
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
        ),
      //   floatingActionButton: FloatingActionButton(
      //   onPressed: ()  {
         
      //   },
      //   child: Icon(Icons.add),
      //   // backgroundColor: Colors.green,
      // ),
        );
  }
}
