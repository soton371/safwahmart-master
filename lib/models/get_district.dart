import 'dart:convert';

GetDistrictList getDistrictListFromJson(String str) => GetDistrictList.fromJson(json.decode(str));

String getDistrictListToJson(GetDistrictList data) => json.encode(data.toJson());

class GetDistrictList {
  GetDistrictList({
    required this.data,
    this.message,
    this.status,
  });

  Data data;
  var message;
  var status;

  factory GetDistrictList.fromJson(Map<String, dynamic> json) => GetDistrictList(
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
    required this.districts,
  });

  List<District> districts;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    districts: List<District>.from(json["districts"].map((x) => District.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "districts": List<dynamic>.from(districts.map((x) => x.toJson())),
  };
}

class District {
  District({
    this.id,
    this.name,
    this.shippingCost,
    this.status,
  });

  var id;
  var name;
  var shippingCost;
  var status;

  factory District.fromJson(Map<String, dynamic> json) => District(
    id: json["id"],
    name: json["name"],
    shippingCost: json["shipping_cost"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "shipping_cost": shippingCost,
    "status": status,
  };
}
