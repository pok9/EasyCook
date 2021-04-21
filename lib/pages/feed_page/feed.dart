import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf3f5f9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 3.0, bottom: 10),
                child: Text(
                  "Easy Cook",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Find a food or Restaur",
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.indigo,
                          ),
                          suffixIcon: Icon(
                            Icons.add_road_rounded,
                            color: Colors.grey,
                          ),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none),
                    ),
                  )),
              SizedBox(
                height: 25,
              ),
              Text(
                "สูตรอาหารยอดนิยม",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                  height: 200,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return _foodCard_1(context);
                      })),
            ],
          ),
        ),
      ),
    );
  }

  Widget _foodCard_1(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.white,
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(

                      image: NetworkImage("https://images.unsplash.com/photo-1484723091739-30a097e8f929?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),fit: BoxFit.cover
                    )
                  ),
                  
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ต้ำยำกุ้ง",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                        Row(
                          children: [
                            Text("4.2",style: TextStyle(color: Colors.grey),),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Theme.of(context).primaryColor,
                                  size: 16.0,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Theme.of(context).primaryColor,
                                  size: 16.0,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Theme.of(context).primaryColor,
                                  size: 16.0,
                                ),
                                Icon(
                                  Icons.star_half,
                                  color: Theme.of(context).primaryColor,
                                  size: 16.0,
                                ),
                                Icon(
                                  Icons.star_border,
                                  color: Theme.of(context).primaryColor,
                                  size: 16.0,
                                ),
                              ],
                            ),
                            Text("(12)",style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      
                      ],
                    ),
                    Text("\$25",style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold),)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
