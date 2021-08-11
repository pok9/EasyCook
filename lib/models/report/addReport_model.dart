// To parse this JSON data, do
//
//     final addReport = addReportFromJson(jsonString);

import 'dart:convert';

AddReport addReportFromJson(String str) => AddReport.fromJson(json.decode(str));

String addReportToJson(AddReport data) => json.encode(data.toJson());

class AddReport {
    AddReport({
        this.success,
        this.message,
    });

    int success;
    String message;

    factory AddReport.fromJson(Map<String, dynamic> json) => AddReport(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
