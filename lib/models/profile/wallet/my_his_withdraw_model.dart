// To parse this JSON data, do
//
//     final myHisWithdrawModel = myHisWithdrawModelFromJson(jsonString);

import 'dart:convert';

List<MyHisWithdrawModel> myHisWithdrawModelFromJson(String str) => List<MyHisWithdrawModel>.from(json.decode(str).map((x) => MyHisWithdrawModel.fromJson(x)));

String myHisWithdrawModelToJson(List<MyHisWithdrawModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyHisWithdrawModel {
    MyHisWithdrawModel({
        this.wid,
        this.wToken,
        this.status,
        this.amount,
        this.userId,
        this.brand,
        this.name,
        this.lastDigits,
        this.datetime,
    });

    int wid;
    String wToken;
    String status;
    double amount;
    int userId;
    String brand;
    String name;
    String lastDigits;
    DateTime datetime;

    factory MyHisWithdrawModel.fromJson(Map<String, dynamic> json) => MyHisWithdrawModel(
        wid: json["wid"],
        wToken: json["w_token"],
        status: json["status"],
        amount: json["amount"].toDouble(),
        userId: json["user_ID"],
        brand: json["brand"],
        name: json["name"],
        lastDigits: json["last_digits"],
        datetime: DateTime.parse(json["datetime"]),
    );

    Map<String, dynamic> toJson() => {
        "wid": wid,
        "w_token": wToken,
        "status": status,
        "amount": amount,
        "user_ID": userId,
        "brand": brand,
        "name": name,
        "last_digits": lastDigits,
        "datetime": datetime.toIso8601String(),
    };
}
