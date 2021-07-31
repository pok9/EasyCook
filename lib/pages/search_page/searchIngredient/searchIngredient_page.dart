import 'package:easy_cook/models/search/searchIngred_model.dart';
import 'package:easy_cook/models/showfood/showfood_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchIngredient extends StatefulWidget {
  // const SearchIngredient({ Key? key }) : super(key: key);

  String nameIngredient;
  SearchIngredient({this.nameIngredient});

  @override
  _SearchIngredientState createState() => _SearchIngredientState();
}

class _SearchIngredientState extends State<SearchIngredient> {
  @override
  void initState() {
    super.initState();
    getSearchIngredient(this.widget.nameIngredient);
  }

  List<DataIngredient> dataIngredient;

  Future<Null> getSearchIngredient(String ingredient) async {
    dataIngredient = [];
    listDataFood = {};
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/searchIngredient/" +
            ingredient;

    final response = await http.get(Uri.parse(apiUrl));
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;
        print("pok test");
        // dataRecipe = searchRecipeNameFromJson(responseString).data;
        dataIngredient = searchIngredModelFromJson(responseString).data;

        for (int i = 0; i < dataIngredient.length; i++) {
          getPost(dataIngredient[i].rid);
        }
      });
    } else {
      // flag = true;
      return null;
    }
  }

  //ข้อมูลสูตรอาหารที่ค้นหา
  ShowFoods dataFood;

  Set<ShowFoods> listDataFood = Set();
  
  //ดึงข้อมูลสูตรอาหารที่ค้นหา
  Future<Null> getPost(int req_rid) async {
    final String apiUrl =
        "http://apifood.comsciproject.com/pjPost/getPost/" + req_rid.toString();
    // print("xxlToken = " + token);
    final response = await http.get(Uri.parse(apiUrl));
    print("response = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        final String responseString = response.body;
        dataFood = showFoodsFromJson(responseString);
        listDataFood.add(dataFood);
      });
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.nameIngredient),
      ),
      body: (listDataFood == null)
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listDataFood.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: (){
                    print(listDataFood.elementAt(index).rid);
                  },
                  leading: Image.network(listDataFood.elementAt(index).image),
                  title: Text(listDataFood.elementAt(index).recipeName),
                );
              },
            ),
    );
  }
}
