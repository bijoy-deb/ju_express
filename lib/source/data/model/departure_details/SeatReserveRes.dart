import 'dart:convert';

SeatReserveRes seatSeatReserveResFromJson(String str) =>
    SeatReserveRes.fromJson(json.decode(str));

class SeatReserveRes {
  SeatReserveRes({
    required this.status,
    this.vuHash,
    this.m,
  });

  int status;
  String? vuHash;
  List<List<String>>? m;

  factory SeatReserveRes.fromJson(Map<String, dynamic> json) => SeatReserveRes(
        status: json["status"],
        vuHash: json["vuHash"],
        m: json["m"] == null
            ? null
            : List<List<String>>.from(
                json["m"].map((x) => List<String>.from(x.map((x) => x)))),
      );
}
