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
    "เมนูอบ",
    "อาหารว่าง"
  ];
  var iconFood = [
    "assets/logoSearch/water.png",
    "assets/logoSearch/boiled.png",
    "assets/logoSearch/healthy.png",
    "assets/logoSearch/steam.png",
    "assets/logoSearch/stewed.png",
    "assets/logoSearch/fried.png",
    "assets/logoSearch/grill.png",
    "assets/logoSearch/baked.png",
    "assets/logoSearch/snack.png"
  ];

  var categoryFoodImage = [
    "assets/imageSearch/water.webp",
    "assets/imageSearch/boiled.webp",
    "assets/imageSearch/healthy.jpg",
    "assets/imageSearch/steam.jpg",
    "assets/imageSearch/stewed.jpg",
    "assets/imageSearch/fried.jpg",
    "assets/imageSearch/grill.jfif",
    "assets/imageSearch/baked.jpg",
    "assets/imageSearch/snack.jpg"
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

  int selected = 0;
  List<String> txtLatest_recipe = ["ทั้งหมด", "ฟรี", "ไม่ฟรี"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf3f5f9),
        // backgroundColor: Color(0xFFF5F5F5),
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
              child: Image.asset(iconAsset),
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
