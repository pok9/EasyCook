// To parse this JSON data, do
//
//     final searchRecipeName = searchRecipeNameFromJson(jsonString);

import 'dart:convert';

SearchRecipeName searchRecipeNameFromJson(String str) => SearchRecipeName.fromJson(json.decode(str));

String searchRecipeNameToJson(SearchRecipeName data) => json.encode(data.toJson());

class SearchRecipeName {
    SearchRecipeName({
        this.data,
    });

    List<Datum> data;

    factory SearchRecipeName.fromJson(Map<String, dynamic> json) => SearchRecipeName(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.rid,
        this.recipeName,
        this.image,
    });

    int rid;
    String recipeName;
    String image;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        rid: json["rid"],
        recipeName: json["recipe_name"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "rid": rid,
        "recipe_name": recipeName,
        "image": image,
    };
}
