// To parse this JSON data, do
//
//     final newfeedsglobal = newfeedsglobalFromJson(jsonString);

import 'dart:convert';

List<Newfeedsglobal> newfeedsglobalFromJson(String str) => List<Newfeedsglobal>.from(json.decode(str).map((x) => Newfeedsglobal.fromJson(x)));

String newfeedsglobalToJson(List<Newfeedsglobal> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Newfeedsglobal {
    Newfeedsglobal({
        this.userId,
        this.nameSurname,
        this.aliasName,
        this.userStatus,
        this.accessStatus,
        this.profileImage,
        this.rid,
        this.recipeName,
        this.image,
        this.date,
        this.price,
        this.score,
        this.count,
    });

    int userId;
    String nameSurname;
    String aliasName;
    int userStatus;
    int accessStatus;
    String profileImage;
    int rid;
    String recipeName;
    String image;
    DateTime date;
    double price;
    double score;
    int count;

    factory Newfeedsglobal.fromJson(Map<String, dynamic> json) => Newfeedsglobal(
        userId: json["user_ID"],
        nameSurname: json["name_surname"],
        aliasName: json["alias_name"],
        userStatus: json["user_status"],
        accessStatus: json["access_status"],
        profileImage: json["profile_image"],
        rid: json["rid"],
        recipeName: json["recipe_name"],
        image: json["image"],
        date: DateTime.parse(json["date"]),
        price: json["price"].toDouble(),
        score: json["score"].toDouble(),
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "user_ID": userId,
        "name_surname": nameSurname,
        "alias_name": aliasName,
        "user_status": userStatus,
        "access_status": accessStatus,
        "profile_image": profileImage,
        "rid": rid,
        "recipe_name": recipeName,
        "image": image,
        "date": date.toIso8601String(),
        "price": price,
        "score": score,
        "count": count,
    };
}
