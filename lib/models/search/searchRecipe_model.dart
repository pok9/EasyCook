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

    List<DataRecipe> data;

    factory SearchRecipeName.fromJson(Map<String, dynamic> json) => SearchRecipeName(
        data: List<DataRecipe>.from(json["data"].map((x) => DataRecipe.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DataRecipe {
    DataRecipe({
        this.rid,
        this.recipeName,
        this.image,
        this.userId,
        this.aliasName,
        this.nameSurname,
        this.profileImage,
        this.score,
        this.count,
        this.price,
    });

    int rid;
    String recipeName;
    String image;
    int userId;
    String aliasName;
    String nameSurname;
    String profileImage;
    double score;
    int count;
    double price;

    factory DataRecipe.fromJson(Map<String, dynamic> json) => DataRecipe(
        rid: json["rid"],
        recipeName: json["recipe_name"],
        image: json["image"],
        userId: json["user_ID"],
        aliasName: json["alias_name"],
        nameSurname: json["name_surname"],
        profileImage: json["profile_image"],
        score: json["score"].toDouble(),
        count: json["count"],
        price: json["price"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "rid": rid,
        "recipe_name": recipeName,
        "image": image,
        "user_ID": userId,
        "alias_name": aliasName,
        "name_surname": nameSurname,
        "profile_image": profileImage,
        "score": score,
        "count": count,
        "price": price,
    };
}
