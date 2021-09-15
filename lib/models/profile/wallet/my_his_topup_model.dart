// To parse this JSON data, do
//
//     final myHisTopupModel = myHisTopupModelFromJson(jsonString);

import 'dart:convert';

List<MyHisTopupModel> myHisTopupModelFromJson(String str) => List<MyHisTopupModel>.from(json.decode(str).map((x) => MyHisTopupModel.fromJson(x)));

String myHisTopupModelToJson(List<MyHisTopupModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyHisTopupModel {
    MyHisTopupModel({
        this.tid,
        this.tToken,
        this.status,
        this.amount,
        this.userId,
        this.brand,
        this.datetime,
    });

    int tid;
    String tToken;
    String status;
    int amount;
    int userId;
    String brand;
    DateTime datetime;

    factory MyHisTopupModel.fromJson(Map<String, dynamic> json) => MyHisTopupModel(
        tid: json["tid"],
        tToken: json["t_token"],
        status: json["status"],
        amount: json["amount"],
        userId: json["user_ID"],
        brand: json["brand"],
        datetime: DateTime.parse(json["datetime"]),
    );

    Map<String, dynamic> toJson() => {
        "tid": tid,
        "t_token": tToken,
        "status": status,
        "amount": amount,
        "user_ID": userId,
        "brand": brand,
        "datetime": datetime.toIso8601String(),
    };
}
