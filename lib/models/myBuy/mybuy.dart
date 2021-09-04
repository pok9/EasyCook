// To parse this JSON data, do
//
//     final mybuy = mybuyFromJson(jsonString);

import 'dart:convert';

List<Mybuy> mybuyFromJson(String str) => List<Mybuy>.from(json.decode(str).map((x) => Mybuy.fromJson(x)));

String mybuyToJson(List<Mybuy> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mybuy {
    Mybuy({
        this.bid,
        this.recipeId,
        this.datetime,
        this.price,
        this.recipeName,
        this.image,
        this.foodCategory,
        this.description,
        this.userId,
        this.nameSurname,
        this.aliasName,
        this.profileImage,
    });

    int bid;
    int recipeId;
    DateTime datetime;
    double price;
    String recipeName;
    String image;
    String foodCategory;
    String description;
    int userId;
    String nameSurname;
    String aliasName;
    String profileImage;

    factory Mybuy.fromJson(Map<String, dynamic> json) => Mybuy(
        bid: json["bid"],
        recipeId: json["recipe_ID"],
        datetime: DateTime.parse(json["datetime"]),
        price: json["price"].toDouble(),
        recipeName: json["recipe_name"],
        image: json["image"],
        foodCategory: json["food_category"],
        description: json["description"],
        userId: json["user_ID"],
        nameSurname: json["name_surname"],
        aliasName: json["alias_name"],
        profileImage: json["profile_image"],
    );

    Map<String, dynamic> toJson() => {
        "bid": bid,
        "recipe_ID": recipeId,
        "datetime": datetime.toIso8601String(),
        "price": price,
        "recipe_name": recipeName,
        "image": image,
        "food_category": foodCategory,
        "description": description,
        "user_ID": userId,
        "name_surname": nameSurname,
        "alias_name": aliasName,
        "profile_image": profileImage,
    };
}
