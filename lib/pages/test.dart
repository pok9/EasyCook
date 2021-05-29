import 'package:flutter/material.dart';

class test extends StatefulWidget {
  test({Key key}) : super(key: key);

  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf3f5f9),
      appBar: AppBar(
        title: Text('เขียนสูตรอาหาร'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Respond to button press
              },
              child: Text('โพสต์'),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
                // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                // textStyle:
                //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: TextStyle(fontWeight: FontWeight.w300),

                    // controller: nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFf3f5f9),
                      border: OutlineInputBorder(),
                      // labelText: 'User Name',
                    ),
                  ),
                ),
                Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
                    onTap: () {
                      print("tap card");
                    },
                    child: Container(
                      height: 200,
                      // width: 500,
                      decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://aumento.officemate.co.th/media/catalog/product/O/F/OFM0007140.jpg?imwidth=640'),
                              fit: BoxFit.cover)),
                    ),
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  // elevation: 5,
                  margin: EdgeInsets.all(0),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    minLines: 6,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFf3f5f9),
                      border: OutlineInputBorder(),
                      // labelText: 'User Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    border: TableBorder.all(),
                    children: [
                      TableRow(children: [
                        Text('สำหรับ'),
                        TextField(
                          style: TextStyle(fontWeight: FontWeight.w300),

                          // controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFf3f5f9),
                            border: OutlineInputBorder(),
                            // labelText: 'User Name',
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Text('สำหรับ'),
                        TextField(
                          style: TextStyle(fontWeight: FontWeight.w300),

                          // controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFf3f5f9),
                            border: OutlineInputBorder(),
                            // labelText: 'User Name',
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: <Widget>[
                //       Text('สำหรับ'),
                //       new Flexible(
                //         child: Padding(
                //           padding: const EdgeInsets.fromLTRB(100, 0, 10, 0),
                //           child: new TextField(
                //             style: TextStyle(fontWeight: FontWeight.w300),

                //             // controller: nameController,
                //             decoration: InputDecoration(
                //               filled: true,
                //               fillColor: Color(0xFFf3f5f9),
                //               border: OutlineInputBorder(),
                //               // labelText: 'User Name',
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: <Widget>[
                //       Text('เวลาที่ใช้'),
                //       new Flexible(
                //         child: Padding(
                //           padding: const EdgeInsets.fromLTRB(100, 0, 10, 0),
                //           child: new TextField(
                //             style: TextStyle(fontWeight: FontWeight.w300),

                //             // controller: nameController,
                //             decoration: InputDecoration(
                //               filled: true,
                //               fillColor: Color(0xFFf3f5f9),
                //               border: OutlineInputBorder(),
                //               // labelText: 'User Name',
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                TextField(
                  style: TextStyle(fontWeight: FontWeight.w300),

                  // controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    // labelText: 'User Name',
                  ),
                )
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                TextField(
                  style: TextStyle(fontWeight: FontWeight.w300),

                  // controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    // labelText: 'User Name',
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
