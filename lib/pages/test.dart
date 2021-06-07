import 'package:easy_cook/class/addFood_addImage_class.dart';
import 'package:easy_cook/pages/test2.dart';
import 'package:flutter/material.dart';

class test extends StatefulWidget {
  // test({Key key}) : super(key: key);
  const test({
    this.initialCount = 1,
  });
  final int initialCount;
  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.white,
    minimumSize: Size(88, 44),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
    backgroundColor: Colors.blue,
  );

  String valueChoosePeople = "1 คน";
  List listPeopleItem = [
    "1 คน",
    "2 คน",
    "3 คน",
    "4 คน",
    "5 คน",
    "6 คน",
    "7 คน",
    "8 คน",
    "9 คน",
    "10 คน",
    "มากกว่า 10 คน",
    "มากกว่า 50 คน",
    "มากกว่า 100 คน"
  ];

  String valueChooseTime = "ภายใน 3 นาที";
  List listTimeItem = [
    "ภายใน 3 นาที",
    "ภายใน 5 นาที",
    "ภายใน 10 นาที",
    "ภายใน 15 นาที",
    "ภายใน 30 นาที",
    "ภายใน 60 นาที",
    "ภายใน 90 นาที",
    "ภายใน 2 ชั่วโมง",
    "มากกว่า 2 ชั่วโมง",
  ];

  String valueChooseFood = "เมนูน้ำ";
  List listFoodItem = [
    "เมนูน้ำ",
    "เมนูต้ม",
    "เมนูสุขภาพ",
    "เมนูนิ่ง",
    "เมนูตุ่น",
    "เมนูทอด",
  ];

  int fieldCount = 0;
  List<List<TextEditingController>> controllers =
      <List<TextEditingController>>[];
  List<Widget> _buildListingredient() {
    int i;
    if (controllers.length < fieldCount) {
      for (i = controllers.length; i < fieldCount; i++) {
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

      return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                "${displayNumber}.",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: controllers[displayNumber - 1][0],
                onChanged: (text) {
                  // controllers1[displayNumber] = text;
                  // print(text + "" + displayNumber.toString());
                  print('Left:' + controllers[displayNumber - 1][0].text);
                  // print(text + "${displayNumber}.");
                },
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                  hintText: "ส่วนผสมที่ $displayNumber",
                  // labelText: 'ส่วนผสม',
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: controllers[displayNumber - 1][1],
                onChanged: (text) {
                  // controllers2[displayNumber] = text;
                  // print(text + "" + displayNumber.toString());
                  print('Right:' + controllers[displayNumber - 1][1].text);
                  // print(text + "${displayNumber}.");
                  // print(controllers2[displayNumber]);
                },
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                  hintText: "จำนวนที่ $displayNumber",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        fieldCount--;
                        controllers.remove(controller);
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList(); // แปลงเป็นlist
  }

  List<AddImage> addImage = new List<AddImage>();

  @override
  Widget build(BuildContext context) {
    // final List<Widget> children = [
    //   Padding(
    //     padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.only(right: 20),
    //           child: Text(
    //             "${1}.",
    //             style: TextStyle(
    //               fontSize: 15,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //         ),
    //         Expanded(
    //           child: TextField(
    //             //controller: controllers[displayNumber - 1][0],
    //             onChanged: (text) {
    //               //print('Left:' + controllers[displayNumber - 1][0].text);
    //             },
    //             decoration: InputDecoration(
    //               hintText: "ส่วนผสมที่ 1",
    //             ),
    //           ),
    //         ),
    //         Expanded(
    //           child: TextField(
    //             //controller: controllers[displayNumber - 1][1],
    //             onChanged: (text) {
    //               //print('Right:' + controllers[displayNumber - 1][1].text);
    //             },
    //             decoration: InputDecoration(
    //               hintText: "จำนวนที่ 1",
    //               suffixIcon: IconButton(
    //                 icon: Icon(Icons.clear),
    //                 onPressed: () {
    //                   setState(() {
    //                     //fieldCount--;
    //                     //controllers.remove(controller);
    //                   });
    //                 },
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    //   Padding(
    //     padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.only(right: 20),
    //           child: Text(
    //             "${2}.",
    //             style: TextStyle(
    //               fontSize: 15,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //         ),
    //         Expanded(
    //           child: TextField(
    //             //controller: controllers[displayNumber - 1][0],
    //             onChanged: (text) {
    //               //print('Left:' + controllers[displayNumber - 1][0].text);
    //             },
    //             decoration: InputDecoration(
    //               hintText: "ส่วนผสมที่ 2",
    //             ),
    //           ),
    //         ),
    //         Expanded(
    //           child: TextField(
    //             //controller: controllers[displayNumber - 1][1],
    //             onChanged: (text) {
    //               //print('Right:' + controllers[displayNumber - 1][1].text);
    //             },
    //             decoration: InputDecoration(
    //               hintText: "จำนวนที่ 2",
    //               suffixIcon: IconButton(
    //                 icon: Icon(Icons.clear),
    //                 onPressed: () {
    //                   setState(() {
    //                     //fieldCount--;
    //                     //controllers.remove(controller);
    //                   });
    //                 },
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // ];
    var screen = MediaQuery.of(context).size;

    final List<Widget> ingredient = _buildListingredient();
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
                print(valueChoosePeople);
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
                      hintText: "ชื่อเมนู",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      // labelText: 'User Name',
                    ),
                  ),
                ),
                // Card(
                //   semanticContainer: true,
                //   clipBehavior: Clip.antiAliasWithSaveLayer,
                //   child: InkWell(
                //     onTap: () {
                //       print("tap card");
                //     },
                //     child: Container(
                //       height: 200,
                //       // width: 500,
                //       decoration: BoxDecoration(
                //           // borderRadius: BorderRadius.circular(50),
                //           image: DecorationImage(
                //               image: NetworkImage(
                //                   'https://aumento.officemate.co.th/media/catalog/product/O/F/OFM0007140.jpg?imwidth=640'),
                //               fit: BoxFit.cover)),
                //     ),
                //   ),

                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(0),
                //   ),
                //   // elevation: 5,
                //   margin: EdgeInsets.all(0),
                // ),
                // Card(
                //   semanticContainer: true,
                //   clipBehavior: Clip.antiAliasWithSaveLayer,
                //   child: Container(
                //     color: Colors.grey,
                //     height: 300,
                //     width: screen.width,
                //     child: IconButton(
                //       iconSize: 48,
                //       color: Colors.white,
                //       icon: const Icon(Icons.camera_alt_rounded),
                //       // tooltip: 'Toggle Bluetooth',
                //       onPressed: () {
                //         setState(() {
                //           // _volume += 10;
                //         });
                //       },
                //     ),
                //   ),

                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(0),
                //   ),
                //   // elevation: 5,
                //   margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                //   // margin: EdgeInsets.zero,
                // ),
                (addImage.length == 0)
                    ? Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Container(
                            color: Colors.grey,
                            height: 300,
                            width: screen.width,
                            child: TextButton.icon(
                              icon: Icon(Icons.camera),
                              label: Text('Take A Photo'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new test2()),
                                ).then((value) {
                                  if (value != null) {
                                    // image2[displayNumber - 1] = value.image;

                                    setState(() {
                                      addImage.add(value);
                                    });
                                  }
                                });
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                            )),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        // elevation: 5,
                        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        // margin: EdgeInsets.zero,
                      )
                    : Card(
                        child: Container(
                          height: 350.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(addImage[0].image),
                                fit: BoxFit.cover),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        // elevation: 5,
                        margin: EdgeInsets.zero,
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    minLines: 4,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFf3f5f9),
                      border: OutlineInputBorder(),
                      // labelText: 'User Name',
                      hintText: "อธิบายสูตรอาหาร",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    border: TableBorder.all(),
                    textDirection: TextDirection.ltr,
                    // defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('สำหรับ'),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          // decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.grey, width: 1),
                          //     borderRadius: BorderRadius.circular(15)),
                          child: DropdownButton(
                            hint: Text('1 คน'),
                            // icon: Icon(Icons.arrow_drop_down),
                            // iconSize: 36,
                            isExpanded: true,
                            // style: TextStyle(color: Colors.black, fontSize: 22),
                            underline: SizedBox(),
                            value: valueChoosePeople,
                            onChanged: (newValue) {
                              setState(() {
                                valueChoosePeople = newValue;
                              });
                            },
                            items: listPeopleItem.map((valueItem) {
                              return DropdownMenuItem(
                                value: valueItem,
                                child: Text(valueItem),
                              );
                            }).toList(),
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('เวลา'),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          // decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.grey, width: 1),
                          //     borderRadius: BorderRadius.circular(15)),
                          child: DropdownButton(
                            hint: Text('ภายใน 3 นาที'),
                            // icon: Icon(Icons.arrow_drop_down),
                            // iconSize: 36,
                            isExpanded: true,
                            // style: TextStyle(color: Colors.black, fontSize: 22),
                            underline: SizedBox(),
                            value: valueChooseTime,
                            onChanged: (newValue) {
                              setState(() {
                                valueChooseTime = newValue;
                              });
                            },
                            items: listTimeItem.map((valueItem) {
                              return DropdownMenuItem(
                                value: valueItem,
                                child: Text(valueItem),
                              );
                            }).toList(),
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('หมวดหมู่อาหาร'),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          // decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.grey, width: 1),
                          //     borderRadius: BorderRadius.circular(15)),
                          child: DropdownButton(
                            hint: Text('ภายใน 3 นาที'),
                            // icon: Icon(Icons.arrow_drop_down),
                            // iconSize: 36,
                            isExpanded: true,
                            // style: TextStyle(color: Colors.black, fontSize: 22),
                            underline: SizedBox(),
                            value: valueChooseFood,
                            onChanged: (newValue) {
                              setState(() {
                                valueChooseFood = newValue;
                              });
                            },
                            items: listFoodItem.map((valueItem) {
                              return DropdownMenuItem(
                                value: valueItem,
                                child: Text(valueItem),
                              );
                            }).toList(),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            // semanticContainer: true,
            // clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            // elevation: 5,
            margin: EdgeInsets.all(0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "ส่วนผสม",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // ListView(
                //     padding: EdgeInsets.all(0),
                //     shrinkWrap: true,
                //     physics: NeverScrollableScrollPhysics(),
                //     children: children),
                // ReorderableListView(
                //     onReorder: (int oldIndex, int newIndex) {},
                //     children: [
                //       // for (final course in _courses)
                //       ListTile(
                //         key: ValueKey(1),
                //         // leading: Image.network(course.imageLocation),
                //         title: Text('test'),
                //       ),
                //     ]),
                ListView(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: ingredient),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: () {
                      print('Button pressed');
                      setState(() {
                        fieldCount++;
                      });
                    },
                    child: Text('เพิ่มสูตรอาหาร'),
                  ),
                ),
                // Container(
                //   color: Colors.red,
                //   child: FractionallySizedBox(
                //       widthFactor: 1,
                //       child: FlatButton(
                //           materialTapTargetSize:
                //               MaterialTapTargetSize.shrinkWrap,
                //           onPressed: () {
                //             print("เพิ่มสูตรอาหาร");
                //           },
                //           color: Color(0xFF00A0BE),
                //           textColor: Color(0xFFFFFFFF),
                //           child: Text('LOGIN',
                //               style: TextStyle(letterSpacing: 4.0)),
                //           shape:
                //               RoundedRectangleBorder(side: BorderSide.none))),
                // ),
              ],
            ),
          ),
          Card(
            color: Colors.red,
            child: Container(
              height: 500,
              child: Column(
                children: [
                  // TextField(
                  //   style: TextStyle(fontWeight: FontWeight.w300),

                  //   // controller: nameController,
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     // labelText: 'User Name',
                  //   ),
                  // )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fieldCount = widget.initialCount;
  }
}
