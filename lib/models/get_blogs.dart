import 'dart:convert';

GetBlogsModel getBlogsModelFromJson(String str) => GetBlogsModel.fromJson(json.decode(str));

String getBlogsModelToJson(GetBlogsModel data) => json.encode(data.toJson());

class GetBlogsModel {
  GetBlogsModel({
    required this.data,
    this.message,
    this.status,
  });

  Data data;
  var message;
  var status;

  factory GetBlogsModel.fromJson(Map<String, dynamic> json) => GetBlogsModel(
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
    required this.blogs,
  });

  Blogs blogs;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    blogs: Blogs.fromJson(json["blogs"]),
  );

  Map<String, dynamic> toJson() => {
    "blogs": blogs.toJson(),
  };
}

class Blogs {
  Blogs({
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

  var currentPage;
  List<BlogData> data;
  var firstPageUrl;
  var from;
  var lastPage;
  var lastPageUrl;
  List<Link> links;
  var nextPageUrl;
  var path;
  var perPage;
  var prevPageUrl;
  var to;
  var total;

  factory Blogs.fromJson(Map<String, dynamic> json) => Blogs(
    currentPage: json["current_page"],
    data: List<BlogData>.from(json["data"].map((x) => BlogData.fromJson(x))),
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

class BlogData {
  BlogData({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.image,
    this.status,
    this.createdAt
  });

  var id;
  var name;
  var slug;
  var description;
  var image;
  var status;
  var createdAt;

  factory BlogData.fromJson(Map<String, dynamic> json) => BlogData(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    description: json["description"],
    image: json["image"],
    status: json["status"],
    createdAt: json["created_at"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "description": description,
    "image": image,
    "status": status,
    "created_at" : createdAt
  };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  var url;
  var label;
  var active;

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