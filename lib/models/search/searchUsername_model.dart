// To parse this JSON data, do
//
//     final searchUserName = searchUserNameFromJson(jsonString);

import 'dart:convert';

SearchUserName searchUserNameFromJson(String str) => SearchUserName.fromJson(json.decode(str));

String searchUserNameToJson(SearchUserName data) => json.encode(data.toJson());

class SearchUserName {
    SearchUserName({
        this.data,
    });

    List<DataUser> data;

    factory SearchUserName.fromJson(Map<String, dynamic> json) => SearchUserName(
        data: List<DataUser>.from(json["data"].map((x) => DataUser.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DataUser {
    DataUser({
        this.userId,
        this.nameSurname,
        this.aliasName,
        this.profileImage,
    });

    int userId;
    String nameSurname;
    String aliasName;
    String profileImage;

    factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
        userId: json["user_ID"],
        nameSurname: json["name_surname"],
        aliasName: json["alias_name"],
        profileImage: json["profile_image"],
    );

    Map<String, dynamic> toJson() => {
        "user_ID": userId,
        "name_surname": nameSurname,
        "alias_name": aliasName,
        "profile_image": profileImage,
    };
}
