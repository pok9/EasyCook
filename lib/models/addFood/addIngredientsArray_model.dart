// To parse this JSON data, do
//
//     final addIngredientsArrayModel = addIngredientsArrayModelFromJson(jsonString);

import 'dart:convert';

AddIngredientsArrayModel addIngredientsArrayModelFromJson(String str) => AddIngredientsArrayModel.fromJson(json.decode(str));

String addIngredientsArrayModelToJson(AddIngredientsArrayModel data) => json.encode(data.toJson());

class AddIngredientsArrayModel {
    AddIngredientsArrayModel({
        this.success,
    });

    int success;

    factory AddIngredientsArrayModel.fromJson(Map<String, dynamic> json) => AddIngredientsArrayModel(
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
    };
}
