// To parse this JSON data, do
//
//     final getAllTokenNotiModel = getAllTokenNotiModelFromJson(jsonString);

import 'dart:convert';

GetAllTokenNotiModel getAllTokenNotiModelFromJson(String str) => GetAllTokenNotiModel.fromJson(json.decode(str));

String getAllTokenNotiModelToJson(GetAllTokenNotiModel data) => json.encode(data.toJson());

class GetAllTokenNotiModel {
    GetAllTokenNotiModel({
        this.tokenNoti,
    });

    List<String> tokenNoti;

    factory GetAllTokenNotiModel.fromJson(Map<String, dynamic> json) => GetAllTokenNotiModel(
        tokenNoti: List<String>.from(json["token_noti"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "token_noti": List<dynamic>.from(tokenNoti.map((x) => x)),
    };
}
