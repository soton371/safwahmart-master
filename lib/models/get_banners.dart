import 'dart:convert';

GetBannersModel getBannersModelFromJson(String str) => GetBannersModel.fromJson(json.decode(str));

String getBannersModelToJson(GetBannersModel data) => json.encode(data.toJson());

class GetBannersModel {
  GetBannersModel({
    this.data,
    this.message,
    this.status,
  });

  dynamic data;
  dynamic message;
  dynamic status;

  factory GetBannersModel.fromJson(Map<String, dynamic> json) => GetBannersModel(
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
    this.banners,
  });

  dynamic banners;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    banners: List<Banner>.from(json["banners"].map((x) => Banner.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "banners": List<dynamic>.from(banners.map((x) => x.toJson())),
  };
}

class Banner {
  Banner({
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

  dynamic id;
  dynamic name;
  dynamic slug;
  dynamic image;
  dynamic status;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic createdAt;
  dynamic updatedAt;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
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
