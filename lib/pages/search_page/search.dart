import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
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
  _search() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ค้นหา'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
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
                  child: TextFormField(
                    onChanged: (String txet) {
                      setState(() {
                        
                      });
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: "ค้นหาสูตรอาหาร",
                        contentPadding: const EdgeInsets.only(left: 24.0),
                        border: InputBorder.none),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/searchRecipeName', (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
      body: (_controller.text != "") ? Container() : GridView.count(
          crossAxisCount: 4,
          children: List.generate(6, (index) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.black,
                      backgroundImage: AssetImage(iconFood[index]),
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
    );
  }
}
