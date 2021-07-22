// To parse this JSON data, do
//
//     final checkFollower = checkFollowerFromJson(jsonString);

import 'dart:convert';

CheckFollower checkFollowerFromJson(String str) => CheckFollower.fromJson(json.decode(str));

String checkFollowerToJson(CheckFollower data) => json.encode(data.toJson());

class CheckFollower {
    CheckFollower({
        this.count,
        this.checkFollower,
        this.user,
    });

    int count;
    int checkFollower;
    List<User> user;

    factory CheckFollower.fromJson(Map<String, dynamic> json) => CheckFollower(
        count: json["count"],
        checkFollower: json["checkFollower"],
        user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "checkFollower": checkFollower,
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
