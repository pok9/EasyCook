import 'package:easy_cook/models/feed/newFeedsFollow_model.dart';
import 'package:easy_cook/models/feed/newfeedsglobal/newfeedsglobal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Feed2Page extends StatefulWidget {
  // const Feed2Page({ Key? key }) : super(key: key);

  @override
  _Feed2PageState createState() => _Feed2PageState();
}

class _Feed2PageState extends State<Feed2Page> {
  ScrollController _scrollController = ScrollController();
  int _currentMax;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getNewfeedsglobal();
    findUser();
    _scrollController.addListener(() {
      print(
          "_scrollController.position.pixels = ${_scrollController.position.pixels}");
      print(
          '_scrollController.position.maxScrollExtent = ${_scrollController.position.maxScrollExtent}');
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreList();
      }
    });
  }

  _getMoreList() {
    print("Get More List");
    _currentMax = dummyListDataNewfeedsglobal.length;

    if ((dataNewfeedsglobal.length - dummyListDataNewfeedsglobal.length) >= 4) {
      for (int i = dummyListDataNewfeedsglobal.length;
          i < _currentMax + 4;
          i++) {
        dummyListDataNewfeedsglobal.add(dataNewfeedsglobal[i]);
      }
    } else {
      for (int i = dummyListDataNewfeedsglobal.length;
          i < dataNewfeedsglobal.length;
          i++) {
        dummyListDataNewfeedsglobal.add(dataNewfeedsglobal[i]);
      }
    }

    setState(() {});
  }

  String token = ""; //โทเคน
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
      print("token = ${token}");

      if (token != "") {
        getNewFeedsFollow();
      }
    });
  }

  List<Newfeedsglobal> dataNewfeedsglobal;
  List<Newfeedsglobal> dummyListDataNewfeedsglobal;
  Future<Null> getNewfeedsglobal() async {
    dummyListDataNewfeedsglobal = [];
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/newfeedsglobal";

    final response = await http.get(Uri.parse(apiUrl));
    // print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      final String responseString = response.body;

      dataNewfeedsglobal = newfeedsglobalFromJson(responseString);

      if (dataNewfeedsglobal.length >= 10) {
        for (int i = 0; i < 10; i++) {
          dummyListDataNewfeedsglobal.add(dataNewfeedsglobal[i]);
        }
      } else {
        for (int i = 0; i < dataNewfeedsglobal.length; i++) {
          dummyListDataNewfeedsglobal.add(dataNewfeedsglobal[i]);
        }
      }
      setState(() {});
    } else {
      return null;
    }
  }

  NewFeedsFollow newFeedsFollow;
  Future<Null> getNewFeedsFollow() async {
    //ฟิดที่เรากดติดตาม
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/newfeeds";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    // print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      final String responseString = response.body;

      newFeedsFollow = newFeedsFollowFromJson(responseString);
      setState(() {});
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0), child: AppBar()),
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: new PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: new Container(
                color: Colors.white70,
                child: new SafeArea(
                  child: Column(
                    children: <Widget>[
                      new Expanded(child: new Container()),
                      new TabBar(
                        tabs: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Text(
                              "หน้าแรก",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Text(
                              "การติดตาม",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: TabBarView(children: [
              (dataNewfeedsglobal == null)
                  ? Container()
                  : GridView.builder(
                      // scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        // maxCrossAxisExtent: 200,
                        mainAxisExtent: 290,

                        maxCrossAxisExtent:
                            (deviceSize.width > 400) ? 250 : 200,
                      ),
                      itemCount:
                          ((dummyListDataNewfeedsglobal.length + 1) % 2 != 0)
                              ? dummyListDataNewfeedsglobal.length
                              : dummyListDataNewfeedsglobal.length + 1,
                      itemBuilder: (BuildContext ctx, index) {
                        if (index == dataNewfeedsglobal.length) {
                          return Center(
                            child: Container(),
                          );
                        }
                        if (index == dummyListDataNewfeedsglobal.length) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Center(child: CupertinoActivityIndicator()),
                            ],
                          );
                        }
                        return InkWell(
                          onTap: () {
                            print(deviceSize.width);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => ShowFood(
                            //           dataNewfeedsglobal[index]
                            //               .rid)),
                            // );
                          },
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          new Container(
                                            height: 30.0,
                                            width: 30.0,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: new NetworkImage(
                                                        dummyListDataNewfeedsglobal[
                                                                index]
                                                            .profileImage))),
                                          ),
                                          new SizedBox(
                                            width: 10.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                new Text(
                                                  dummyListDataNewfeedsglobal[
                                                          index]
                                                      .aliasName,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                new Text(
                                                  "1 นาทีที่แล้ว",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.more_vert),
                                          onPressed: () {
                                            // print("more_vert" + index.toString());
                                          })
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 0, 0, 4),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          dummyListDataNewfeedsglobal[index]
                                              .recipeName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // SizedBox(height: 19,),

                                Container(
                                  height: 161,
                                  // width: 500,
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/logos/loadding.gif',
                                    image: dummyListDataNewfeedsglobal[index]
                                        .image,
                                  ),
                                  // decoration: BoxDecoration(
                                  //     // borderRadius: BorderRadius.circular(50),
                                  //     image: DecorationImage(
                                  //         image: NetworkImage(
                                  //             dummyListDataNewfeedsglobal[index]
                                  //                 .image),
                                  //         fit: BoxFit.cover)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RatingBarIndicator(
                                        rating: 3,
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: Colors.blue,
                                        ),
                                        itemCount: 5,
                                        itemSize: 16,
                                      ),
                                      Text("ฟรี"),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
              (newFeedsFollow == null)
                  ? Container()
                  : ListView.builder(
                      itemCount: newFeedsFollow.feed.length,
                      itemBuilder: (context, index) => index < 0
                          ? new SizedBox(
                              child: AlertDialog(
                                  content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("กรุณารอสักครู่...   "),
                                  CircularProgressIndicator()
                                ],
                              )),
                            )
                          : Container(
                              // height: 500,
                              width: 280,
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              new Container(
                                                height: 30.0,
                                                width: 30.0,
                                                decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: new DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: new NetworkImage(
                                                            newFeedsFollow
                                                                .feed[index]
                                                                .profileImage))),
                                              ),
                                              new SizedBox(
                                                width: 10.0,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 8, 0, 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    new Text(
                                                      newFeedsFollow.feed[index]
                                                          .aliasName,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    new Text(
                                                      newFeedsFollow
                                                          .feed[index].date
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.more_vert),
                                              onPressed: () {
                                                // print("more_vert" + index.toString());
                                              })
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            newFeedsFollow
                                                .feed[index].recipeName,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "4.2",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 12.0,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 12.0,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 12.0,
                                              ),
                                              Icon(
                                                Icons.star_half,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 12.0,
                                              ),
                                              Icon(
                                                Icons.star_border,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 12.0,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "(12)",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 310,
                                      // width: 500,
                                      decoration: BoxDecoration(
                                          // borderRadius: BorderRadius.circular(50),
                                          image: DecorationImage(
                                              image: NetworkImage(newFeedsFollow
                                                  .feed[index].image),
                                              fit: BoxFit.cover)),
                                    ),
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                margin: EdgeInsets.all(10),
                              ),
                            ),
                    )
            ]),
          ),
        ));
  }
}
