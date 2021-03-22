import 'package:flutter/material.dart';

class ShowFood extends StatefulWidget {
  ShowFood({Key key}) : super(key: key);

  @override
  _ShowFoodState createState() => _ShowFoodState();
}

class _ShowFoodState extends State<ShowFood> {

  List<String> test = ["11111","22222","333333","44444","55555"];
  // List<TextEditingController> controllers2 = <TextEditingController>[]; //ทดสอบ
  List<List<TextEditingController>> controllers =
      <List<TextEditingController>>[];
  List<Widget> _buildList() {
    int i;
    // if (controllers.length < 5) {
    //   for (i = controllers.length; i < 5; i++) {
    //     var ctl = <TextEditingController>[];
    //     ctl.add(TextEditingController());
    //     // ctl.add(TextEditingController());
    //     controllers.add(ctl);
    //   }
    // }

    //  if (5 < controllers.length) {
      for (i = 0; i < test.length; i++) {
        var ctl = <TextEditingController>[];
        ctl.add(TextEditingController());
        // ctl.add(TextEditingController());
        controllers.add(ctl);
      }
    // }

    i = 0;

    return controllers.map<Widget>((List<TextEditingController> controller) {
      int displayNumber = i;
      i++;

      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 10, 0),
            child: Text(
              displayNumber.toString()+".",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
          ),
          Text(
            test[displayNumber],
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
          ),
          SizedBox(
            width: 50,
          ),
          Text(
            test[displayNumber],
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
          ),
        ],
      );
    }).toList(); // แปลงเป็นlist
  }

  List<List<TextEditingController>> controllers2 =
      <List<TextEditingController>>[];
  List<Widget> _buildList2() {
    int i;
    if (controllers.length < 5) {
      for (i = controllers.length; i < 5; i++) {
        var ctl = <TextEditingController>[];
        ctl.add(TextEditingController());
        ctl.add(TextEditingController());
        controllers.add(ctl);
      }
    }

    i = 0;

    return controllers.map<Widget>((List<TextEditingController> controller) {
      int displayNumber = i + 1;
      i++;

      return Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 10, 0),
                child: Text(
                  "$displayNumber.",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                ),
              ),
              Text(
                "ฟฟฟฟฟฟฟฟsssssssssss",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 200,
                  width: 300,
                  child: Image.network(
                    "https://www.emquartier.co.th/wp-content/uploads/2018/01/980x525-5-1024x549.jpg",
                    fit: BoxFit.cover,
                  )),
            ],
          )
        ],
      );
    }).toList(); // แปลงเป็นlist
  }

  final List<Widget> ingredient = [
    Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Text(
            "1.",
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
          ),
        ),
        Text(
          "พริกไทย",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
        ),
        SizedBox(
          width: 30,
        ),
        Text(
          "1 กรัม",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
        ),
      ],
    ),
    Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Text(
            "2.",
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
          ),
        ),
        Text(
          "เกลือ",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
        ),
        SizedBox(
          width: 30,
        ),
        Text(
          "1 กรัม",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
        ),
      ],
    ),
    Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Text(
            "3.",
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
          ),
        ),
        Text(
          "ผักกาด",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
        ),
        SizedBox(
          width: 30,
        ),
        Text(
          "1 กรัม",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> test = _buildList();
    final List<Widget> test2 = _buildList2();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 270,
                    width: 500,
                    color: Colors.white24,
                  ),
                  Container(
                      height: 200,
                      width: 500,
                      child: Image.network(
                        "https://www.emquartier.co.th/wp-content/uploads/2018/01/980x525-5-1024x549.jpg",
                        fit: BoxFit.cover,
                      )),
                  Positioned(
                    top: 100,
                    left: 120,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 75,
                        backgroundImage: NetworkImage(
                            "https://sahamongkolfilm.com/Sahamongkolfilm/wp-content/uploads/2017/06/PeachGirl-crt03.jpg"),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 210,
                    left: 240,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              Text(
                "เซฟป้อม",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              Text(
                "ต๊อกโบกี",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.double),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    height: 200,
                    width: 300,
                    child: Image.network(
                      "https://www.emquartier.co.th/wp-content/uploads/2018/01/980x525-5-1024x549.jpg",
                      fit: BoxFit.cover,
                    )),
              ),

              Divider(
                thickness: 1,
                color: Colors.grey,
              ),

              Text(
                "ส่วนผสม",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.double),
              ),
              ListView(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: test,
              ),
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              Text(
                "วิธีทำ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.double),
              ),
              ListView(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: test2,
              ),
              // Text(
              //   "วิธีทำ",
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              // ),
              // ListView(
              //   padding: EdgeInsets.all(0),
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   children: ingredient,
              // ),

              //  SliverFillRemaining(
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       border: Border.all(color: Colors.grey),
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     margin: const EdgeInsets.all(10),
              //     padding: const EdgeInsets.all(10),
              //     child: ListView.separated(
              //       physics: NeverScrollableScrollPhysics(),
              //       itemCount: 5,
              //       separatorBuilder: (ctx, index) => Divider(),
              //       itemBuilder: (ctx,index) => ListTile(
              //         leading: CircleAvatar(
              //           child: Text('# ${(index + 1)}'),
              //         ),
              //         title: Text(
              //           "4"
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ],
      ),
    );
  }
}
