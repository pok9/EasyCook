// import 'dart:io';

// import 'package:easy_cook/class/addFood_addImage_class.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';

// class AddImageOrViderPage extends StatefulWidget {
//   // test3({Key? key}) : super(key: key);

//   @override
//   _AddImageOrViderPageState createState() => _AddImageOrViderPageState();
// }

// class _AddImageOrViderPageState extends State<AddImageOrViderPage> {
//   final picker = ImagePicker();
//   File imageFile;

//   pickCropImage() async {
//     FilePickerResult result =
//         await FilePicker.platform.pickFiles(type: FileType.image);

//     if (result != null) {
//       PlatformFile file = result.files.first;

//       imageFile = File(file.path);
//       cropImage();
//     } else {}
//   }

//   captureImage() async {
//     var image = await picker.getImage(source: ImageSource.camera);

//     if (image != null) {
//       imageFile = File(image.path);
//       cropImage();
//     }
//   }

//   cropImage() async {
//     File croppedFile = await ImageCropper.cropImage(
//         aspectRatio: CropAspectRatio(ratioX: 10, ratioY: 9),
//         sourcePath: imageFile.path,
//         // aspectRatioPresets: [
//         //   CropAspectRatioPreset.square,
//         //   CropAspectRatioPreset.ratio3x2,
//         //   CropAspectRatioPreset.original,
//         //   CropAspectRatioPreset.ratio4x3,
//         //   CropAspectRatioPreset.ratio16x9
//         // ],
//         androidUiSettings: AndroidUiSettings(
//           toolbarTitle: 'Crop',
//           toolbarColor: Color(0xffc69f50),
//           toolbarWidgetColor: Colors.white,
//           initAspectRatio: CropAspectRatioPreset.original,
//           lockAspectRatio: true,
//           // hideBottomControls: true,
//         ));
//     if (croppedFile != null) {
//       setState(() {
//         imageFile = croppedFile;
//         AddImage addImage = new AddImage(File(imageFile.path));
//         Navigator.pop(context, addImage);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('เพิ่มรูป & วิดีโอ'),
//         // actions: [
//         //   IconButton(
//         //     icon: Icon(Icons.add),
//         //     onPressed: () {},
//         //   ),
//         // ],
//       ),
//       body: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width - 50,
//                   child: ElevatedButton(
//                       onPressed: pickCropImage,
//                       child: Text(
//                         'รูปภาพในมือถือ',
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       )),
//                 ),
//               ),
//               // FlatButton(
//               //     onPressed: pickCropImage,
//               //     minWidth: 200,
//               //     color: Color(0xffc69f50),
//               //     child: Text(
//               //       'Pick&Crop',
//               //       style: TextStyle(color: Colors.white, fontSize: 20),
//               //     )),

//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width - 50,
//                   child: ElevatedButton(
//                       onPressed: captureImage,
//                       child: Text(
//                         'ถ่ายรูปภาพ',
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       )),
//                 ),
//               ),

//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width - 50,
//                   child: ElevatedButton(
//                       onPressed: () async {
//                         FilePickerResult result = await FilePicker.platform
//                             .pickFiles(type: FileType.video);

//                         if (result != null) {
//                           PlatformFile file = result.files.first;

//                           AddImage addImage = new AddImage(File(file.path));
//                           Navigator.pop(context, addImage);
//                         } else {}
//                       },
//                       child: Text(
//                         'เพิ่ม วิดีโอ จากคลัง',
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       )),
//                 ),
//               ),

//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width - 50,
//                   child: ElevatedButton(
//                       onPressed: () async {
//                         var image =
//                             await picker.getVideo(source: ImageSource.camera);

//                         AddImage addImage = new AddImage(File(image.path));
//                         Navigator.pop(context, addImage);
//                       },
//                       child: Text(
//                         'ถ่ายวิดีโอ',
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       )),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
