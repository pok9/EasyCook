// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) => List<CategoryModel>.from(json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
    CategoryModel({
        this.rid,
        this.userId,
        this.nameSurname,
        this.aliasName,
        this.profileImage,
        this.recipeName,
        this.foodCategory,
        this.image,
        this.price,
        this.score,
    });

    int rid;
    int userId;
    String nameSurname;
    String aliasName;
    String profileImage;
    String recipeName;
    String foodCategory;
    String image;
    int price;
    int score;

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        rid: json["rid"],
        userId: json["user_ID"],
        nameSurname: json["name_surname"],
        aliasName: json["alias_name"],
        profileImage: json["profile_image"],
        recipeName: json["recipe_name"],
        foodCategory: json["food_category"],
        image: json["image"],
        price: json["price"],
        score: json["score"],
    );

    Map<String, dynamic> toJson() => {
        "rid": rid,
        "user_ID": userId,
        "name_surname": nameSurname,
        "alias_name": aliasName,
        "profile_image": profileImage,
        "recipe_name": recipeName,
        "food_category": foodCategory,
        "image": image,
        "price": price,
        "score": score,
    };
}
