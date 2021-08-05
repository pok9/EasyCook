// To parse this JSON data, do
//
//     final manageMembersModel = manageMembersModelFromJson(jsonString);

import 'dart:convert';

ManageMembersModel manageMembersModelFromJson(String str) => ManageMembersModel.fromJson(json.decode(str));

String manageMembersModelToJson(ManageMembersModel data) => json.encode(data.toJson());

class ManageMembersModel {
    ManageMembersModel({
        this.success,
        this.message,
    });

    int success;
    String message;

    factory ManageMembersModel.fromJson(Map<String, dynamic> json) => ManageMembersModel(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
