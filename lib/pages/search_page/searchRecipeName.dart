// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:easy_cook/models/search/searchRecipe_model.dart';

// class SearchRecipeName extends StatefulWidget {
//   String recipName;
//   SearchRecipeName(String recipName) {
//     this.recipName = recipName;
//   }

//   @override
//   _SearchRecipeNameState createState() => _SearchRecipeNameState(recipName);
// }

// String token = ""; //โทเคน
// List<Datum> dataRecipe;

// bool flag = false;

// class _SearchRecipeNameState extends State<SearchRecipeName> {
  
//   String _recipName;
//   _SearchRecipeNameState(String recipName) {
//     flag = false;
//     this._recipName = recipName;
//     print(this._recipName);
//   }
//   @override
//   void initState() {
//     super.initState();
//     findToken();
//     getSearchRecipeName();
//   }

//   Future<Null> findToken() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();

//     setState(() {
//       token = preferences.getString("tokens");
//     });
//   }

//   Future<Null> getSearchRecipeName() async {
//     final String apiUrl =
//         "http://apifood.comsciproject.com/pjPost/searchRecipeName/" +
//             _recipName;
//     print(apiUrl);
//     final response = await http
//         .get(Uri.parse(apiUrl), headers: {"Authorization": "Bearer $token"});
//     print("response = " + response.statusCode.toString());
//     if (response.statusCode == 200) {
//       setState(() {
//         final String responseString = response.body;

//         dataRecipe = searchRecipeNameFromJson(responseString).data;
//         // print(dataRecipe[0].recipeName);
//         // datas = myAccountFromJson(responseString);
//         // dataUser = datas.data[0];
//       });
//     } else {
//       flag = true;
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: ListView.builder(
//           itemCount: dataRecipe.length,
//           itemBuilder: (context, index) => (index < 0 && flag)
//               ? new SizedBox(
//                   child: Container(),
//                 )
//               : Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Container(
//                     child: FittedBox(
//                       child: Material(
//                         color: Colors.white,
//                         elevation: 14.0,
//                         borderRadius: BorderRadius.circular(24.0),
//                         shadowColor: Color(0x802196F3),
//                         child: Row(
//                           children: [
//                             Container(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 16.0),
//                                 child: myDetailsContainer4(index),
//                               ),
//                             ),
//                             SizedBox(width: 50,),
//                             Container(
//                               width: 250,
//                               height: 180,
//                               child: ClipRRect(
//                                 borderRadius: new BorderRadius.circular(24.0),
//                                 child: Image(
//                                   fit: BoxFit.cover,
//                                   alignment: Alignment.topRight,
//                                   image: NetworkImage(dataRecipe[index].image),
//                                 ),
//                               ),
//                             ),
//                             // Container(
//                             //   width: 250,
//                             //   height: 250,
//                             //   child: ClipRRect(
//                             //     borderRadius: new BorderRadius.circular(24.0),
//                             //     child: Image(
//                             //       fit: BoxFit.contain,
//                             //       alignment: Alignment.topRight,
//                             //       image: NetworkImage(
//                             //           'https://placeimg.com/640/480/any'),
//                             //     ),
//                             //   ),
//                             // )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 )),
//     );
//   }
// }

// Widget myDetailsContainer4(int index) {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     children: <Widget>[
//       Padding(
//         padding: const EdgeInsets.only(left: 8.0),
//         child: Container(
//             child: Text(
//           dataRecipe[0].recipeName,
//           style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
//         )),
//       ),
//       Padding(
//         padding: const EdgeInsets.only(left: 8.0),
//         child: Container(
//             child: Row(
//           children: <Widget>[
//             Container(
//                 child: Text(
//               "3.5",
//               style: TextStyle(
//                 color: Colors.black54,
//                 fontSize: 18.0,
//               ),
//             )),
//             Container(
//               child: Icon(
//                 FontAwesomeIcons.solidStar,
//                 color: Colors.amber,
//                 size: 15.0,
//               ),
//             ),
//             Container(
//               child: Icon(
//                 FontAwesomeIcons.solidStar,
//                 color: Colors.amber,
//                 size: 15.0,
//               ),
//             ),
//             Container(
//               child: Icon(
//                 FontAwesomeIcons.solidStar,
//                 color: Colors.amber,
//                 size: 15.0,
//               ),
//             ),
//             Container(
//               child: Icon(
//                 FontAwesomeIcons.solidStarHalf,
//                 color: Colors.amber,
//                 size: 15.0,
//               ),
//             ),
//             Container(
//                 child: Text(
//               "(50)",
//               style: TextStyle(
//                 color: Colors.black54,
//                 fontSize: 18.0,
//               ),
//             )),
//           ],
//         )),
//       ),
//       SizedBox(
//         height: 50,
//       ),
//       Row(
//         children: [
//           new Container(
//             height: 70.0,
//             width: 70.0,
//             decoration: new BoxDecoration(
//                 shape: BoxShape.circle,
//                 image: new DecorationImage(
//                     fit: BoxFit.fill,
//                     image:
//                         new NetworkImage("https://placeimg.com/640/480/any"))),
//           ),
//           new SizedBox(
//             width: 10.0,
//           ),
//           new Text(
//             "เซฟปก",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           )
//         ],
//       ),
//     ],
//   );
// }
