// To parse this JSON data, do
//
//     final editName = editNameFromJson(jsonString);

import 'dart:convert';

EditName editNameFromJson(String str) => EditName.fromJson(json.decode(str));

String editNameToJson(EditName data) => json.encode(data.toJson());

class EditName {
    EditName({
        this.success,
        this.nameSurname,
        this.aliasName,
    });

    int success;
    String nameSurname;
    String aliasName;

    factory EditName.fromJson(Map<String, dynamic> json) => EditName(
        success: json["success"],
        nameSurname: json["name_surname"],
        aliasName: json["alias_name"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "name_surname": nameSurname,
        "alias_name": aliasName,
    };
}
