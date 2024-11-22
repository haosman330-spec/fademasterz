// To parse this JSON data, do
//
//     final profileModal = profileModalFromJson(jsonString);

import 'dart:convert';

ProfileModal profileModalFromJson(String str) =>
    ProfileModal.fromJson(json.decode(str));

String profileModalToJson(ProfileModal data) => json.encode(data.toJson());

ProfileUserData profileUserDataFromJson(String str) =>
    ProfileUserData.fromJson(json.decode(str));

String profileUserDataToJson(ProfileUserData data) =>
    json.encode(data.toJson());

class ProfileModal {
  bool? status;
  String? message;
  ProfileUserData? data;

  ProfileModal({
    this.status,
    this.message,
    this.data,
  });

  factory ProfileModal.fromJson(Map<String, dynamic> json) => ProfileModal(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : ProfileUserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };

  @override
  String toString() {
    return 'ProfileModal{status: $status, message: $message, data: $data}';
  }
}

class ProfileUserData {
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

  ProfileUserData({
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

  factory ProfileUserData.fromJson(Map<String, dynamic> json) =>
      ProfileUserData(
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
    return 'ProfileUserData{id: $id, image: $image, name: $name, email: $email, countryCode: $countryCode, phone: $phone, status: $status, address: $address, lat: $lat, lng: $lng, serviceCategoryIds: $serviceCategoryIds, workExperience: $workExperience, instagramLink: $instagramLink, shopStartTime: $shopStartTime, shopEndTime: $shopEndTime, note: $note, role: $role, mobileVerify: $mobileVerify, device: $device, deviceId: $deviceId, fcmToken: $fcmToken, createdAt: $createdAt, updatedAt: $updatedAt, token: $token}';
  }

  ProfileUserData copyWith({
    int? id,
    String? image,
    String? name,
    String? email,
    String? countryCode,
    String? phone,
    String? status,
    String? address,
    String? lat,
    String? lng,
    String? serviceCategoryIds,
    String? workExperience,
    String? instagramLink,
    String? shopStartTime,
    String? shopEndTime,
    String? note,
    String? role,
    String? mobileVerify,
    String? device,
    String? deviceId,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? token,
  }) {
    return ProfileUserData(
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
      email: email ?? this.email,
      countryCode: countryCode ?? this.countryCode,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      serviceCategoryIds: serviceCategoryIds ?? this.serviceCategoryIds,
      workExperience: workExperience ?? this.workExperience,
      instagramLink: instagramLink ?? this.instagramLink,
      shopStartTime: shopStartTime ?? this.shopStartTime,
      shopEndTime: shopEndTime ?? this.shopEndTime,
      note: note ?? this.note,
      role: role ?? this.role,
      mobileVerify: mobileVerify ?? this.mobileVerify,
      device: device ?? this.device,
      deviceId: deviceId ?? this.deviceId,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      token: token ?? this.token,
    );
  }
}
