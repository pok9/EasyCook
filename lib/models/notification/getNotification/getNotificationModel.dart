

// To parse this JSON data, do
//
//     final getNotificationModel = getNotificationModelFromJson(jsonString);

import 'dart:convert';

GetNotificationModel getNotificationModelFromJson(String str) => GetNotificationModel.fromJson(json.decode(str));

String getNotificationModelToJson(GetNotificationModel data) => json.encode(data.toJson());

class GetNotificationModel {
    GetNotificationModel({
        this.data,
    });

    List<DataNotificationModel> data;

    factory GetNotificationModel.fromJson(Map<String, dynamic> json) => GetNotificationModel(
        data: List<DataNotificationModel>.from(json["data"].map((x) => DataNotificationModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DataNotificationModel {
    DataNotificationModel({
        this.nid,
        this.myId,
        this.state,
        this.description,
        this.date,
        this.visited,
        this.status,
        this.recipeId,
        this.fromUserid,
        this.fromProfileImage,
    });

    int nid;
    int myId;
    String state;
    String description;
    DateTime date;
    int visited;
    String status;
    int recipeId;
    int fromUserid;
    String fromProfileImage;

    factory DataNotificationModel.fromJson(Map<String, dynamic> json) => DataNotificationModel(
        nid: json["nid"],
        myId: json["my_ID"],
        state: json["state"],
        description: json["description"],
        date: DateTime.parse(json["date"]),
        visited: json["visited"],
        status: json["status"] == null ? null : json["status"],
        recipeId: json["recipe_ID"],
        fromUserid: json["from_userid"],
        fromProfileImage: json["from_profile_image"],
    );

    Map<String, dynamic> toJson() => {
        "nid": nid,
        "my_ID": myId,
        "state": state,
        "description": description,
        "date": date.toIso8601String(),
        "visited": visited,
        "status": status == null ? null : status,
        "recipe_ID": recipeId,
        "from_userid": fromUserid,
        "from_profile_image": fromProfileImage,
    };
}
