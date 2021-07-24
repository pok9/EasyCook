// To parse this JSON data, do
//
//     final buyFood = buyFoodFromJson(jsonString);

import 'dart:convert';

BuyFood buyFoodFromJson(String str) => BuyFood.fromJson(json.decode(str));

String buyFoodToJson(BuyFood data) => json.encode(data.toJson());

class BuyFood {
    BuyFood({
        this.success,
        this.message,
    });

    int success;
    String message;

    factory BuyFood.fromJson(Map<String, dynamic> json) => BuyFood(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
