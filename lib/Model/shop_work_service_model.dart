// To parse this JSON data, do
//
//     final shopWorkServiceModal = shopWorkServiceModalFromJson(jsonString);

import 'dart:convert';

ShopWorkServiceResponse shopWorkServiceResponseFromJson(String str) =>
    ShopWorkServiceResponse.fromJson(json.decode(str));

String shopWorkServiceResponseToJson(ShopWorkServiceResponse data) =>
    json.encode(data.toJson());

class ShopWorkServiceResponse {
  bool? status;
  String? message;
  ShopWorkServiceResponseData? data;

  ShopWorkServiceResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ShopWorkServiceResponse.fromJson(Map<String, dynamic> json) =>
      ShopWorkServiceResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : ShopWorkServiceResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class ShopWorkServiceResponseData {
  int? totalPages;
  List<ShopWorkServiceData>? workServices;

  ShopWorkServiceResponseData({
    this.totalPages,
    this.workServices,
  });

  factory ShopWorkServiceResponseData.fromJson(Map<String, dynamic> json) =>
      ShopWorkServiceResponseData(
        totalPages: json["total_pages"],
        workServices: json["work_services"] == null
            ? []
            : List<ShopWorkServiceData>.from(
                json["work_services"]!.map(
                  (x) => ShopWorkServiceData.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "total_pages": totalPages,
        "work_services": workServices == null
            ? []
            : List<dynamic>.from(workServices!.map((x) => x.toJson())),
      };
}

class ShopWorkServiceData {
  int? id;
  String? name;

  ShopWorkServiceData({
    this.id,
    this.name,
  });

  factory ShopWorkServiceData.fromJson(Map<String, dynamic> json) =>
      ShopWorkServiceData(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  String toString() {
    return 'Datum{id: $id, name: $name}';
  }
}
