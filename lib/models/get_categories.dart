// To parse this JSON data, do
//
//     final getCategories = getCategoriesFromJson(jsonString);

import 'dart:convert';

GetCategories getCategoriesFromJson(String str) => GetCategories.fromJson(json.decode(str));

String getCategoriesToJson(GetCategories data) => json.encode(data.toJson());

class GetCategories {
  GetCategories({
    required this.data,
    required this.message,
    required this.status,
  });

  Data data;
  String message;
  int status;

  factory GetCategories.fromJson(Map<String, dynamic> json) => GetCategories(
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
    required this.categories,
    required this.page,
  });

  Categories categories;
  Page page;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    categories: Categories.fromJson(json["categories"]),
    page: Page.fromJson(json["page"]),
  );

  Map<String, dynamic> toJson() => {
    "categories": categories.toJson(),
    "page": page.toJson(),
  };
}

class Categories {
  Categories({
    this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  dynamic currentPage;
  List<Datum> data;
  dynamic firstPageUrl;
  dynamic from;
  dynamic lastPage;
  dynamic lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  dynamic path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
    currentPage: json["current_page"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class Datum {
  Datum({
    this.id,
    this.productTypeId,
    this.parentId,
    this.name,
    this.slug,
    this.title,
    this.icon,
    this.bannerImage,
    this.image,
    this.isHighlight,
    this.showOnMenu,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.orderLevel,
    this.totalProducts,
    required this.childCategories,
  });

  dynamic id;
  dynamic productTypeId;
  dynamic parentId;
  dynamic name;
  dynamic slug;
  dynamic title;
  dynamic icon;
  dynamic bannerImage;
  dynamic image;
  dynamic isHighlight;
  dynamic showOnMenu;
  dynamic status;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic orderLevel;
  dynamic totalProducts;
  List<ChildCategory> childCategories;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    productTypeId: json["product_type_id"],
    parentId: json["parent_id"] == null ? null : json["parent_id"],
    name: json["name"],
    slug: json["slug"],
    title: json["title"] == null ? null : json["title"],
    icon: json["icon"],
    bannerImage: json["banner_image"],
    image: json["image"] == null ? null : json["image"],
    isHighlight: isDefaultValues.map[json["is_highlight"]],
    showOnMenu: isDefaultValues.map[json["show_on_menu"]],
    status: json["status"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    orderLevel: json["order_level"],
    totalProducts: json["total_products"],
    childCategories: List<ChildCategory>.from(json["child_categories"].map((x) => ChildCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_type_id": productTypeId,
    "parent_id": parentId == null ? null : parentId,
    "name": name,
    "slug": slug,
    "title": title == null ? null : title,
    "icon": icon,
    "banner_image": bannerImage,
    "image": image == null ? null : image,
    "is_highlight": isDefaultValues.reverse[isHighlight],
    "show_on_menu": isDefaultValues.reverse[showOnMenu],
    "status": status,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "order_level": orderLevel,
    "total_products": totalProducts,
    "child_categories": List<dynamic>.from(childCategories.map((x) => x.toJson())),
  };
}

class ChildCategory {
  ChildCategory({
    this.id,
    this.parentId,
    this.name,
    this.productTypeId,
    this.slug,
    required this.childCategories,
  });

  dynamic id;
  dynamic parentId;
  dynamic name;
  dynamic productTypeId;
  dynamic slug;
  List<dynamic> childCategories;

  factory ChildCategory.fromJson(Map<String, dynamic> json) => ChildCategory(
    id: json["id"],
    parentId: json["parent_id"],
    name: json["name"],
    productTypeId: json["product_type_id"],
    slug: json["slug"],
    childCategories: List<dynamic>.from(json["child_categories"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "parent_id": parentId,
    "name": name,
    "product_type_id": productTypeId,
    "slug": slug,
    "child_categories": List<dynamic>.from(childCategories.map((x) => x)),
  };
}

enum IsDefault { NO, YES }

final isDefaultValues = EnumValues({
  "No": IsDefault.NO,
  "Yes": IsDefault.YES
});

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  dynamic url;
  dynamic label;
  dynamic active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"] == null ? null : json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url == null ? null : url,
    "label": label,
    "active": active,
  };
}

class Page {
  Page({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.bannerImage,
    this.image,
    this.seoTitle,
    this.seoDescription,
    this.isDefault,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic name;
  dynamic slug;
  dynamic description;
  dynamic bannerImage;
  dynamic image;
  dynamic seoTitle;
  dynamic seoDescription;
  dynamic isDefault;
  dynamic status;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic createdAt;
  dynamic updatedAt;

  factory Page.fromJson(Map<String, dynamic> json) => Page(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    description: json["description"],
    bannerImage: json["banner_image"],
    image: json["image"],
    seoTitle: json["seo_title"],
    seoDescription: json["seo_description"],
    isDefault: isDefaultValues.map[json["is_default"]],
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
    "description": description,
    "banner_image": bannerImage,
    "image": image,
    "seo_title": seoTitle,
    "seo_description": seoDescription,
    "is_default": isDefaultValues.reverse[isDefault],
    "status": status,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
