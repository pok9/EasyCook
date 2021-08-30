// To parse this JSON data, do
//
//     final myPost = myPostFromJson(jsonString);

import 'dart:convert';

MyPost myPostFromJson(String str) => MyPost.fromJson(json.decode(str));

String myPostToJson(MyPost data) => json.encode(data.toJson());

class MyPost {
    MyPost({
        this.userId,
        this.nameSurname,
        this.aliasName,
        this.userStatus,
        this.profileImage,
        this.countPost,
        this.countFollower,
        this.countFollowing,
        this.recipePost,
    });

    int userId;
    String nameSurname;
    String aliasName;
    int userStatus;
    String profileImage;
    int countPost;
    int countFollower;
    int countFollowing;
    List<RecipePost> recipePost;

    factory MyPost.fromJson(Map<String, dynamic> json) => MyPost(
        userId: json["user_ID"],
        nameSurname: json["name_surname"],
        aliasName: json["alias_name"],
        userStatus: json["user_status"],
        profileImage: json["profile_image"],
        countPost: json["countPost"],
        countFollower: json["countFollower"],
        countFollowing: json["countFollowing"],
        recipePost: List<RecipePost>.from(json["recipePost"].map((x) => RecipePost.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "user_ID": userId,
        "name_surname": nameSurname,
        "alias_name": aliasName,
        "user_status": userStatus,
        "profile_image": profileImage,
        "countPost": countPost,
        "countFollower": countFollower,
        "countFollowing": countFollowing,
        "recipePost": List<dynamic>.from(recipePost.map((x) => x.toJson())),
    };
}

class RecipePost {
    RecipePost({
        this.rid,
        this.recipeName,
        this.image,
        this.date,
        this.price,
        this.score,
        this.count,
    });

    int rid;
    String recipeName;
    String image;
    DateTime date;
    double price;
    double score;
    int count;

    factory RecipePost.fromJson(Map<String, dynamic> json) => RecipePost(
        rid: json["rid"],
        recipeName: json["recipe_name"],
        image: json["image"],
        date: DateTime.parse(json["date"]),
        price: json["price"].toDouble(),
        score: json["score"].toDouble(),
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "rid": rid,
        "recipe_name": recipeName,
        "image": image,
        "date": date.toIso8601String(),
        "price": price,
        "score": score,
        "count": count,
    };
}
