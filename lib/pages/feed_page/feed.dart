import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:easy_cook/sidebar/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_cook/models/feed/newFeedsProfile_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

String token = ""; //โทเคน
//user
MyAccount datas;
DataAc dataUser;

//NewfeedsProfile
NewfeedsProfile newfeed;
Feed post;

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
    super.initState();
    print("444444444 = " + token);
    findUser();
    print("333333333 = " + token);
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      print(newfeed);
      print("11111111 = " + token);
      token = preferences.getString("tokens");
      print("22222222 = " + token);
      getMyAccounts();
      newFeedPosts();
      print("newfeed" + newfeed.toString());
    });
  }

  Future<Null> getMyAccounts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        datas = myAccountFromJson(responseString);
        dataUser = datas.data[0];
      });
    } else {
      return null;
    }
  }

  Future<Null> newFeedPosts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjPost/newfeeds";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        newfeed = newfeedsProfileFromJson(responseString);
        //  post = newfeed.feeds[0];
        // dataUser = datas.data[0];
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
          title: Text('Easy Cook'),
        ),
      ),
      drawer: (token != "") ? Container(
        width: deviceSize.width - 45,
        child: Drawer(
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      curve: Curves.linear,
                      type: PageTransitionType.bottomToTop,
                      child: ProfilePage(),
                    ),
                  );
                },
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: new NetworkImage(
                          "https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?size=626&ext=jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF73AEF5),
                                    const Color(0xFF73AEF5)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: CircleAvatar(
                                  radius: 39,
                                  backgroundColor: Colors.grey,
                                  backgroundImage:
                                      NetworkImage(dataUser.profileImage),
                                ),
                              ),
                            ),
                            // Container(
                            //   height: 70.0,
                            //   width: 70.0,
                            //   decoration: new BoxDecoration(
                            //       shape: BoxShape.circle,
                            //       image: new DecorationImage(
                            //           fit: BoxFit.fill,
                            //           image: new NetworkImage(
                            //               datas.data[0].profileImage))),
                            // ),
                          ],
                        ),
                        //Padding(padding: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    datas.data[0].aliasName,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Text(
                              //       'Chanchai Ditthapan',
                              //       style: TextStyle(
                              //         fontSize: 20,
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.folder,
                  color: Colors.cyan,
                  size: 30,
                ),
                title: Text('สูตรที่ซื้อ',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 23,
                        color: Colors.black)),
                onTap: () {},
              ),
              Divider(
                thickness: 0.5,
                color: Colors.grey,
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.cyan,
                  size: 30,
                ),
                title: Text('ตั้งค่า',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 23,
                        color: Colors.black)),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.cyan,
                  size: 30,
                ),
                title: Text('ออกจากระบบ',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 23,
                        color: Colors.black)),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login-page', (route) => false);
                },
              ),
            ],
          ),
        ),
      ):Container(
        width: deviceSize.width - 45,
        child: Drawer(
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  
                },
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    // image: DecorationImage(
                    //   image: new NetworkImage(
                    //       "https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?size=626&ext=jpg"),
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF73AEF5),
                                    const Color(0xFF73AEF5)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                            
                              ),
                            ),
                           
                          ],
                        ),
                 
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Column(
                            children: [
                              Row(
                               
                              ),
                              
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.folder,
                  color: Colors.cyan,
                  size: 30,
                ),
                title: Text('สูตรที่ซื้อ',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 23,
                        color: Colors.black)),
                onTap: () {},
              ),
              Divider(
                thickness: 0.5,
                color: Colors.grey,
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.cyan,
                  size: 30,
                ),
                title: Text('ตั้งค่า',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 23,
                        color: Colors.black)),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.cyan,
                  size: 30,
                ),
                title: Text('ออกจากระบบ',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 23,
                        color: Colors.black)),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login-page', (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
      body: (token == "")
          ? Container()
          : (newfeed == null)
              ? AlertDialog(
                  content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("กรุณารอสักครู่...   "),
                    CircularProgressIndicator()
                  ],
                ))
              : ListView.builder(
                  itemCount: newfeed.feeds.length,
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
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                                image: new NetworkImage(newfeed
                                                    .feeds[index]
                                                    .profileImage))),
                                      ),
                                      new SizedBox(
                                        width: 10.0,
                                      ),
                                      new Text(
                                        newfeed.feeds[index].aliasName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              // child: Text(newfeed.feeds[index].recipeName, style: TextStyle(
                              //                   fontWeight: FontWeight.bold),),
                              child: Text(
                                newfeed.feeds[index].recipeName,
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .apply(fontSizeFactor: 1.5),
                              ),
                            ),
                            //2nd row
                            Flexible(
                                fit: FlexFit.loose,
                                child: GestureDetector(
                                  onTap: () {
                                    // print(newfeed.feeds[index].profileImage.toString());
                                    // Navigator.pushNamed(context, '/showfood-page',arguments: newfeed.feeds[index].rid);
                                    // print(newfeed.feeds[index].);
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                      return ShowFood(newfeed.feeds[index]);
                                    }));
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Container(
                                      width: 300,
                                      height: 300,
                                      child: ClipRRect(
                                        borderRadius:
                                            new BorderRadius.circular(24.0),
                                        child: Image(
                                          fit: BoxFit.cover,
                                          // alignment: Alignment.topRight,
                                          image: NetworkImage(
                                              newfeed.feeds[index].image),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // child: new Image.network(
                                  //   //รูปอาหาร
                                  //   newfeed.feeds[index].image,
                                  //   height: 500,
                                  //   fit: BoxFit.fill,
                                  // ),
                                )),

                            //3rd row
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                  Icon(Icons.bookmark_border,
                                      color: Colors.black),
                                ],
                              ),
                            ),

                            //4th row
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'คะแนน : 55',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),

                            //5th row
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 16.0, 16.0, 16.0),
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
                                            image: new NetworkImage(newfeed
                                                .feeds[index].profileImage))),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                "1 วันที่แล้ว",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
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
