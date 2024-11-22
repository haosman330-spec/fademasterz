// To parse this JSON data, do
//
//     final chooseAvailabilityResponse = chooseAvailabilityResponseFromJson(jsonString);

import 'dart:convert';

ChooseAvailabilityResponse chooseAvailabilityResponseFromJson(String str) =>
    ChooseAvailabilityResponse.fromJson(json.decode(str));

String chooseAvailabilityResponseToJson(ChooseAvailabilityResponse data) =>
    json.encode(data.toJson());

class ChooseAvailabilityResponse {
  bool? status;
  String? message;
  ChooseAvailabilityData? data;

  ChooseAvailabilityResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ChooseAvailabilityResponse.fromJson(Map<String, dynamic> json) =>
      ChooseAvailabilityResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : ChooseAvailabilityData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class ChooseAvailabilityData {
  List<AvailableSpecialist>? availableSpecialist;
  List<Slot>? slots;

  ChooseAvailabilityData({
    this.availableSpecialist,
    this.slots,
  });

  factory ChooseAvailabilityData.fromJson(Map<String, dynamic> json) =>
      ChooseAvailabilityData(
        availableSpecialist: json["available_specialist"] == null
            ? []
            : List<AvailableSpecialist>.from(json["available_specialist"]!
                .map((x) => AvailableSpecialist.fromJson(x))),
        slots: json["slots"] == null
            ? []
            : List<Slot>.from(json["slots"]!.map((x) => Slot.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "available_specialist": availableSpecialist == null
            ? []
            : List<dynamic>.from(availableSpecialist!.map((x) => x.toJson())),
        "slots": slots == null
            ? []
            : List<dynamic>.from(slots!.map((x) => x.toJson())),
      };
}

class AvailableSpecialist {
  int? id;
  String? name;
  String? image;

  AvailableSpecialist({
    this.id,
    this.name,
    this.image,
  });

  factory AvailableSpecialist.fromJson(Map<String, dynamic> json) =>
      AvailableSpecialist(
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
    return 'AvailableSpecialist{id: $id, name: $name, image: $image}';
  }
}

class Slot {
  int? id;
  String? time;

  Slot({
    this.id,
    this.time,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        id: json["id"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "time": time,
      };

  @override
  String toString() {
    return 'Slot{id: $id, time: $time}';
  }
}
