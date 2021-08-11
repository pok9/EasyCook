// To parse this JSON data, do
//
//     final addReportImageModel = addReportImageModelFromJson(jsonString);

import 'dart:convert';

AddReportImageModel addReportImageModelFromJson(String str) => AddReportImageModel.fromJson(json.decode(str));

String addReportImageModelToJson(AddReportImageModel data) => json.encode(data.toJson());

class AddReportImageModel {
    AddReportImageModel({
        this.path,
    });

    String path;

    factory AddReportImageModel.fromJson(Map<String, dynamic> json) => AddReportImageModel(
        path: json["path"],
    );

    Map<String, dynamic> toJson() => {
        "path": path,
    };
}
