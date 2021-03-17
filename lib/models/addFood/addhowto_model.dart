// To parse this JSON data, do
//
//     final addHowtoArrayModels = addHowtoArrayModelsFromJson(jsonString);

import 'dart:convert';

AddHowtoArrayModels addHowtoArrayModelsFromJson(String str) => AddHowtoArrayModels.fromJson(json.decode(str));

String addHowtoArrayModelsToJson(AddHowtoArrayModels data) => json.encode(data.toJson());

class AddHowtoArrayModels {
    AddHowtoArrayModels({
        this.success,
    });

    int success;

    factory AddHowtoArrayModels.fromJson(Map<String, dynamic> json) => AddHowtoArrayModels(
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
    };
}
