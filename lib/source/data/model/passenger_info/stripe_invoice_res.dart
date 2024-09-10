// To parse this JSON data, do
//
//     final stripeInvoiceRes = stripeInvoiceResFromJson(jsonString);

import 'dart:convert';

StripeInvoiceRes stripeInvoiceResFromJson(String str) =>
    StripeInvoiceRes.fromJson(json.decode(str));

String stripeInvoiceResToJson(StripeInvoiceRes data) =>
    json.encode(data.toJson());

class StripeInvoiceRes {
  int? status;
  String? link;
  List<List<String>>? m;

  StripeInvoiceRes({
    this.status,
    this.link,
    this.m,
  });

  factory StripeInvoiceRes.fromJson(Map<String, dynamic> json) =>
      StripeInvoiceRes(
        status: json["status"],
        link: json["link"],
        m: json["m"] == null
            ? []
            : List<List<String>>.from(
                json["m"]!.map((x) => List<String>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "link": link,
        "m": m == null
            ? []
            : List<dynamic>.from(
                m!.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}
