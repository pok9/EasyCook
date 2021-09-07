import 'dart:convert';

import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChooseWallpaperPage extends StatefulWidget {
  @override
  _ChooseWallpaperPageState createState() => _ChooseWallpaperPageState();
}

class _ChooseWallpaperPageState extends State<ChooseWallpaperPage> {
  String token = ""; //โทเคน
  //ดึง token
  Future<String> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getString("tokens");
  }

  //ข้อมูลตัวเอง
  MyAccount data_MyAccount;
  DataMyAccount data_DataAc;

  Future<MyAccount> getMyAccounts() async {
    final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

    final response = await http
        .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      // if (mounted)
      // setState(() {
      final String responseString = response.body;

      // getMyPost();
      // });
      return myAccountFromJson(responseString);
    } else {
      return null;
    }
  }

  Future<Null> updateWallpaper(String wallpaperName) async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjUsers/updateWallpaper";

    var data = {"wallpaperName": wallpaperName};
    print(data);
    final response = await http.post(Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    print("respon = ${response.statusCode}");
    if (response.statusCode == 200) {
      final String responseString = response.body;
      print("responseString = ${responseString}");
      Fluttertoast.showToast(
        msg: "เปลี่ยนรูป วอลล์เปเปอร์ ใหม่แล้ว",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      // return editNameFromJson(responseString);
    } else {
      return null;
    }
  }

  List<String> imgWallaper = [
    'assets/wallpapers/default.jpg',
    'assets/wallpapers/bots.gif',
    'assets/wallpapers/color.jpg',
    'assets/wallpapers/yourname.gif',
    'assets/wallpapers/raincode.gif',
    'assets/wallpapers/8bitSea.gif',
    'assets/wallpapers/l1.png',
    'assets/wallpapers/l2.jpg',
    'assets/wallpapers/l3.jpg',
    'assets/wallpapers/l4.jpg',
    'assets/wallpapers/l5.jpg',
  ];

  int id = 0;
  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text('เลือกวอลล์เปเปอร์'),
        ),
        body: FutureBuilder(
          future: findUser(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              token = snapshot.data;
              return FutureBuilder(
                future: getMyAccounts(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    data_MyAccount = snapshot.data;
                    data_DataAc = data_MyAccount.data[0];
                    id = imgWallaper.indexOf(data_DataAc.wallpaper);

                    return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: imgWallaper.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              // setState(() {
                              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //     content: Text("เปลี่ยนรูป วอลล์เปเปอร์ ใหม่แล้ว"),
                              //   ));

                              // });
                              id = index;
                              updateWallpaper(imgWallaper[index]);

                              setState(() {});
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: 200,
                                  width: sizeScreen.width,
                                  child: Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Image.asset(
                                      imgWallaper[index],
                                      fit: BoxFit.fill,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 8, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Radio(
                                        value: index,
                                        groupValue: id,
                                        onChanged: (value) {
                                          // setState(() {
                                          //   id = index;
                                          // });
                                        },
                                        activeColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  }
                  return Center(child: CircularProgressIndicator());
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
