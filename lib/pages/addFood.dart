import 'dart:convert';

import 'package:easy_cook/pages/test.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddFoodPage extends StatefulWidget {
  /////////////////////ส่วนผสม///////////////////
  // AddFoodPage({Key key}) : super(key: key);
  const AddFoodPage({
    this.initialCount = 1,
    this.initialCount2 = 1, //ทดสอบ
  });
  // ยังอนุญาตให้มีจำนวนผู้เล่นเริ่มต้นแบบไดนามิก
  final int initialCount;
  final int initialCount2; //ทดสอบ
  /////////////////////ส่วนผสม///////////////////

  @override
  _AddFoodPageState createState() => _AddFoodPageState();
}

String _name;

var image = TextEditingController();
var img;
Widget _buildNameField() {
  return TextFormField(
    decoration: InputDecoration(labelText: 'ชื่ออาหาร'),
    // maxLength: 30,
    onChanged: (String text) {
      _name = text;
    },
  );
}

class _AddFoodPageState extends State<AddFoodPage> {
  int fieldCount = 0;
  int nextIndex = 0;

  List<TextEditingController> controllers = <TextEditingController>[];

  List<Widget> _buildList() {
    int i;
    if (controllers.length < fieldCount) {
      for (i = controllers.length; i < fieldCount; i++) {
        controllers.add(TextEditingController());
      }
    }

    i = 0;

    return controllers.map<Widget>((TextEditingController controller) {
      

      int displayNumber = i + 1;
      i++;
     

      return Row(
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
                  controller: controller,
                  onChanged: (text) {
                    // controllers1[displayNumber] = text;
                    print(text+""+displayNumber.toString());
                   
                    // print(text + "${displayNumber}.");
                  },
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                    hintText: "ส่วนผสม $displayNumber",
                    // labelText: 'ส่วนผสม',
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: (text) {
                    // controllers2[displayNumber] = text;
                    print(text+""+displayNumber.toString());
                    
                    // print(controllers2[displayNumber]);
                  },
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                    hintText: "ขนาด $displayNumber",
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
          );
    }).toList(); // แปลงเป็นlist
  }

  int fieldCount2 = 0;//ทดสอบ
  int nextIndex2 = 0;//ทดสอบ

  List<TextEditingController> controllers2 = <TextEditingController>[];//ทดสอบ

  List<Widget> _buildList2() {//ทดเสอบ
    int i;
    if (controllers2.length < fieldCount2) {
      for (i = controllers2.length; i < fieldCount2; i++) {
        controllers2.add(TextEditingController());
      }
    }

    i = 0;

    return controllers2.map<Widget>((TextEditingController controller2) {
      int displayNumber = i + 1;
      i++;
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
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
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  controller: controller2,
                  onChanged: (text) {
                    print(text + "${displayNumber}.");
                  },
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                    hintText: "วิธีทำ $displayNumber",
                    // labelText: 'ส่วนผสม',
                  ),
                ),
              ),
              // Expanded(
              //   child: TextField(
              //     controller: controller2,
              //     onChanged: (text) {
              //       print(text + "${displayNumber}.");
              //     },
              //     decoration: InputDecoration(
              //       // border: OutlineInputBorder(),
              //       hintText: "ขนาด $displayNumber",
              //       suffixIcon: IconButton(
              //         icon: Icon(Icons.clear),
              //         onPressed: () {
              //           setState(() {
              //             fieldCount2--;
              //             controllers2.remove(controller2);
              //           });
              //         },
              //       ),
              //     ),
              //   ),
              // ),
              
            ],
          ),
        ),
      );
    }).toList(); // แปลงเป็นlist
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = _buildList();
    final List<Widget> children2 = _buildList2();//ทดสอบ
    return Scaffold(
        appBar: AppBar(
          title: Text('เพิ่มสูตรอาหาร'),
        ),
        body: Container(
          margin: EdgeInsets.all(5),
          child: Form(
              child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: _buildNameField(),
              ),
              Center(
                child: new Text('ตั้งรูปปกอาหาร'),
              ),
              (img == null)
                  ? IconButton(
                      iconSize: 200,
                      icon: Image.asset('assets/images/camera.png'),
                      onPressed: () async {
                        img = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                        String bit = base64Encode(img.readAsBytesSync());
                        image.text = bit;

                        print(img);

                        setState(() {});
                      })
                  : InkWell(
                      child: Image.file(
                        img,
                        width: 0,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                      onTap: () async {
                        img = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                        String bit = base64Encode(img.readAsBytesSync());
                        image.text = bit;

                        print(img);

                        setState(() {});
                      }),

              Divider(
                thickness: 1,
              ),

              ////////////////////ส่วนผสม//////////////////////
              Center(
                child: new Text('ส่วนผสม'),
              ),

              ListView(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: children,
              ),
              GestureDetector(
                onTap: () {
                  // เมื่อเพิ่มlist(ส่วนผสม)เราจำเป็นต้องใส่ fieldCount เท่านั้น, because the _buildList()
                  // จะจัดการสร้าง TextEditingController ใหม่
                  setState(() {
                    fieldCount++;

                    for (int i = 0; i < controllers.length; i++) {
                      print("THIS IS  = ${controllers[i].text} + [${i}]");
                    }
                  });
                },
                child: Container(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'เพิ่ม ส่วนผสม',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              ////////////////////ส่วนผสม//////////////////////

              Center(
                child: new Text('วิธีทำ'),
              ),

              // ListView(
              //   padding: EdgeInsets.all(0),
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   children: children2,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     // เมื่อเพิ่มlist(ส่วนผสม)เราจำเป็นต้องใส่ fieldCount เท่านั้น, because the _buildList()
              //     // จะจัดการสร้าง TextEditingController ใหม่
              //     setState(() {
              //       fieldCount2++;

              //       for (int i = 0; i < controllers2.length; i++) {
              //         print("THIS IS  = ${controllers2[i].text} + [${i}]");
              //       }
              //     });
              //   },
              //   child: Container(
              //     color: Colors.blue,
              //     child: Padding(
              //       padding: const EdgeInsets.all(16),
              //       child: Text(
              //         'เพิ่ม วิธีทำ',
              //         style: TextStyle(
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

            ],
          )),
        ));
  }

  @override
  void initState() {
    super.initState();
    fieldCount = widget.initialCount;
    fieldCount2 = widget.initialCount2;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(AddFoodPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
