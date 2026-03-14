// To parse this JSON data, do
//
//     final bookingSummaryArgument = bookingSummaryArgumentFromJson(jsonString);

import 'dart:convert';

BookingSummaryArgument bookingSummaryArgumentFromJson(String str) =>
    BookingSummaryArgument.fromJson(json.decode(str));

String bookingSummaryArgumentToJson(BookingSummaryArgument data) =>
    json.encode(data.toJson());

class BookingSummaryArgument {
  String? price;
  String? shopId;
  String? specialistId;
  String? serviceId;
  String? noteText;
  String? image;
  String? date;
  String? time;
  String? bookingStatus;
  int? bookingId;
  String? paymentMethod;

  BookingSummaryArgument({
    this.price,
    this.shopId,
    this.specialistId,
    this.serviceId,
    this.noteText,
    this.image,
    this.date,
    this.time,
    this.bookingStatus,
    this.bookingId,
    this.paymentMethod,
  });

  factory BookingSummaryArgument.fromJson(Map<String, dynamic> json) =>
      BookingSummaryArgument(
        price: json["price"],
        shopId: json["shopId"],
        specialistId: json["specialistId"],
        serviceId: json["serviceId"],
        noteText: json["notetext"],
        image: json["image"],
        date: json["date"],
        time: json["time"],
        bookingStatus: json["bookingStatus"],
        bookingId: json["bookingId"],
        paymentMethod: json["paymentMethod"],
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "shopId": shopId,
        "specialistId": specialistId,
        "serviceId": serviceId,
        "notetext": noteText,
        "image": image,
        "date": date,
        "time": time,
        "bookingStatus": bookingStatus,
        "bookingId": bookingId,
        "paymentMethod": paymentMethod,
      };

  @override
  String toString() {
    return 'BookingSummaryArgument{price: $price, shopId: $shopId, specialistId: $specialistId, serviceId: $serviceId, noteText: $noteText, image: $image, date: $date, time: $time, bookingStatus: $bookingStatus, bookingId: $bookingId, paymentMethod: $paymentMethod}';
  }
}

FilterData filterDataFromJson(String str) =>
    FilterData.fromJson(json.decode(str));

String filterDataToJson(FilterData data) => json.encode(data.toJson());

class FilterData {
  List<String>? serviceId;
  String? startYear;
  String? endYear;
  String? availability;

  FilterData({
    this.startYear,
    this.endYear,
    this.availability,
    this.serviceId,
  });

  factory FilterData.fromJson(Map<String, dynamic> json) => FilterData(
        serviceId: json["serviceId"],
        availability: json["availability"],
        startYear: json["startYear"],
        endYear: json["endYear"],
      );

  Map<String, dynamic> toJson() => {
        "serviceId": serviceId,
        "availability": availability,
        "startYear": startYear,
        "endYear": endYear,
      };

  @override
  String toString() {
    return 'FilterData{serviceId: $serviceId, startYear: $startYear, endYear: $endYear, availability: $availability}';
  }
}
