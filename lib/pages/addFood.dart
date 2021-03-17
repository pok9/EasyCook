import 'dart:convert';
import 'dart:io';

import 'package:easy_cook/class/addFood_addImage_class.dart';
import 'package:easy_cook/class/token_class.dart';
import 'package:easy_cook/database/db_service.dart';
import 'package:easy_cook/models/addFood/addIngredientsArray_model.dart';
import 'package:easy_cook/models/addFood/createPost_model.dart';
import 'package:easy_cook/pages/addFood_addImage.dart';
import 'package:easy_cook/pages/test.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../class/token_class.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; //->

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

// CreatePostModel
Future<CreatePostModel> createPosts(
    String tokens, File image, String recipe_name, double price) async {
  // final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signin";
  final String apiUrl = "http://apifood.comsciproject.com/pjPost/createPost";

  final mimeTypeData =
      lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');

  final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(apiUrl));

  final file = await http.MultipartFile.fromPath('image', image.path,
      contentType: new MediaType(mimeTypeData[0], mimeTypeData[1]));

  imageUploadRequest.files.add(file);
  imageUploadRequest.fields['token'] = tokens;
  imageUploadRequest.fields['recipe_name'] = recipe_name;
  imageUploadRequest.fields['price'] = price.toString();
  var streamedResponse = await imageUploadRequest.send();
  var response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 200) {
    final String responseString = response.body;

    return createPostModelFromJson(responseString);
  } else {
    return null;
  }

  // imageUploadRequest.files.add(file);
  // imageUploadRequest.fields['token'] = tokens;

  // var streamedResponse = await imageUploadRequest.send();
  // var response = await http.Response.fromStream(streamedResponse);

  // if (response.statusCode == 200) {
  //   final String responseString = response.body;

  //   return register2ModelFromJson(responseString);
  // } else {
  //   return null;
  // }
}

Future<AddIngredientsArrayModel> addIngredients(
    String recipe_ID, List<String> ingredientName, List<String> amount, List<String> step) async {
  final String apiUrl =
      "http://apifood.comsciproject.com/pjPost/addIngredientsArray";

  print(ingredientName);
  print(amount);
  print(step);

  // List<st>
  var data = {
    "recipe_ID": recipe_ID,
    "ingredientName": ingredientName,
    "amount": amount,
    "step": step
  };
  print("jsonEncode(data) = "+jsonEncode(data));
  final response = await http.post(Uri.parse(apiUrl), body:jsonEncode(data),headers: {"Authorization": "Bearer $token","Content-Type" : "application/json"});

  // print( );
  // addIngredientsArrayModelFromJson
  // print("addIngredients======");
  print("addIngredients======"+(response.statusCode.toString()));
  // print("addIngredients======"+(response));
  if (response.statusCode == 200) {
    final String responseString = response.body;

    return addIngredientsArrayModelFromJson(responseString);
  } else {
    return null;
  }
}

var _ctrlNameFood = new TextEditingController(); //ชื่อเมนู
String token = ""; //โทเคน
double price = 0.0;

int recipe_id_come = 0;

Widget _buildNameField() {
  return TextFormField(
    controller: _ctrlNameFood,
    decoration: InputDecoration(labelText: 'ชื่อเมนู'),
    // maxLength: 30,
    // onChanged: (String text) {
    //   _name = text;
    // },
  );
}

// String _name;

// Future<String> getToken() async {
//   var service = DBService();
//   var body = await service.readData();
//   body.forEach((token) {
//     // setState(() {
//       var tokenModel = Token_jwt();
//       print(token['id']);
//       print(token['token']);
//     // });
//   });
//   // return token['token'];
//   // return token[0]['token'];
//   token = body[0]['token'];
// }
Future<String> tokens() async {
  token = await Token_jwt().getTokens();
}

class _AddFoodPageState extends State<AddFoodPage> {
  _AddFoodPageState() {
    tokens();
    print("Token = " + token);

    // String str = );
    // print(str.toString());

    // print("pok 555"+token);
    // String token = await _getTokens();
    // Future<String> token = getToken();
    // print(token);
    // getToken();
    // print("token = " + token);

    // print("55555");
    // String token = getToken() as String;
    // print("token = "+token);

    // var service = DBService();
    //                   var token = await service.readData();
    //                   token.forEach((token){
    //                     setState(() {
    //                       var tokenModel = Token_jwt();
    //                       print(token['id']);
    //                       print(token['token']);
    //                     });
    //                   });
  }

  // final storage = new FlutterSecureStorage();
  final _picker = ImagePicker();
  List<AddImage> addImage = List<AddImage>();
  // List<AddImage> addImage2 = List<AddImage>();

  // var image = TextEditingController();
  // var img;

  int fieldCount = 0;
  int nextIndex = 0;

  List<List<TextEditingController>> controllers =
      <List<TextEditingController>>[];

  List<Widget> _buildList() {
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
                hintText: "ขนาดที่ $displayNumber",
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

  int fieldCount2 = 0; //ทดสอบ
  int nextIndex2 = 0; //ทดสอบ

  List<TextEditingController> controllers2 = <TextEditingController>[]; //ทดสอบ
  List<File> image2 = <File>[];

  List<Widget> _buildList2() {
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
      return Row(
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
                // border: OutlineInputBorder(),
                hintText: "วิธีทำที่ $displayNumber",
                // suffixIcon: IconButton(
                //   icon: Icon(Icons.clear),
                //   onPressed: () {
                //     setState(() {
                //       // fieldCount2--;
                //       // controllers2.remove(controller2);
                //     });
                //   },
                // ),
                // labelText: 'ส่วนผสม',
              ),
            ),
          ),
          Expanded(
            flex: 3,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       print("5555 " + displayNumber.toString());
            //     },
            //     style: ButtonStyle(backgroundColor:
            //         MaterialStateProperty.resolveWith(
            //             (Set<MaterialState> states) {
            //       return Theme.of(context).colorScheme.primary.withOpacity(0.5);
            //       ;
            //     })),
            //     // color: Colors.orangeAccent,
            //     // padding: EdgeInsets.all(10.0),
            //     child: Column(
            //       children: [
            //         Icon(Icons.add),
            //       ],
            //     ),
            //   ),
            child: (image2[displayNumber - 1].toString() == File('').toString())
                ? IconButton(
                    iconSize: 100,
                    icon: Image.asset('assets/images/add.png'),
                    // onPressed: () async {

                    //   final pickedFile =
                    //       await _picker.getImage(source: ImageSource.gallery);
                    //   // img = await ImagePicker().getImage(
                    //   //     source: ImageSource.gallery);
                    //   img = File(pickedFile.path);
                    //   // String bit = base64Encode(img.readAsBytesSync());
                    //   // image.text = bit;

                    //   print(img);
                    //   setState(() {});
                    // }
                    onPressed: () {
                      // print("test = " + displayNumber.toString());
                      // print(image2.length);
                      // print(image2[displayNumber - 1]);
                      // print(File(''));
                      // image2[displayNumber - 1].toString() == File('').toString() ///////

                      // if (image2[displayNumber - 1].toString() == File('').toString()) {
                      //   print("true" + displayNumber.toString());
                      // }

                      // Navigator.push(
                      //   context,
                      //   new MaterialPageRoute(
                      //       builder: (context) => new AddFood_AddImagePage()),
                      // ).then((value) {
                      //   if (value != null) {
                      //     // image2[displayNumber - 1] = value;
                      //     // print("value = "+image2[displayNumber - 1].toString());

                      //     // print(value);
                      //     // addImage.add(value);
                      //     // img = addImage[0].image;
                      //     // setState(() {});
                      //   }
                      // });

                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new AddFood_AddImagePage()),
                      ).then((value) {
                        if (value != null) {
                          image2[displayNumber - 1] = value.image;
                          // addImage2.add(value);
                          // image2[displayNumber - 1] =
                          //     addImage2[displayNumber - 1].image;
                          setState(() {});
                        }
                      });
                    })
                : InkWell(
                    child: Image.file(
                      image2[displayNumber - 1],
                      width: 0,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    onTap: () async {
                      print("77777777777777");
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new AddFood_AddImagePage()),
                      ).then((value) {
                        if (value != null) {
                          image2[displayNumber - 1] = value.image;
                          // image2[displayNumber - 1] =
                          //     addImage2[displayNumber - 1].image;

                          // image2[displayNumber - 1] = value;
                          setState(() {});
                        }
                      });
                    }),
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              print("${displayNumber}");
              fieldCount2--;
              controllers2.remove(controller2);
              image2.remove(image2[displayNumber - 1]);
              setState(() {});
            },
          ),
        ],
      );
    }).toList(); // แปลงเป็นlist
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = _buildList();
    final List<Widget> children2 = _buildList2(); //ทดสอบ

    return Scaffold(
        appBar: AppBar(
          title: Text('เพิ่มสูตรอาหาร'),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  // print(_ctrlNameFood.text);
                  // print(addImage[0].image);
                  // print(token);
                  // print(price);
                  // createPosts
                  if (_ctrlNameFood.text != '') {
                    final CreatePostModel res = await createPosts(
                        token, addImage[0].image, _ctrlNameFood.text, price);

                    // print(res.success);
                    // print(res.recipeId);
                    recipe_id_come = res.recipeId;

                    // for(var data in controllers){
                    //   print(data[1].text)
                    //   print(data[1].text);
                    // }
                    // print(controllers[0][1].text);
                    // for(var i = 0; i<controllers[0].length;i++){
                    //     print(controllers[i][0].text+" "+controllers[i][1].text);
                    // }

                    List<String> ingredientName = [];
                    List<String> amount = [];
                    List<String> step = [];

                    for (var i = 0; i < controllers.length; i++) {
                      ingredientName.add(controllers[i][0].text);
                      amount.add(controllers[i][1].text);
                      step.add((i + 1).toString());
                      print("iiiiiiiiiiii = "+i.toString());
                    }

                    // jsonEncode(ingredientName);
                    // jsonEncode(amount);
                    // jsonEncode(step);
                    // addIngredients
                    // print("99999999");
                   
                    print(ingredientName);
                    print(amount);
                    print(step);
                   
                    // print("recipe_id_come = "+recipe_id_come.toString());

                    AddIngredientsArrayModel res2 = await addIngredients(recipe_id_come.toString(), ingredientName,amount, step);
                    
                    print(jsonEncode(ingredientName));
                    // print("res2.success = "+res2.success.toString());
                    
                    
                    
                    // print("55555555");
                    // print(recipe_id_come);
                    // print(jsonEncode(ingredientName));
                    // print(jsonEncode(amount));
                    // print(jsonEncode(step));
                  }
                },
                child: Text('เพิ่ม')),
          ],
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
                  child: Text(
                "ตั้งรูปปกอาหาร",
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 2.0),
              )),
              ElevatedButton(
                  onPressed: () {
                    // for (var list in image2) {
                    //   print(list);
                    // }
                    // // var service = DBService();
                    // // var token = await service.readData();
                    // // token.forEach((token){
                    // //   setState(() {
                    // //     var tokenModel = Token_jwt();
                    // //     print(token['id']);
                    // //     print(token['token']);
                    // //   });
                    // // });
                    print(addImage[0].image);
                  },
                  child: Text('show')),
              (addImage.length == 0)
                  ? IconButton(
                      iconSize: 200,
                      icon: Image.asset('assets/images/camera.png'),
                      // onPressed: () async {

                      //   final pickedFile =
                      //       await _picker.getImage(source: ImageSource.gallery);
                      //   // img = await ImagePicker().getImage(
                      //   //     source: ImageSource.gallery);
                      //   img = File(pickedFile.path);
                      //   // String bit = base64Encode(img.readAsBytesSync());
                      //   // image.text = bit;

                      //   print(img);
                      //   setState(() {});
                      // }
                      onPressed: () {
                        print("5555555555555555555");
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new AddFood_AddImagePage()),
                        ).then((value) {
                          if (value != null) {
                            print(value);
                            addImage.add(value);
                            setState(() {});
                          }
                        });
                      })
                  : InkWell(
                      child: Image.file(
                        addImage[0].image,
                        width: 0,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                      onTap: () async {
                        print("77777777777777");
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new AddFood_AddImagePage()),
                        ).then((value) {
                          if (value != null) {
                            // print(value);
                            // addImage.add(value);
                            addImage[0].image = value.image;
                            // img = addImage[0].image;
                            setState(() {});
                          }
                        });
                      }),

              Divider(
                thickness: 2,
              ),

              ////////////////////ส่วนผสม//////////////////////
              Center(
                  child: Text(
                "ส่วนผสม",
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 2.0),
              )),

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
                      //   print("THIS IS  = ${controllers[i].text} + [${i}]");
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
                  child: Text(
                "วิธีทำ",
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 2.0),
              )),

              ListView(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: children2,
              ),
              GestureDetector(
                onTap: () {
                  // เมื่อเพิ่มlist(ส่วนผสม)เราจำเป็นต้องใส่ fieldCount เท่านั้น, because the _buildList()
                  // จะจัดการสร้าง TextEditingController ใหม่
                  setState(() {
                    fieldCount2++;

                    for (int i = 0; i < controllers2.length; i++) {
                      //   print("THIS IS  = ${controllers[i].text} + [${i}]");
                    }
                  });
                },
                child: Container(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'เพิ่ม วิธีทำ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
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

// Future<String> _getTokens() async {
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   token =  preferences.getString("token") ?? null;
// }
