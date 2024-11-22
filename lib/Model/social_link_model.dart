// To parse this JSON data, do
//
//     final socialLinkModal = socialLinkModalFromJson(jsonString);

import 'dart:convert';

SocialLinkModal socialLinkModalFromJson(String str) =>
    SocialLinkModal.fromJson(json.decode(str));

String socialLinkModalToJson(SocialLinkModal data) =>
    json.encode(data.toJson());

class SocialLinkModal {
  bool? status;
  String? message;
  Data? data;

  SocialLinkModal({
    this.status,
    this.message,
    this.data,
  });

  factory SocialLinkModal.fromJson(Map<String, dynamic> json) =>
      SocialLinkModal(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  String? facebookUrl;
  String? instaUrl;
  String? twitterUrl;
  String? whatsupUrl;

  Data({
    this.id,
    this.facebookUrl,
    this.instaUrl,
    this.twitterUrl,
    this.whatsupUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        facebookUrl: json["facebook_url"],
        instaUrl: json["insta_url"],
        twitterUrl: json["twitter_url"],
        whatsupUrl: json["whatsup_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "facebook_url": facebookUrl,
        "insta_url": instaUrl,
        "twitter_url": twitterUrl,
        "whatsup_url": whatsupUrl,
      };
}
