import 'dart:convert';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  RegisterModel({
    this.success,
    this.token,
    this.message,
  });

  int success;
  String token;
  String message;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        success: json["success"],
        token: json["token"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "token": token,
        "message": message,
      };
}
