// To parse this JSON data, do
//
//     final deleteCommentModel = deleteCommentModelFromJson(jsonString);

import 'dart:convert';

DeleteCommentModel deleteCommentModelFromJson(String str) => DeleteCommentModel.fromJson(json.decode(str));

String deleteCommentModelToJson(DeleteCommentModel data) => json.encode(data.toJson());

class DeleteCommentModel {
    DeleteCommentModel({
        this.success,
    });

    int success;

    factory DeleteCommentModel.fromJson(Map<String, dynamic> json) => DeleteCommentModel(
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
    };
}
