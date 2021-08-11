// To parse this JSON data, do
//
//     final getAllReportModel = getAllReportModelFromJson(jsonString);

import 'dart:convert';

List<GetAllReportModel> getAllReportModelFromJson(String str) => List<GetAllReportModel>.from(json.decode(str).map((x) => GetAllReportModel.fromJson(x)));

String getAllReportModelToJson(List<GetAllReportModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllReportModel {
    GetAllReportModel({
        this.reportId,
        this.userTargetId,
        this.nameUserReport,
        this.userReportId,
        this.aliasUserReport,
        this.profileUserReport,
        this.datetime,
        this.typeReport,
        this.title,
    });

    int reportId;
    int userTargetId;
    String nameUserReport;
    int userReportId;
    String aliasUserReport;
    String profileUserReport;
    DateTime datetime;
    String typeReport;
    String title;

    factory GetAllReportModel.fromJson(Map<String, dynamic> json) => GetAllReportModel(
        reportId: json["report_ID"],
        userTargetId: json["userTarget_ID"],
        nameUserReport: json["name_userReport"],
        userReportId: json["userReport_ID"],
        aliasUserReport: json["alias_userReport"],
        profileUserReport: json["profile_userReport"],
        datetime: DateTime.parse(json["datetime"]),
        typeReport: json["type_report"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "report_ID": reportId,
        "userTarget_ID": userTargetId,
        "name_userReport": nameUserReport,
        "userReport_ID": userReportId,
        "alias_userReport": aliasUserReport,
        "profile_userReport": profileUserReport,
        "datetime": datetime.toIso8601String(),
        "type_report": typeReport,
        "title": title,
    };
}
