// To parse this JSON data, do
//
//     final manageFollow = manageFollowFromJson(jsonString);

import 'dart:convert';

ManageFollow manageFollowFromJson(String str) => ManageFollow.fromJson(json.decode(str));

String manageFollowToJson(ManageFollow data) => json.encode(data.toJson());

class ManageFollow {
    ManageFollow({
        this.success,
    });

    int success;

    factory ManageFollow.fromJson(Map<String, dynamic> json) => ManageFollow(
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
    };
}
