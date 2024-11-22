// To parse this JSON data, do
//
//     final getCategoryResponse = getCategoryResponseFromJson(jsonString);

import 'dart:convert';

GetCategory getCategoryResponseFromJson(String str) =>
    GetCategory.fromJson(json.decode(str));

String getCategoryResponseToJson(GetCategory data) =>
    json.encode(data.toJson());

class GetCategory {
  bool? status;
  String? message;
  List<CategoryDataModel>? data;

  GetCategory({
    this.status,
    this.message,
    this.data,
  });

  factory GetCategory.fromJson(Map<String, dynamic> json) => GetCategory(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<CategoryDataModel>.from(
                json["data"]!.map((x) => CategoryDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<CategoryDataModel>.from(data!.map((x) => x.toJson())),
      };
}

class CategoryDataModel {
  int? id;
  String? name;
  bool? isSelected;

  CategoryDataModel({
    this.id,
    this.name,
    this.isSelected,
  });

  factory CategoryDataModel.fromJson(Map<String, dynamic> json) =>
      CategoryDataModel(
        id: json["id"],
        name: json["name"],
        isSelected: json["isSelected"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isSelected": isSelected,
      };

  @override
  String toString() {
    return 'CategoryDataModel{id: $id, name: $name, isSelected: $isSelected}';
  }
}
