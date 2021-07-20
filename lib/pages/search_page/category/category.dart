import 'package:flutter/material.dart';
import 'package:sliver_fab/sliver_fab.dart';

class Category extends StatefulWidget {
  String categoryName;

  Category({this.categoryName});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return (false)
        ? Material(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text(
                //   "Initialization",
                //   style: TextStyle(
                //     fontSize: 32,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                SizedBox(height: 20),
                CircularProgressIndicator()
              ],
            ),
          )
        : SliverFab(
            slivers: [
              SliverAppBar(
                title: Text(this.widget.categoryName),
                pinned: true,
                expandedHeight: 180.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    "https://www.mama.co.th/imgadmins/img_product_cate/big/cate_big_20180409150840.jpg", ///////////////////////////
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate(List.generate(
                      20,
                      (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 50,
                              color: Colors.amber,
                            ),
                          ))))
            ],
            floatingWidget: Container(),
          );
  }
}
