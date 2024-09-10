import 'dart:convert';

CouponCodeRes couponCodeResFromJson(String str) =>
    CouponCodeRes.fromJson(json.decode(str));

class CouponCodeRes {
  int? status;
  String? discountType;
  String? discount;
  String? maxDiscount;
  List<List<String>>? m;

  CouponCodeRes({
    this.status,
    this.discountType,
    this.discount,
    this.maxDiscount,
    this.m,
  });

  factory CouponCodeRes.fromJson(Map<String, dynamic> json) => CouponCodeRes(
        status: json["status"],
        discountType: json["discountType"].toString(),
        discount: json["discount"].toString(),
        maxDiscount: json["maxDiscount"].toString(),
        m: json["m"] == null
            ? null
            : List<List<String>>.from(
                json["m"].map((x) => List<String>.from(x.map((x) => x))),
              ),
      );
}
