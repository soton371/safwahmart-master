// To parse this JSON data, do
//
//     final getSlidersModel = getSlidersModelFromJson(jsonString);

import 'dart:convert';

GetSlidersModel getSlidersModelFromJson(String str) => GetSlidersModel.fromJson(json.decode(str));

String getSlidersModelToJson(GetSlidersModel data) => json.encode(data.toJson());

class GetSlidersModel {
  GetSlidersModel({
    this.data,
    this.message,
    this.status,
  });

  var data;
  var message;
  var status;

  factory GetSlidersModel.fromJson(Map<String, dynamic> json) => GetSlidersModel(
    data: Data.fromJson(json["data"]),
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "message": message,
    "status": status,
  };
}

class Data {
  Data({
    this.sliders,
  });

  var sliders;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    sliders: List<Slider>.from(json["sliders"].map((x) => Slider.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sliders": List<dynamic>.from(sliders.map((x) => x.toJson())),
  };
}

class Slider {
  Slider({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  var id;
  var name;
  var slug;
  var image;
  var status;
  var createdBy;
  var updatedBy;
  var createdAt;
  var updatedAt;

  factory Slider.fromJson(Map<String, dynamic> json) => Slider(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    image: json["image"],
    status: json["status"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "image": image,
    "status": status,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
