
import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 3.0,bottom: 10),
                child: Text("Explore",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Find a food or Restaur",
                      prefixIcon: Icon(Icons.search,color: Colors.indigo,),
                      suffixIcon: Icon(Icons.add_road_rounded,color: Colors.grey,),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none
                    ),
                  ),
                )),
            ],
          ),
        ),
      ),
    );
  }
}