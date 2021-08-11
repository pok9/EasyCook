// To parse this JSON data, do
//
//     final getCommentPostModel = getCommentPostModelFromJson(jsonString);

import 'dart:convert';

List<GetCommentPostModel> getCommentPostModelFromJson(String str) => List<GetCommentPostModel>.from(json.decode(str).map((x) => GetCommentPostModel.fromJson(x)));

String getCommentPostModelToJson(List<GetCommentPostModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetCommentPostModel {
    GetCommentPostModel({
        this.userId,
        this.nameSurname,
        this.aliasName,
        this.profileImage,
        this.userStatus,
        this.cid,
        this.recipeId,
        this.commentDetail,
        this.datetime,
    });

    int userId;
    String nameSurname;
    String aliasName;
    String profileImage;
    int userStatus;
    int cid;
    int recipeId;
    String commentDetail;
    DateTime datetime;

    factory GetCommentPostModel.fromJson(Map<String, dynamic> json) => GetCommentPostModel(
        userId: json["user_ID"],
        nameSurname: json["name_surname"],
        aliasName: json["alias_name"],
        profileImage: json["profile_image"],
        userStatus: json["user_status"],
        cid: json["cid"],
        recipeId: json["recipe_ID"],
        commentDetail: json["commentDetail"],
        datetime: DateTime.parse(json["datetime"]),
    );

    Map<String, dynamic> toJson() => {
        "user_ID": userId,
        "name_surname": nameSurname,
        "alias_name": aliasName,
        "profile_image": profileImage,
        "user_status": userStatus,
        "cid": cid,
        "recipe_ID": recipeId,
        "commentDetail": commentDetail,
        "datetime": datetime.toIso8601String(),
    };
}
