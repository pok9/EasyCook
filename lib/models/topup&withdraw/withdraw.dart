// To parse this JSON data, do
//
//     final withdraw = withdrawFromJson(jsonString);

import 'dart:convert';

Withdraw withdrawFromJson(String str) => Withdraw.fromJson(json.decode(str));

String withdrawToJson(Withdraw data) => json.encode(data.toJson());

class Withdraw {
    Withdraw({
        this.success,
        this.message,
    });

    int success;
    String message;

    factory Withdraw.fromJson(Map<String, dynamic> json) => Withdraw(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
