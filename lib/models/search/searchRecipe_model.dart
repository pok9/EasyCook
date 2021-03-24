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
        this.userId,
        this.aliasName,
        this.nameSurname,
        this.profileImage,
        this.score,
    });

    int rid;
    String recipeName;
    String image;
    int userId;
    String aliasName;
    String nameSurname;
    String profileImage;
    int score;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        rid: json["rid"],
        recipeName: json["recipe_name"],
        image: json["image"],
        userId: json["user_ID"],
        aliasName: json["alias_name"],
        nameSurname: json["name_surname"],
        profileImage: json["profile_image"],
        score: json["score"],
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
    };
}
