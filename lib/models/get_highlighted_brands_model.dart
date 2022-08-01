// To parse this JSON data, do
//
//     final getHighlightedBrandsModel = getHighlightedBrandsModelFromJson(jsonString);

import 'dart:convert';

GetHighlightedBrandsModel getHighlightedBrandsModelFromJson(String str) => GetHighlightedBrandsModel.fromJson(json.decode(str));

String getHighlightedBrandsModelToJson(GetHighlightedBrandsModel data) => json.encode(data.toJson());

class GetHighlightedBrandsModel {
  GetHighlightedBrandsModel({
    this.data,
    this.message,
    this.status,
  });

  var data;
  var message;
  var status;

  factory GetHighlightedBrandsModel.fromJson(Map<String, dynamic> json) => GetHighlightedBrandsModel(
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
    this.brands,
  });

  var brands;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    brands: List<Brand>.from(json["brands"].map((x) => Brand.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "brands": List<dynamic>.from(brands.map((x) => x.toJson())),
  };
}

class Brand {
  Brand({
    this.id,
    this.productTypeId,
    this.name,
    this.slug,
    this.title,
    this.logo,
    this.isHighlight,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  var id;
  var productTypeId;
  var name;
  var slug;
  var title;
  var logo;
  var isHighlight;
  var status;
  var createdBy;
  var updatedBy;
  var createdAt;
  var updatedAt;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"],
    productTypeId: json["product_type_id"],
    name: json["name"],
    slug: json["slug"],
    title: json["title"],
    logo: json["logo"],
    isHighlight: json["is_highlight"],
    status: json["status"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_type_id": productTypeId,
    "name": name,
    "slug": slug,
    "title": title,
    "logo": logo,
    "is_highlight": isHighlight,
    "status": status,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
