// To parse this JSON data, do
//
//     final notificationResponseModal = notificationResponseModalFromJson(jsonString);

import 'dart:convert';

NotificationResponseModal notificationResponseModalFromJson(String str) =>
    NotificationResponseModal.fromJson(json.decode(str));

String notificationResponseModalToJson(NotificationResponseModal data) =>
    json.encode(data.toJson());

class NotificationResponseModal {
  bool? status;
  String? message;
  Data? data;

  NotificationResponseModal({
    this.status,
    this.message,
    this.data,
  });

  factory NotificationResponseModal.fromJson(Map<String, dynamic> json) =>
      NotificationResponseModal(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  List<ListElement>? list;
  int? totalPage;

  Data({
    this.list,
    this.totalPage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: json["list"] == null
            ? []
            : List<ListElement>.from(
                json["list"]!.map((x) => ListElement.fromJson(x))),
        totalPage: json["total_page"],
      );

  Map<String, dynamic> toJson() => {
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
        "total_page": totalPage,
      };
}

class ListElement {
  int? id;
  String? title;
  String? description;
  int? bookingId;
  int? userId;
  String? type;
  int? ownerId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  ListElement({
    this.id,
    this.title,
    this.description,
    this.bookingId,
    this.userId,
    this.type,
    this.ownerId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        bookingId: json["booking_id"],
        userId: json["user_id"],
        type: json["type"],
        ownerId: json["owner_id"],
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
        "title": title,
        "description": description,
        "booking_id": bookingId,
        "user_id": userId,
        "type": type,
        "owner_id": ownerId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };

  @override
  String toString() {
    return 'ListElement{id: $id, title: $title, description: $description, bookingId: $bookingId, userId: $userId, type: $type, ownerId: $ownerId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt}';
  }
}
