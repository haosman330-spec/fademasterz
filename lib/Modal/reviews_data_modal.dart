// To parse this JSON data, do
//
//     final reviewsResponseModol = reviewsResponseModolFromJson(jsonString);

import 'dart:convert';

ReviewsResponseModal reviewsResponseModalFromJson(String str) =>
    ReviewsResponseModal.fromJson(json.decode(str));

String reviewsResponseModalToJson(ReviewsResponseModal data) =>
    json.encode(data.toJson());

class ReviewsResponseModal {
  bool? status;
  String? message;
  Data? data;

  ReviewsResponseModal({
    this.status,
    this.message,
    this.data,
  });

  factory ReviewsResponseModal.fromJson(Map<String, dynamic> json) =>
      ReviewsResponseModal(
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
  List<Review>? reviews;
  int? totalPages;

  Data({
    this.reviews,
    this.totalPages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        reviews: json["reviews"] == null
            ? []
            : List<Review>.from(
                json["reviews"]!.map((x) => Review.fromJson(x))),
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "reviews": reviews == null
            ? []
            : List<dynamic>.from(reviews!.map((x) => x.toJson())),
        "total_pages": totalPages,
      };
}

class Review {
  int? id;
  int? userId;
  double? rating;
  String? comment;
  DateTime? createdAt;
  String? userName;

  Review({
    this.id,
    this.userId,
    this.rating,
    this.comment,
    this.createdAt,
    this.userName,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        userId: json["user_id"],
        rating: json["rating"]?.toDouble(),
        comment: json["comment"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        userName: json["user_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "rating": rating,
        "comment": comment,
        "created_at": createdAt?.toIso8601String(),
        "user_name": userName,
      };
}
