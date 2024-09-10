import 'dart:convert';

import 'package:ju_express/source/data/model/common/district.dart';

FromWiseToRes fromWiseToResFromJson(String str) =>
    FromWiseToRes.fromJson(json.decode(str));

class FromWiseToRes {
  int? status;
  List<District>? districts;
  List<List<String>>? m;

  FromWiseToRes({
    this.status,
    this.districts,
    this.m,
  });

  factory FromWiseToRes.fromJson(Map<String, dynamic> json) => FromWiseToRes(
        status: json["status"],
        districts: json["to"] == null
            ? []
            : List<District>.from(json["to"]!.map((x) => District.fromJson(x))),
        m: json["m"] == null
            ? []
            : List<List<String>>.from(
                json["m"]!.map((x) => List<String>.from(x.map((x) => x)))),
      );
}
