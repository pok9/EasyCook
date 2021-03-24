import 'package:flutter/material.dart';

class SearchRecipeName extends StatefulWidget {
  SearchRecipeName({Key key}) : super(key: key);

  @override
  _SearchRecipeNameState createState() => _SearchRecipeNameState();
}

class _SearchRecipeNameState extends State<SearchRecipeName> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
       body: Center(
         child: Text('data'),
       ),
    );
  }
}