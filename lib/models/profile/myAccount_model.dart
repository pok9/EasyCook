// To parse this JSON data, do
//
//     final myAccount = myAccountFromJson(jsonString);

import 'dart:convert';

MyAccount myAccountFromJson(String str) => MyAccount.fromJson(json.decode(str));

String myAccountToJson(MyAccount data) => json.encode(data.toJson());

class MyAccount {
    MyAccount({
        this.success,
        this.message,
        this.data,
    });

    int success;
    String message;
    List<DataMyAccount> data;

    factory MyAccount.fromJson(Map<String, dynamic> json) => MyAccount(
        success: json["success"],
        message: json["message"],
        // data: json["data"] != null ? new List<DataMyAccount>.from( json["data"].map((x) => DataMyAccount.fromJson(x))) : List<DataMyAccount>()
        data: List<DataMyAccount>.from(json["data"].map((x) => DataMyAccount.fromJson(x))),
    
    
    
    
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DataMyAccount {
    DataMyAccount({
        this.userId,
        this.email,
        this.facebookId,
        this.nameSurname,
        this.aliasName,
        this.userStatus,
        this.accessStatus,
        this.balance,
        this.profileImage,
    });

    int userId;
    String email;
    dynamic facebookId;
    String nameSurname;
    String aliasName;
    int userStatus;
    int accessStatus;
    double balance;
    String profileImage;

    factory DataMyAccount.fromJson(Map<String, dynamic> json) => DataMyAccount(
        userId: json["user_ID"],
        email: json["email"],
        facebookId: json["facebookID"],
        nameSurname: json["name_surname"],
        aliasName: json["alias_name"],
        userStatus: json["user_status"],
        accessStatus: json["access_status"],
        balance: json["balance"].toDouble(),
        profileImage: json["profile_image"],
    );

    Map<String, dynamic> toJson() => {
        "user_ID": userId,
        "email": email,
        "facebookID": facebookId,
        "name_surname": nameSurname,
        "alias_name": aliasName,
        "user_status": userStatus,
        "access_status": accessStatus,
        "balance": balance,
        "profile_image": profileImage,
    };
}
