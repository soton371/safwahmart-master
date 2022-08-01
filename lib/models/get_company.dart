// To parse this JSON data, do
//
//     final getCompany = getCompanyFromJson(jsonString);

import 'dart:convert';

GetCompany getCompanyFromJson(String str) => GetCompany.fromJson(json.decode(str));

String getCompanyToJson(GetCompany data) => json.encode(data.toJson());

class GetCompany {
  GetCompany({
    required this.data,
    this.message,
    this.status,
  });

  Data data;
  dynamic message;
  dynamic status;

  factory GetCompany.fromJson(Map<String, dynamic> json) => GetCompany(
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
    required this.company,
  });

  Company company;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    company: Company.fromJson(json["company"]),
  );

  Map<String, dynamic> toJson() => {
    "company": company.toJson(),
  };
}

class Company {
  Company({
    this.id,
    this.name,
    this.title,
    this.phone,
    this.hotline,
    this.email,
    this.address,
    this.logo,
    this.faviconIcon,
    this.googleMapEmbedCode,
    this.website,
    this.bin,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic name;
  dynamic title;
  dynamic phone;
  dynamic hotline;
  dynamic email;
  dynamic address;
  dynamic logo;
  dynamic faviconIcon;
  dynamic googleMapEmbedCode;
  dynamic website;
  dynamic bin;
  dynamic createdAt;
  dynamic updatedAt;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    name: json["name"],
    title: json["title"],
    phone: json["phone"],
    hotline: json["hotline"],
    email: json["email"],
    address: json["address"],
    logo: json["logo"],
    faviconIcon: json["favicon_icon"],
    googleMapEmbedCode: json["google_map_embed_code"],
    website: json["website"],
    bin: json["bin"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "title": title,
    "phone": phone,
    "hotline": hotline,
    "email": email,
    "address": address,
    "logo": logo,
    "favicon_icon": faviconIcon,
    "google_map_embed_code": googleMapEmbedCode,
    "website": website,
    "bin": bin,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
