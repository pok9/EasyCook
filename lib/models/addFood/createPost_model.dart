// To parse this JSON data, do
//
//     final createPostModel = createPostModelFromJson(jsonString);

import 'dart:convert';

CreatePostModel createPostModelFromJson(String str) => CreatePostModel.fromJson(json.decode(str));

String createPostModelToJson(CreatePostModel data) => json.encode(data.toJson());

class CreatePostModel {
    CreatePostModel({
        this.success,
        this.recipeId,
    });

    int success;
    int recipeId;

    factory CreatePostModel.fromJson(Map<String, dynamic> json) => CreatePostModel(
        success: json["success"],
        recipeId: json["recipe_ID"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "recipe_ID": recipeId,
    };
}
