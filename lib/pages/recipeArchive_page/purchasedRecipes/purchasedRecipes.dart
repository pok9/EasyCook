import 'package:easy_cook/pages/search_page/search.dart';
import 'package:flutter/material.dart';

class PurchasedRecipes extends StatefulWidget {
  // const PurchasedRecipes({ Key? key }) : super(key: key);

  @override
  _PurchasedRecipesState createState() => _PurchasedRecipesState();
}

class _PurchasedRecipesState extends State<PurchasedRecipes> {
  int _value = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สูตรที่ซื้อ'),
      ),
      body: ListView(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                child: DropdownButton(
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                  },
                  value: _value,
                  items: [
                    DropdownMenuItem(
                      child: Text("สูตรที่ซื้อ (ล่าสุด)"),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("สูตรที่ซื้อ (เก่าสุด)"),
                      value: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.yellow,
                  height: 100,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
