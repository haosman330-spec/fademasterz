// To parse this JSON data, do
//
//     final bookingDetailResponse = bookingDetailResponseFromJson(jsonString);

import 'dart:convert';

BookingDetailResponse bookingDetailResponseFromJson(String str) =>
    BookingDetailResponse.fromJson(json.decode(str));

String bookingDetailResponseToJson(BookingDetailResponse data) =>
    json.encode(data.toJson());

class BookingDetailResponse {
  bool? status;
  String? message;
  BookingDetailData? data;

  BookingDetailResponse({
    this.status,
    this.message,
    this.data,
  });

  factory BookingDetailResponse.fromJson(Map<String, dynamic> json) =>
      BookingDetailResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : BookingDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class BookingDetailData {
  int? id;
  String? bookingId;
  int? shopId;
  DateTime? date;
  String? startTime;
  String? specialistId;
  String? subTotal;
  String? tax;
  String? total;
  String? bookingStatus;
  String? serviceIds;
  String? desired_look;
  String? note;
  String? shopImage;
  String? shopName;
  String? shopAddress;
  String? specialistName;
  List<Service>? services;

  BookingDetailData({
    this.id,
    this.bookingId,
    this.shopId,
    this.date,
    this.startTime,
    this.specialistId,
    this.subTotal,
    this.tax,
    this.total,
    this.bookingStatus,
    this.serviceIds,
    this.desired_look,
    this.note,
    this.shopImage,
    this.shopName,
    this.shopAddress,
    this.specialistName,
    this.services,
  });

  factory BookingDetailData.fromJson(Map<String, dynamic> json) =>
      BookingDetailData(
        id: json["id"],
        bookingId: json["booking_id"],
        shopId: json["shop_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        startTime: json["start_time"],
        specialistId: json["specialist_id"].toString(),
        subTotal: json["sub_total"].toString(),
        tax: json["tax"].toString(),
        total: json["total"].toString(),
        bookingStatus: json["booking_status"],
        serviceIds: json["service_ids"],
        desired_look: json["desired_look"],
        note: json["note"],
        shopImage: json["shop_image"],
        shopName: json["shop_name"],
        shopAddress: json["shop_address"],
        specialistName: json["specialist_name"],
        services: json["services"] == null
            ? []
            : List<Service>.from(
                json["services"]!.map((x) => Service.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_id": bookingId,
        "shop_id": shopId,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "specialist_id": specialistId,
        "sub_total": subTotal,
        "tax": tax,
        "total": total,
        "booking_status": bookingStatus,
        "service_ids": serviceIds,
        "desired_look": desired_look,
        "note": note,
        "shop_image": shopImage,
        "shop_name": shopName,
        "shop_address": shopAddress,
        "specialist_name": specialistName,
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'BookingDetailData{id: $id, bookingId: $bookingId, shopId: $shopId, date: $date, startTime: $startTime, specialistId: $specialistId, subTotal: $subTotal, tax: $tax, total: $total, bookingStatus: $bookingStatus, serviceIds: $serviceIds, shopImage: $shopImage, shopName: $shopName, shopAddress: $shopAddress, specialistName: $specialistName, services: $services}';
  }
}

class Service {
  int? id;
  String? name;
  String? price;

  Service({
    this.id,
    this.name,
    this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
        price: json["price"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
      };

  @override
  String toString() {
    return 'Service{id: $id, name: $name, price: $price}';
  }
}
