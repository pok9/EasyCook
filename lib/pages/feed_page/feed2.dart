import 'package:easy_cook/models/feed/newFeedsFollow_model.dart';
import 'package:easy_cook/models/feed/newfeedsglobal/newfeedsglobal.dart';
import 'package:easy_cook/models/myBuy/mybuy.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/pages/buyFood_page/recipe_purchase_page.dart';
import 'package:easy_cook/pages/drawer/drawers.dart';
import 'package:easy_cook/pages/showFood&User_page/XXX_showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
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

      if (token != "" && token != null) {
        getNewFeedsFollow();
        getMybuy();
        getMyAccounts();
      }
    });
  }

  //ข้อมูลตัวเอง
  MyAccount data_MyAccount;
  DataMyAccount data_DataAc;
  Future<Null> getMyAccounts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        data_MyAccount = myAccountFromJson(responseString);
        data_DataAc = data_MyAccount.data[0];
      });
    } else {
      return null;
    }
  }

  List<Mybuy> dataMybuy;
  List<String> checkBuy = [];
  Future<Null> getMybuy() async {
    checkBuy = [];
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/mybuy";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          final String responseString = response.body;

          dataMybuy = mybuyFromJson(responseString);
          for (var item in dataMybuy) {
            checkBuy.add(item.recipeId.toString());
          }
        });
    } else {
      return null;
    }
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
      if (mounted)
        setState(() {
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
        });
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
      if (mounted)
        setState(() {
          final String responseString = response.body;

          newFeedsFollow = newFeedsFollowFromJson(responseString);
        });
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: AppBar(
              title: Text('สูตรล่าสุด'),
            )),
        drawer: Drawers(
          token: token,
          data_MyAccount: data_MyAccount,
          data_DataAc: data_DataAc,
        ),
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            // backgroundColor: Color(0xFFf3f5f9),
            backgroundColor: Colors.white,
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
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisExtent: 250,
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
                            if (dummyListDataNewfeedsglobal[index].price == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShowFood(
                                        dummyListDataNewfeedsglobal[index]
                                            .rid)),
                              ).then((value) => {getNewfeedsglobal()});
                            } else {
                              if (data_DataAc == null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RecipePurchasePage(
                                            req_rid:
                                                dummyListDataNewfeedsglobal[
                                                        index]
                                                    .rid,
                                          )),
                                ).then((value) => {getNewfeedsglobal()});
                              } else {
                                if (data_DataAc.userId ==
                                        dummyListDataNewfeedsglobal[index]
                                            .userId ||
                                    checkBuy.indexOf(
                                            dummyListDataNewfeedsglobal[index]
                                                .rid
                                                .toString()) >=
                                        0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowFood(
                                            dummyListDataNewfeedsglobal[index]
                                                .rid)),
                                  ).then((value) => {getNewfeedsglobal()});
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RecipePurchasePage(
                                              req_rid:
                                                  dummyListDataNewfeedsglobal[
                                                          index]
                                                      .rid,
                                            )),
                                  ).then((value) => {
                                        if (token != "" && token != null)
                                          {getMybuy(), getNewfeedsglobal()}
                                      });
                                }
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 170,
                                      // width: 250,

                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          // borderRadius: BorderRadius.circular(50),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  dummyListDataNewfeedsglobal[
                                                          index]
                                                      .image),
                                              fit: BoxFit.cover)),
                                    ),
                                    (dummyListDataNewfeedsglobal[index].price ==
                                            0)
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8, right: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Stack(
                                                  children: [
                                                    (data_DataAc == null)
                                                        ? CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            radius: 16,
                                                          )
                                                        : (data_DataAc.userId ==
                                                                dummyListDataNewfeedsglobal[
                                                                        index]
                                                                    .userId)
                                                            ? Container()
                                                            : CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                radius: 16,
                                                              ),
                                                    Positioned(
                                                      top: 1,
                                                      right: 1,
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        child: (data_DataAc ==
                                                                null)
                                                            ? Image.network(
                                                                "https://image.flaticon.com/icons/png/512/1177/1177428.png")
                                                            : (data_DataAc
                                                                        .userId ==
                                                                    dummyListDataNewfeedsglobal[
                                                                            index]
                                                                        .userId)
                                                                ? Container()
                                                                : (checkBuy.indexOf(dummyListDataNewfeedsglobal[index]
                                                                            .rid
                                                                            .toString()) >=
                                                                        0)
                                                                    ? Image.network(
                                                                        "https://image.flaticon.com/icons/png/512/1053/1053171.png")
                                                                    : Image.network(
                                                                        "https://image.flaticon.com/icons/png/512/1177/1177428.png"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 2, 4, 0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        children: [
                                          new Container(
                                            height: 20.0,
                                            width: 20.0,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: new NetworkImage(
                                                        dummyListDataNewfeedsglobal[
                                                                index]
                                                            .profileImage))),
                                          ),
                                        ],
                                      ),
                                      new SizedBox(
                                        width: 10.0,
                                      ),
                                      Expanded(
                                        child: new Text(
                                          dummyListDataNewfeedsglobal[index]
                                              .aliasName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      (dummyListDataNewfeedsglobal[index]
                                                  .score ==
                                              0)
                                          ? Container()
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 8, 0, 0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.blue,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 1,
                                                  ),
                                                  Text(
                                                    dummyListDataNewfeedsglobal[
                                                                index]
                                                            .score
                                                            .toString() +
                                                        "/5",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text(
                                                    '(${dummyListDataNewfeedsglobal[index].count})',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          dummyListDataNewfeedsglobal[index]
                                              .recipeName,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.justify,
                                          // style: TextStyle(

                                          //     color: Colors.black,
                                          //     fontSize: 15),
                                          style: GoogleFonts.lato(fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(child: Container()),
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
                                            style: GoogleFonts.lato(),
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
