import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    LoginModel({
        this.success,
        this.token,
        this.message,
    });

    int success;
    String token; 
    String message;

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        success: json["success"],
        token: json["token"],
        message : json["message"]
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "token": token,
        "message" : message
    };
}
