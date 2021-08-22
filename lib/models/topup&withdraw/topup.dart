// To parse this JSON data, do
//
//     final topup = topupFromJson(jsonString);

import 'dart:convert';

Topup topupFromJson(String str) => Topup.fromJson(json.decode(str));

String topupToJson(Topup data) => json.encode(data.toJson());

class Topup {
    Topup({
        this.success,
        this.balance,
    });

    int success;
    double balance;

    factory Topup.fromJson(Map<String, dynamic> json) => Topup(
        success: json["success"],
        balance: json["balance"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "balance": balance,
    };
}
