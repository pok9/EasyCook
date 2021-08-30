// To parse this JSON data, do
//
//     final popularRecipeModel = popularRecipeModelFromJson(jsonString);

import 'dart:convert';

List<PopularRecipeModel> popularRecipeModelFromJson(String str) => List<PopularRecipeModel>.from(json.decode(str).map((x) => PopularRecipeModel.fromJson(x)));

String popularRecipeModelToJson(List<PopularRecipeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PopularRecipeModel {
    PopularRecipeModel({
        this.rid,
        this.recipeName,
        this.image,
        this.date,
        this.price,
        this.userId,
        this.nameSurname,
        this.aliasName,
        this.profileImage,
        this.counts,
        this.avgScore,
    });

    int rid;
    String recipeName;
    String image;
    DateTime date;
    int price;
    int userId;
    String nameSurname;
    String aliasName;
    String profileImage;
    int counts;
    double avgScore;

    factory PopularRecipeModel.fromJson(Map<String, dynamic> json) => PopularRecipeModel(
        rid: json["rid"],
        recipeName: json["recipe_name"],
        image: json["image"],
        date: DateTime.parse(json["date"]),
        price: json["price"],
        userId: json["user_ID"],
        nameSurname: json["name_surname"],
        aliasName: json["alias_name"],
        profileImage: json["profile_image"],
        counts: json["counts"],
        avgScore: json["avg_score"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "rid": rid,
        "recipe_name": recipeName,
        "image": image,
        "date": date.toIso8601String(),
        "price": price,
        "user_ID": userId,
        "name_surname": nameSurname,
        "alias_name": aliasName,
        "profile_image": profileImage,
        "counts": counts,
        "avg_score": avgScore,
    };
}
