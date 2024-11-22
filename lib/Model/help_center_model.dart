// To parse this JSON data, do
//
//     final helpCenterModal = helpCenterModalFromJson(jsonString);

import 'dart:convert';

HelpCenterModal helpCenterModalFromJson(String str) =>
    HelpCenterModal.fromJson(json.decode(str));

String helpCenterModalToJson(HelpCenterModal data) =>
    json.encode(data.toJson());

class HelpCenterModal {
  bool? status;
  String? message;
  HelpCenterData? data;

  HelpCenterModal({
    this.status,
    this.message,
    this.data,
  });

  factory HelpCenterModal.fromJson(Map<String, dynamic> json) =>
      HelpCenterModal(
        status: json["status"],
        message: json["message"],
        data:
            json["data"] == null ? null : HelpCenterData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class HelpCenterData {
  int? id;
  String? helpEmail;
  String? helpNumber;
  String? helpWebsite;

  HelpCenterData({
    this.id,
    this.helpEmail,
    this.helpNumber,
    this.helpWebsite,
  });

  factory HelpCenterData.fromJson(Map<String, dynamic> json) => HelpCenterData(
        id: json["id"],
        helpEmail: json["help_email"],
        helpNumber: json["help_number"],
        helpWebsite: json["help_website"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "help_email": helpEmail,
        "help_number": helpNumber,
        "help_website": helpWebsite,
      };
}
