// To parse this JSON data, do
//
//     final bookingSummaryResponse = bookingSummaryResponseFromJson(jsonString);

import 'dart:convert';

BookingSummaryResponse bookingSummaryResponseFromJson(String str) =>
    BookingSummaryResponse.fromJson(json.decode(str));

String bookingSummaryResponseToJson(BookingSummaryResponse data) =>
    json.encode(data.toJson());

class BookingSummaryResponse {
  bool? status;
  String? message;
  BookingData? data;

  BookingSummaryResponse({
    this.status,
    this.message,
    this.data,
  });

  factory BookingSummaryResponse.fromJson(Map<String, dynamic> json) =>
      BookingSummaryResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : BookingData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class BookingData {
  int? id;
  String? image;
  String? name;
  String? address;
  DateTime? bookingDate;
  String? bookingTime;
  Specialist? specialist;
  List<Service>? services;
  String? subTotal;
  String? tax;
  String? total;

  BookingData({
    this.id,
    this.image,
    this.name,
    this.address,
    this.bookingDate,
    this.bookingTime,
    this.specialist,
    this.services,
    this.subTotal,
    this.tax,
    this.total,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) => BookingData(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        address: json["address"],
        bookingDate: json["booking_date"] == null
            ? null
            : DateTime.parse(json["booking_date"]),
        bookingTime: json["booking_time"],
        specialist: json["specialist"] == null
            ? null
            : Specialist.fromJson(json["specialist"]),
        services: json["services"] == null
            ? []
            : List<Service>.from(
                json["services"]!.map((x) => Service.fromJson(x))),
        subTotal: json["sub_total"],
        tax: json["tax"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "address": address,
        "booking_date":
            "${bookingDate!.year.toString().padLeft(4, '0')}-${bookingDate!.month.toString().padLeft(2, '0')}-${bookingDate!.day.toString().padLeft(2, '0')}",
        "booking_time": bookingTime,
        "specialist": specialist?.toJson(),
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
        "sub_total": subTotal,
        "tax": tax,
        "total": total,
      };

  @override
  String toString() {
    return 'Data{id: $id, image: $image, name: $name, address: $address, bookingDate: $bookingDate, bookingTime: $bookingTime, specialist: $specialist, services: $services, subTotal: $subTotal, tax: $tax, total: $total}';
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

class Specialist {
  int? id;
  String? name;

  Specialist({
    this.id,
    this.name,
  });

  factory Specialist.fromJson(Map<String, dynamic> json) => Specialist(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  String toString() {
    return 'Specialist{id: $id, name: $name}';
  }
}
