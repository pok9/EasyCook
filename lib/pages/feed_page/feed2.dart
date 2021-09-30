import 'package:easy_cook/models/feed/newFeedsFollow_model.dart';
import 'package:easy_cook/models/feed/newfeedsglobal/newfeedsglobal.dart';
import 'package:easy_cook/models/myBuy/mybuy.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/pages/addFood_page/addFood.dart';
import 'package:easy_cook/pages/buyFood_page/recipe_purchase_page.dart';
import 'package:easy_cook/pages/drawer/drawers.dart';
import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:easy_cook/pages/showFood&User_page/XXX_showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood/showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
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

    if (selected == 0) {
      _currentMax = dummyListDataNewfeedsglobal.length;

      if ((dataNewfeedsglobal.length - dummyListDataNewfeedsglobal.length) >=
          4) {
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
    } else if (selected == 1) {
      _currentMax = dummyListDataNewfeedsglobal_free.length;

      if ((dataNewfeedsglobal.length -
              dummyListDataNewfeedsglobal_free.length) >=
          4) {
        for (int i = dummyListDataNewfeedsglobal_free.length;
            i < _currentMax + 4;
            i++) {
          dummyListDataNewfeedsglobal_free.add(dataNewfeedsglobal[i]);
        }
      } else {
        for (int i = dummyListDataNewfeedsglobal_free.length;
            i < dataNewfeedsglobal.length;
            i++) {
          dummyListDataNewfeedsglobal_free.add(dataNewfeedsglobal[i]);
        }
      }
    } else if (selected == 2) {
      _currentMax = dummyListDataNewfeedsglobal_notFree.length;

      if ((dataNewfeedsglobal.length -
              dummyListDataNewfeedsglobal_notFree.length) >=
          4) {
        for (int i = dummyListDataNewfeedsglobal_notFree.length;
            i < _currentMax + 4;
            i++) {
          dummyListDataNewfeedsglobal_notFree.add(dataNewfeedsglobal[i]);
        }
      } else {
        for (int i = dummyListDataNewfeedsglobal_notFree.length;
            i < dataNewfeedsglobal.length;
            i++) {
          dummyListDataNewfeedsglobal_notFree.add(dataNewfeedsglobal[i]);
        }
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
  List<Newfeedsglobal> dummyListDataNewfeedsglobal_free;
  List<Newfeedsglobal> dummyListDataNewfeedsglobal_notFree;
  Future<Null> getNewfeedsglobal() async {
    dummyListDataNewfeedsglobal = [];
    dummyListDataNewfeedsglobal_free = [];
    dummyListDataNewfeedsglobal_notFree = [];
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
              if (dataNewfeedsglobal[i].price > 0) {
                dummyListDataNewfeedsglobal_notFree.add(dataNewfeedsglobal[i]);
              } else {
                dummyListDataNewfeedsglobal_free.add(dataNewfeedsglobal[i]);
              }
            }
          } else {
            for (int i = 0; i < dataNewfeedsglobal.length; i++) {
              dummyListDataNewfeedsglobal.add(dataNewfeedsglobal[i]);
              if (dataNewfeedsglobal[i].price > 0) {
                dummyListDataNewfeedsglobal_notFree.add(dataNewfeedsglobal[i]);
              } else {
                dummyListDataNewfeedsglobal_free.add(dataNewfeedsglobal[i]);
              }
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

  String dateEdit(String date) {
    //data
    Map<String, String> map = {
      '01': "มกราคม",
      '02': "กุมภาพันธ์",
      '03': "มีนาคม",
      '04': "เมษายน",
      '05': "พฤษภาคม",
      '06': "มิถุนายน",
      '07': "กรกฎาคม",
      '08': "สิงหาคม",
      '09': "กันยายน",
      '10': "ตุลาคม",
      '11': "พฤศจิกายน",
      '12': "ธันวาคม"
    };
    List<String> dateTimeSp = date.split(" ");
    List<String> dateSp = dateTimeSp[0].split("-");

    //time
    List timeSp = dateTimeSp[1].split(".");
    List time = timeSp[0].split(":");

    String text =
        "${dateSp[2]} ${map[dateSp[1]]} เวลา ${time[0]}:${time[1]} น.";
    return text;
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xFFf3f5f9),
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

            // backgroundColor: Colors.white,
            // backgroundColor: Color(0xFFF5F5F5),
            backgroundColor: Color(0xFFf3f5f9),
            appBar: new PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: new Container(
                color: Color(0xFFf3f5f9),
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
            body: OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
              ) {
                final bool connected = connectivity != ConnectivityResult.none;
                return (connected)
                    ? body(deviceSize, context)
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      height: 100,
                                      width: 100,
                                      child: Image.asset(
                                          'assets/images/hambergerGray.png'))
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "คุณออฟไลน์อยู่",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "ตรวจสอบการเชื่อมต่อของคุณ",
                                  style: TextStyle(fontSize: 15),
                                )
                              ],
                            )
                          ],
                        ),
                      );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    'There are no bottons to push :)',
                  ),
                  new Text(
                    'Just turn off your internet.',
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  int selected = 0;
  List<String> txtLatest_recipe = ["ทั้งหมด", "ฟรี", "ไม่ฟรี"];
  TabBarView body(Size deviceSize, BuildContext context) {
    return TabBarView(children: [
      (dataNewfeedsglobal == null)
          ? Center(child: Center(child: CupertinoActivityIndicator()))
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  selected = index;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: selected == index
                                      ? Colors.blue
                                      : Colors.white,
                                ),
                                child: Text(
                                  txtLatest_recipe[index],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: selected == index
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                        separatorBuilder: (_, index) => SizedBox(
                              width: 15,
                            ),
                        itemCount: 3),
                  ),
                ),
                // bodyFeed2(dummyListDataNewfeedsglobal, deviceSize, context)
                (selected == 0)
                    ? bodyFeed2(
                        dummyListDataNewfeedsglobal, deviceSize, context)
                    : (selected == 1)
                        ? bodyFeed2(dummyListDataNewfeedsglobal_free,
                            deviceSize, context)
                        : bodyFeed2(dummyListDataNewfeedsglobal_notFree,
                            deviceSize, context),
              ],
            ),
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
                  : InkWell(
                      onTap: () {
                        if (newFeedsFollow.feed[index].price == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ShowFood(newFeedsFollow.feed[index].rid)),
                          ).then((value) => {getNewfeedsglobal()});
                        } else {
                          if (data_DataAc == null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecipePurchasePage(
                                        req_rid: newFeedsFollow.feed[index].rid,
                                      )),
                            ).then((value) => {getNewfeedsglobal()});
                          } else {
                            if (data_DataAc.userId ==
                                    newFeedsFollow.feed[index].userId ||
                                checkBuy.indexOf(newFeedsFollow.feed[index].rid
                                        .toString()) >=
                                    0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShowFood(
                                        newFeedsFollow.feed[index].rid)),
                              ).then((value) => {getNewfeedsglobal()});
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RecipePurchasePage(
                                          req_rid:
                                              newFeedsFollow.feed[index].rid,
                                        )),
                              ).then((value) => {
                                    if (token != "" && token != null)
                                      {getMybuy(), getNewfeedsglobal()}
                                  });
                            }
                          }
                        }
                      },
                      child: Container(
                        // height: 500,
                        width: 280,
                        child: Column(
                          children: [
                            Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    child: InkWell(
                                      onTap: () {
                                        if (token == "") {
                                          Navigator.push(context,
                                              CupertinoPageRoute(
                                                  builder: (context) {
                                            return ProfileUser(
                                              reqUid: newFeedsFollow
                                                  .feed[index].userId,
                                            );
                                          }));
                                        } else if (data_DataAc.userId ==
                                            newFeedsFollow.feed[index].userId) {
                                          Navigator.push(context,
                                              CupertinoPageRoute(
                                                  builder: (context) {
                                            return ProfilePage();
                                          }));
                                        } else {
                                          Navigator.push(context,
                                              CupertinoPageRoute(
                                                  builder: (context) {
                                            return ProfileUser(
                                              reqUid: newFeedsFollow
                                                  .feed[index].userId,
                                            );
                                          }));
                                        }
                                      },
                                      child: Row(
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
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 8, 0, 8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  new Text(
                                                    newFeedsFollow
                                                        .feed[index].aliasName,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  new Text(
                                                    dateEdit(newFeedsFollow
                                                        .feed[index].date
                                                        .toString()),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            newFeedsFollow.feed[index].recipeName,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        height: 310,
                                        // width: 500,
                                        decoration: BoxDecoration(
                                            // borderRadius: BorderRadius.circular(50),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    newFeedsFollow
                                                        .feed[index].image),
                                                fit: BoxFit.cover)),
                                      ),
                                      (newFeedsFollow.feed[index].price == 0)
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
                                                          : (data_DataAc
                                                                      .userId ==
                                                                  newFeedsFollow
                                                                      .feed[
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
                                                                      newFeedsFollow
                                                                          .feed[
                                                                              index]
                                                                          .userId)
                                                                  ? Container()
                                                                  : (checkBuy.indexOf(newFeedsFollow
                                                                              .feed[
                                                                                  index]
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
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 5,
                              margin: EdgeInsets.all(10),
                            ),
                          ],
                        ),
                      ),
                    ),
            )
    ]);
  }

  GridView bodyFeed2(List<Newfeedsglobal> dummyListDataNewfeedsglobal,
      Size deviceSize, BuildContext context) {
    return GridView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisExtent: 250,
          maxCrossAxisExtent: (deviceSize.width > 400) ? 250 : 200,
        ),
        itemCount: ((dummyListDataNewfeedsglobal.length + 1) % 2 != 0)
            ? dummyListDataNewfeedsglobal.length
            : dummyListDataNewfeedsglobal.length + 1,
        itemBuilder: (BuildContext ctx, index) {
          if (index == dummyListDataNewfeedsglobal.length) {
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
                      builder: (context) =>
                          ShowFood(dummyListDataNewfeedsglobal[index].rid)),
                ).then((value) => {getNewfeedsglobal()});
              } else {
                if (data_DataAc == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RecipePurchasePage(
                              req_rid: dummyListDataNewfeedsglobal[index].rid,
                            )),
                  ).then((value) => {getNewfeedsglobal()});
                } else {
                  if (data_DataAc.userId ==
                          dummyListDataNewfeedsglobal[index].userId ||
                      checkBuy.indexOf(dummyListDataNewfeedsglobal[index]
                              .rid
                              .toString()) >=
                          0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ShowFood(dummyListDataNewfeedsglobal[index].rid)),
                    ).then((value) => {getNewfeedsglobal()});
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecipePurchasePage(
                                req_rid: dummyListDataNewfeedsglobal[index].rid,
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

                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(5),
                        //     image: DecorationImage(
                        //         image: NetworkImage(
                        //             dummyListDataNewfeedsglobal[index]
                        //                 .image),
                        //         fit: BoxFit.cover)),

                        // child: FadeInImage.assetNetwork(

                        //   placeholder: "assets/loadGif/loadding2.gif",
                        //   image: dummyListDataNewfeedsglobal[index].image,
                        //   fit: BoxFit.cover,
                        // ),

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/loadGif/loadding2.gif",
                            image: dummyListDataNewfeedsglobal[index].image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      (dummyListDataNewfeedsglobal[index].price == 0)
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8, right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Stack(
                                    children: [
                                      (data_DataAc == null)
                                          ? CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 16,
                                            )
                                          : (data_DataAc.userId ==
                                                  dummyListDataNewfeedsglobal[
                                                          index]
                                                      .userId)
                                              ? Container()
                                              : CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 16,
                                                ),
                                      Positioned(
                                        top: 1,
                                        right: 1,
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          child: (data_DataAc == null)
                                              ? Image.network(
                                                  "https://image.flaticon.com/icons/png/512/1177/1177428.png")
                                              : (data_DataAc.userId ==
                                                      dummyListDataNewfeedsglobal[
                                                              index]
                                                          .userId)
                                                  ? Container()
                                                  : (checkBuy.indexOf(
                                                              dummyListDataNewfeedsglobal[
                                                                      index]
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
                    padding: const EdgeInsets.fromLTRB(4, 2, 4, 0),
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
                                          dummyListDataNewfeedsglobal[index]
                                              .profileImage))),
                            ),
                          ],
                        ),
                        new SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: new Text(
                            dummyListDataNewfeedsglobal[index].aliasName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        (dummyListDataNewfeedsglobal[index].score == 0)
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                                      dummyListDataNewfeedsglobal[index]
                                              .score
                                              .toString() +
                                          "/5",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            dummyListDataNewfeedsglobal[index].recipeName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            // style: TextStyle(

                            //     color: Colors.black,
                            //     fontSize: 15),
                            style: TextStyle(fontSize: 15),
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
        });
  }
}
