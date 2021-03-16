import 'dart:convert';

Register2Model register2ModelFromJson(String str) => Register2Model.fromJson(json.decode(str));

String register2ModelToJson(Register2Model data) => json.encode(data.toJson());

class Register2Model {
    Register2Model({
        this.success,
    });

    int success;

    factory Register2Model.fromJson(Map<String, dynamic> json) => Register2Model(
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
    };
}
