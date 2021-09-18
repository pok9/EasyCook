import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_cook/models/checkFollower_checkFollowing/checkFollowing_model.dart';
import 'package:easy_cook/models/feed/newFeedsFollow_model.dart';
import 'package:easy_cook/models/feed/newfeedsglobal/newfeedsglobal.dart';
import 'package:easy_cook/models/feed/popularRecipe/popularRecipeModel.dart';
import 'package:easy_cook/models/feed/recommendRecipe/recommendRecipe.dart';
import 'package:easy_cook/models/feed/recommendUser/recommendUser.dart';
import 'package:easy_cook/models/follow/manageFollow_model.dart';
import 'package:easy_cook/models/login/login_model.dart';
import 'package:easy_cook/models/myBuy/mybuy.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/pages/buyFood_page/purchasedRecipes/purchasedRecipes.dart';
import 'package:easy_cook/pages/buyFood_page/recipe_purchase_page.dart';
import 'package:easy_cook/pages/drawer/drawers.dart';
import 'package:easy_cook/pages/drawer/helpCenter/helpCenter.dart';
import 'package:easy_cook/pages/feed_page/feed/recommendPage.dart';

import 'package:easy_cook/pages/login&register_page/login_page/login.dart';

import 'package:easy_cook/pages/profile_page/profile.dart';

import 'package:easy_cook/pages/showFood&User_page/XXX_showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:easy_cook/slidepage.dart';
import 'package:easy_cook/style/utiltties.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FeedPage extends StatefulWidget {
  const FeedPage({Key key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  PageController pageController = PageController();
  int pageCount = 2;

  @override
  void initState() {
    super.initState();

    findUser();

    getRecommendRecipe();

    getPopularRecipe_free_and_not_free();
    getPopularRecipe_free();
    getPopularRecipe_not_free();

    getRecommendUser();

    Timer.periodic(Duration(seconds: 3), (timer) {
      if (!pageController.hasClients) {
        return;
      }
      if (pageController.page >= pageCount - 1) {
        pageController.animateToPage(0,
            duration: Duration(milliseconds: 5000),
            curve: Curves.fastLinearToSlowEaseIn);
      } else {
        pageController.nextPage(
            duration: Duration(milliseconds: 5000),
            curve: Curves.fastLinearToSlowEaseIn);
      }
    });
  }

  String token = ""; //โทเคน
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
      print("Token >>> $token");
      if (token != "" && token != null) {
        getMyAccounts();
      }
    });
  }

  //user
  MyAccount data_MyAccount;
  DataMyAccount data_DataAc;
  Future<Null> getMyAccounts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          final String responseString = response.body;

          data_MyAccount = myAccountFromJson(responseString);
          data_DataAc = data_MyAccount.data[0];

          checkFollowings();
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
    print("responseFeed_follow = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          final String responseString = response.body;

          dataMybuy = mybuyFromJson(responseString);
          for (var item in dataMybuy) {
            print(item.recipeId);
            checkBuy.add(item.recipeId.toString());
          }
        });
    } else {
      return null;
    }
  }

  CheckFollowing dataCheckFollowing;
  List<String> checkFollowing = [];
  // List<bool> checkFollowing = [];

  Future<Null> checkFollowings() async {
    checkFollowing = [];
    final String apiUrl =
        "http://apifood.comsciproject.com/pjFollow/checkFollowing/${data_DataAc.userId}";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          final String responseString = response.body;
          dataCheckFollowing = checkFollowingFromJson(responseString);

          for (var item in dataCheckFollowing.user) {
            checkFollowing.add(item.userId.toString());
          }
          print(checkFollowing);
        });
    } else {
      return null;
    }
  }

  List<RecommendRecipe> dataRecommendRecipe;

  Future<Null> getRecommendRecipe() async {
    //ฟิดที่เรากดติดตาม
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/recommendRecipe";

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          final String responseString = response.body;

          dataRecommendRecipe = recommendRecipeFromJson(responseString);
          if (token != "" && token != null) {
            getMybuy();
          }
        });
    } else {
      return null;
    }
  }

  //สูตรอาหารฟรีและไม่ฟรียอดนิยม
  List<PopularRecipeModel> dataPopularRecipe_free_and_not_free;
  Future<Null> getPopularRecipe_free_and_not_free() async {
    //ฟิดที่เรากดติดตาม
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/popular_recipe_free";

    final response = await http.get(Uri.parse(apiUrl));
    // print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          final String responseString = response.body;

          dataPopularRecipe_free_and_not_free =
              popularRecipeModelFromJson(responseString);
          if (token != "" && token != null) {
            getMybuy();
          }
        });
    } else {
      return null;
    }
  }

  //สูตรอาหารฟรียอดนิยม
  List<PopularRecipeModel> dataPopularRecipe_free;
  Future<Null> getPopularRecipe_free() async {
    //ฟิดที่เรากดติดตาม
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/popular_recipe_free";

    final response = await http.get(Uri.parse(apiUrl));
    // print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          final String responseString = response.body;

          dataPopularRecipe_free = popularRecipeModelFromJson(responseString);
          if (token != "" && token != null) {
            getMybuy();
          }
        });
    } else {
      return null;
    }
  }

  //สูตรอาหารไม่ฟรียอดนิยม
  List<PopularRecipeModel> dataPopularRecipe_not_free;
  Future<Null> getPopularRecipe_not_free() async {
    //ฟิดที่เรากดติดตาม
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/popular_recipe_price";

    final response = await http.get(Uri.parse(apiUrl));
    // print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          final String responseString = response.body;

          dataPopularRecipe_not_free =
              popularRecipeModelFromJson(responseString);
          if (token != "" && token != null) {
            getMybuy();
          }
        });
    } else {
      return null;
    }
  }

  List<RecommendUser> dataRecommendUser;
  Future<Null> getRecommendUser() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjUsers/recommendUser";

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          final String responseString = response.body;

          dataRecommendUser = recommendUserFromJson(responseString);
        });
    } else {
      return null;
    }
  }

  LoginModel login;
  Future<Null> logins(String email, String password) async {
    // final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signin";

    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signin";

    final response = await http
        .post(Uri.parse(apiUrl), body: {"email": email, "password": password});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      login = loginModelFromJson(responseString);
    } else {
      return null;
    }
  }

  TextEditingController _ctrlEmail = TextEditingController(); //email
  TextEditingController _ctrlPassword = TextEditingController(); // password
  final _formKey = GlobalKey<FormState>();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  //จัดการติดตามหรือยกเลิกติดตาม
  Future<Null> manageFollow(String state, int following_ID) async {
    // final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signin";

    final String apiUrl =
        "http://apifood.comsciproject.com/pjFollow/ManageFollow";
    final response = await http.post(Uri.parse(apiUrl),
        body: {"state": state, "following_ID": following_ID.toString()},
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      final String responseString = response.body;
      ManageFollow aa = manageFollowFromJson(responseString);
      print(aa.success);

      checkFollowings();
    } else {
      return null;
    }
  }

  Future<Null> insertNotificationData(
    String my_ID,
    String state,
    String description,
    String recipe_ID,
    String from_userid,
    String status,
  ) async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjNoti/insertNotificationData";

    // List<st>
    var data = {
      "my_ID": my_ID,
      "state": state,
      "description": description,
      "recipe_ID": recipe_ID,
      "from_userid": from_userid,
      "status": status
    };
    print("jsonEncode(data)InsertNotificationData = " + jsonEncode(data));
    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data), headers: {"Content-Type": "application/json"});

    print(
        "response.statusCodeInsertNotificationData => ${response.statusCode}");
    print("response.bodyInsertNotificationData => ${response.body}");
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: Colors.white70,
      backgroundColor: Color(0xFFf3f5f9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 20.0,
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText('Easy Cook'),
                TypewriterAnimatedText('Easy Cook'),
                WavyAnimatedText('Easy Cook'),
                // WavyAnimatedText('ชุมชนของคนรักการทําอาหาร'),
              ],
              isRepeatingAnimation: true,
              onTap: () {
                print("Tap Event");
              },
            ),
          ),
        ),
      ),
      drawer: Drawers(
        token: token,
        data_MyAccount: data_MyAccount,
        data_DataAc: data_DataAc,
      ),

      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return (connected)
              ? body(context)
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
                                fontSize: 20, fontWeight: FontWeight.bold),
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
    );
  }

  RefreshIndicator body(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: findUser,
      child: Container(
        child: ListView(
          children: [
            LimitedBox(
              maxHeight: 250,
              child: Stack(
                children: [
                  PageView(
                    controller: pageController,
                    children: [
                      AdsSlideCard(
                        slideImage:
                            "https://pbs.twimg.com/media/ESUlHHKUcAIYNfb.jpg",
                      ),
                      AdsSlideCard(
                        slideImage:
                            "http://i2.wp.com/www.thaismescenter.com/wp-content/uploads/2019/10/74.jpg?resize=660%2C655",
                      ),
                      AdsSlideCard(
                        slideImage:
                            "https://scm-assets.constant.co/scm/unilever/e9dc924f238fa6cc29465942875fe8f0/f9f93df5-dfe0-4c78-98ff-a05380282039.jpg",
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 18.0,
                    left: 0.0,
                    right: 0.0,
                    child: Center(
                      child: SlideIndicator(
                        pageController: pageController,
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: GridView.count(
            //     shrinkWrap: true,
            //     physics: NeverScrollableScrollPhysics(),
            //     crossAxisCount: 4,
            //     children: [
            //       MenuFeature(
            //         iconAsset:
            //             "https://image.flaticon.com/icons/png/128/5019/5019495.png",
            //         name: "test",
            //       ),
            //       MenuFeature(
            //         iconAsset:
            //             "https://image.flaticon.com/icons/png/128/5019/5019428.png",
            //         name: "test",
            //       ),
            //       MenuFeature(
            //         iconAsset:
            //             "https://image.flaticon.com/icons/png/128/5019/5019512.png",
            //         name: "test",
            //       ),
            //       MenuFeature(
            //         iconAsset:
            //             "https://image.flaticon.com/icons/png/128/5019/5019453.png",
            //         name: "test",
            //       ),
            //       MenuFeature(
            //         iconAsset:
            //             "https://image.flaticon.com/icons/png/128/5019/5019437.png",
            //         name: "test",
            //       ),
            //       MenuFeature(
            //         iconAsset:
            //             "https://image.flaticon.com/icons/png/512/5019/5019349.png",
            //         name: "test",
            //       ),
            //       MenuFeature(
            //         iconAsset:
            //             "https://image.flaticon.com/icons/png/128/5019/5019501.png",
            //         name: "test",
            //       ),
            //       MenuFeature(
            //         iconAsset:
            //             "https://image.flaticon.com/icons/png/128/5018/5018006.png",
            //         name: "test",
            //       ),
            //     ],
            //   ),
            // ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DividerCutom(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "สูตรอาหารยอดนิยม1",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_forward_rounded, color: Colors.indigo)
                    ],
                  ),
                ),
                Container(
                    height: 300,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return _foodCard_1(context);
                        })),
                DividerCutom(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "สูตรอาหารยอดนิยม2",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_forward_rounded, color: Colors.indigo)
                      // Text(
                      //   "ดูทั้งหมด",
                      //   style: TextStyle(
                      //       fontSize: 20, fontWeight: FontWeight.normal),
                      // ),
                    ],
                  ),
                ),
                Container(
                    height: 300,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return _foodCard_2(context);
                        })),
                DividerCutom(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "วัตถุดิบแนะนำยอดนิยม",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_forward_rounded, color: Colors.indigo)
                      // Text(
                      //   "ดูทั้งหมด",
                      //   style: TextStyle(
                      //       fontSize: 20, fontWeight: FontWeight.normal),
                      // ),
                    ],
                  ),
                ),
                ingredients(),

                DividerCutom(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    children: [
                      Text(
                        "swipe",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                (dataRecommendRecipe == null)
                    ? Container(
                        // height: 0,
                        height: 0,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          padding: EdgeInsets.zero,
                          height: deviceSize.height * 0.6,
                          // height: deviceSize.height,
                          child: TinderSwapCard(
                            totalNum: dataRecommendRecipe.length,
                            maxHeight: deviceSize.height * 0.5,
                            minHeight: deviceSize.height * 0.39,
                            maxWidth: deviceSize.width ,
                            minWidth: deviceSize.width * 0.4,

                            // maxHeight: deviceSize.height * 0.7,
                            // minHeight: deviceSize.height * 0.2,
                            // maxWidth: deviceSize.width,
                            // minWidth: deviceSize.width * 0.5,

                            // maxHeight: deviceSize.height * 0.75,
                            // minHeight: deviceSize.height * 0.6,
                            // maxWidth: deviceSize.width,
                            // minWidth: deviceSize.width * 0.75,
                            cardBuilder: (context, index) => InkWell(
                              onTap: () {
                                if (data_DataAc != null) {
                                  if (dataRecommendRecipe[index].price == 0 ||
                                      dataRecommendRecipe[index].userId ==
                                          data_DataAc.userId ||
                                      checkBuy.indexOf(
                                              dataRecommendRecipe[index]
                                                  .rid
                                                  .toString()) >=
                                          0) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShowFood(
                                              dataRecommendRecipe[index].rid)),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RecipePurchasePage(
                                                req_rid:
                                                    dataRecommendRecipe[index]
                                                        .rid,
                                              )),
                                    ).then((value) {
                                      if (token != "" && token != null) {
                                        getMybuy();
                                      }
                                    });
                                  }
                                } else {
                                  if (dataRecommendRecipe[index].price == 0) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShowFood(
                                              dataRecommendRecipe[index].rid)),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RecipePurchasePage(
                                                req_rid:
                                                    dataRecommendRecipe[index]
                                                        .rid,
                                              )),
                                    ).then((value) {
                                      if (token != "" && token != null) {
                                        getMybuy();
                                      }
                                    });
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          blurRadius: 5,
                                          spreadRadius: 2)
                                    ]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: deviceSize.width,
                                        height: deviceSize.height,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    dataRecommendRecipe[index]
                                                        .image),
                                                fit: BoxFit.cover)),
                                      ),
                                      // Container(
                                      //   width: deviceSize.width,
                                      //   height: deviceSize.height,
                                      //   decoration: BoxDecoration(
                                      //       gradient: LinearGradient(
                                      //           colors: [
                                      //         Colors.black.withOpacity(0.25),
                                      //         Colors.black.withOpacity(0)
                                      //       ],
                                      //           end: Alignment.topCenter,
                                      //           begin: Alignment.bottomCenter)),
                                      //   child: Column(
                                      //     crossAxisAlignment: CrossAxisAlignment.start,
                                      //     mainAxisAlignment: MainAxisAlignment.end,
                                      //     children: [
                                      //       Row(
                                      //         children: [
                                      //           Container(
                                      //             width: deviceSize.width * 0.72,
                                      //             child: Column(
                                      //               children: [
                                      //                 Row(
                                      //                   children: [
                                      //                     Text(
                                      //                       dataRecommendRecipe[index]
                                      //                           .recipeName,
                                      //                       style: TextStyle(
                                      //                           fontSize: 24,
                                      //                           color: Colors.white,
                                      //                           fontWeight:
                                      //                               FontWeight.bold),
                                      //                     ),
                                      //                     SizedBox(width: 10,),
                                      //                    Text(
                                      //                       dataRecommendRecipe[index]
                                      //                           .recipeName,
                                      //                       style: TextStyle(
                                      //                           fontSize: 24,
                                      //                           color: Colors.white,
                                      //                           fontWeight:
                                      //                               FontWeight.bold),
                                      //                     ),
                                      //                   ],
                                      //                 )
                                      //               ],
                                      //             ),
                                      //           )
                                      //         ],
                                      //       )
                                      //     ],
                                      //   ),
                                      // )
                                      (dataRecommendRecipe[index].score == 0)
                                          ? Container()
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      16, 16, 0, 0),
                                              child: Row(
                                                // crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.blue,
                                                    size: 20,
                                                  ),
                                                  SizedBox(
                                                    width: 1,
                                                  ),
                                                  Text(
                                                    dataRecommendRecipe[index]
                                                        .score
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text(
                                                    '(4)',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      (dataRecommendRecipe[index].price == 0)
                                          ? Container()
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 16, right: 16),
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
                                                                  dataRecommendRecipe[
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
                                                                      dataRecommendRecipe[
                                                                              index]
                                                                          .userId)
                                                                  ? Container()
                                                                  : (checkBuy.indexOf(dataRecommendRecipe[index]
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
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Text(
                                            //       "testasdjasjdknkjaskdnjkasndkj",
                                            //       style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20),
                                            //     ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    dataRecommendRecipe[index]
                                                        .recipeName,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      // margin: EdgeInsets.all(100.0),
                                                      height: 32.0,
                                                      width: 32.0,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle),
                                                    ),
                                                    Positioned(
                                                      top: 1,
                                                      right: 1,
                                                      child: new Container(
                                                        height: 30.0,
                                                        width: 30.0,
                                                        decoration: new BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image: new DecorationImage(
                                                                fit:
                                                                    BoxFit.fill,
                                                                image: new NetworkImage(
                                                                    dataRecommendRecipe[
                                                                            index]
                                                                        .profileImage))),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                new SizedBox(
                                                  width: 10.0,
                                                ),
                                                new Text(
                                                  dataRecommendRecipe[index]
                                                      .aliasName,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                DividerCutom(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "แนะนำสูตรอาหาร",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecommendPage()),
                            );
                          },
                          icon: Icon(Icons.arrow_forward_rounded,
                              color: Colors.indigo))
                    ],
                  ),
                ),

                (dataRecommendRecipe == null)
                    ? Container(
                        height: 329,
                      )
                    : Container(
                        height: 300,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: dataRecommendRecipe.length,
                            itemBuilder: (context, index) {
                              return _recommendRecipeCard(
                                  context, dataRecommendRecipe[index]);
                            })),

                DividerCutom(),

                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "แนะนำเซฟ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_forward_rounded, color: Colors.indigo)
                    ],
                  ),
                ),

                (dataRecommendUser == null || checkFollowing == null)
                    ? Container(
                        height: 135,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                            height: 135,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: dataRecommendUser.length,
                                itemBuilder: (context, index) {
                                  return _introduce_safe_Card(context,
                                      dataRecommendUser[index], checkFollowing);
                                })),
                      ),

                DividerCutom(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "สูตรอาหาร ยอดนิยม",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_forward_rounded, color: Colors.indigo)
                    ],
                  ),
                ),
                (dataPopularRecipe_free_and_not_free == null)
                    ? Container(
                        height: 329,
                      )
                    : Container(
                        height: 329,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                dataPopularRecipe_free_and_not_free.length,
                            itemBuilder: (context, index) {
                              return _popular_recipe(context,
                                  dataPopularRecipe_free_and_not_free[index]);
                            })),

                DividerCutom(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "สูตรอาหารฟรี ยอดนิยม",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_forward_rounded, color: Colors.indigo)
                    ],
                  ),
                ),
                (dataPopularRecipe_free == null)
                    ? Container(
                        height: 329,
                      )
                    : Container(
                        height: 329,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: dataPopularRecipe_free.length,
                            itemBuilder: (context, index) {
                              return _popular_recipe(
                                  context, dataPopularRecipe_free[index]);
                            })),

                DividerCutom(),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "สูตรอาหารไม่ฟรี ยอดนิยม",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_forward_rounded, color: Colors.indigo)
                    ],
                  ),
                ),
                (dataPopularRecipe_not_free == null)
                    ? Container(
                        height: 329,
                      )
                    : Container(
                        height: 329,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: dataPopularRecipe_not_free.length,
                            itemBuilder: (context, index) {
                              return _popular_recipe(
                                  context, dataPopularRecipe_not_free[index]);
                            })),

                // DividerCutom(),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Padding DividerCutom() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Container(
        color: Colors.grey[300],
        height: 8,
      ),
    );
  }

  Widget _foodCard_1(context) {
    return Container(
      // height: 500,
      width: 200,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    "https://placeimg.com/640/480/any"))),
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      new Text(
                        "เซฟปก",
                        style: TextStyle(fontWeight: FontWeight.bold),
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
            Container(
              height: 160,
              // width: 250,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://1.bp.blogspot.com/-lZZ9zblXUDw/YOAODqKn24I/AAAAAAABnCo/n-VGeIW4is4BjMCuUDlHhv0B9r1kQlG9ACLcBGAsYHQ/s280/girl-s%2B%25281%2529.jpg"),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "ผัดกะเพราพิเศษใส่ไข่สูตรผีบอก ณ.ขอนแก่นasdasdasdasasdas",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                children: [
                  Text(
                    "4.2",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Theme.of(context).primaryColor,
                        size: 16.0,
                      ),
                      Icon(
                        Icons.star,
                        color: Theme.of(context).primaryColor,
                        size: 16.0,
                      ),
                      Icon(
                        Icons.star,
                        color: Theme.of(context).primaryColor,
                        size: 16.0,
                      ),
                      Icon(
                        Icons.star_half,
                        color: Theme.of(context).primaryColor,
                        size: 16.0,
                      ),
                      Icon(
                        Icons.star_border,
                        color: Theme.of(context).primaryColor,
                        size: 16.0,
                      ),
                    ],
                  ),
                  Text(
                    "(12)",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(10),
      ),
    );
  }

  Widget _foodCard_2(context) {
    return Container(
      // height: 500,
      width: 200,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    "https://placeimg.com/640/480/any"))),
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      new Text(
                        "เซฟปก",
                        style: TextStyle(fontWeight: FontWeight.bold),
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
            Container(
              height: 160,
              // width: 250,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://1.bp.blogspot.com/-lZZ9zblXUDw/YOAODqKn24I/AAAAAAABnCo/n-VGeIW4is4BjMCuUDlHhv0B9r1kQlG9ACLcBGAsYHQ/s280/girl-s%2B%25281%2529.jpg"),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "ผัดกะเพราพิเศษใส่ไข่สูตรผีบอก ณ.ขอนแก่นasdasdasdasasdas",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.black),
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
                  Text(
                    "4.2",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Theme.of(context).primaryColor,
                        size: 16.0,
                      ),
                      Icon(
                        Icons.star,
                        color: Theme.of(context).primaryColor,
                        size: 16.0,
                      ),
                      Icon(
                        Icons.star,
                        color: Theme.of(context).primaryColor,
                        size: 16.0,
                      ),
                      Icon(
                        Icons.star_half,
                        color: Theme.of(context).primaryColor,
                        size: 16.0,
                      ),
                      Icon(
                        Icons.star_border,
                        color: Theme.of(context).primaryColor,
                        size: 16.0,
                      ),
                    ],
                  ),
                  Text(
                    "(12)",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "\$25",
                    style: TextStyle(
                        color: Colors.indigo, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(10),
      ),
    );
  }

  Padding ingredients() {
    return Padding(
      padding: const EdgeInsets.only(left: 13, right: 13, top: 18, bottom: 18),
      child: Container(
        height: 150,
        padding: EdgeInsets.only(left: 18, right: 18, top: 22, bottom: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: NetworkImage(
                  "https://ed.edtfiles-media.com/ud/news/1/155/463477/1_5-850x567.jpg"),
              fit: BoxFit.cover),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Text(
                      'เนื้อ',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                Text(
                  'ดูเพิ่มเติม >',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w100),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommendRecipeCard(context, RecommendRecipe dataRecommendRecipe) {
    return InkWell(
      onTap: () {
        if (data_DataAc != null) {
          if (dataRecommendRecipe.price == 0 ||
              dataRecommendRecipe.userId == data_DataAc.userId ||
              checkBuy.indexOf(dataRecommendRecipe.rid.toString()) >= 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShowFood(dataRecommendRecipe.rid)),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipePurchasePage(
                        req_rid: dataRecommendRecipe.rid,
                      )),
            ).then((value) {
              if (token != "" && token != null) {
                getMybuy();
              }
            });
          }
        } else {
          if (dataRecommendRecipe.price == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShowFood(dataRecommendRecipe.rid)),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipePurchasePage(
                        req_rid: dataRecommendRecipe.rid,
                      )),
            ).then((value) {
              if (token != "" && token != null) {
                getMybuy();
              }
            });
          }
        }
      },
      child: Container(
        width: 230,
        child: Stack(
          children: [
            Container(
              // height: 500,
              height: 300,
              width: 230,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(20)),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  dataRecommendRecipe.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            (dataRecommendRecipe.score == 0)
                ? Container()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.blue,
                          size: 20,
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        Text(
                          dataRecommendRecipe.score.toString(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          '(4)',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
            (dataRecommendRecipe.price == 0)
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(top: 16, right: 16),
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
                                        dataRecommendRecipe.userId)
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
                                            dataRecommendRecipe.userId)
                                        ? Container()
                                        : (checkBuy.indexOf(dataRecommendRecipe
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
                  ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //       "testasdjasjdknkjaskdnjkasndkj",
                  //       style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20),
                  //     ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dataRecommendRecipe.recipeName,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            // margin: EdgeInsets.all(100.0),
                            height: 32.0,
                            width: 32.0,
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                          ),
                          Positioned(
                            top: 1,
                            right: 1,
                            child: new Container(
                              height: 30.0,
                              width: 30.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(
                                          dataRecommendRecipe.profileImage))),
                            ),
                          ),
                        ],
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      new Text(
                        dataRecommendRecipe.aliasName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _popular_recipe(context, PopularRecipeModel dataRecommendRecipe) {
    return Container(
      // height: 500,
      width: 250,
      child: InkWell(
        onTap: () {
          if (data_DataAc != null) {
            if (dataRecommendRecipe.price == 0 ||
                dataRecommendRecipe.userId == data_DataAc.userId ||
                checkBuy.indexOf(dataRecommendRecipe.rid.toString()) >= 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowFood(dataRecommendRecipe.rid)),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RecipePurchasePage(
                          req_rid: dataRecommendRecipe.rid,
                        )),
              ).then((value) {
                if (token != "" && token != null) {
                  getMybuy();
                }
              });
            }
          } else {
            if (dataRecommendRecipe.price == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowFood(dataRecommendRecipe.rid)),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RecipePurchasePage(
                          req_rid: dataRecommendRecipe.rid,
                        )),
              ).then((value) {
                if (token != "" && token != null) {
                  getMybuy();
                }
              });
            }
          }
        },
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      dataRecommendRecipe.profileImage))),
                        ),
                        new SizedBox(
                          width: 10.0,
                        ),
                        new Text(
                          dataRecommendRecipe.aliasName,
                          style: TextStyle(fontWeight: FontWeight.bold),
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
              Container(
                height: 210,
                decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                        image: NetworkImage(dataRecommendRecipe.image),
                        fit: BoxFit.cover)),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        dataRecommendRecipe.recipeName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "4.2",
                            style: TextStyle(color: Colors.grey),
                          ),
                          RatingBarIndicator(
                            rating: 3,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.blue,
                            ),
                            itemCount: 5,
                            itemSize: 16,
                          ),
                          Text(
                            "(12)",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    (data_DataAc == null)
                        ? Text(
                            (dataRecommendRecipe.price == 0)
                                ? "ฟรี "
                                : "\฿${dataRecommendRecipe.price}",
                            style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold))
                        : Text(
                            (dataRecommendRecipe.userId == data_DataAc.userId)
                                ? ""
                                : (checkBuy.indexOf(dataRecommendRecipe.rid
                                            .toString()) >=
                                        0)
                                    ? "ซื้อแล้ว"
                                    : (dataRecommendRecipe.price == 0)
                                        ? "ฟรี "
                                        : "\฿${dataRecommendRecipe.price}",
                            style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold),
                          )
                  ],
                ),
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
    );
  }

  Widget _introduce_safe_Card(
      context, RecommendUser dataRecommendUser, List<String> checkFollowing) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: GestureDetector(
        onTap: () {
          if (data_DataAc == null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileUser(
                        reqUid: dataRecommendUser.userId,
                        imageHero: dataRecommendUser.profileImage,
                      )),
            );
          } else if ((data_DataAc.userId == dataRecommendUser.userId)) {
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return ProfilePage();
            }));
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileUser(
                      reqUid: dataRecommendUser.userId,
                      imageHero: dataRecommendUser.profileImage)),
            ).then((value) {
              if (value != 0 && token != "" && token != null) {
                checkFollowings();
              }
            });
          }
        },
        child: Container(
          // height: 500,
          // width: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Hero(
                tag: dataRecommendUser.profileImage,
                child: Row(
                  children: [
                    Container(
                      height: 65.0,
                      width: 65.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: new NetworkImage(
                                  dataRecommendUser.profileImage))),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    dataRecommendUser.aliasName,
                    style: TextStyle(fontWeight: FontWeight.normal),
                  )
                ],
              ),
              (data_DataAc == null)
                  ? Row(
                      children: [
                        Container(
                          width: 90,
                          height: 25,
                          child: MaterialButton(
                            splashColor: Colors.grey,
                            color: Colors.white,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return LoginPage();
                                  }).then((value) {
                                findUser();
                                // Navigator.pop(context);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                              child: Text(
                                '+ ติดตาม',
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 11),
                              ),
                            ),
                            shape: StadiumBorder(
                                side: BorderSide(width: 1, color: Colors.blue)),
                          ),
                        ),
                      ],
                    )
                  : (data_DataAc.userId == dataRecommendUser.userId)
                      ? Container(
                          height: 25,
                        )
                      : (checkFollowing.indexOf(
                                  dataRecommendUser.userId.toString()) >=
                              0)
                          ? Row(
                              children: [
                                Container(
                                  width: 90,
                                  height: 25,
                                  child: MaterialButton(
                                    splashColor: Colors.grey,
                                    color: Colors.white,
                                    onPressed: () {
                                      print("เลิกติดตาม");
                                      if (token == "") {
                                        showDialog(
                                            context: context,
                                            builder: (_) {
                                              return LoginPage();
                                            }).then((value) {
                                          findUser();
                                          // Navigator.pop(context);
                                        });
                                      } else {
                                        manageFollow(
                                            "unfol", dataRecommendUser.userId);
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 2),
                                      child: Text(
                                        '- เลิกติดตาม',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 11),
                                      ),
                                    ),
                                    shape: StadiumBorder(
                                        side: BorderSide(
                                            width: 1, color: Colors.red)),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Container(
                                  width: 90,
                                  height: 25,
                                  child: MaterialButton(
                                    splashColor: Colors.grey,
                                    color: Colors.white,
                                    onPressed: () {
                                      print("ติดตาม123");
                                      if (token == "") {
                                        showDialog(
                                            context: context,
                                            builder: (_) {
                                              return LoginPage();
                                            }).then((value) {
                                          findUser();
                                          // Navigator.pop(context);
                                        });
                                      } else {
                                        manageFollow(
                                            "fol", dataRecommendUser.userId);

                                        insertNotificationData(
                                            dataRecommendUser.userId.toString(),
                                            data_DataAc.aliasName,
                                            "ได้ติดตามคุณ",
                                            null,
                                            data_DataAc.userId.toString(),
                                            "follow");
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 2),
                                      child: Text(
                                        '+ ติดตาม',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 11),
                                      ),
                                    ),
                                    shape: StadiumBorder(
                                        side: BorderSide(
                                            width: 1, color: Colors.blue)),
                                  ),
                                ),
                              ],
                            ),
            ],
          ),
        ),
      ),
    );
  }
}

class SlideIndicator extends AnimatedWidget {
  final PageController pageController;
  SlideIndicator({this.pageController}) : super(listenable: pageController);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(3, buildIndicator),
    );
  }

  Widget buildIndicator(int index) {
    // print("build $index ");

    double select = max(
        0.0,
        1.0 -
            ((pageController.page ?? pageController.initialPage) - index)
                .abs());
    double decrease = 10 * select;

    // print("decrease = ${decrease}");
    return Container(
      width: 30,
      child: Center(
        child: Container(
          width: 20 - decrease,
          height: 4,
          decoration: BoxDecoration(
              color: decrease > 1.0 ? Colors.blue : Colors.black,
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

class AdsSlideCard extends StatelessWidget {
  final String slideImage;
  AdsSlideCard({this.slideImage});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              slideImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class MenuFeature extends StatelessWidget {
  final String iconAsset;
  final String name;
  MenuFeature({this.iconAsset, this.name});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Image.network(iconAsset),
            ),
            Text(
              name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

class PromoteShopCard extends StatelessWidget {
  final String image;
  PromoteShopCard({this.image});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width -
            MediaQuery.of(context).size.width / 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
