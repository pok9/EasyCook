// To parse this JSON data, do
//
//     final deleteRecipeModel = deleteRecipeModelFromJson(jsonString);

import 'dart:convert';

DeleteRecipeModel deleteRecipeModelFromJson(String str) => DeleteRecipeModel.fromJson(json.decode(str));

String deleteRecipeModelToJson(DeleteRecipeModel data) => json.encode(data.toJson());

class DeleteRecipeModel {
    DeleteRecipeModel({
        this.success,
        this.message,
    });

    int success;
    String message;

    factory DeleteRecipeModel.fromJson(Map<String, dynamic> json) => DeleteRecipeModel(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
