import 'dart:convert';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
    RegisterModel({
        this.success,
        this.token,
    });

    int success;
    String token;

    factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        success: json["success"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "token": token,
    };
}
