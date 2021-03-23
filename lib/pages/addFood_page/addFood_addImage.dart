// import 'dart:io';

// import 'package:easy_cook/class/addFood_addImage_class.dart';
// // import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class AddFood_AddImagePage extends StatefulWidget {
//   AddFood_AddImagePage({Key key}) : super(key: key);

//   @override
//   _AddFood_AddImagePageState createState() => _AddFood_AddImagePageState();
// }

// class _AddFood_AddImagePageState extends State<AddFood_AddImagePage> {
//   final _picker = ImagePicker();
//   var img;
//   var pickedFile;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('เพิ่มรูป'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: ListView(
//           children: [
//             SizedBox(
//               height: 20,
//             ),
//             GestureDetector(
//               onTap: () async {

                
//                 pickedFile =
//                     await _picker.getImage(source: ImageSource.gallery);
               
//                 img = File(pickedFile.path);
               
//                 // print()
//                 // print();
//                 // print("pickedFile = "+pickedFile.);
//                 AddImage addImage = new AddImage(
//                   img,
//                   "image"
//                 );
//                 Navigator.pop(context, addImage);
//                 setState(() {});
//               },
//               child: Container(
//                 color: Colors.blue,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Text(
//                     'เพิ่ม รูปภาพ จากคลัง',
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

            
//             SizedBox(
//               height: 20,
//             ),
//             GestureDetector(
//               onTap: () async {

                
//                 pickedFile =
//                     await _picker.getImage(source: ImageSource.camera);
               
//                 img = File(pickedFile.path);
               

//                 print(img);
//                 // print("pickedFile = "+pickedFile.);
//                 AddImage addImage = new AddImage(
//                   img,
//                   "image"
//                 );
//                 Navigator.pop(context, addImage);
//                 setState(() {});
//               },
//               child: Container(
//                 color: Colors.blue,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Text(
//                     'ถ่ายรูปภาพ ',
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             SizedBox(
//               height: 20,
//             ),
//             GestureDetector(
//               onTap: () async {
//                 pickedFile =
//                     await _picker.getVideo(source: ImageSource.gallery);
//                 // img = await ImagePicker().getImage(
//                 //     source: ImageSource.gallery);
//                 img = File(pickedFile.path);
//                 // String bit = base64Encode(img.readAsBytesSync());
//                 // image.text = bit;

//                 print(img);
//                 AddImage addImage = new AddImage(
//                   img,
//                   "video"
//                 );
//                 Navigator.pop(context, addImage);
//                 setState(() {});
//               },
//               child: Container(
//                 color: Colors.blue,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Text(
//                     'เพิ่ม วิดีโอ จากคลัง',
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             SizedBox(
//               height: 20,
//             ),
//             GestureDetector(
//               onTap: () async {

                
//                 pickedFile =
//                     await _picker.getVideo(source: ImageSource.camera);
               
//                 img = File(pickedFile.path);
               

//                 print(img);
//                 // print("pickedFile = "+pickedFile.);
//                 AddImage addImage = new AddImage(
//                   img,
//                   "video"
//                 );
//                 Navigator.pop(context, addImage);
//                 setState(() {});
//               },
//               child: Container(
//                 color: Colors.blue,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Text(
//                     'ถ่ายวิดีโอ ',
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           pickedFile = await _picker.getImage(source: ImageSource.camera);
//           // img = await ImagePicker().getImage(
//           //     source: ImageSource.gallery);
//           img = File(pickedFile.path);
//           // String bit = base64Encode(img.readAsBytesSync());
//           // image.text = bit;

//           print(img);
//           AddImage addImage = new AddImage(
//             img,
//             "image"
//           );
//           Navigator.pop(context, addImage);
//           setState(() {});
//         },
//         child: Icon(Icons.camera_alt),
//         // backgroundColor: Colors.green,
//       ),
//     );
//   }
// }
