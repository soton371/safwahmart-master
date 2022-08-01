import 'dart:convert';

GetProfileModel getProfileModelFromJson(String str) => GetProfileModel.fromJson(json.decode(str));

String getProfileModelToJson(GetProfileModel data) => json.encode(data.toJson());

class GetProfileModel {
  GetProfileModel({
    required this.data,
    this.message,
    this.status,
  });

  Data data;
  var message;
  var status;

  factory GetProfileModel.fromJson(Map<String, dynamic> json) => GetProfileModel(
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
    required this.profile,
  });

  Profile profile;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    profile: Profile.fromJson(json["profile"]),
  );

  Map<String, dynamic> toJson() => {
    "profile": profile.toJson(),
  };
}

class Profile {
  Profile({
    this.id,
    this.userId,
    this.refferedBy,
    this.warehouseId,
    this.type,
    this.name,
    this.phone,
    this.email,
    this.gender,
    this.country,
    this.address,
    this.city,
    this.zipCode,
    this.isDefault,
    this.openingBalance,
    this.currentBalance,
    this.status,
  });

  var id;
  var userId;
  dynamic refferedBy;
  dynamic warehouseId;
  dynamic type;
  var name;
  var phone;
  dynamic email;
  dynamic gender;
  dynamic country;
  dynamic address;
  dynamic city;
  dynamic zipCode;
  var isDefault;
  var openingBalance;
  var currentBalance;
  var status;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["id"] ?? '',
    userId: json["user_id"] ?? '',
    refferedBy: json["reffered_by"] ?? '',
    warehouseId: json["warehouse_id"] ?? '',
    type: json["type"] ?? '',
    name: json["name"] ?? '',
    phone: json["phone"] ?? '',
    email: json["email"] ?? '',
    gender: json["gender"] ?? '',
    country: json["country"] ?? '',
    address: json["address"] ?? '',
    city: json["city"] ?? '',
    zipCode: json["zip_code"] ?? '',
    isDefault: json["is_default"] ?? '',
    openingBalance: json["opening_balance"] ?? '',
    currentBalance: json["current_balance"] ?? '',
    status: json["status"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "reffered_by": refferedBy,
    "warehouse_id": warehouseId,
    "type": type,
    "name": name,
    "phone": phone,
    "email": email,
    "gender": gender,
    "country": country,
    "address": address,
    "city": city,
    "zip_code": zipCode,
    "is_default": isDefault,
    "opening_balance": openingBalance,
    "current_balance": currentBalance,
    "status": status,
  };
}
