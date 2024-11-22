// To parse this JSON data, do
//
//     final cancellledBookingResponse = cancellledBookingResponseFromJson(jsonString);

import 'dart:convert';

CancelledBookingResponse cancelledBookingResponseFromJson(String str) =>
    CancelledBookingResponse.fromJson(json.decode(str));

String cancelledBookingResponseToJson(CancelledBookingResponse data) =>
    json.encode(data.toJson());

class CancelledBookingResponse {
  bool? status;
  String? message;
  Data? data;

  CancelledBookingResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CancelledBookingResponse.fromJson(Map<String, dynamic> json) =>
      CancelledBookingResponse(
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
  List<CancelBooking>? cancelBooking;
  int? upcomingTotalPages;

  Data({
    this.cancelBooking,
    this.upcomingTotalPages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        cancelBooking: json["Cancel_booking"] == null
            ? []
            : List<CancelBooking>.from(
                json["Cancel_booking"]!.map((x) => CancelBooking.fromJson(x))),
        upcomingTotalPages: json["upcoming_total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "Cancel_booking": cancelBooking == null
            ? []
            : List<dynamic>.from(cancelBooking!.map((x) => x.toJson())),
        "upcoming_total_pages": upcomingTotalPages,
      };
}

class CancelBooking {
  int? id;
  String? bookingId;
  DateTime? date;
  String? startTime;
  String? total;
  String? shopImage;
  String? shopName;
  String? shopAddress;

  CancelBooking({
    this.id,
    this.bookingId,
    this.date,
    this.startTime,
    this.total,
    this.shopImage,
    this.shopName,
    this.shopAddress,
  });

  factory CancelBooking.fromJson(Map<String, dynamic> json) => CancelBooking(
        id: json["id"],
        bookingId: json["booking_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        startTime: json["start_time"],
        total: json["total"].toString(),
        shopImage: json["shop_image"].toString(),
        shopName: json["shop_name"].toString(),
        shopAddress: json["shop_address"].toString(),
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
}
