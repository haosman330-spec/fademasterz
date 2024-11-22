// To parse this JSON data, do
//
//     final verifyOtpModal = verifyOtpModalFromJson(jsonString);

import 'dart:convert';

VerifyOtpModal verifyOtpModalFromJson(String str) =>
    VerifyOtpModal.fromJson(json.decode(str));

String verifyOtpModalToJson(VerifyOtpModal data) => json.encode(data.toJson());

class VerifyOtpModal {
  bool? status;
  String? message;
  Data? data;

  VerifyOtpModal({
    this.status,
    this.message,
    this.data,
  });

  factory VerifyOtpModal.fromJson(Map<String, dynamic> json) => VerifyOtpModal(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };

  @override
  String toString() {
    return 'VerifyOtpModal{status: $status, message: $message, data: $data}';
  }
}

class Data {
  UserDetail? userDetail;
  String? isSetup;

  Data({
    this.userDetail,
    this.isSetup,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userDetail: json["user_detail"] == null
            ? null
            : UserDetail.fromJson(json["user_detail"]),
        isSetup: json["is_setup"],
      );

  Map<String, dynamic> toJson() => {
        "user_detail": userDetail?.toJson(),
        "is_setup": isSetup,
      };

  @override
  String toString() {
    return 'Data{userDetail: $userDetail, isSetup: $isSetup}';
  }
}

class UserDetail {
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
  String? note;
  String? role;
  String? mobileVerify;
  String? device;
  String? deviceId;
  String? fcmToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? token;

  UserDetail({
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
    this.note,
    this.role,
    this.mobileVerify,
    this.device,
    this.deviceId,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
    this.token,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
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
        workExperience: json["work_experience"].toString(),
        instagramLink: json["instagram_link"],
        shopStartTime: json["shop_start_time"],
        shopEndTime: json["shop_end_time"],
        note: json["note"],
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
        token: json["token"],
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
        "note": note,
        "role": role,
        "mobile_verify": mobileVerify,
        "device": device,
        "device_id": deviceId,
        "fcm_token": fcmToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "token": token,
      };

  @override
  String toString() {
    return 'UserDetail{id: $id, image: $image, name: $name, email: $email, countryCode: $countryCode, phone: $phone, status: $status, address: $address, lat: $lat, lng: $lng, serviceCategoryIds: $serviceCategoryIds, workExperience: $workExperience, instagramLink: $instagramLink, shopStartTime: $shopStartTime, shopEndTime: $shopEndTime, note: $note, role: $role, mobileVerify: $mobileVerify, device: $device, deviceId: $deviceId, fcmToken: $fcmToken, createdAt: $createdAt, updatedAt: $updatedAt, token: $token}';
  }
}
