// To parse this JSON data, do
//
//     final editImageFoodModel = editImageFoodModelFromJson(jsonString);

import 'dart:convert';

EditImageFoodModel editImageFoodModelFromJson(String str) => EditImageFoodModel.fromJson(json.decode(str));

String editImageFoodModelToJson(EditImageFoodModel data) => json.encode(data.toJson());

class EditImageFoodModel {
    EditImageFoodModel({
        this.path,
    });

    String path;

    factory EditImageFoodModel.fromJson(Map<String, dynamic> json) => EditImageFoodModel(
        path: json["path"],
    );

    Map<String, dynamic> toJson() => {
        "path": path,
    };
}
