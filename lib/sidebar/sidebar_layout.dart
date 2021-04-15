import 'package:easy_cook/pages/feed_page/feed.dart';
import 'package:easy_cook/sidebar/sidebar.dart';
import 'package:flutter/material.dart';

class SideBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FeedPage(),
          SideBar(),
        ],
      ),
    );
  }
}
