// To parse this JSON data, do
//
//     final recommendRecipe = recommendRecipeFromJson(jsonString);

import 'dart:convert';

List<RecommendRecipe> recommendRecipeFromJson(String str) => List<RecommendRecipe>.from(json.decode(str).map((x) => RecommendRecipe.fromJson(x)));

String recommendRecipeToJson(List<RecommendRecipe> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecommendRecipe {
    RecommendRecipe({
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
        this.count,
    });

    int rid;
    int userId;
    String nameSurname;
    String aliasName;
    String profileImage;
    String recipeName;
    String foodCategory;
    String image;
    double price;
    double score;
    int count;

    factory RecommendRecipe.fromJson(Map<String, dynamic> json) => RecommendRecipe(
        rid: json["rid"],
        userId: json["user_ID"],
        nameSurname: json["name_surname"],
        aliasName: json["alias_name"],
        profileImage: json["profile_image"],
        recipeName: json["recipe_name"],
        foodCategory: json["food_category"],
        image: json["image"],
        price: json["price"].toDouble(),
        score: json["score"].toDouble(),
        count: json["count"],
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
        "count": count,
    };
}
