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
    Status status;
    double amount;
    int userId;
    Brand brand;
    DateTime datetime;

    factory MyHisTopupModel.fromJson(Map<String, dynamic> json) => MyHisTopupModel(
        tid: json["tid"],
        tToken: json["t_token"],
        status: statusValues.map[json["status"]],
        amount: json["amount"].toDouble(),
        userId: json["user_ID"],
        brand: brandValues.map[json["brand"]],
        datetime: DateTime.parse(json["datetime"]),
    );

    Map<String, dynamic> toJson() => {
        "tid": tid,
        "t_token": tToken,
        "status": statusValues.reverse[status],
        "amount": amount,
        "user_ID": userId,
        "brand": brandValues.reverse[brand],
        "datetime": datetime.toIso8601String(),
    };
}

enum Brand { PROMPTPAY, VISA }

final brandValues = EnumValues({
    "Promptpay": Brand.PROMPTPAY,
    "Visa": Brand.VISA
});

enum Status { PENDING, SUCCESSFUL }

final statusValues = EnumValues({
    "pending": Status.PENDING,
    "successful": Status.SUCCESSFUL
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
