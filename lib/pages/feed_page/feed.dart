import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFf3f5f9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: Text('Easy Cook'),
        ),
      ),
      drawer: Container(
        width: deviceSize.width - 45,
        child: Drawer(
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {},
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: new NetworkImage(
                          "https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?size=626&ext=jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login-page');
                              },
                              child: Text(
                                'เข้าสู่ระบบ',
                              ),
                              style: ButtonStyle(
                                  side: MaterialStateProperty.all(BorderSide(
                                      width: 2, color: Colors.white)),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 50)),
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(fontSize: 15)))),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/register-page');
                              },
                              child: Text(
                                'สมัครสมาชิก',
                              ),
                              style: ButtonStyle(
                                  side: MaterialStateProperty.all(BorderSide(
                                      width: 2, color: Colors.white)),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 43)),
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(fontSize: 15)))),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Column(
                          children: [
                            Row(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.folder,
                  color: Colors.cyan,
                  size: 30,
                ),
                title: Text('สูตรที่ซื้อ',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 23,
                        color: Colors.black)),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.notifications,
                  color: Colors.cyan,
                  size: 30,
                ),
                title: Text('การแจ้งเตือน',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 23,
                        color: Colors.black)),
                onTap: () {},
              ),
              Divider(
                thickness: 0.5,
                color: Colors.grey,
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.cyan,
                  size: 30,
                ),
                title: Text('ตั้งค่า',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 23,
                        color: Colors.black)),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.cyan,
                  size: 30,
                ),
                title: Text('ออกจากระบบ',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 23,
                        color: Colors.black)),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 3.0, bottom: 10),
                  //   child: Text(
                  //     "Easy Cook",
                  //     style:
                  //         TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  // Container(
                  //     height: 50,
                  //     decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(30),
                  //         border: Border.all(color: Colors.grey)),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: TextField(
                  //         decoration: InputDecoration(
                  //             hintText: "Find a food or Restaur",
                  //             prefixIcon: Icon(
                  //               Icons.search,
                  //               color: Colors.indigo,
                  //             ),
                  //             suffixIcon: Icon(
                  //               Icons.add_road_rounded,
                  //               color: Colors.grey,
                  //             ),
                  //             focusedBorder: InputBorder.none,
                  //             enabledBorder: InputBorder.none,
                  //             errorBorder: InputBorder.none,
                  //             disabledBorder: InputBorder.none),
                  //       ),
                  //     )),
                  // SizedBox(
                  //   height: 25,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "สูตรอาหารยอดนิยม",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_forward_rounded, color: Colors.indigo)
                        // Text(
                        //   "ดูทั้งหมด",
                        //   style: TextStyle(
                        //       fontSize: 20, fontWeight: FontWeight.normal),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                      height: 240,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return _foodCard_1(context);
                          })),

                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "สูตรอาหารยอดนิยม",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_forward_rounded, color: Colors.indigo)
                        // Text(
                        //   "ดูทั้งหมด",
                        //   style: TextStyle(
                        //       fontSize: 20, fontWeight: FontWeight.normal),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                      height: 240,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return _foodCard_1(context);
                          })),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Top Offers",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_forward_rounded, color: Colors.indigo)
                      // Text(
                      //   "ดูทั้งหมด",
                      //   style: TextStyle(
                      //       fontSize: 20, fontWeight: FontWeight.normal),
                      // ),
                    ],
                  ),
                  Container(
                      height: 330,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return _foodCardSlim_1(context);
                          })),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _foodCard_1(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Card(
        child: Container(
          color: Colors.white,
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 125,
                width: 250,
                decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://images.unsplash.com/photo-1484723091739-30a097e8f929?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
                        fit: BoxFit.cover)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //   height: 40.0,
                        //   width: 40.0,
                        //   decoration: new BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       image: new DecorationImage(
                        //           fit: BoxFit.fill,
                        //           image: new NetworkImage(
                        //               "https://images.unsplash.com/photo-1484723091739-30a097e8f929?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"))),
                        // ),
                        Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                      "https://images.unsplash.com/photo-1484723091739-30a097e8f929?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"))),
                        ),
                        Text(
                          "ต้ำยำกุ้ง",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              "4.2",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Theme.of(context).primaryColor,
                                  size: 16.0,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Theme.of(context).primaryColor,
                                  size: 16.0,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Theme.of(context).primaryColor,
                                  size: 16.0,
                                ),
                                Icon(
                                  Icons.star_half,
                                  color: Theme.of(context).primaryColor,
                                  size: 16.0,
                                ),
                                Icon(
                                  Icons.star_border,
                                  color: Theme.of(context).primaryColor,
                                  size: 16.0,
                                ),
                              ],
                            ),
                            Text(
                              "(12)",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      "\$25",
                      style: TextStyle(
                          color: Colors.indigo, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _foodCardSlim_1(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://images.unsplash.com/photo-1484723091739-30a097e8f929?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
                            fit: BoxFit.cover)),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ต้ำยำกุ้ง",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Italian Recipe for you",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      "ฟรี",
                      style: TextStyle(
                          color: Colors.indigo, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: Divider(
                height: 2,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
