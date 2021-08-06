// To parse this JSON data, do
//
//     final commentPostModel = commentPostModelFromJson(jsonString);

import 'dart:convert';

CommentPostModel commentPostModelFromJson(String str) => CommentPostModel.fromJson(json.decode(str));

String commentPostModelToJson(CommentPostModel data) => json.encode(data.toJson());

class CommentPostModel {
    CommentPostModel({
        this.success,
        this.comment,
    });

    int success;
    List<Comment> comment;

    factory CommentPostModel.fromJson(Map<String, dynamic> json) => CommentPostModel(
        success: json["success"],
        comment: List<Comment>.from(json["comment"].map((x) => Comment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "comment": List<dynamic>.from(comment.map((x) => x.toJson())),
    };
}

class Comment {
    Comment({
        this.userId,
        this.nameSurname,
        this.aliasName,
        this.profileImage,
        this.cid,
        this.recipeId,
        this.commentDetail,
        this.datetime,
    });

    int userId;
    String nameSurname;
    String aliasName;
    String profileImage;
    int cid;
    int recipeId;
    String commentDetail;
    DateTime datetime;

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        userId: json["user_ID"],
        nameSurname: json["name_surname"],
        aliasName: json["alias_name"],
        profileImage: json["profile_image"],
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
        "cid": cid,
        "recipe_ID": recipeId,
        "commentDetail": commentDetail,
        "datetime": datetime.toIso8601String(),
    };
}
