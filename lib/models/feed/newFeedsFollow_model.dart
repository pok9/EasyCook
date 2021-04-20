// To parse this JSON data, do
//
//     final newfeedsProfile = newfeedsProfileFromJson(jsonString);

import 'dart:convert';

NewfeedsFollow newfeedsFollowFromJson(String str) => NewfeedsFollow.fromJson(json.decode(str));

String newfeedsFollowToJson(NewfeedsFollow data) => json.encode(data.toJson());

class NewfeedsFollow {
    NewfeedsFollow({
        this.success,
        this.feeds,
    });

    int success;
    List<Feed> feeds;

    factory NewfeedsFollow.fromJson(Map<String, dynamic> json) => NewfeedsFollow(
        success: json["success"],
        feeds: List<Feed>.from(json["feeds"].map((x) => Feed.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "feeds": List<dynamic>.from(feeds.map((x) => x.toJson())),
    };
}

class Feed {
    Feed({
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
    int price;

    factory Feed.fromJson(Map<String, dynamic> json) => Feed(
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
        price: json["price"],
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
    };
}
