import 'dart:io';

import 'package:easy_cook/class/addFood_addImage_class.dart';
import 'package:easy_cook/pages/test2.dart';
import 'package:easy_cook/pages/test3.dart';
import 'package:easy_cook/pages/video_items.dart';
import 'package:easy_cook/style/utiltties.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';

import 'addFood_page/addImageORvideo_class.dart';

class test extends StatefulWidget {
  const test({
    this.initialCount = 1,
    this.initialCount2 = 1, //ทดสอบ
  });
  final int initialCount;
  final int initialCount2; //ทดสอบ
  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  //*******************************************************************************************************/
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
  //########################################################################################################/

  //*******************************************************************************************************/
  int fieldCount = 0; //จำนวนแถว
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
                  print('Left:' + controllers[displayNumber - 1][0].text);
                },
                decoration: InputDecoration(
                  hintText: "ส่วนผสมที่ $displayNumber",
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: controllers[displayNumber - 1][1],
                onChanged: (text) {
                  print('Right:' + controllers[displayNumber - 1][1].text);
                },
                decoration: InputDecoration(
                  hintText: "จำนวนที่ $displayNumber",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        fieldCount--;
                        controllers.remove(controller);
                        if (controllers.length == 0) {
                          this.fieldCount = 1;
                        }
                        print('controllers ${controllers.length}');
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
  //########################################################################################################/

  //*******************************************************************************************************/
  int fieldCount2 = 0; //ทดสอบ
  List<TextEditingController> controllers2 = <TextEditingController>[]; //ทดสอบ
  List<File> image2 = <File>[];

  List<Widget> _buildhowto() {
    //ทดเสอบ

    int i;
    if (controllers2.length < fieldCount2) {
      for (i = controllers2.length; i < fieldCount2; i++) {
        controllers2.add(TextEditingController());
        image2.add(File(''));
      }
    }

    i = 0;

    return controllers2.map<Widget>((TextEditingController controller2) {
      int displayNumber = i + 1;
      i++;
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        // elevation: 5,
        margin: EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    flex: 5,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      controller: controller2,
                      onChanged: (text) {
                        print(text + "${displayNumber}.");
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "วิธีทำที่ $displayNumber",
                      ),
                    ),
                  ),
                  (image2[displayNumber - 1].toString() == File('').toString())
                      ? Expanded(
                          flex: 2,
                          child: IconButton(
                              iconSize: 100,
                              icon: Image.asset('assets/images/dot.png'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new test3()),
                                ).then((value) {
                                  if (value != null) {
                                    image2[displayNumber - 1] = value.image;

                                    setState(() {});
                                  }
                                });
                              }))
                      : Container(),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      print("${displayNumber}");
                      fieldCount2--;
                      controllers2.remove(controller2);
                      image2.remove(image2[displayNumber - 1]);
                      if (controllers2.length == 0) {
                        this.fieldCount2 = 1;
                      }
                      print('controllers2.length =  ${controllers2.length}');
                      setState(() {});
                    },
                  ),
                ],
              ),
              (image2[displayNumber - 1].toString() == File('').toString())
                  ? Container()
                  : Container(
                      height: 350,
                      child: Row(
                        children: [
                          Expanded(
                              // flex: 3,
                              child: (image2[displayNumber - 1].toString() ==
                                      File('').toString())
                                  ? Container()
                                  : (lookupMimeType(image2[displayNumber - 1]
                                              .path)[0] ==
                                          "i")
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 20, 0, 0),
                                          child: Container(
                                              constraints:
                                                  new BoxConstraints.expand(
                                                height: 350.0,
                                              ),
                                              alignment: Alignment.bottomRight,
                                              padding: new EdgeInsets.only(
                                                  right: 10, bottom: 8.0),
                                              decoration: new BoxDecoration(
                                                image: new DecorationImage(
                                                  image: FileImage(image2[
                                                      displayNumber - 1]),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: ToggleButtons(
                                                color: Colors.black
                                                    .withOpacity(0.60),
                                                selectedColor: Colors.black,
                                                selectedBorderColor:
                                                    Colors.grey,
                                                // fillColor: Color(0xFF6200EE).withOpacity(0.08),
                                                splashColor: Colors.blue,
                                                hoverColor: Color(0xFF6200EE)
                                                    .withOpacity(0.04),
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                constraints: BoxConstraints(
                                                    minHeight: 30.0),
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.camera_alt,
                                                      ),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      Text("แก้ไข")
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.delete),
                                                      Text("ลบ")
                                                    ],
                                                  ),
                                                ],
                                                isSelected: [true, true],
                                                onPressed: (int index) {
                                                  setState(() {
                                                    if (index == 0) {
                                                      Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (context) =>
                                                                new test3()),
                                                      ).then((value) {
                                                        if (value != null) {
                                                          setState(() {
                                                            image2[
                                                                displayNumber -
                                                                    1] = value
                                                                .image;
                                                          });
                                                        }
                                                      });
                                                    } else if (index == 1) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'ยืนยัน'),
                                                              content: const Text(
                                                                  'คุณต้องการลบรูปนี้ ?'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          'Cancel'),
                                                                  child:
                                                                      const Text(
                                                                    'ยกเลิก',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      print(
                                                                          image2);
                                                                      image2[displayNumber -
                                                                              1] =
                                                                          File(
                                                                              '');

                                                                      Navigator.pop(
                                                                          context);
                                                                    });
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'ตกลง',
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    }
                                                  });
                                                },
                                              )),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 0),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: AspectRatio(
                                              aspectRatio: 1,
                                              child: Container(
                                                child: VideoItems(
                                                  videoPlayerController:
                                                      VideoPlayerController
                                                          .file(image2[
                                                              displayNumber -
                                                                  1]),
                                                  looping: false,
                                                  autoplay: false,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                        ],
                      ),
                    ),
              Divider(
                color: Colors.black,
              )
            ],
          ),
        ),
      );
    }).toList(); // แปลงเป็นlist
  }

  //########################################################################################################/

  List<AddImage> addImage = []; //รูปหน้าปก สูตรอาหาร
  var _ctrlNameFood = TextEditingController(); //ชื่อสูตรอาหาร
  var _ctrlExplain = TextEditingController(); //อธิบายสูตรอาหาร

  //แจ้งเตือนตอนกดโพส
  showdialogPost(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "แจ้งเตือน",
              style: TextStyle(color: Colors.red),
            ),
            content: Text("กรุณาเพิ่มรูปภาพปกอาหาร"),
            actions: [
              TextButton(
                child: Text(
                  "ตกลง",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size; //ขนาดของหน้าจอ

    final List<Widget> ingredient = _buildListingredient();
    final List<Widget> howto = _buildhowto();

    // final transformationController = TransformationController();

    return Scaffold(
      backgroundColor: Color(0xFFf3f5f9),
      appBar: AppBar(
        title: Text('เขียนสูตรอาหาร'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                print('ชื่อสูตรอาหาร ' + _ctrlNameFood.text);
                try {
                  print(addImage[0].image);
                } catch (e) {
                  print("5555555555555");
                }
                if (addImage.length == 0) {
                  showdialogPost(context);
                }

                print('อธิบายสูตร' + _ctrlExplain.text);

                print('สำหรับ ' + valueChoosePeople);
                print('เวลา ' + valueChooseTime);
                print('หมวดหมู่อาหาร ' + valueChooseFood);
              },
              child: Text('โพสต์'),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          Card(
            margin: EdgeInsets.zero, //ปรับระยะขอบการ์ดให้ติดขอบทุกด้าน
            //ปรับขอบการ์ด
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                    controller: _ctrlNameFood,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFFAFAFA),
                      border: OutlineInputBorder(),
                      hintText: "ชื่อเมนู",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                ),
                (addImage.length == 0)
                    ? Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Container(
                            color: Colors.grey,
                            height: 300,
                            width: screen.width,
                            child: TextButton.icon(
                              icon: Icon(Icons.camera_alt),
                              label: Text('รูปภาพอาหาร'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new test2()),
                                ).then((value) {
                                  if (value != null) {
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
                        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      )
                    : Container(
                        constraints: new BoxConstraints.expand(
                          height: 350.0,
                        ),
                        alignment: Alignment.bottomRight,
                        padding: new EdgeInsets.only(right: 10, bottom: 8.0),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: FileImage(addImage[0].image),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: ToggleButtons(
                          color: Colors.black.withOpacity(0.60),
                          selectedColor: Colors.black,
                          selectedBorderColor: Colors.grey,
                          splashColor: Colors.blue,
                          hoverColor: Color(0xFF6200EE).withOpacity(0.04),
                          borderRadius: BorderRadius.circular(20.0),
                          constraints: BoxConstraints(minHeight: 30.0),
                          children: <Widget>[
                            Row(
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                ),
                                SizedBox(
                                  width: 1,
                                ),
                                Text("แก้ไข")
                              ],
                            ),
                            Row(
                              children: [Icon(Icons.delete), Text("ลบ")],
                            ),
                          ],
                          isSelected: [true, true],
                          onPressed: (int index) {
                            setState(() {
                              if (index == 0) {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new test2()),
                                ).then((value) {
                                  if (value != null) {
                                    addImage.removeAt(0);
                                    setState(() {
                                      addImage.add(value);
                                    });
                                  }
                                });
                              } else if (index == 1) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('ยืนยัน'),
                                        content:
                                            const Text('คุณต้องการลบรูปนี้ ?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text(
                                              'ยกเลิก',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                addImage.removeAt(0);
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: const Text(
                                              'ตกลง',
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              }
                            });
                          },
                        )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _ctrlExplain,
                    minLines: 4,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFFAFAFA),
                      border: OutlineInputBorder(),
                      hintText: "อธิบายสูตรอาหาร",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Table(
                    border: TableBorder.all(),
                    textDirection: TextDirection.ltr,
                    children: [
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('สำหรับ'),
                        ),
                        Container(
                          width: 300.0,
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              // hint: Text('1 คน'),
                              isExpanded: true,
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
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('เวลา'),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: DropdownButton(
                            hint: Text('ภายใน 3 นาที'),
                            isExpanded: true,
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
                          child: DropdownButton(
                            hint: Text('ภายใน 3 นาที'),
                            isExpanded: true,
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            margin: EdgeInsets.all(0),
            child: Column(
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
                    child: Text('เพิ่มส่วนผสม'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            margin: EdgeInsets.all(0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "วิธีทำ",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ListView(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: howto,
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: () {
                      print('Button pressed');
                      setState(() {
                        fieldCount2++;
                      });
                    },
                    child: Text('เพิ่ม วิธีทำ'),
                  ),
                ),
              ],
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
    fieldCount2 = widget.initialCount2;
  }
}
