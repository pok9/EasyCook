import 'package:easy_cook/models/notification/getNotification/getNotificationModel.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood/showFood.dart';
import 'package:easy_cook/pages/showFood&User_page/showProfileUser.dart';
import 'package:flutter/cupertino.dart';
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
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   findUser();
  // }

  String token = ""; //โทเคน
  // Future<Null> findUser() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();

  //   setState(() {
  //     token = preferences.getString("tokens");
  //     print("Token >>> $token");
  //     if (token != "" || !token.isEmpty) {
  //       getNotification();
  //     }
  //   });
  // }

  List<DataNotificationModel> dataGetNotification = [];
  // Future<Null> getNotification() async {
  //   final String apiUrl =
  //       "http://apifood.comsciproject.com/pjNoti/getNotification";

  //   final response = await http
  //       .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer ${token}"});
  //   print("response = " + response.statusCode.toString());
  //   if (response.statusCode == 200) {
  //     final String responseString = response.body;

  //     dataGetNotification = getNotificationModelFromJson(responseString).data;

  //     setState(() {});
  //   } else {
  //     return null;
  //   }
  // }

  Future<Null> clearNotificationData() async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjNoti/clearNotificationData";

    final response = await http.post(Uri.parse(apiUrl), headers: {
      "Authorization": "Bearer $token",
    });

    print("clearNotificationData======" + (response.statusCode.toString()));
    print("clearNotificationData === >> " + (response.body.toString()));
    setState(() {
      // getNotification();
    });
  }

  String getTimeDifferenceFromNow(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inSeconds < 5) {
      return "เมื่อสักครู่";
    } else if (difference.inMinutes < 1) {
      return "${difference.inSeconds} วินาที";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes} นาที";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} ชั่วโมง";
    } else if (difference.inDays < 8) {
      return "${difference.inDays} วัน";
    } else {
      return "${dateEdit(dateTime.toString())}";
    }
  }

  String dateEdit(String date) {
    //data
    Map<String, String> map = {
      '01': "ม.ค.",
      '02': "ก.พ.",
      '03': "มี.ค.",
      '04': "เม.ย.",
      '05': "พ.ค.",
      '06': "มิ.ย.",
      '07': "ก.ค.",
      '08': "ส.ค.",
      '09': "ก.ย.",
      '10': "ต.ค.",
      '11': "พ.ย.",
      '12': "ธ.ค."
    };
    List<String> dateTimeSp = date.split(" ");
    List<String> dateSp = dateTimeSp[0].split("-");

    //time
    List timeSp = dateTimeSp[1].split(".");
    List time = timeSp[0].split(":");

    String text =
        "${dateSp[2]} ${map[dateSp[1]]} ${dateSp[0]} - ${time[0]}:${time[1]} น.";
    return text;
  }

  Future<bool> loadList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    token = preferences.getString("tokens");
    print("Token >>> $token");
    if (token != "" || !token.isEmpty) {
      final String apiUrl =
          "http://apifood.comsciproject.com/pjNoti/getNotification";

      final response = await http.get(Uri.parse(apiUrl),
          headers: {"Authorization": "Bearer ${token}"});
      print("response = " + response.statusCode.toString());
      if (response.statusCode == 200) {
        final String responseString = response.body;

        dataGetNotification = getNotificationModelFromJson(responseString).data;
      } else {
        return null;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การแจ้งเตือน'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PopupMenuButton(
              child: Center(child: Icon(Icons.delete_forever)),
              onSelected: (value) {
                setState(() {
                  if (value == 1) {
                    print("555");
                    clearNotificationData();
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
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: loadList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return (dataGetNotification.length == 0)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 60,
                            height: 60,
                            child: Image.asset("assets/images/notification-bell.png")),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "คุณไม่มีการแจ้งเตือน",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      ],
                    ),
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
                        elevation: 0,
                        child: ListTile(
                          // leading: FlutterLogo(size: 72.0),
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    dataGetNotification[index]
                                        .fromProfileImage),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                        radius: 13,
                                        backgroundColor: Colors.grey),
                                    Padding(
                                      padding: const EdgeInsets.all(1),
                                      child: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: (dataGetNotification[
                                                          index]
                                                      .status ==
                                                  "buy")
                                              ? Colors.green
                                              : (dataGetNotification[index]
                                                          .status ==
                                                      "comment")
                                                  ? Colors.blue
                                                  : (dataGetNotification[index]
                                                              .status ==
                                                          "scorefood")
                                                      ? Colors.red
                                                      : Colors.grey,
                                          backgroundImage: (dataGetNotification[
                                                          index]
                                                      .status ==
                                                  "buy")
                                              ? NetworkImage(
                                                  "https://image.flaticon.com/icons/png/512/3135/3135706.png")
                                              : (dataGetNotification[index]
                                                          .status ==
                                                      "comment")
                                                  ? NetworkImage(
                                                      "https://image.flaticon.com/icons/png/512/4081/4081342.png")
                                                  : (dataGetNotification[index]
                                                              .status ==
                                                          "scorefood")
                                                      ? NetworkImage(
                                                          "https://image.flaticon.com/icons/png/512/3237/3237420.png")
                                                      : (dataGetNotification[
                                                                      index]
                                                                  .status ==
                                                              "follow")
                                                          ? NetworkImage(
                                                              "https://image.flaticon.com/icons/png/512/1057/1057046.png")
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
                              "${dataGetNotification[index].description}\n\n${getTimeDifferenceFromNow(DateTime.parse("${dataGetNotification[index].date}"))}"),
                          // trailing: Icon(Icons.more_horiz),
                          isThreeLine: true,
                          onTap: () {
                            if (dataGetNotification[index].status == "follow" ||
                                dataGetNotification[index].status == "buy" ||
                                dataGetNotification[index].status ==
                                    "scorefood") {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return ProfileUser(
                                  reqUid: dataGetNotification[index].fromUserid,
                                );
                              }));
                            } else if (dataGetNotification[index].status ==
                                "comment") {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return ShowFood(
                                    dataGetNotification[index].recipeId);
                              }));
                            }
                          },
                        ),
                      );
                    });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}


// 