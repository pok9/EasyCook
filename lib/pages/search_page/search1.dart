import 'package:easy_cook/pages/search_page/category/category.dart';
import 'package:easy_cook/pages/search_page/search2.dart';
import 'package:flutter/material.dart';

class SearchPage1 extends StatefulWidget {
  // const SearchPage1({ Key? key }) : super(key: key);

  @override
  _SearchPage1State createState() => _SearchPage1State();
}

class _SearchPage1State extends State<SearchPage1> {
  var menuFood = [
    'เมนูน้ำ',
    'เมนูต้ม',
    'เมนูสุขภาพ',
    'เมนูนึ่ง',
    'เมนูตุ๋น',
    'เมนูทอด'
  ];
  var iconFood = [
    'assets/logos/drink.png',
    'assets/logos/pot.png',
    'assets/logos/vegetables.png',
    'assets/logos/steam.png',
    'assets/logos/stew.png',
    'assets/logos/fried.png'
  ];

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
      body: DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: new Container(
              color: Colors.white70,
              child: new SafeArea(
                child: Column(
                  children: <Widget>[
                    new Expanded(child: new Container()),
                    new TabBar(
                      tabs: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Text(
                            "หมวดหมู่",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        new Text(
                          "Cart",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: new TabBarView(
            children: <Widget>[
              ListView(
                children: [
                  dividerTextCustom("ส่วนผสม"),
                  Container(
                    height: 75,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 5,
                        children: [
                          MenuFeature(
                            iconAsset:
                                "https://image.flaticon.com/icons/png/128/5019/5019495.png",
                            name: "เมนูน้ำ",
                          ),
                          MenuFeature(
                            iconAsset:
                                "https://image.flaticon.com/icons/png/128/5019/5019495.png",
                            name: "เมนูสุขภาพ",
                          ),
                        ],
                      ),
                    ),
                  ),
                  dividerTextCustom("หมวดหมู่"),
                  Container(
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 5,
                          children: List.generate(6, (index) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.black,
                                      backgroundImage:
                                          AssetImage(iconFood[index]),
                                    ),
                                  ),
                                  Text(
                                    menuFood[index],
                                    // style: Theme.of(context).textTheme.headline5,
                                  ),
                                ],
                              ),
                            );
                          })),
                    ),
                  ),
                  dividerTextCustom("หมวดหมู่"),
                  Container(
                    height: 75,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 5,
                          children: List.generate(1, (index) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.black,
                                      backgroundImage:
                                          AssetImage(iconFood[index]),
                                    ),
                                  ),
                                  Text(
                                    menuFood[index],
                                    // style: Theme.of(context).textTheme.headline5,
                                  ),
                                ],
                              ),
                            );
                          })),
                    ),
                  ),
                  dividerTextCustom("หมวดหมู่"),
                  Container(
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 5,
                          children: List.generate(6, (index) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.black,
                                      backgroundImage:
                                          AssetImage(iconFood[index]),
                                    ),
                                  ),
                                  Text(
                                    menuFood[index],
                                    // style: Theme.of(context).textTheme.headline5,
                                  ),
                                ],
                              ),
                            );
                          })),
                    ),
                  ),
                  dividerTextCustom("หมวดหมู่"),
                  Container(
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 5,
                          children: List.generate(6, (index) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.black,
                                      backgroundImage:
                                          AssetImage(iconFood[index]),
                                    ),
                                  ),
                                  Text(
                                    menuFood[index],
                                    // style: Theme.of(context).textTheme.headline5,
                                  ),
                                ],
                              ),
                            );
                          })),
                    ),
                  ),
                ],
              ),
              new Column(
                children: <Widget>[new Text("Cart Page")],
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding dividerTextCustom(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: <Widget>[
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
  MenuFeature({this.iconAsset, this.name});
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
                        "https://www.mama.co.th/imgadmins/img_product_cate/big/cate_big_20180409150840.jpg",
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
              width: 50,
              height: 50,
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
