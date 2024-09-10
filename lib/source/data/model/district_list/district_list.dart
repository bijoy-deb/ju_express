import 'dart:convert';

import '../common/district.dart';

DistrictListRes districtListResFromJson(String str) =>
    DistrictListRes.fromJson(json.decode(str));

class DistrictListRes {
  int? status;
  List<District>? districts;
  List<List<String>>? m;

  DistrictListRes({
    this.status,
    this.districts,
    this.m,
  });

  factory DistrictListRes.fromJson(Map<String, dynamic> json) =>
      DistrictListRes(
        status: json["status"],
        districts: json["districts"] == null
            ? []
            : List<District>.from(
                json["districts"]!.map((x) => District.fromJson(x))),
        m: json["m"] == null
            ? []
            : List<List<String>>.from(
                json["m"]!.map((x) => List<String>.from(x.map((x) => x)))),
      );
}
