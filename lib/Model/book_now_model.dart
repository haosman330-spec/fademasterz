// To parse this JSON data, do
//
//     final bookNowResponse = bookNowResponseFromJson(jsonString);

import 'dart:convert';

BookNowResponse bookNowResponseFromJson(String str) =>
    BookNowResponse.fromJson(json.decode(str));

String bookNowResponseToJson(BookNowResponse data) =>
    json.encode(data.toJson());

class BookNowResponse {
  bool? status;
  String? message;
  BookNowData? data;

  BookNowResponse({
    this.status,
    this.message,
    this.data,
  });

  factory BookNowResponse.fromJson(Map<String, dynamic> json) =>
      BookNowResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : BookNowData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class BookNowData {
  String? url;

  BookNowData({
    this.url,
  });

  factory BookNowData.fromJson(Map<String, dynamic> json) => BookNowData(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}
