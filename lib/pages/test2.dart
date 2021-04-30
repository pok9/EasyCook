import 'dart:math';

import 'package:easy_cook/models/profile/myPost_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class test2 extends StatefulWidget {
  var req_uid;

  test2(this.req_uid);

  @override
  _test2State createState() => _test2State(req_uid);
}

class _test2State extends State<test2> {
  @override
  void initState() {
    super.initState();
    getMyPost();
  }

  var _req_uid;
  _test2State(this._req_uid);

  //ข้อมูลโพสต์ที่ค้นหา
  MyPost data_MyPost;
  List<RecipePost> data_RecipePost;
  Future<Null> getMyPost() async {
    String uid = _req_uid.toString();
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/mypost/" + uid;

    final response = await http.get(Uri.parse(apiUrl));
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        data_MyPost = myPostFromJson(responseString);
        data_RecipePost = data_MyPost.recipePost;
        // newfeed = newfeedsFollowFromJson(responseString);
        //  post = newfeed.feeds[0];
        // dataUser = datas.data[0];
      });
    } else {
      return null;
    }
  }

  //===========================================================================

  double get randHeight => Random().nextInt(100).toDouble();
  List<Widget> _bodyUp;
  List<Widget> _randomHeightWidgets(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _bodyUp ??= List.generate(1, (index) {
      // final height = randHeight.clamp(
      //   500.0,
      //   MediaQuery.of(context).size.width, // simply using MediaQuery to demonstrate usage of context
      // );
      return Container(
          // color: Colors.primaries[index],
          height: 233,
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
                          backgroundImage: NetworkImage(
                              data_MyPost.profileImage), //////////////////
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        MaterialButton(
                          splashColor: Colors.grey,
                          color: Colors.red[400],
                          onPressed: () {
                            print("ติดตาม");
                            // manageFollow("fol", dataPost.userId);
                          },
                          child: Text(
                            'ติดตาม',
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
                                      data_MyPost.countPost.toString(),
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
                                      data_MyPost.countFollower.toString(),
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
                                      data_MyPost.countFollowing.toString(),
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
            ],
          ));
    });

    return _bodyUp;
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // Persistent AppBar that never scrolls
      backgroundColor: Color(0xFFf3f5f9),
      appBar: AppBar(
        title: Text(data_MyPost == null ? "" : data_MyPost.aliasName),
        elevation: 0.0,
      ),
      body: data_MyPost == null
          ? Container()
          : DefaultTabController(
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
                        Tab(
                          child: Text(
                            "อาหาร",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "body",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          ListView.builder(
                            itemCount: data_RecipePost.length,
                            itemBuilder: (context, index) => index < 0
                                ? new SizedBox(
                                    child: AlertDialog(
                                        content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("กรุณารอสักครู่...   "),
                                        CircularProgressIndicator()
                                      ],
                                    )),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      //1st row
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 16.0, 8.0, 16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                              data_MyPost
                                                                  .profileImage))),
                                                ),
                                                new SizedBox(
                                                  width: 10.0,
                                                ),
                                                new Text(
                                                  data_MyPost.aliasName,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            new IconButton(
                                                icon: Icon(Icons.more_vert),
                                                onPressed: () {
                                                  print("more_vert" +
                                                      index.toString());
                                                })
                                          ],
                                        ),
                                      ),

                                      //2nd row
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              print("up $index");
                                              // print(data_RecipePost[index].rid);/////////////////////////////////////////////
                                              // Navigator.push(context,
                                              //     CupertinoPageRoute(
                                              //         builder: (context) {
                                              //   return ShowFood(
                                              //       data_RecipePost[index].rid);
                                              // }));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 0, 8, 0),
                                              child: Container(
                                                width: deviceSize.width,
                                                height: 300,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          24.0),
                                                  child: Image(
                                                    fit: BoxFit.cover,
                                                    // alignment: Alignment.topRight,
                                                    image: NetworkImage(
                                                        data_RecipePost[index]
                                                            .image),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // ),
                                          Positioned(
                                            left: 8.0,
                                            bottom: 0.0,
                                            right: 8.0,
                                            child: GestureDetector(
                                              onTap: () {
                                                print("down $index");
                                                // Navigator.push(context,////////////////////////////////////
                                                //     CupertinoPageRoute(
                                                //         builder: (context) {
                                                //   return ShowFood(
                                                //       data_RecipePost[index]
                                                //           .rid);
                                                // }));
                                              },
                                              child: Container(
                                                height: 60.0,
                                                width: deviceSize.width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          24.0),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.black,
                                                      Colors.black12,
                                                    ],
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 18.0,
                                            bottom: 10.0,
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data_RecipePost[index]
                                                          .recipeName,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 16.0,
                                                        ),
                                                        Icon(
                                                          Icons.star,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 16.0,
                                                        ),
                                                        Icon(
                                                          Icons.star,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 16.0,
                                                        ),
                                                        Icon(
                                                          Icons.star_half,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 16.0,
                                                        ),
                                                        Icon(
                                                          Icons.star_border,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 16.0,
                                                        ),
                                                        SizedBox(
                                                          width: 5.0,
                                                        ),
                                                        Text(
                                                          "(คะแนน " +
                                                              (data_RecipePost[
                                                                      index]
                                                                  .score
                                                                  .toString()) +
                                                              ")",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),

                                      // //3rd row
                                      // Padding(
                                      //   padding: const EdgeInsets.fromLTRB(
                                      //       16.0, 12.0, 16.0, 12.0),
                                      //   child: Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.spaceBetween,
                                      //     children: [
                                      //       new Row(
                                      //         mainAxisAlignment:
                                      //             MainAxisAlignment
                                      //                 .spaceBetween,
                                      //         children: [
                                      //           Icon(
                                      //             Icons.favorite_border,
                                      //             color: Colors.black,
                                      //           ),
                                      //           new SizedBox(
                                      //             width: 16.0,
                                      //           ),
                                      //           Icon(Icons.chat_bubble_outline,
                                      //               color: Colors.black),
                                      //           new SizedBox(
                                      //             width: 16.0,
                                      //           ),
                                      //           Icon(Icons.share,
                                      //               color: Colors.black),
                                      //         ],
                                      //       ),
                                      //       Icon(Icons.bookmark_border,
                                      //           color: Colors.black),
                                      //     ],
                                      //   ),
                                      // ),
                                      // //5th row
                                      // Padding(
                                      //   padding: const EdgeInsets.fromLTRB(
                                      //       16.0, 0, 16.0, 16.0),
                                      //   child: Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.start,
                                      //     children: [
                                      //       new Container(
                                      //         height: 40.0,
                                      //         width: 40.0,
                                      //         decoration: new BoxDecoration(
                                      //             shape: BoxShape.circle,
                                      //             image: new DecorationImage(
                                      //                 fit: BoxFit.fill,
                                      //                 image: new NetworkImage(
                                      //                     "https://i.pravatar.cc/300"))), ///////////////////////////////////////
                                      //       ),
                                      //       new SizedBox(
                                      //         width: 10.0,
                                      //       ),
                                      //       Expanded(
                                      //         child: new TextField(
                                      //           keyboardType:
                                      //               TextInputType.multiline,
                                      //           maxLines: null,
                                      //           decoration: new InputDecoration(
                                      //             border: InputBorder.none,
                                      //             hintText: "เพิ่ม คอมเมนต์...",
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),

                                      // //6th row
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(
                                      //       horizontal: 16.0),
                                      //   child: Text(
                                      //     "1 วันที่แล้ว",
                                      //     style: TextStyle(color: Colors.grey),
                                      //   ),
                                      // ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                          ),
                          GridView.count(
                            padding: EdgeInsets.zero,
                            crossAxisCount: 3,
                            children: Colors.primaries.map((color) {
                              return Container(color: color, height: 150.0);
                            }).toList(),
                          ),
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
