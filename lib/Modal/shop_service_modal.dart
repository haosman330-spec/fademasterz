// To parse this JSON data, do
//
//     final shopServiceResponse = shopServiceResponseFromJson(jsonString);

import 'dart:convert';

ShopServiceResponse shopServiceResponseFromJson(String str) =>
    ShopServiceResponse.fromJson(json.decode(str));

String shopServiceResponseToJson(ShopServiceResponse data) =>
    json.encode(data.toJson());

class ShopServiceResponse {
  bool? status;
  String? message;
  ServiceData? data;

  ShopServiceResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ShopServiceResponse.fromJson(Map<String, dynamic> json) =>
      ShopServiceResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : ServiceData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };

  @override
  String toString() {
    return 'ShopServiceResponse{status: $status, message: $message, data: $data}';
  }
}

class ServiceData {
  List<Service1>? services;
  int? totalPages;

  ServiceData({
    this.services,
    this.totalPages,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) => ServiceData(
        services: json["services"] == null
            ? []
            : List<Service1>.from(
                json["services"]!.map((x) => Service1.fromJson(x))),
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
        "total_pages": totalPages,
      };

  @override
  String toString() {
    return 'ServiceData{services: $services, totalPages: $totalPages}';
  }
}

class Service1 {
  int? id;
  String? name;
  String? price;
  String? duration;
  bool? selected;

  Service1({this.id, this.name, this.duration, this.price, this.selected});

  factory Service1.fromJson(Map<String, dynamic> json) => Service1(
        id: json["id"],
        name: json["name"],
        duration: json["duration"],
        price: json["price"].toString(),
        selected: json["selected"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "duration": duration,
        "price": price,
        "selected": selected,
      };

  @override
  String toString() {
    return 'Service1{id: $id, name: $name, duration: $duration, price: $price, selected: $selected}';
  }
}
