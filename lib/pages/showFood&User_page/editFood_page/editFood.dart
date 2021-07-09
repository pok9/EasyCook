import 'dart:io';

import 'package:easy_cook/class/addFood_addImage_class.dart';
import 'package:easy_cook/models/showfood/showfood_model.dart';
import 'package:easy_cook/pages/addFood_page/addImage.dart';
import 'package:easy_cook/pages/addFood_page/addImageOrVideo.dart';
import 'package:easy_cook/style/utiltties.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';

import '../../video_items.dart';

class EditFoodPage extends StatefulWidget {
  // EditFoodPage({Key? key}) : super(key: key);
  // const EditFoodPage({
  //   this.ingredient_row_start = 1,
  //   this.howto_row_start = 1, //ทดสอบ
  // });

  String recipeName;
  String imageFood;
  List<Ingredient> dataIngredient;
  List<Howto> dataHowto;
  EditFoodPage(
      this.recipeName, this.imageFood, this.dataIngredient, this.dataHowto);

  // final int ingredient_row_start; //จำนวนแถวส่วนผสมตั้งต้น
  // final int howto_row_start; //ทดสอบ
  @override
  _EditFoodPageState createState() => _EditFoodPageState(
      this.recipeName, this.imageFood, this.dataIngredient, this.dataHowto);
}

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

TextEditingController _ctrlPrice = TextEditingController()..text = 'ฟรี'; //ราคา

class _EditFoodPageState extends State<EditFoodPage> {
  _EditFoodPageState(String recipeName, String imageFood,
      List<Ingredient> dataIngredient, List<Howto> dataHowto) {
    this._ctrlNameFood.text = recipeName;
    this._imageFood = imageFood;

    this.ingredient_row = dataIngredient.length;
    for (int i = 0; i < dataIngredient.length; i++) {
      var ctl = <TextEditingController>[];
      ctl.add(TextEditingController(text: dataIngredient[i].ingredientName));
      ctl.add(TextEditingController(text: dataIngredient[i].amount));
      ctl_ingredient_row.add(ctl);
    }

    this.howto_row = dataHowto.length;
    for (int i = 0; i < dataHowto.length; i++) {
      ctl_howto_row.add(TextEditingController(text: dataHowto[i].description));
      imageHowto.add(File(dataHowto[i].pathFile));
      print("dataHowto[i].pathFile = ${dataHowto[i].pathFile}");
      print("File = ${File(dataHowto[i].pathFile)}");
    }
  }

  var _ctrlNameFood = TextEditingController(); //ชื่อสูตรอาหาร

  String _imageFood;
  List<AddImage> addImage = []; //รูปหน้าปก สูตรอาหาร

  int ingredient_row;
  List<List<TextEditingController>> ctl_ingredient_row =
      <List<TextEditingController>>[];
  List<Widget> _buildListingredient() {
    int i;
    if (ctl_ingredient_row.length < ingredient_row) {
      for (i = ctl_ingredient_row.length; i < ingredient_row; i++) {
        var ctl = <TextEditingController>[];
        ctl.add(TextEditingController());
        ctl.add(TextEditingController());
        ctl_ingredient_row.add(ctl);
      }
    }

    i = 0;

    return ctl_ingredient_row
        .map<Widget>((List<TextEditingController> controller) {
      int displayNumber = i + 1;
      i++;

      return Padding(
        key: ValueKey('${displayNumber - 1}'),
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.import_export_outlined),
            ),
            Expanded(
              child: TextField(
                controller: ctl_ingredient_row[displayNumber - 1][0],
                onChanged: (text) {
                  print(
                      'Left:' + ctl_ingredient_row[displayNumber - 1][0].text);
                },
                decoration: InputDecoration(
                  hintText: "ส่วนผสมที่ $displayNumber",
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: ctl_ingredient_row[displayNumber - 1][1],
                onChanged: (text) {
                  print(
                      'Right:' + ctl_ingredient_row[displayNumber - 1][1].text);
                },
                decoration: InputDecoration(
                  hintText: "จำนวนที่ $displayNumber",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        ingredient_row--;
                        ctl_ingredient_row.remove(controller);

                        if (ctl_ingredient_row.length == 0) {
                          this.ingredient_row = 1;
                        }
                        print('controllers ${ctl_ingredient_row.length}');
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

  int howto_row; //จำนวนแถววิธีทำ
  List<TextEditingController> ctl_howto_row = <TextEditingController>[]; //ทดสอบ
  List<File> imageHowto = <File>[];

  List<Widget> _buildhowto() {
    //ทดเสอบ

    int i;
    if (ctl_howto_row.length < howto_row) {
      for (i = ctl_howto_row.length; i < howto_row; i++) {
        ctl_howto_row.add(TextEditingController());
        imageHowto.add(File(''));
      }
    }

    i = 0;

    return ctl_howto_row.map<Widget>((TextEditingController controller2) {
      int displayNumber = i + 1;
      i++;
      return Card(
        key: ValueKey('${displayNumber - 1}'),
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
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.import_export_outlined),
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
                  (imageHowto[displayNumber - 1].toString() ==
                          File('').toString())
                      ? Expanded(
                          flex: 2,
                          child: IconButton(
                              iconSize: 100,
                              icon: Image.asset('assets/images/dot.png'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          new AddImageOrViderPage()),
                                ).then((value) {
                                  if (value != null) {
                                    imageHowto[displayNumber - 1] = value.image;

                                    setState(() {});
                                  }
                                });
                              }))
                      : Container(),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      print("${displayNumber}");

                      howto_row--;
                      ctl_howto_row.remove(controller2);
                      imageHowto.remove(imageHowto[displayNumber - 1]);

                      if (ctl_howto_row.length == 0) {
                        howto_row = 1;
                      }
                      print('controllers2.length =  ${ctl_howto_row.length}');
                      setState(() {});
                    },
                  ),
                ],
              ),
              (imageHowto[displayNumber - 1].toString() == File('').toString())
                  ? Container()
                  : Container(
                      height: 350,
                      child: Row(
                        children: [
                          Expanded(
                              // flex: 3,
                              child: (imageHowto[displayNumber - 1]
                                          .toString() ==
                                      File('').toString())
                                  ? Container()
                                  : (lookupMimeType(
                                              imageHowto[displayNumber - 1]
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
                                                  image: (imageHowto[displayNumber -
                                                                  1]
                                                              .path
                                                              .substring(
                                                                  0, 4) ==
                                                          "http")
                                                      ? NetworkImage(imageHowto[
                                                              displayNumber - 1]
                                                          .path)
                                                      : FileImage(imageHowto[
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
                                                                new AddImageOrViderPage()),
                                                      ).then((value) {
                                                        if (value != null) {
                                                          setState(() {
                                                            imageHowto[
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
                                                                          imageHowto);
                                                                      imageHowto[
                                                                          displayNumber -
                                                                              1] = File(
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
                                                  videoPlayerController: (imageHowto[
                                                                  displayNumber -
                                                                      1]
                                                              .path
                                                              .substring(
                                                                  0, 4) ==
                                                          "http")
                                                      ? VideoPlayerController
                                                          .network(imageHowto[
                                                                  displayNumber -
                                                                      1]
                                                              .path)
                                                      : VideoPlayerController
                                                          .file(imageHowto[
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

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size; //ขนาดของหน้าจอ

    final List<Widget> ingredient = _buildListingredient();
    final List<Widget> howto = _buildhowto();
    return Scaffold(
      backgroundColor: Color(0xFFf3f5f9),
      appBar: AppBar(
        title: Text('แก้ไขสูตรอาหาร'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                print("ชื่อเมนู = " + _ctrlNameFood.text);

                if (_imageFood != null) {
                  //รูปไม่ถูกเปลี่ยน
                  print(true);
                } else {
                  print(false);
                }

                //ส่วนผสม
                for (int i = 0; i < ctl_ingredient_row.length; i++) {
                  print((i + 1).toString() +
                      " " +
                      ctl_ingredient_row[i][0].text +
                      " " +
                      ctl_ingredient_row[i][1].text);
                }

                //วิธีทำ
                for (int i = 0; i < ctl_howto_row.length; i++) {
                  print(ctl_howto_row[i].text);
                }
              },
              child: Text('แก้ไข'),
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
                    maxLength: 30,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                    controller: _ctrlNameFood,
                    decoration: InputDecoration(
                      // errorText: _validate ? 'โปรดใส่ชื่อเมนู' : null,
                      filled: true,
                      fillColor: Color(0xFFFAFAFA),
                      border: OutlineInputBorder(),
                      hintText: "ชื่อเมนู",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    // onChanged: (value) {
                    //   if (value.length > 0) {
                    //     setState(() {
                    //       _validate = false;
                    //     });
                    //   }
                    // },
                  ),
                ),
                (addImage.length == 0 && _imageFood == null)
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
                                    builder: (context) => new AddImagePage()),
                              ).then((value) {
                                if (value != null) {
                                  setState(() {
                                    addImage.add(value);
                                  });
                                }
                              });
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                          ),
                        ),
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
                            image: (_imageFood != null)
                                ? NetworkImage(_imageFood)
                                : FileImage(addImage[0].image),
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
                          children: [
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
                                      builder: (context) => new AddImagePage()),
                                ).then((value) {
                                  if (value != null) {
                                    if (_imageFood != null) {
                                      _imageFood = null;
                                    } else {
                                      addImage.removeAt(0);
                                    }
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
                                                if (_imageFood != null) {
                                                  _imageFood = null;
                                                } else {
                                                  addImage.removeAt(0);
                                                }

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
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    // controller: _ctrlExplain,

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
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('ราคา(\u0E3F)'),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: TextField(
                            controller: _ctrlPrice,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                )
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
                // ListView(
                //     padding: EdgeInsets.all(0),
                //     shrinkWrap: true,
                //     physics: NeverScrollableScrollPhysics(),
                //     children: ingredient),
                ReorderableListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: ingredient,
                  onReorder: (int oldIndex, int newIndex) {
                    if (newIndex > oldIndex) {
                      newIndex = newIndex - 1;
                    }

                    final dragIngredient_row =
                        ctl_ingredient_row.removeAt(oldIndex);
                    setState(() {
                      ctl_ingredient_row.insert(newIndex, dragIngredient_row);
                    });
                  },
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: () {
                      print('Button pressed');
                      setState(() {
                        ingredient_row++;
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

                ReorderableListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: howto,
                  onReorder: (int oldIndex, int newIndex) {
                    if (newIndex > oldIndex) {
                      newIndex = newIndex - 1;
                    }

                    final dragHowto_row = ctl_howto_row.removeAt(oldIndex);

                    final dragImageHowto = imageHowto.removeAt(oldIndex);

                    setState(() {
                      ctl_howto_row.insert(newIndex, dragHowto_row);
                      imageHowto.insert(newIndex, dragImageHowto);
                    });
                  },
                ),
                // ListView(
                //   padding: EdgeInsets.all(0),
                //   shrinkWrap: true,
                //   physics: NeverScrollableScrollPhysics(),
                //   children: howto,
                // ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: TextButton(
                    style: flatButtonStyle,
                    onPressed: () {
                      print('Button pressed');
                      setState(() {
                        howto_row++;
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

    // ingredient_row = widget.ingredient_row_start;
    // howto_row = widget.howto_row_start;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
