import 'dart:io';

import 'package:easy_cook/class/addFood_addImage_class.dart';
import 'package:easy_cook/pages/addFood_page/addImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewPage extends StatefulWidget {
  // ReviewPage({Key? key}) : super(key: key);
  double rating = 0.0;
  ReviewPage(this.rating);

  @override
  _ReviewPageState createState() => _ReviewPageState(this.rating);
}

class _ReviewPageState extends State<ReviewPage> {
  double _rating;

  _ReviewPageState(this._rating);
  List<AddImage> addImage = []; //รูปอาหาร
  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;

    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0))),
          content: Container(
            width: double.maxFinite,
            // width: 50,
            child: Column(
              mainAxisSize: MainAxisSize.min, //autoSize

              children: [
                RatingBarIndicator(
                  rating: _rating,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.blue,
                  ),
                  itemCount: 5,
                  itemSize: 47.5,
                  direction: Axis.horizontal,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: TextFormField(
                    // controller: _ctrlExplain,
                    // maxLength: 60,
                    minLines: 4,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFFAFAFA),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0))),
                      hintText: "เขียนรีวิว",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                ),
                Row(
                  children: [
                    (addImage.length == 0)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(),
                                primary: Colors.grey,
                                padding: EdgeInsets.all(15)),
                            child: Icon(
                              Icons.add,
                              size: 50,
                            ),
                            onPressed: () {
                              print("เพิ่มรูปภาพ");
                              print(addImage.length);
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new AddImagePage()),
                              ).then((value) {
                                print("pokkk");
                                // print("value = $value");
                                if (value != null) {
                                  setState(() {
                                    addImage.add(value);
                                  });
                                }
                              });
                            },
                          )
                        : Container(
                            height: 165,
                            width: 165,
                            child: Stack(
                              children: [
                                Image.file(
                                  addImage[0].image,
                                  width: 150,
                                  height: 150,
                                ),
                                Positioned(
                                  right: -14,
                                  top: -6,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        addImage = [];
                                      });
                                    },
                                    child:
                                        Icon(Icons.clear, color: Colors.white),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      // padding: EdgeInsets.all(0),
                                      primary: Colors.grey, // <-- Button color
                                      onPrimary: Colors.red, // <-- Splash color
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        'ยกเลิก',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text('โพสต์'),
                      onPressed: () {},
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   child: Text('ยกเลิก'),
                    //   style: ElevatedButton.styleFrom(
                    //     primary: Colors.red,
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 5,
                    // ),
                    // ElevatedButton(
                    //   onPressed: () {},
                    //   child: Text('โพสต์'),
                    //   style: ElevatedButton.styleFrom(
                    //     primary: Colors.blue,
                    //   ),
                    // )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
