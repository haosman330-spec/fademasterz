// To parse this JSON data, do
//
//     final bookingDetailResponse = bookingDetailResponseFromJson(jsonString);

import 'dart:convert';

// To parse this JSON data, do
//
//     final bookingDetailResponse = bookingDetailResponseFromJson(jsonString);

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
  int? specialistId;
  int? subTotal;
  double? tax;
  double? total;
  String? bookingStatus;
  String? serviceIds;
  String? desiredLook;
  String? note;
  String? shopImage;
  String? shopName;
  String? shopAddress;
  String? specialistName;
  List<Service>? services;
  Rating? rating;

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
    this.desiredLook,
    this.note,
    this.shopImage,
    this.shopName,
    this.shopAddress,
    this.specialistName,
    this.services,
    this.rating,
  });

  factory BookingDetailData.fromJson(Map<String, dynamic> json) {
    return BookingDetailData(
      id: json["id"],
      bookingId: json["booking_id"],
      shopId: json["shop_id"],
      date: json["date"] == null ? null : DateTime.parse(json["date"]),
      startTime: json["start_time"],
      specialistId: json["specialist_id"],
      subTotal: json["sub_total"],
      tax: json["tax"]?.toDouble(),
      total: json["total"]?.toDouble(),
      bookingStatus: json["booking_status"],
      serviceIds: json["service_ids"],
      desiredLook: json["desired_look"],
      note: json["note"],
      shopImage: json["shop_image"],
      shopName: json["shop_name"],
      shopAddress: json["shop_address"],
      specialistName: json["specialist_name"],
      services: json["services"] == null
          ? []
          : List<Service>.from(
              json["services"]!.map((x) => Service.fromJson(x))),
      rating: json["rating"] == null || json["rating"].runtimeType == String
          ? null
          : Rating.fromJson(json["rating"]),
    );
  }

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
        "desired_look": desiredLook,
        "note": note,
        "shop_image": shopImage,
        "shop_name": shopName,
        "shop_address": shopAddress,
        "specialist_name": specialistName,
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
        "rating": rating?.toJson(),
      };
}

class Rating {
  int? id;
  int? userId;
  int? shopId;
  int? bookingId;
  double? rating;
  String? comment;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Rating({
    this.id,
    this.userId,
    this.shopId,
    this.bookingId,
    this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        id: json["id"],
        userId: json["user_id"],
        shopId: json["shop_id"],
        bookingId: json["booking_id"],
        rating: json["rating"]?.toDouble(),
        comment: json["comment"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "shop_id": shopId,
        "booking_id": bookingId,
        "rating": rating,
        "comment": comment,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class Service {
  int? id;
  String? name;
  int? price;

  Service({
    this.id,
    this.name,
    this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
      };
}

/*
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
  Rating? rating;

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
    this.rating,
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
        rating: json["rating"] == null ? null : Rating.fromJson(json["rating"]),
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
        "rating": rating?.toJson(),
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

class Rating {
  int? id;
  int? userId;
  int? shopId;
  int? bookingId;
  double? rating;
  String? comment;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Rating({
    this.id,
    this.userId,
    this.shopId,
    this.bookingId,
    this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        id: json["id"],
        userId: json["user_id"],
        shopId: json["shop_id"],
        bookingId: json["booking_id"],
        rating: json["rating"]?.toDouble(),
        comment: json["comment"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "shop_id": shopId,
        "booking_id": bookingId,
        "rating": rating,
        "comment": comment,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
*/
