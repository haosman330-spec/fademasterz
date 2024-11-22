// To parse this JSON data, do
//
//     final selectDateResponse = selectDateResponseFromJson(jsonString);

import 'dart:convert';

SelectDateResponse selectDateResponseFromJson(String str) =>
    SelectDateResponse.fromJson(json.decode(str));

String selectDateResponseToJson(SelectDateResponse data) =>
    json.encode(data.toJson());

class SelectDateResponse {
  bool? status;
  String? message;
  List<SelectDateData>? data;

  SelectDateResponse({
    this.status,
    this.message,
    this.data,
  });

  factory SelectDateResponse.fromJson(Map<String, dynamic> json) =>
      SelectDateResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<SelectDateData>.from(
                json["data"]!.map((x) => SelectDateData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'SelectDateResponse{status: $status, message: $message, data: $data}';
  }
}

class SelectDateData {
  int? id;
  String? name;
  String? image;

  SelectDateData({
    this.id,
    this.name,
    this.image,
  });

  factory SelectDateData.fromJson(Map<String, dynamic> json) => SelectDateData(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };

  @override
  String toString() {
    return 'SelectDateData{id: $id, name: $name, image: $image}';
  }
}
