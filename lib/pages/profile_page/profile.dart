import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/models/profile/myPost_model.dart';
import 'package:easy_cook/pages/profile_page/edit_profile/edit_profile.dart';
import 'package:easy_cook/pages/profile_page/showFollower&Following.dart';
import 'package:easy_cook/pages/profile_page/topup&withdraw/topup/payment_channel.dart';
import 'package:easy_cook/pages/profile_page/topup&withdraw/withdraw/withdrawPage.dart';
import 'package:easy_cook/pages/profile_page/wallet/walletPage.dart';
import 'package:easy_cook/pages/showFood&User_page/XXX_showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScrollProfilePageState();
  }
}

class _ScrollProfilePageState extends State
    with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
    findUser();
  }

  String token = ""; //โทเคน
  //ดึง token
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("tokens");
      print("ProfilePage_token = " + token);
      getMyAccounts();
      // getMyAccounts();
      // print("dataUser = " + dataUser.toString());
    });
  }

  //ข้อมูลตัวเอง
  MyAccount data_MyAccount;
  DataMyAccount data_DataAc;

  Future<Null> getMyAccounts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        data_MyAccount = myAccountFromJson(responseString);
        data_DataAc = data_MyAccount.data[0];
        // print(data_DataAc.userId);
        getMyPost();
      });
    } else {
      return null;
    }
  }

  //ข้อมูลโพสต์ตัวเอง
  MyPost data_MyPost;
  List<RecipePost> data_RecipePost;
  Future<Null> getMyPost() async {
    String uid = data_DataAc.userId.toString();
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/mypost/" + uid;

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      if (mounted)
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

  buildSliverAppBar() {
    return SliverAppBar(
      // title: buildHeader(),
      title: Text(data_DataAc.aliasName),
      // centerTitle: true,
      pinned: true,
      floating: false,
      snap: false,
      elevation: 0.0,
      expandedHeight: (data_DataAc.userStatus == 0) ? 403 : 550,
      backgroundColor: Colors.blue,
      flexibleSpace: FlexibleSpaceBar(
        background: buildFlexibleSpaceWidget(),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WalletPage()))
                .then((value) => {
                      if (token != "" && token != null) {getMyAccounts()}
                    });
          },
          icon: Icon(Icons.account_balance_wallet_outlined),
        )
      ],
      bottom: buildFlexibleTooBarWidget(),
    );
  }

  Widget buildFlexibleTooBarWidget() {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 44),
      child: Container(
        alignment: Alignment.center,
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: TabBar(
            controller: tabController,
            tabs: <Widget>[
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
        ),
      ),
    );
  }

  buildFlexibleSpaceWidget() {
    return Column(
      children: [
        Container(
            // color: Colors.primaries[index],
            // height:500,
            child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 390,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?size=626&ext=jpg"),
                        fit: BoxFit.cover),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Column(
                      children: [
                        // SizedBox(
                        //   height: 36,
                        // ),

                        CircleAvatar(
                          radius: 48,
                          backgroundImage:
                              NetworkImage(data_DataAc.profileImage),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          data_DataAc.aliasName,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          data_DataAc.nameSurname,
                          style: TextStyle(color: Colors.white60, fontSize: 15),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        MaterialButton(
                          splashColor: Colors.white,
                          color: Colors.blue,
                          onPressed: () {
                            print("แก้ไขโปรไฟล์");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditProfilePage(this.data_DataAc)),
                            ).then((value) => findUser());
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
                                child: InkWell(
                                  onTap: () {
                                    print("โพสต์");
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        data_RecipePost.length.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 110,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ShowFollowerAndFollowing(
                                                index: 0,
                                                id: this.data_DataAc.userId,
                                                name:
                                                    this.data_DataAc.aliasName,
                                              )),
                                    ).then((value) => findUser());
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              ),
                              Container(
                                width: 110,
                                child: InkWell(
                                  onTap: () {
                                    print("กำลังตืดตาม");
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ShowFollowerAndFollowing(
                                                index: 1,
                                                id: this.data_DataAc.userId,
                                                name:
                                                    this.data_DataAc.aliasName,
                                              )),
                                    ).then((value) => findUser());
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        data_MyPost.countFollowing
                                            .toString(), //"data_MyPost.countFollowing.toString()"
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            (data_DataAc.userStatus == 0)
                ? Container()
                : InkWell(
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WalletPage()))
                          .then((value) => {
                                if (token != "" && token != null)
                                  {getMyAccounts()}
                              });
                    },
                    child: Container(
                      color: Colors.white,
                      child: Padding(
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
                                    "กระเป๋าหลัก(\u0E3F)",
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white.withOpacity(.7),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    '${NumberFormat("#,###.##").format(data_DataAc.balance)} ›', //"data_DataAc.balance.toString()"
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
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
                                      onPressed: () {
                                        _ctrlPrice.text = "";

                                        _displayBottomSheet(context, "topup");
                                      },
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
                                      onPressed: () {
                                        _ctrlPrice.text = "";
                                        _displayBottomSheet(
                                            context, "withdraw");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        )),
      ],
    );
  }

  void _displayBottomSheet(context, String select) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => SingleChildScrollView(
              child: Container(
                color: Color(0xFF737373),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: _buildBottomNavigationMenu(context, select),
              ),
            ));
  }

  TextEditingController _ctrlPrice = TextEditingController(); //ราคา
  final _formKey = GlobalKey<FormState>();
  Container _buildBottomNavigationMenu(context, String select) {
    return Container(

        // height: (MediaQuery.of(context).viewInsets.bottom != 0) ? MediaQuery.of(context).size.height * .60 : MediaQuery.of(context).size.height * .30,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(30),
                topRight: const Radius.circular(30))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "ระบุจำนวนเงิน(บาท)",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          // setState(() {
                          Navigator.pop(context);

                          //   if (_ctrlPriceCopy.text == "0.00") {
                          //     _ctrlPrice.text = "0.00";
                          //     _selectPrices = "ฟรี";
                          //     _prices[1] = Price('ระบุราคา');
                          //   }
                          // });
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.blue,
                          size: 25,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(7),
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}')),
                      // FilteringTextInputFormatter.allow(RegExp('[1234567890.0]')),
                      // FilteringTextInputFormatter.deny('..')

                      //   FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: _ctrlPrice,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      labelText: 'จำนวนเงิน',
                      hintText: '0.00',
                    ),
                    autofocus: false,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'โปรดระบุยอดเงิน';
                      }

                      if (select == 'topup') {
                        if (double.parse(_ctrlPrice.text) < 20) {
                          return 'ขั้นต่ำ 20 บาท';
                        }
                      } else if (select == 'withdraw') {
                        if (double.parse(_ctrlPrice.text) < 100) {
                          return 'ขั้นต่ำ 100 บาท';
                        } else if (double.parse(_ctrlPrice.text) >
                            data_DataAc.balance) {
                          return 'เงินคุณที่สามาถอนเงินได้ ${data_DataAc.balance} บาท';
                        }
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    // padding: EdgeInsets.all(20),

                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            if (select == 'topup') {
                              if (double.parse(_ctrlPrice.text) >= 20) {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentChannelPage(
                                            amount_to_fill:
                                                double.parse(_ctrlPrice.text),
                                          )),
                                ).then((value) => {
                                      if (token != "" && token != null)
                                        {getMyAccounts()}
                                    });
                              }
                            } else if (select == 'withdraw') {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WithdrawPage(
                                          amount_to_fill:
                                              double.parse(_ctrlPrice.text),
                                          name: data_DataAc.aliasName,
                                          email: data_DataAc.email,
                                        )),
                              ).then((value) => {
                                    if (token != "" && token != null)
                                      {getMyAccounts()}
                                  });
                            }
                          }

                          // setState(() {
                          //   Navigator.pop(context);
                          //   _ctrlPriceCopy.text = _ctrlPrice.text;
                          //   if (_ctrlPriceCopy.text == "0.00" ||
                          //       _ctrlPriceCopy.text == "" ||
                          //       double.parse(_ctrlPrice.text) == 0) {
                          //     _ctrlPrice.text = "0.00";
                          //     _ctrlPriceCopy.text == "0.00";
                          //     _selectPrices = "ฟรี";
                          //     _prices[1] = Price('ระบุราคา');
                          //   } else {
                          //     _prices[1] = Price('${_ctrlPrice.text}');
                          //     _selectPrices = _ctrlPrice.text;
                          //   }
                          // });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ตกลง',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  // buildHeader() {
  //   return Container(
  //     width: double.infinity,
  //     padding: EdgeInsets.only(left: 10),
  //     height: 38,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       border: Border.all(color: Colors.white),
  //       borderRadius: BorderRadius.circular(30),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(
  //           Icons.search_rounded,
  //           size: 18,
  //         ),
  //         SizedBox(
  //           width: 4,
  //         ),
  //         Text(
  //           "search for",
  //           style: TextStyle(
  //             fontSize: 14,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // Building the main body of the page
    return Scaffold(
      //Pull down to refresh
      body: RefreshIndicator(
        // Scroll components send ScrollNotification type notification when scrolling

        notificationPredicate: (ScrollNotification notifation) {
          // This property contains information such as current viewport and scroll position.
          ScrollMetrics scrollMetrics = notifation.metrics;
          if (scrollMetrics.minScrollExtent == 0) {
            return true;
          } else {
            return false;
          }
        },
        // pull down the new callback method
        onRefresh: () async {
          // Simulate network refresh waiting for 2 seconds
          await Future.delayed(Duration(milliseconds: 2000));
          // Return the value to end refresh
          this.findUser();
          return Future.value(true);
        },
        child: data_DataAc == null || data_MyPost == null
            // ? Container(
            //     child: AlertDialog(
            //         content: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text("กรุณารอสักครู่...   "),
            //         CircularProgressIndicator()
            //       ],
            //     )),
            //   )
            ? Center(
                child: CircularProgressIndicator(),
              )
            : buildNestedScrollView(),
      ),
    );
  }

  // Page destroy the calm life cycle
  // @override
  // void dispose() {
  //   tabController.dispose();
  // }

  Widget buildNestedScrollView() {
    // Slide view
    return NestedScrollView(
      // Configure foldable head layout
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [buildSliverAppBar()];
      },
      // The main content of the page
      body: buidChildWidget(),
    );
  }

  Widget buidChildWidget() {
    var deviceSize = MediaQuery.of(context).size;
    return TabBarView(
      controller: tabController,
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: data_RecipePost
              .length, /////////////////////////////////////////////////////////////////
          itemBuilder: (context, index) => index < 0
              // ? new SizedBox(
              //     child: AlertDialog(
              //         content: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text("กรุณารอสักครู่...   "),
              //         CircularProgressIndicator()
              //       ],
              //     )),
              //   )
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //1st row
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 8.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Row(
                    //         children: [
                    //           new Container(
                    //             height: 40.0,
                    //             width: 40.0,
                    //             decoration: new BoxDecoration(
                    //                 shape: BoxShape.circle,
                    //                 image: new DecorationImage(
                    //                     fit: BoxFit.fill,
                    //                     image: new NetworkImage(
                    //                         data_DataAc.profileImage))),
                    //           ),
                    //           new SizedBox(
                    //             width: 10.0,
                    //           ),
                    //           new Text(
                    //             data_DataAc.aliasName,
                    //             style: TextStyle(fontWeight: FontWeight.bold),
                    //           )
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    //2nd row
                    GestureDetector(
                      onTap: () {
                        print("up $index");
                        print(data_RecipePost[index].rid);
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) {
                          return ShowFood(data_RecipePost[index].rid);
                        })).then((value) => findUser());
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Container(
                              width: deviceSize.width,
                              height: 300,
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(24.0),
                                child: Image(
                                  fit: BoxFit.cover,
                                  // alignment: Alignment.topRight,
                                  image: NetworkImage(data_RecipePost[index]
                                      .image), ////////////////////////////////////////////////////////
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8.0,
                            bottom: 0.0,
                            right: 8.0,
                            child: Container(
                              height: 60.0,
                              width: deviceSize.width,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(24.0),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black,
                                    Colors.black12,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data_RecipePost[index].recipeName,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        RatingBarIndicator(
                                          rating: (data_RecipePost[index]
                                                      .score ==
                                                  null)
                                              ? 0
                                              : data_RecipePost[index].score,
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Colors.blue,
                                          ),
                                          itemCount: 5,
                                          itemSize: 16.0,
                                          // direction: Axis.vertical,
                                        ),
                                        Text(
                                          "(คะแนน " +
                                              (data_RecipePost[index]
                                                  .score
                                                  .toString()) +
                                              ")",
                                          style: TextStyle(color: Colors.grey),
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
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(15.0, 8, 8.0, 0),
                    //   child: Text(
                    //     data_RecipePost[index].recipeName,
                    //     style: TextStyle(fontSize: 20),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(15.0, 8, 8.0, 16.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Row(
                    //         children: [
                    //           new Container(
                    //             height: 30.0,
                    //             width: 30.0,
                    //             decoration: new BoxDecoration(
                    //                 shape: BoxShape.circle,
                    //                 image: new DecorationImage(
                    //                     fit: BoxFit.fill,
                    //                     image: new NetworkImage(data_DataAc
                    //                         .profileImage))), /////////////////////////////////////////////////
                    //           ),
                    //           new SizedBox(
                    //             width: 10.0,
                    //           ),
                    //           new Text(
                    //             data_DataAc
                    //                 .aliasName, //////////////////////////////////////////////////
                    //             style: TextStyle(fontWeight: FontWeight.normal),
                    //           )
                    //         ],
                    //       ),
                    //       // new IconButton(
                    //       //     icon: Icon(Icons.more_vert),
                    //       //     onPressed: () {
                    //       //       print("more_vert" + index.toString());
                    //       //     })
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 16,
                    )
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
    );
  }
}
