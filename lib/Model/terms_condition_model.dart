// To parse this JSON data, do
//
//     final termsConditionModal = termsConditionModalFromJson(jsonString);

import 'dart:convert';

TermsConditionModal termsConditionModalFromJson(String str) =>
    TermsConditionModal.fromJson(json.decode(str));

String termsConditionModalToJson(TermsConditionModal data) =>
    json.encode(data.toJson());

class TermsConditionModal {
  bool? status;
  String? message;
  TermsConditionData? data;

  TermsConditionModal({
    this.status,
    this.message,
    this.data,
  });

  factory TermsConditionModal.fromJson(Map<String, dynamic> json) =>
      TermsConditionModal(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : TermsConditionData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class TermsConditionData {
  int? id;
  String? terms;

  TermsConditionData({
    this.id,
    this.terms,
  });

  factory TermsConditionData.fromJson(Map<String, dynamic> json) =>
      TermsConditionData(
        id: json["id"],
        terms: json["terms"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "terms": terms,
      };
}
