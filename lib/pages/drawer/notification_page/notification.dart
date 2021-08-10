import 'package:easy_cook/models/notification/getNotification/getNotificationModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  // NotificationPage({Key? key}) : super(key: key);
  int numNotification;
  NotificationPage({this.numNotification});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  String token = ""; //โทเคน
  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      token = preferences.getString("tokens");
      print("Token >>> $token");
      if (token != "" || !token.isEmpty) {
        getNotification();
      }
    });
  }

  List<DataNotificationModel> dataGetNotification;
  Future<Null> getNotification() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjNoti/getNotification";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer ${token}"});
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      final String responseString = response.body;

      dataGetNotification = getNotificationModelFromJson(responseString).data;

      setState(() {});
    } else {
      return null;
    }
  }

  Future<Null> clearNotificationData() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjNoti/clearNotificationData";

    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Authorization": "Bearer $token",
    });

    print("clearNotificationData======" + (response.statusCode.toString()));
    print("clearNotificationData === >> "+ (response.body.toString()));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การแจ้งเตือน'),
        actions: [
          PopupMenuButton(
            child: Center(child: Icon(Icons.more_vert_outlined)),
            onSelected: (value) {
              setState(() {
                if (value == 1) {
                  print("555");
                  clearNotificationData();
                  getNotification();
                }
              });
            },
            itemBuilder: (context) {
              return [
                
                PopupMenuItem(
                  child: Text('ลบการแจ้งเตือนทั้งหมด'),
                  value: 1,
                ),
              ];
            },
          )
        ],
      ),
      body: (dataGetNotification == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              reverse: true,
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              // scrollDirection: Axis.v,
              itemCount: dataGetNotification.length,
              itemBuilder: (context, index) {
                return Card(
                  color: ((dataGetNotification.length -
                              this.widget.numNotification) <=
                          index)
                      ? Colors.grey.shade300
                      : Colors.white,
                  margin: EdgeInsets.all(1),
                  child: ListTile(
                    // leading: FlutterLogo(size: 72.0),
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              dataGetNotification[index].fromProfileImage),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                  radius: 13, backgroundColor: Colors.grey),
                              Padding(
                                padding: const EdgeInsets.all(1),
                                child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: (dataGetNotification[index]
                                                .status ==
                                            "buy")
                                        ? Colors.green
                                        : (dataGetNotification[index].status ==
                                                "comment")
                                            ? Colors.blue
                                            : Colors.grey,
                                    backgroundImage: (dataGetNotification[index]
                                                .status ==
                                            "buy")
                                        ? NetworkImage(
                                            "https://image.flaticon.com/icons/png/512/3135/3135706.png")
                                        : (dataGetNotification[index].status ==
                                                "comment")
                                            ? NetworkImage(
                                                "https://image.flaticon.com/icons/png/512/4081/4081342.png")
                                            : NetworkImage(
                                                "https://image.flaticon.com/icons/png/512/3602/3602137.png")),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(dataGetNotification[index].state),
                    ),
                    subtitle: Text(
                        "${dataGetNotification[index].description}\n\n${dataGetNotification[index].date}"),
                    trailing: Icon(Icons.more_horiz),
                    isThreeLine: true,
                    onTap: () {},
                  ),
                );
              }),
    );
  }
}


// 