import 'dart:convert';

TicketSaleRes ticketSaleResFromJson(String str) =>
    TicketSaleRes.fromJson(json.decode(str));

String ticketSaleResToJson(TicketSaleRes data) => json.encode(data.toJson());

class TicketSaleRes {
  int? status;
  String? vuHash;
  String? payId;
  String? subTotal;
  String? processFee;
  String? serviceCharge;
  String? discountedProcessFee;
  String? discount;
  PaymentMethods? paymentMethods;
  double? payWaitTime;
  String? refId;
  String? total;
  List<List<String>>? m;

  TicketSaleRes({
    this.paymentMethods,
    this.status,
    this.vuHash,
    this.payId,
    this.subTotal,
    this.processFee,
    this.serviceCharge,
    this.discountedProcessFee,
    this.discount,
    this.payWaitTime,
    this.refId,
    this.total,
    this.m,
  });

  factory TicketSaleRes.fromJson(Map<String, dynamic> json) => TicketSaleRes(
        status: json["status"],
        paymentMethods: json["paymentMethods"] == null
            ? null
            : PaymentMethods.fromJson(json["paymentMethods"]),
        vuHash: json["vuHash"],
        payId: json["payID"],
        subTotal: json["subTotal"],
        processFee: json["processFee"],
        serviceCharge: json["serviceCharge"],
        discountedProcessFee: json["discountedProcessFee"],
        discount: json["discount"],
        payWaitTime: double.tryParse(json["payWaitTime"].toString()),
        refId: json["refID"],
        total: json["total"],
        m: json["m"] == null
            ? []
            : List<List<String>>.from(
                json["m"]!.map((x) => List<String>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "paymentMethods": paymentMethods?.toJson(),
        "status": status,
        "vuHash": vuHash,
        "payID": payId,
        "subTotal": subTotal,
        "processFee": processFee,
        "serviceCharge": serviceCharge,
        "discountedProcessFee": discountedProcessFee,
        "discount": discount,
        "payWaitTime": payWaitTime,
        "refID": refId,
        "total": total,
        "m": m == null
            ? []
            : List<dynamic>.from(
                m!.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}

class PaymentMethods {
  int? nmbBank;
  int? crdbBank;
  int? tPesa;
  int? tigoPesa;
  int? mPesa;
  int? airtelMoney;
  int? tigoPesaUSSDPush;
  int? mPesaUSSDPush;

  PaymentMethods(
      {this.nmbBank,
      this.crdbBank,
      this.tPesa,
      this.tigoPesa,
      this.mPesa,
      this.airtelMoney,
      this.mPesaUSSDPush,
      this.tigoPesaUSSDPush});

  factory PaymentMethods.fromJson(Map<String, dynamic> json) => PaymentMethods(
      nmbBank: json["NMBBank"],
      crdbBank: json["CRDBBank"],
      tPesa: json["TPesa"],
      tigoPesa: json["TigoPesa"],
      mPesa: json["MPesa"],
      airtelMoney: json["airtelMoney"],
      tigoPesaUSSDPush: json['TigoPesaUSSDPush'],
      mPesaUSSDPush: json['MPesaUSSDPush']);

  Map<String, dynamic> toJson() => {
        "NMBBank": nmbBank,
        "CRDBBank": crdbBank,
        "TPesa": tPesa,
        "TigoPesa": tigoPesa,
        "MPesa": mPesa,
        "airtelMoney": airtelMoney,
        "TigoPesaUSSDPush": tigoPesaUSSDPush,
        "MPesaUSSDPush": mPesaUSSDPush
      };
}
