// To parse this JSON data, do
//
//     final recommendUser = recommendUserFromJson(jsonString);

import 'dart:convert';

List<RecommendUser> recommendUserFromJson(String str) => List<RecommendUser>.from(json.decode(str).map((x) => RecommendUser.fromJson(x)));

String recommendUserToJson(List<RecommendUser> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecommendUser {
    RecommendUser({
        this.userId,
        this.nameSurname,
        this.aliasName,
        this.profileImage,
        this.amountFollower,
    });

    int userId;
    String nameSurname;
    String aliasName;
    String profileImage;
    int amountFollower;

    factory RecommendUser.fromJson(Map<String, dynamic> json) => RecommendUser(
        userId: json["user_ID"],
        nameSurname: json["name_surname"],
        aliasName: json["alias_name"],
        profileImage: json["profile_image"],
        amountFollower: json["amountFollower"],
    );

    Map<String, dynamic> toJson() => {
        "user_ID": userId,
        "name_surname": nameSurname,
        "alias_name": aliasName,
        "profile_image": profileImage,
        "amountFollower": amountFollower,
    };
}
