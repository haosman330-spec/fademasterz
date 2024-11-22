// To parse this JSON data, do
//
//     final selectSpecialistResponse = selectSpecialistResponseFromJson(jsonString);

import 'dart:convert';

SelectSpecialistTimeResponse selectSpecialistResponseFromJson(String str) =>
    SelectSpecialistTimeResponse.fromJson(json.decode(str));

String selectSpecialistResponseToJson(SelectSpecialistTimeResponse data) =>
    json.encode(data.toJson());

class SelectSpecialistTimeResponse {
  bool? status;
  String? message;
  List<SpecialistTimeData>? data;

  SelectSpecialistTimeResponse({
    this.status,
    this.message,
    this.data,
  });

  factory SelectSpecialistTimeResponse.fromJson(Map<String, dynamic> json) =>
      SelectSpecialistTimeResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<SpecialistTimeData>.from(
                json["data"]!.map((x) => SpecialistTimeData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SpecialistTimeData {
  int? id;
  String? time;

  SpecialistTimeData({
    this.id,
    this.time,
  });

  factory SpecialistTimeData.fromJson(Map<String, dynamic> json) =>
      SpecialistTimeData(
        id: json["id"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "time": time,
      };

  @override
  String toString() {
    return 'SpecialistTimeData{id: $id, time: $time}';
  }
}
