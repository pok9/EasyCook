// To parse this JSON data, do
//
//     final apiNotificationModel = apiNotificationModelFromJson(jsonString);

import 'dart:convert';

ApiNotificationModel apiNotificationModelFromJson(String str) => ApiNotificationModel.fromJson(json.decode(str));

String apiNotificationModelToJson(ApiNotificationModel data) => json.encode(data.toJson());

class ApiNotificationModel {
    ApiNotificationModel({
        this.success,
        this.message,
    });

    int success;
    String message;

    factory ApiNotificationModel.fromJson(Map<String, dynamic> json) => ApiNotificationModel(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
