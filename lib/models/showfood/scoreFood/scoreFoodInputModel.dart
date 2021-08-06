// To parse this JSON data, do
//
//     final scoreFoodInputModel = scoreFoodInputModelFromJson(jsonString);

import 'dart:convert';

ScoreFoodInputModel scoreFoodInputModelFromJson(String str) => ScoreFoodInputModel.fromJson(json.decode(str));

String scoreFoodInputModelToJson(ScoreFoodInputModel data) => json.encode(data.toJson());

class ScoreFoodInputModel {
    ScoreFoodInputModel({
        this.success,
        this.avgscore,
    });

    int success;
    double avgscore;

    factory ScoreFoodInputModel.fromJson(Map<String, dynamic> json) => ScoreFoodInputModel(
        success: json["success"],
        avgscore: json["avgscore"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "avgscore": avgscore,
    };
}
