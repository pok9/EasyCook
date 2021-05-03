// import 'package:easy_cook/models/checkFollower/checkFollower_model.dart';
// import 'package:easy_cook/models/follow/manageFollow_model.dart';
// import 'package:easy_cook/models/profile/myAccount_model.dart';
// import 'package:easy_cook/models/profile/myPost_model.dart';
// import 'package:easy_cook/models/search/searchUsername_model.dart';
// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ProfileUser extends StatefulWidget {
//   // String aliasName;
//   // String nameSurname;
//   // String profileImage;
//   DataUser dataUser;
//   ProfileUser(this.dataUser);

//   @override
//   _ProfileUserState createState() => _ProfileUserState(this.dataUser);
// }
// // //ข้อมูลผู้ใช้
// // List<DataUser> dataUser;

// //MyPost ข้อมูลของคนที่ค้นหา
// MyPost dataPost;

// class _ProfileUserState extends State<ProfileUser> {
//   DataUser _dataUser; //ข้อมูลที่ login
//   _ProfileUserState(this._dataUser);

//   @override
//   void initState() {
//     // checkFollowers = null;
//     super.initState();
//     findUser();

//     // print("checkkkkk = "+checkFollowers.checkFollower.toString());
//   }

//   String token = ""; //โทเคน
//   //user
//   MyAccount datas;
//   DataAc dataUser;

//   Future<Null> findUser() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();

//     setState(() {
//       // print("11111111 = " + token);
//       token = preferences.getString("tokens");
//       // print("22222222 = " + token);
//       getMyAccounts();
//       // print("dataUser = " + dataUser.toString());
//       // print("newfeed = " + newfeed.toString());
//       // newFeedPosts();
//     });
//     // token = await Token_jwt().getTokens();
//     // setState(() {});
//   }

//   Future<Null> getMyAccounts() async {
//     final String apiUrl = "http://apifood.comsciproject.com/pjUsers/myAccount";

//     final response = await http
//         .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
//     print("response = " + response.statusCode.toString());
//     if (response.statusCode == 200) {
//       setState(() {
//         final String responseString = response.body;

//         datas = myAccountFromJson(responseString);
//         dataUser = datas.data[0];
//         myPosts();
//       });
//     } else {
//       return null;
//     }
//   }

//   Future<Null> myPosts() async {
//     final String apiUrl = "http://apifood.comsciproject.com/pjPost/mypost/" +
//         _dataUser.userId.toString();

//     // print("apiUrl = " + apiUrl);
//     final response = await http.get(Uri.parse(apiUrl));
//     // print("_dataUser" + response.toString());
//     // print("responsemyPosts = " + response.statusCode.toString());
//     if (response.statusCode == 200) {
//       setState(() {
//         final String responseString = response.body;

//         dataPost = myPostFromJson(responseString);
//         checkFollower();
//         // print("dataPost = " + dataPost.countPost.toString());
//         // newfeed = newfeedsProfileFromJson(responseString);
//         //  post = newfeed.feeds[0];
//         // dataUser = datas.data[0];
//       });
//     } else {
//       return null;
//     }
//   }

//   CheckFolloweer checkFollowers;
//   Future<Null> checkFollower() async {
//     final String apiUrl =
//         "http://apifood.comsciproject.com/pjFollow/checkFollower/" +
//             dataPost.userId.toString();

//     print("apiUrlcheckFol = " + apiUrl);
//     final response = await http
//         .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
//     print("_dataUser" + response.toString());
//     print("responsemyPosts = " + response.statusCode.toString());
//     if (response.statusCode == 200) {
//       setState(() {
//         final String responseString = response.body;
//         checkFollowers = checkFolloweerFromJson(responseString);
//         setState(() {
//           print("checkkkkk222 = " + checkFollowers.checkFollower.toString());
//         });
//         // dataPost = myPostFromJson(responseString);
//         //  print("checkkkkk222 = "+checkFollowers.checkFollower.toString());
//       });
//     } else {
//       return null;
//     }
//   }

//   Future<Null> manageFollow(String state, int following_ID) async {
//     // final String apiUrl = "http://apifood.comsciproject.com/pjUsers/signin";

//     final String apiUrl =
//         "http://apifood.comsciproject.com/pjFollow/ManageFollow";
//     print("manageFollow111");
//     final response = await http.post(Uri.parse(apiUrl),
//         body: {"state": state, "following_ID": following_ID.toString()},
//         headers: {"Authorization": "Bearer $token"});
//     print("manageFollo22222");
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       final String responseString = response.body;
//       ManageFollow aa = manageFollowFromJson(responseString);
//         print(aa.success);
//       setState(() {
//         // initState();
//         myPosts();
//       });
//     } else {
//       return null;
//     }
//   }
// var rng = new Random();
//   @override
//   Widget build(BuildContext context) {
//     //checkFoller เช็คติดตาม

//     Size size = MediaQuery.of(context).size;
    
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(this._dataUser.aliasName),
//       ),
//       // extendBodyBehindAppBar: true,
//       body: (dataUser == null)
//           ? Container()
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         height: size.height * 0.40,
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                               image: NetworkImage(
//                                   'https://source.unsplash.com/400x255/?food&sig' +
//                                       rng.nextInt(100).toString()),
//                               fit: BoxFit.cover),
//                         ),
//                         child: Column(
//                           children: [
//                             SizedBox(
//                               height: 36,
//                             ),
//                             CircleAvatar(
//                               radius: 48,
//                               backgroundImage:
//                                   NetworkImage(this._dataUser.profileImage),
//                             ),
//                             SizedBox(
//                               height: 16,
//                             ),
//                             Text(
//                               this._dataUser.aliasName,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 22,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 4,
//                             ),
//                             Text(
//                               this._dataUser.nameSurname,
//                               style: TextStyle(
//                                   color: Colors.white70, fontSize: 14),
//                             ),
//                             SizedBox(
//                               height: 4,
//                             ),
//                             (dataUser.userId == dataPost.userId ||
//                                     checkFollowers == null)
//                                 ? Container()
//                                 : (checkFollowers.checkFollower == 0)
//                                     ? MaterialButton(
//                                         splashColor: Colors.grey,
//                                         color: Colors.red[400],
//                                         onPressed: () {
//                                           print("ติดตาม");
//                                           manageFollow("fol", dataPost.userId);
//                                         },
//                                         child: Text(
//                                           'ติดตาม',
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                         shape: StadiumBorder(),
//                                       )
//                                     : MaterialButton(
//                                         splashColor: Colors.grey,
//                                         color: Colors.grey,
//                                         onPressed: () {
//                                           print("ยกเลิกติดตาม");
//                                           manageFollow(
//                                               "unfol", dataPost.userId);
//                                         },
//                                         child: Text(
//                                           'กำลังติดตาม',
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                         shape: StadiumBorder(),
//                                       ),
//                             Expanded(child: Container()),
//                             Container(
//                               height: 64,
//                               color: Colors.black.withOpacity(0.4),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Container(
//                                     width: 110,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           'โพสต์',
//                                           style: TextStyle(
//                                               color: Colors.white70,
//                                               fontSize: 12),
//                                         ),
//                                         SizedBox(
//                                           height: 4,
//                                         ),
//                                         Text(
//                                           dataPost.countPost.toString(),
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     width: 110,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           'ติดตาม',
//                                           style: TextStyle(
//                                               color: Colors.white70,
//                                               fontSize: 12),
//                                         ),
//                                         SizedBox(
//                                           height: 4,
//                                         ),
//                                         Text(
//                                           dataPost.countFollower.toString(),
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     width: 110,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           'กำลังติดตาม',
//                                           style: TextStyle(
//                                               color: Colors.white70,
//                                               fontSize: 12),
//                                         ),
//                                         SizedBox(
//                                           height: 4,
//                                         ),
//                                         Text(
//                                           dataPost.countFollowing.toString(),
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Material(
//                         elevation: 1,
//                         child: Container(
//                           height: 56,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Icon(
//                                 Icons.web,
//                                 color: Colors.black,
//                                 size: 28,
//                               ),
//                               Icon(
//                                 Icons.image,
//                                 color: Colors.black,
//                                 size: 28,
//                               ),
//                               Icon(
//                                 Icons.play_circle_outline,
//                                 color: Colors.black,
//                                 size: 28,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       (dataPost.recipePost == null)
//                           ? Container()
//                           : Container(
//                               height: size.height * 0.60 - 56,
//                               padding: EdgeInsets.only(
//                                   left: 16, right: 16, top: 0, bottom: 24),
//                               child: GridView.count(
//                                 crossAxisCount: 3,
//                                 crossAxisSpacing: 8,
//                                 mainAxisSpacing: 8,
//                                 physics: BouncingScrollPhysics(),
//                                 children: List.generate(
//                                     dataPost.recipePost.length, (index) {
//                                   return Container(
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.all(
//                                         Radius.circular(10),
//                                       ),
//                                       image: DecorationImage(
//                                           image: NetworkImage(
//                                               'https://source.unsplash.com/400x255/?food&sig' +
//                                                   rng.nextInt(100).toString()),
//                                           fit: BoxFit.cover),
//                                     ),
//                                   );
//                                 }),
//                               ),
//                             ),
//                     ],
//                   ),
//                   // Positioned(
//                   //   top: 32,
//                   //   left: 16,
//                   //   child: Icon(
//                   //     Icons.keyboard_arrow_left,
//                   //     color: Colors.white,
//                   //     size: 32,
//                   //   ),
//                   // )
//                 ],
//               ),
//             ),
//     );
//   }
// }
