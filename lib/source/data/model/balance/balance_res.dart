import 'dart:convert';

BalanceRes balanceResFromJson(String str) =>
    BalanceRes.fromJson(json.decode(str));

class BalanceRes {
  int? status;
  Customer? customer;
  List<List<dynamic>>? m;
  int? rdc;

  BalanceRes({
    this.status,
    this.customer,
    this.m,
    this.rdc,
  });

  factory BalanceRes.fromJson(Map<String, dynamic> json) => BalanceRes(
        status: json["status"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        m: json["m"] == null
            ? []
            : List<List<dynamic>>.from(
                json["m"]!.map((x) => List<dynamic>.from(x.map((x) => x)))),
        rdc: json["rdc"],
      );
}

class Customer {
  String? firstName;
  String? lastName;
  String? pin;
  String? mobile;
  String? cCode;
  String? busCard;
  String? tftId;
  String? tftTitle;
  String? balance;
  double? discount;
  String? discountType;
  String? gender;

  Customer(
      {this.firstName,
      this.lastName,
      this.pin,
      this.mobile,
      this.cCode,
      this.busCard,
      this.tftId,
      this.tftTitle,
      this.balance,
      this.discount,
      this.discountType,
      this.gender});

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        firstName: json["first_name"],
        lastName: json["last_name"],
        pin: json["pin"],
        mobile: json["mobile"],
        cCode: json["cCode"],
        busCard: json["bus_card"],
        tftId: json["tftID"],
        tftTitle: json["tftTitle"],
        balance: json["balance"] ?? "0.0",
        discount: (double.tryParse(json["discount"].toString())) ?? 0.0,
        discountType: json["discount_type"].toString(),
        gender: json["gender"].toString(),
      );
}
