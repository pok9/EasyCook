// To parse this JSON data, do
//
//     final searchIngredModel = searchIngredModelFromJson(jsonString);

import 'dart:convert';

SearchIngredModel searchIngredModelFromJson(String str) => SearchIngredModel.fromJson(json.decode(str));

String searchIngredModelToJson(SearchIngredModel data) => json.encode(data.toJson());

class SearchIngredModel {
    SearchIngredModel({
        this.data,
    });

    List<DataIngredient> data;

    factory SearchIngredModel.fromJson(Map<String, dynamic> json) => SearchIngredModel(
        data: List<DataIngredient>.from(json["data"].map((x) => DataIngredient.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DataIngredient {
    DataIngredient({
        this.rid,
        this.ingredientName,
    });

    int rid;
    String ingredientName;

    factory DataIngredient.fromJson(Map<String, dynamic> json) => DataIngredient(
        rid: json["rid"],
        ingredientName: json["ingredientName"],
    );

    Map<String, dynamic> toJson() => {
        "rid": rid,
        "ingredientName": ingredientName,
    };
}
