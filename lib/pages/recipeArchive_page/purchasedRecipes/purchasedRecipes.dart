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
                                    height: 200,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.white,
                                                height: 200,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(4, 4, 0, 0),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  'ชื่อสูตรอาหาร',
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 5),
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child: Text(
                                                                              "\฿ 100",
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textAlign: TextAlign.left,
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red)))
                                                                    ],
                                                                  ),
                                                                )
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(4, 0, 4, 0),
                                                      child: Divider(
                                                        height: 1,
                                                        thickness: 1,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Text(
                                                            "อธิบายสูตรอาหาร",
                                                            maxLines: 4,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ))
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(4, 0, 4, 0),
                                                      child: Divider(
                                                        height: 1,
                                                        thickness: 1,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(4, 0, 0, 8),
                                                      child: Row(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png"),
                                                            radius: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              "ชื่อเล่น",
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.white,
                                                height: 200,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Image.network(
                                                    "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
              );
            },
          )
        ],
      ),
    );
  }
}
