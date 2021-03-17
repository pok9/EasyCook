import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    LoginModel({
        this.success,
        this.token,
    });

    int success;
    String token;

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        success: json["success"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "token": token,
    };
}
