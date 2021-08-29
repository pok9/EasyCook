// To parse this JSON data, do
//
//     final topupQrModel = topupQrModelFromJson(jsonString);

import 'dart:convert';

TopupQrModel topupQrModelFromJson(String str) => TopupQrModel.fromJson(json.decode(str));

String topupQrModelToJson(TopupQrModel data) => json.encode(data.toJson());

class TopupQrModel {
    TopupQrModel({
        this.filename,
        this.qrCode,
    });

    String filename;
    String qrCode;

    factory TopupQrModel.fromJson(Map<String, dynamic> json) => TopupQrModel(
        filename: json["filename"],
        qrCode: json["qr__code"],
    );

    Map<String, dynamic> toJson() => {
        "filename": filename,
        "qr__code": qrCode,
    };
}
