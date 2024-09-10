import 'dart:convert';

StatusMessageRes statusMsgResFromJson(String str) =>
    StatusMessageRes.fromJson(json.decode(str));

class StatusMessageRes {
  StatusMessageRes({
    this.status,
    this.m,
  });

  int? status;
  List<List<String>>? m;

  factory StatusMessageRes.fromJson(Map<String, dynamic> json) =>
      StatusMessageRes(
        status: json["status"],
        m: json["m"] == null
            ? []
            : List<List<String>>.from(
                json["m"]!.map((x) => List<String>.from(x.map((x) => x)))),
      );
}
