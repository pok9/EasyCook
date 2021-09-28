import 'package:easy_cook/models/profile/myAccount_model.dart';
import 'package:easy_cook/pages/drawer/drawers.dart';
import 'package:easy_cook/pages/login&register_page/login_page/login.dart';
import 'package:easy_cook/pages/search_page/category/category.dart';
import 'package:easy_cook/pages/search_page/search2.dart';
import 'package:easy_cook/pages/showFood&User_page/showFood/showFoodStory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class SearchPage1 extends StatefulWidget {
  // const SearchPage1({ Key? key }) : super(key: key);

  @override
  _SearchPage1State createState() => _SearchPage1State();
}

class _SearchPage1State extends State<SearchPage1> {
  var menuFood = [
    "เมนูน้ำ",
    "เมนูต้ม",
    "เมนูสุขภาพ",
    "เมนูนึ่ง",
    "เมนูตุ๋น",
    "เมนูทอด",
    "เมนูย่าง",
  ];
  var iconFood = [
    "https://cdn-icons-png.flaticon.com/512/4913/4913194.png",
    "https://cdn-icons-png.flaticon.com/512/3063/3063364.png",
    "https://cdn-icons-png.flaticon.com/512/5601/5601409.png",
    "https://cdn-icons-png.flaticon.com/512/3063/3063360.png",
    "https://cdn-icons-png.flaticon.com/512/1302/1302319.png",
    "https://cdn-icons-png.flaticon.com/512/1143/1143203.png",
    "https://cdn-icons-png.flaticon.com/512/4212/4212850.png",
  ];

  var categoryFoodImage = [
    "https://c4.wallpaperflare.com/wallpaper/1015/171/825/smoothie-4k-hd-wallpaper-preview.jpg",
    "https://img.taste.com.au/pqrFylbF/taste/2018/05/how-to-boil-an-egg-140215-2.jpg",
    "https://img.freepik.com/free-photo/keto-diet-food-keto-breakfast-grilled-chicken-avocado-feta-cheese-quail-eggs-strawberries-nuts-lettuce-gray-background_114941-1607.jpg?size=626&ext=jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoCnCRigJXR961hQpA6G-Hy03S3eD7xMQiTHbPJP2jgyyuns4YG14vSRJctRp210CRUZU&usqp=CAU",
    "https://vistapointe.net/images/stew-8.jpg",
    "https://wallpapercave.com/wp/wp2055348.jpg",
    "https://images.unsplash.com/photo-1508615263227-c5d58c1e5821?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YmJxfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80"
  ];

  @override
  void initState() {
    super.initState();

    findUser();
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
        });
    } else {
      return null;
    }
  }

  final StoryController controller = StoryController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf3f5f9),
      appBar: AppBar(
        title: Text('ค้นหา'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 12.0, bottom: 8.0), //กรอบ search
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // side: BorderSide(width: 2, color: Colors.blue),
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage2()))
                          .then((value) => () {});
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Row(
                        children: [
                          Center(
                              child: Text(
                            'ค้นหา...',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ],
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
              ? ListView(
                  children: [
                    dividerTextCustom("หมวดหมู่"),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 5,
                          children: List.generate(menuFood.length, (index) {
                            return MenuFeature(
                              iconAsset: iconFood[index],
                              name: menuFood[index],
                              categoryFoodImage: categoryFoodImage[index],
                            );
                          })),
                    ),
                  ],
                )
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

  // TabBarView body() {
  //   return new TabBarView(
  //     children: <Widget>[
  //       ListView(
  //         children: [
  //           dividerTextCustom("หมวดหมู่"),
  //           Padding(
  //             padding: const EdgeInsets.all(0.0),
  //             child: GridView.count(
  //                 shrinkWrap: true,
  //                 physics: NeverScrollableScrollPhysics(),
  //                 crossAxisCount: 5,
  //                 children: List.generate(menuFood.length, (index) {
  //                   return MenuFeature(
  //                     iconAsset: iconFood[index],
  //                     name: menuFood[index],
  //                   );
  //                 })),
  //           ),
  //         ],
  //       ),
  //       new Column(
  //         children: <Widget>[new Text("Cart Page")],
  //       )

  //     ],
  //   );
  // }

  Padding dividerTextCustom(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: Divider(
                color: Colors.black,
                height: 36,
              )),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: Divider(
                color: Colors.black,
                height: 36,
              )),
        ),
      ]),
    );
  }
}

class MenuFeature extends StatelessWidget {
  final String iconAsset;
  final String name;
  final String categoryFoodImage;
  MenuFeature({this.iconAsset, this.name,this.categoryFoodImage});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(name);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Category(
                    categoryName: name,
                    categoryFoodImage:
                        categoryFoodImage,
                  )),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: Image.network(iconAsset),
            ),
            Text(
              name,
              // style: TextStyle(fontSize: 16, ),
            )
          ],
        ),
      ),
    );
  }
}
