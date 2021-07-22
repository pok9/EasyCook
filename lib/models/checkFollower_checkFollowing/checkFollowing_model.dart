// To parse this JSON data, do
//
//     final checkFollowing = checkFollowingFromJson(jsonString);

import 'dart:convert';

CheckFollowing checkFollowingFromJson(String str) => CheckFollowing.fromJson(json.decode(str));

String checkFollowingToJson(CheckFollowing data) => json.encode(data.toJson());

class CheckFollowing {
    CheckFollowing({
        this.count,
        this.user,
    });

    int count;
    List<User> user;

    factory CheckFollowing.fromJson(Map<String, dynamic> json) => CheckFollowing(
        count: json["count"],
        user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "user": List<dynamic>.from(user.map((x) => x.toJson())),
    };
}

class User {
    User({
        this.userId,
        this.nameSurname,
        this.aliasName,
        this.profileImage,
        this.userStatus,
    });

    int userId;
    String nameSurname;
    String aliasName;
    String profileImage;
    int userStatus;

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_ID"],
        nameSurname: json["name_surname"],
        aliasName: json["alias_name"],
        profileImage: json["profile_image"],
        userStatus: json["user_status"],
    );

    Map<String, dynamic> toJson() => {
        "user_ID": userId,
        "name_surname": nameSurname,
        "alias_name": aliasName,
        "profile_image": profileImage,
        "user_status": userStatus,
    };
}
