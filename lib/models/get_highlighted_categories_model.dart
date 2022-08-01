// To parse this JSON data, do
//
//     final getHighlightedCategoriesModel = getHighlightedCategoriesModelFromJson(jsonString);

import 'dart:convert';

GetHighlightedCategoriesModel getHighlightedCategoriesModelFromJson(String str) => GetHighlightedCategoriesModel.fromJson(json.decode(str));

String getHighlightedCategoriesModelToJson(GetHighlightedCategoriesModel data) => json.encode(data.toJson());

class GetHighlightedCategoriesModel {
  GetHighlightedCategoriesModel({
    this.data,
    this.message,
    this.status,
  });

  var data;
  var message;
  var status;

  factory GetHighlightedCategoriesModel.fromJson(Map<String, dynamic> json) => GetHighlightedCategoriesModel(
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
    this.categories,
  });

  var categories;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class Category {
  Category({
    this.id,
    this.productTypeId,
    this.parentId,
    this.name,
    this.slug,
    this.title,
    this.image,
    this.icon,
    this.isHighlight,
    this.showOnMenu,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  var id;
  var productTypeId;
  dynamic parentId;
  var name;
  var slug;
  dynamic title;
  dynamic image;
  dynamic icon;
  var isHighlight;
  var showOnMenu;
  var status;
  var createdBy;
  var updatedBy;
  var createdAt;
  var updatedAt;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    productTypeId: json["product_type_id"],
    parentId: json["parent_id"],
    name: json["name"],
    slug: json["slug"],
    title: json["title"],
    image: json["image"],
    icon: json["icon"],
    isHighlight: json["is_highlight"],
    showOnMenu: json["show_on_menu"],
    status: json["status"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_type_id": productTypeId,
    "parent_id": parentId,
    "name": name,
    "slug": slug,
    "title": title,
    "image": image,
    "icon": icon,
    "is_highlight": isHighlight,
    "show_on_menu": showOnMenu,
    "status": status,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
