// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

GetAreaList getAreaListFromJson(String str) => GetAreaList.fromJson(json.decode(str));

String getAreaListToJson(GetAreaList data) => json.encode(data.toJson());

class GetAreaList {
  GetAreaList({
    required this.data,
    this.message,
    this.status,
  });

  Data data;
  var message;
  var status;

  factory GetAreaList.fromJson(Map<String, dynamic> json) => GetAreaList(
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
    required this.areas,
  });

  List<Area> areas;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    areas: List<Area>.from(json["areas"].map((x) => Area.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "areas": List<dynamic>.from(areas.map((x) => x.toJson())),
  };
}

class Area {
  Area({
    this.id,
    this.districtId,
    this.name,
    this.status,
  });

  var id;
  var districtId;
  var name;
  var status;

  factory Area.fromJson(Map<String, dynamic> json) => Area(
    id: json["id"],
    districtId: json["district_id"],
    name: json["name"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "district_id": districtId,
    "name": name,
    "status": status,
  };
}
