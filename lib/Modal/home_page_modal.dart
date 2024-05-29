// To parse this JSON data, do
//
//     final homePageModal = homePageModalFromJson(jsonString);

import 'dart:convert';

HomePageModal homePageModalFromJson(String str) =>
    HomePageModal.fromJson(json.decode(str));

String homePageModalToJson(HomePageModal data) => json.encode(data.toJson());

class HomePageModal {
  bool? status;
  String? message;
  HomeData? data;

  HomePageModal({
    this.status,
    this.message,
    this.data,
  });

  factory HomePageModal.fromJson(Map<String, dynamic> json) => HomePageModal(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : HomeData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };

  @override
  String toString() {
    return 'HomePageModal{status: $status, message: $message, data: $data}';
  }
}

class HomeData {
  UserDetail? userDetail;
  List<Shop>? shops;
  int? totalPages;
  int? totalShops;

  HomeData({
    this.userDetail,
    this.shops,
    this.totalPages,
    this.totalShops,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        userDetail: json["user_detail"] == null
            ? null
            : UserDetail.fromJson(json["user_detail"]),
        shops: json["shops"] == null
            ? []
            : List<Shop>.from(json["shops"]!.map((x) => Shop.fromJson(x))),
        totalPages: json["total_pages"],
        totalShops: json["total_shops"],
      );

  Map<String, dynamic> toJson() => {
        "user_detail": userDetail?.toJson(),
        "shops": shops == null
            ? []
            : List<dynamic>.from(shops!.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_shops": totalShops,
      };
}

class Shop {
  int? id;
  String? name;
  String? image;
  String? address;
  String? lat;
  String? lng;
  String? status;
  String? distance;
  String? avgRating;

  Shop({
    this.id,
    this.name,
    this.image,
    this.address,
    this.lat,
    this.lng,
    this.status,
    this.distance,
    this.avgRating,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        address: json["address"],
        lat: json["lat"],
        lng: json["lng"],
        status: json["status"],
        distance: json["distance"],
        avgRating: json["avg_rating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "address": address,
        "lat": lat,
        "lng": lng,
        "status": status,
        "distance": distance,
        "avg_rating": avgRating,
      };

  @override
  String toString() {
    return 'Shop{id: $id, name: $name, image: $image, address: $address, lat: $lat, lng: $lng, status: $status, distance: $distance, avgRating: $avgRating}';
  }
}

class UserDetail {
  String? name;
  String? image;

  UserDetail({
    this.name,
    this.image,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
      };
}
