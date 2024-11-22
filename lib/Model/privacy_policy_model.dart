// To parse this JSON data, do
//
//     final privacyPolicyModal = privacyPolicyModalFromJson(jsonString);

import 'dart:convert';

PrivacyPolicyModal privacyPolicyModalFromJson(String str) =>
    PrivacyPolicyModal.fromJson(json.decode(str));

String privacyPolicyModalToJson(PrivacyPolicyModal data) =>
    json.encode(data.toJson());

class PrivacyPolicyModal {
  bool? status;
  String? message;
  PrivacyPolicyData? data;

  PrivacyPolicyModal({
    this.status,
    this.message,
    this.data,
  });

  factory PrivacyPolicyModal.fromJson(Map<String, dynamic> json) =>
      PrivacyPolicyModal(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : PrivacyPolicyData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class PrivacyPolicyData {
  int? id;
  String? privacyPolicy;

  PrivacyPolicyData({
    this.id,
    this.privacyPolicy,
  });

  factory PrivacyPolicyData.fromJson(Map<String, dynamic> json) =>
      PrivacyPolicyData(
        id: json["id"],
        privacyPolicy: json["privacy_policy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "privacy_policy": privacyPolicy,
      };
}
