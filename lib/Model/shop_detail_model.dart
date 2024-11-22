// To parse this JSON data, do
//
//     final shopDetailModal = shopDetailModalFromJson(jsonString);

import 'dart:convert';

ShopDetailModal shopDetailModalFromJson(String str) =>
    ShopDetailModal.fromJson(json.decode(str));

String shopDetailModalToJson(ShopDetailModal data) =>
    json.encode(data.toJson());

class ShopDetailModal {
  bool? status;
  String? message;
  ShopDetailData? data;

  ShopDetailModal({
    this.status,
    this.message,
    this.data,
  });

  factory ShopDetailModal.fromJson(Map<String, dynamic> json) =>
      ShopDetailModal(
        status: json["status"],
        message: json["message"],
        data:
            json["data"] == null ? null : ShopDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class ShopDetailData {
  int? id;
  String? image;
  String? name;
  String? email;
  String? countryCode;
  String? phone;
  String? status;
  String? address;
  String? lat;
  String? lng;
  String? serviceCategoryIds;
  String? workExperience;
  String? instagramLink;
  String? shopStartTime;
  String? shopEndTime;
  String? role;
  String? mobileVerify;
  String? device;
  String? deviceId;
  String? fcmToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? avgRating;
  int? totalReview;
  String? about;
  List<OurSpecialist>? ourSpecialist;
  List<Service>? services;
  List<Gallery>? gallery;
  List<Review1>? review;

  ShopDetailData({
    this.id,
    this.image,
    this.name,
    this.email,
    this.countryCode,
    this.phone,
    this.status,
    this.address,
    this.lat,
    this.lng,
    this.serviceCategoryIds,
    this.workExperience,
    this.instagramLink,
    this.shopStartTime,
    this.shopEndTime,
    this.role,
    this.mobileVerify,
    this.device,
    this.deviceId,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
    this.avgRating,
    this.totalReview,
    this.about,
    this.ourSpecialist,
    this.services,
    this.gallery,
    this.review,
  });

  factory ShopDetailData.fromJson(Map<String, dynamic> json) => ShopDetailData(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        email: json["email"],
        countryCode: json["country_code"],
        phone: json["phone"],
        status: json["status"],
        address: json["address"],
        lat: json["lat"],
        lng: json["lng"],
        serviceCategoryIds: json["service_category_ids"],
        workExperience: json["work_experience"],
        instagramLink: json["instagram_link"],
        shopStartTime: json["shop_start_time"],
        shopEndTime: json["shop_end_time"],
        role: json["role"],
        mobileVerify: json["mobile_verify"],
        device: json["device"],
        deviceId: json["device_id"],
        fcmToken: json["fcm_token"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        avgRating: json["avg_rating"],
        totalReview: json["total_review"],
        about: json["about"],
        ourSpecialist: json["our_specialist"] == null
            ? []
            : List<OurSpecialist>.from(
                json["our_specialist"]!.map((x) => OurSpecialist.fromJson(x))),
        services: json["services"] == null
            ? []
            : List<Service>.from(
                json["services"]!.map((x) => Service.fromJson(x))),
        gallery: json["gallery"] == null
            ? []
            : List<Gallery>.from(
                json["gallery"]!.map((x) => Gallery.fromJson(x))),
        review: json["review"] == null
            ? []
            : List<Review1>.from(
                json["review"]!.map((x) => Review1.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "email": email,
        "country_code": countryCode,
        "phone": phone,
        "status": status,
        "address": address,
        "lat": lat,
        "lng": lng,
        "service_category_ids": serviceCategoryIds,
        "work_experience": workExperience,
        "instagram_link": instagramLink,
        "shop_start_time": shopStartTime,
        "shop_end_time": shopEndTime,
        "role": role,
        "mobile_verify": mobileVerify,
        "device": device,
        "device_id": deviceId,
        "fcm_token": fcmToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "avg_rating": avgRating,
        "total_review": totalReview,
        "about": about,
        "our_specialist": ourSpecialist == null
            ? []
            : List<dynamic>.from(ourSpecialist!.map((x) => x.toJson())),
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
        "gallery": gallery == null
            ? []
            : List<dynamic>.from(gallery!.map((x) => x.toJson())),
        "review":
            review == null ? [] : List<dynamic>.from(review!.map((x) => x)),
      };

  @override
  String toString() {
    return 'ShopDetailData{id: $id, image: $image, name: $name, email: $email, countryCode: $countryCode, phone: $phone, status: $status, address: $address, lat: $lat, lng: $lng, serviceCategoryIds: $serviceCategoryIds, workExperience: $workExperience, instagramLink: $instagramLink, shopStartTime: $shopStartTime, shopEndTime: $shopEndTime, role: $role, mobileVerify: $mobileVerify, device: $device, deviceId: $deviceId, fcmToken: $fcmToken, createdAt: $createdAt, updatedAt: $updatedAt, avgRating: $avgRating, totalReview: $totalReview, about: $about, ourSpecialist: $ourSpecialist, services: $services, gallery: $gallery, review: $review}';
  }
}

class Gallery {
  int? id;
  String? image;

  Gallery({
    this.id,
    this.image,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
        id: json["id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };
}

class OurSpecialist {
  int? id;
  String? name;
  String? image;

  OurSpecialist({
    this.id,
    this.name,
    this.image,
  });

  factory OurSpecialist.fromJson(Map<String, dynamic> json) => OurSpecialist(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}

class Service {
  int? id;
  String? name;

  Service({
    this.id,
    this.name,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Review1 {
  int? id;
  String? userId;
  String? rating;
  String? comment;
  DateTime? createdAt;
  String? userName;

  Review1({
    this.id,
    this.userId,
    this.rating,
    this.comment,
    this.createdAt,
    this.userName,
  });

  factory Review1.fromJson(Map<String, dynamic> json) => Review1(
        id: json["id"],
        userId: json["user_id"].toString(),
        rating: json["rating"].toString(),
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

  @override
  String toString() {
    return 'Review1{id: $id, userId: $userId, rating: $rating, comment: $comment, createdAt: $createdAt, userName: $userName}';
  }
}
