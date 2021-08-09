// To parse this JSON data, do
//
//     final getCountVisitedModel = getCountVisitedModelFromJson(jsonString);

import 'dart:convert';

GetCountVisitedModel getCountVisitedModelFromJson(String str) => GetCountVisitedModel.fromJson(json.decode(str));

String getCountVisitedModelToJson(GetCountVisitedModel data) => json.encode(data.toJson());

class GetCountVisitedModel {
    GetCountVisitedModel({
        this.countVisit,
    });

    int countVisit;

    factory GetCountVisitedModel.fromJson(Map<String, dynamic> json) => GetCountVisitedModel(
        countVisit: json["countVisit"],
    );

    Map<String, dynamic> toJson() => {
        "countVisit": countVisit,
    };
}
