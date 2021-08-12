// To parse this JSON data, do
//
//     final getReportModel = getReportModelFromJson(jsonString);

import 'dart:convert';

GetReportModel getReportModelFromJson(String str) => GetReportModel.fromJson(json.decode(str));

String getReportModelToJson(GetReportModel data) => json.encode(data.toJson());

class GetReportModel {
    GetReportModel({
        this.reportId,
        this.typeReport,
        this.title,
        this.description,
        this.dataTarget,
        this.dataUserReport,
        this.dataRecipe,
        this.image,
    });

    int reportId;
    String typeReport;
    String title;
    String description;
    DataTarget dataTarget;
    DataUserReport dataUserReport;
    DataRecipe dataRecipe;
    String image;

    factory GetReportModel.fromJson(Map<String, dynamic> json) => GetReportModel(
        reportId: json["report_ID"],
        typeReport: json["type_report"],
        title: json["title"],
        description: json["description"],
        dataTarget: DataTarget.fromJson(json["dataTarget"]),
        dataUserReport: DataUserReport.fromJson(json["dataUserReport"]),
        dataRecipe: DataRecipe.fromJson(json["dataRecipe"]),
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "report_ID": reportId,
        "type_report": typeReport,
        "title": title,
        "description": description,
        "dataTarget": dataTarget.toJson(),
        "dataUserReport": dataUserReport.toJson(),
        "dataRecipe": dataRecipe.toJson(),
        "image": image,
    };
}

class DataRecipe {
    DataRecipe({
        this.recipeId,
        this.recipeName,
        this.recipeImage,
    });

    int recipeId;
    String recipeName;
    String recipeImage;

    factory DataRecipe.fromJson(Map<String, dynamic> json) => DataRecipe(
        recipeId: json["recipe_ID"],
        recipeName: json["recipe_name"],
        recipeImage: json["recipe_image"],
    );

    Map<String, dynamic> toJson() => {
        "recipe_ID": recipeId,
        "recipe_name": recipeName,
        "recipe_image": recipeImage,
    };
}

class DataTarget {
    DataTarget({
        this.userTargetId,
        this.nameUserTarget,
        this.aliasUserTarget,
        this.profileUserTarget,
    });

    int userTargetId;
    String nameUserTarget;
    String aliasUserTarget;
    String profileUserTarget;

    factory DataTarget.fromJson(Map<String, dynamic> json) => DataTarget(
        userTargetId: json["userTarget_ID"],
        nameUserTarget: json["name_userTarget"],
        aliasUserTarget: json["alias_userTarget"],
        profileUserTarget: json["profile_userTarget"],
    );

    Map<String, dynamic> toJson() => {
        "userTarget_ID": userTargetId,
        "name_userTarget": nameUserTarget,
        "alias_userTarget": aliasUserTarget,
        "profile_userTarget": profileUserTarget,
    };
}

class DataUserReport {
    DataUserReport({
        this.userReport,
        this.nameUserReport,
        this.aliasUserReport,
        this.profileUserReport,
    });

    int userReport;
    String nameUserReport;
    String aliasUserReport;
    String profileUserReport;

    factory DataUserReport.fromJson(Map<String, dynamic> json) => DataUserReport(
        userReport: json["userReport"],
        nameUserReport: json["name_userReport"],
        aliasUserReport: json["alias_userReport"],
        profileUserReport: json["profile_userReport"],
    );

    Map<String, dynamic> toJson() => {
        "userReport": userReport,
        "name_userReport": nameUserReport,
        "alias_userReport": aliasUserReport,
        "profile_userReport": profileUserReport,
    };
}
