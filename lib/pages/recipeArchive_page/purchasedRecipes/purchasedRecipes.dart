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
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                        child: Container(color: Colors.black,height: 100,)
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'ผัดกะเพราไก่ไข่ดาวพิเศษ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                ),
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.0)),
                              Text(
                                'aa',
                                style: const TextStyle(fontSize: 10.0),
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 1.0)),
                              Text(
                                ' views',
                                style: const TextStyle(fontSize: 10.0),
                              ),
                            ],
                          ),
                        )),
                    const Icon(
                      Icons.more_vert,
                      size: 16.0,
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
