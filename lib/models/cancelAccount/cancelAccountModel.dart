// To parse this JSON data, do
//
//     final cancelAccoutModel = cancelAccoutModelFromJson(jsonString);

import 'dart:convert';

CancelAccoutModel cancelAccoutModelFromJson(String str) => CancelAccoutModel.fromJson(json.decode(str));

String cancelAccoutModelToJson(CancelAccoutModel data) => json.encode(data.toJson());

class CancelAccoutModel {
    CancelAccoutModel({
        this.success,
        this.accessStatus,
    });

    int success;
    int accessStatus;

    factory CancelAccoutModel.fromJson(Map<String, dynamic> json) => CancelAccoutModel(
        success: json["success"],
        accessStatus: json["access_status"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "access_status": accessStatus,
    };
}
