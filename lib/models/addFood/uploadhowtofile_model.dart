// To parse this JSON data, do
//
//     final uploadHowtoFileModels = uploadHowtoFileModelsFromJson(jsonString);

import 'dart:convert';

UploadHowtoFileModels uploadHowtoFileModelsFromJson(String str) => UploadHowtoFileModels.fromJson(json.decode(str));

String uploadHowtoFileModelsToJson(UploadHowtoFileModels data) => json.encode(data.toJson());

class UploadHowtoFileModels {
    UploadHowtoFileModels({
        this.path,
        this.type,
    });

    String path;
    String type;

    factory UploadHowtoFileModels.fromJson(Map<String, dynamic> json) => UploadHowtoFileModels(
        path: json["path"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "path": path,
        "type": type,
    };
}
