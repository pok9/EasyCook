// To parse this JSON data, do
//
//     final checkFolloweer = checkFolloweerFromJson(jsonString);

import 'dart:convert';

CheckFolloweer checkFolloweerFromJson(String str) => CheckFolloweer.fromJson(json.decode(str));

String checkFolloweerToJson(CheckFolloweer data) => json.encode(data.toJson());

class CheckFolloweer {
    CheckFolloweer({
        this.count,
        this.checkFollower,
        this.user,
    });

    int count;
    int checkFollower;
    List<User> user;

    factory CheckFolloweer.fromJson(Map<String, dynamic> json) => CheckFolloweer(
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
