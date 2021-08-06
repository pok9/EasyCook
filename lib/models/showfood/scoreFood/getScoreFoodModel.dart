// To parse this JSON data, do
//
//     final getScoreFoodModel = getScoreFoodModelFromJson(jsonString);

import 'dart:convert';

GetScoreFoodModel getScoreFoodModelFromJson(String str) => GetScoreFoodModel.fromJson(json.decode(str));

String getScoreFoodModelToJson(GetScoreFoodModel data) => json.encode(data.toJson());

class GetScoreFoodModel {
    GetScoreFoodModel({
        this.score,
    });

    double score;

    factory GetScoreFoodModel.fromJson(Map<String, dynamic> json) => GetScoreFoodModel(
        score: json["score"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "score": score,
    };
}
