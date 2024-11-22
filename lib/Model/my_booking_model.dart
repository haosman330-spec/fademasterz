// To parse this JSON data, do
//
//     final bookingDetailResponse = bookingDetailResponseFromJson(jsonString);

import 'dart:convert';

MyBookingResponse bookingDetailResponseFromJson(String str) =>
    MyBookingResponse.fromJson(json.decode(str));

String bookingDetailResponseToJson(MyBookingResponse data) =>
    json.encode(data.toJson());

class MyBookingResponse {
  bool? status;
  String? message;
  MyBookingData? data;

  MyBookingResponse({
    this.status,
    this.message,
    this.data,
  });

  factory MyBookingResponse.fromJson(Map<String, dynamic> json) =>
      MyBookingResponse(
        status: json["status"],
        message: json["message"],
        data:
            json["data"] == null ? null : MyBookingData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class MyBookingData {
  List<UpComing>? upcoming;
  int? upcomingTotalPages;
  List<Completed>? completed;
  int? completedTotalPages;

  MyBookingData({
    this.upcoming,
    this.upcomingTotalPages,
    this.completed,
    this.completedTotalPages,
  });

  factory MyBookingData.fromJson(Map<String, dynamic> json) => MyBookingData(
        upcoming: json["Upcoming"] == null
            ? []
            : List<UpComing>.from(
                json["Upcoming"]!.map((x) => UpComing.fromJson(x))),
        upcomingTotalPages: json["upcoming_total_pages"],
        completed: json["Completed"] == null
            ? []
            : List<Completed>.from(
                json["Completed"]!.map((x) => Completed.fromJson(x))),
        completedTotalPages: json["completed_total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "Upcoming": upcoming == null
            ? []
            : List<dynamic>.from(upcoming!.map((x) => x.toJson())),
        "upcoming_total_pages": upcomingTotalPages,
        "Completed": completed == null
            ? []
            : List<dynamic>.from(completed!.map((x) => x.toJson())),
        "completed_total_pages": completedTotalPages,
      };
}

class Completed {
  int? id;
  String? bookingId;
  DateTime? date;
  String? startTime;
  String? total;
  String? shopImage;
  String? shopName;
  String? shopAddress;

  Completed({
    this.id,
    this.bookingId,
    this.date,
    this.startTime,
    this.total,
    this.shopImage,
    this.shopName,
    this.shopAddress,
  });

  factory Completed.fromJson(Map<String, dynamic> json) => Completed(
        id: json["id"],
        bookingId: json["booking_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        startTime: json["start_time"],
        total: json["total"].toString(),
        shopImage: json["shop_image"],
        shopName: json["shop_name"],
        shopAddress: json["shop_address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_id": bookingId,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "total": total,
        "shop_image": shopImage,
        "shop_name": shopName,
        "shop_address": shopAddress,
      };

  @override
  String toString() {
    return 'Completed{id: $id, bookingId: $bookingId, date: $date, startTime: $startTime, total: $total, shopImage: $shopImage, shopName: $shopName, shopAddress: $shopAddress}';
  }
}

class UpComing {
  int? id;
  String? bookingId;
  DateTime? date;
  String? startTime;
  String? total;
  String? shopImage;
  String? shopName;
  String? shopAddress;

  UpComing({
    this.id,
    this.bookingId,
    this.date,
    this.startTime,
    this.total,
    this.shopImage,
    this.shopName,
    this.shopAddress,
  });

  factory UpComing.fromJson(Map<String, dynamic> json) => UpComing(
        id: json["id"],
        bookingId: json["booking_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        startTime: json["start_time"],
        total: json["total"].toString(),
        shopImage: json["shop_image"],
        shopName: json["shop_name"],
        shopAddress: json["shop_address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_id": bookingId,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "total": total,
        "shop_image": shopImage,
        "shop_name": shopName,
        "shop_address": shopAddress,
      };

  @override
  String toString() {
    return 'Completed{id: $id, bookingId: $bookingId, date: $date, startTime: $startTime, total: $total, shopImage: $shopImage, shopName: $shopName, shopAddress: $shopAddress}';
  }
}
