// To parse this JSON data, do
//
//     final topup = topupFromJson(jsonString);

import 'dart:convert';

TopupCreditCardModel topupCreditCardFromJson(String str) => TopupCreditCardModel.fromJson(json.decode(str));

String topupCreditCardToJson(TopupCreditCardModel data) => json.encode(data.toJson());

class TopupCreditCardModel {
    TopupCreditCardModel({
        this.success,
        this.balance,
    });

    int success;
    double balance;

    factory TopupCreditCardModel.fromJson(Map<String, dynamic> json) => TopupCreditCardModel(
        success: json["success"],
        balance: json["balance"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "balance": balance,
    };
}
