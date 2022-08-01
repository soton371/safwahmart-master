// To parse this JSON data, do
//
//     final getBrandsModel = getBrandsModelFromJson(jsonString);

import 'dart:convert';

GetBrandsModel getBrandsModelFromJson(String str) => GetBrandsModel.fromJson(json.decode(str));

String getBrandsModelToJson(GetBrandsModel data) => json.encode(data.toJson());

class GetBrandsModel {
  GetBrandsModel({
    required this.data,
    required this.message,
    required this.status,
  });

  Data data;
  String message;
  int status;

  factory GetBrandsModel.fromJson(Map<String, dynamic> json) => GetBrandsModel(
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
    required this.brands,
    required this.page,
  });

  Brands brands;
  Page page;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    brands: Brands.fromJson(json["brands"]),
    page: Page.fromJson(json["page"]),
  );

  Map<String, dynamic> toJson() => {
    "brands": brands.toJson(),
    "page": page.toJson(),
  };
}

class Brands {
  Brands({
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

  factory Brands.fromJson(Map<String, dynamic> json) => Brands(
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
    this.name,
    this.slug,
    this.title,
    this.logo,
    this.position,
    this.metaTitle,
    this.metaDescription,
    this.isHighlight,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.totalProducts,
  });

  dynamic id;
  dynamic productTypeId;
  dynamic name;
  dynamic slug;
  dynamic title;
  dynamic logo;
  dynamic position;
  dynamic metaTitle;
  dynamic metaDescription;
  dynamic isHighlight;
  dynamic status;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic totalProducts;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    productTypeId: json["product_type_id"],
    name: json["name"],
    slug: json["slug"],
    title: json["title"],
    logo: json["logo"] == null ? null : json["logo"],
    position: json["position"],
    metaTitle: json["meta_title"],
    metaDescription: json["meta_description"],
    isHighlight: json["is_highlight"] == null ? null : json["is_highlight"],
    status: json["status"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"] == null ? null : json["updated_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    totalProducts: json["total_products"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_type_id": productTypeId,
    "name": name,
    "slug": slug,
    "title": title,
    "logo": logo == null ? null : logo,
    "position": position,
    "meta_title": metaTitle,
    "meta_description": metaDescription,
    "is_highlight": isHighlight == null ? null : isHighlight,
    "status": status,
    "created_by": createdBy,
    "updated_by": updatedBy == null ? null : updatedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "total_products": totalProducts,
  };
}

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
    isDefault: json["is_default"],
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
    "is_default": isDefault,
    "status": status,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
