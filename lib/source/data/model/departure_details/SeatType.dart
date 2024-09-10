// To parse this JSON data, do
//
//     final seatType = seatTypeFromJson(jsonString);

import 'dart:convert';

SeatType seatTypeFromJson(String str) => SeatType.fromJson(json.decode(str));

String seatTypeToJson(SeatType data) => json.encode(data.toJson());

class SeatType {
  SeatType({
    this.t,
    this.n,
    this.sc,
    this.c,
  });

  String? t;
  String? n;
  String? sc;
  String? c;

  factory SeatType.fromJson(Map<String, dynamic> json) => SeatType(
        t: json["t"],
        n: json["n"],
        sc: json["sc"],
        c: json["c"],
      );

  Map<String, dynamic> toJson() => {
        "t": t,
        "n": n,
        "sc": sc,
        "c": c,
      };
}
