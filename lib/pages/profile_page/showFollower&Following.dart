import 'package:easy_cook/models/checkFollower_checkFollowing/checkFollower_model.dart';
import 'package:easy_cook/models/checkFollower_checkFollowing/checkFollowing_model.dart';
import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShowFollowerAndFollowing extends StatefulWidget {
  int index;
  DataAc data_DataAc;

  ShowFollowerAndFollowing({this.index, this.data_DataAc});

  @override
  _ShowFollowerAndFollowingState createState() =>
      _ShowFollowerAndFollowingState();
}

class _ShowFollowerAndFollowingState extends State<ShowFollowerAndFollowing> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  String token = ""; //โทเคน
  //ดึง token
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("tokens");
      getFollowing();
    });
  }

  CheckFollowing checkFollowing;
  Future<Null> getFollowing() async {
    print("ddddddd");
    print("uid = ${this.widget.data_DataAc.userId}");
    final String apiUrl =
        "http://apifood.comsciproject.com/pjFollow/checkFollowing/${this.widget.data_DataAc.userId}";

    print("apiUrl = ${apiUrl}");

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;

        checkFollowing = checkFollowingFromJson(responseString);
      });
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: this.widget.index,
      child: Scaffold(
        appBar: AppBar(
          
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'ติดตาม',
              ),
              Tab(
                text: 'กำลังติดตาม',
              ),
            ],
          ),
          title: Text(this.widget.data_DataAc.aliasName),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 20, 0, 0),
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      title: Text("ชื่อเล่น"),
                      subtitle: Text("ชื่อจริง"),
                      leading: Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    "https://thestandard.co/wp-content/uploads/2021/05/one-piece-thai-version-by-cartoon-club-stop-broadcasting-due-to-copyright.jpg"))),
                      ),
                    ),
                  );
                },
              ),
            ),
            (checkFollowing == null)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      CircularProgressIndicator()
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(4, 20, 0, 0),
                    child: ListView.builder(
                      itemCount: checkFollowing.count,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: ListTile(
                            title: Text(checkFollowing.user[index].aliasName),
                            subtitle: Text(checkFollowing.user[index].nameSurname),
                            leading: Container(
                              height: 60.0,
                              width: 60.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(
                                          checkFollowing.user[index].profileImage))),
                            ),
                            trailing: OutlinedButton(
                              onPressed: () {},
                              child: Text('กำลังติดตาม'),
                              style: OutlinedButton.styleFrom(
                                primary: Colors.blue,
                                backgroundColor: Colors.white,
                                side: BorderSide(width: 0, color: Colors.blue),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
