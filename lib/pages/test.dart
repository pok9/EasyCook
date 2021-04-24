// import 'dart:html';

// import 'package:file_picker/file_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:js';

import 'package:easy_cook/pages/feed_page/feed_follow.dart';
import 'package:easy_cook/pages/video_items.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';
// import 'package:flutter/services.dart';

class test extends StatefulWidget {
  test() : super();

  final String title = "Collpasable Appbar Demo";
  @override
  _testState createState() => _testState();
}

custom() {
  return CustomScrollView(
    slivers: [
      SliverAppBar(
        expandedHeight: 200.0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              "Collapsing Toolbar",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            background: Image.network(
              "https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?size=626&ext=jpg",
              fit: BoxFit.cover,
            )),
      ),
      SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 4.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Container(
              alignment: Alignment.center,
              color: Colors.teal[100 * (index % 9)],
              child: Text('Grid Item $index'),
            );
          },
          childCount: 20,
        ),
      ),
      SliverFixedExtentList(
        itemExtent: 50.0,
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Container(
              alignment: Alignment.center,
              color: Colors.lightBlue[100 * (index % 9)],
              child: Text('List Item $index'),
            );
          },
        ),
      ),
    ],
  );
}

// nested() {
//   return NestedScrollView(
//     headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//       return [
//         SliverAppBar(
//           expandedHeight: 200.0,
//           floating: false,
//           pinned: true,
//           flexibleSpace: FlexibleSpaceBar(
//               centerTitle: true,
//               title: Text(
//                 "Collapsing Toolbar",
//                 style: TextStyle(color: Colors.white, fontSize: 16.0),
//               ),
//               background: Image.network(
//                 "https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?size=626&ext=jpg",
//                 fit: BoxFit.cover,
//               )),
//         ),
//       ];
//     },
//     body: Center(
//       child: Text("The Parrot"),
//     ),
//   );
// }

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: custom(),
    );
  }
}
