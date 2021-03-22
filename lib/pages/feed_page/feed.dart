import 'package:easy_cook/pages/profile_page/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_cook/models/profile/newFeedsProfile_model.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

String token = ""; //โทเคน
//user
MyAccount datas;
Datum dataUser;

//NewfeedsProfile
NewfeedsProfile newfeed;
Feed post;

class _FeedPageState extends State<FeedPage> {

  @override
  void initState() { 
    super.initState();
    findUser();
  }
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      print("11111111 = " + token);
      token = preferences.getString("tokens");
      print("22222222 = " + token);
      getMyAccounts();
      newFeedPosts();
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
        child: AppBar(title: Text('Easy Cook'),),
      ),
      body: (token == "")
          ? Container() : ListView.builder(
        itemCount: newfeed.feeds.length,
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
                                          newfeed.feeds[index].profileImage))),
                            ),
                            new SizedBox(
                              width: 10.0,
                            ),
                            new Text(
                              newfeed.feeds[index].aliasName,
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
                      newfeed.feeds[index].image,
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
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
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
                                      newfeed.feeds[index].profileImage))),
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
