import 'dart:convert';

SaleHistoryResponseModel saleHistoryResponseModelFromJson(String str) =>
    SaleHistoryResponseModel.fromJson(json.decode(str));

class SaleHistoryResponseModel {
  int? status;
  List<Sale>? sale;
  List<List<dynamic>>? m;

  SaleHistoryResponseModel({
    this.status,
    this.sale,
    this.m,
  });

  factory SaleHistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      SaleHistoryResponseModel(
        status: json["status"],
        sale: json["sale"] == null
            ? []
            : List<Sale>.from(json["sale"]!.map((x) => Sale.fromJson(x))),
        m: json["m"] == null
            ? []
            : List<List<dynamic>>.from(json["m"]!.map((x) => x)),
      );
}

class Sale {
  String? coach;
  dynamic fleets;
  String? seat;
  String? dropping;
  String? boarding;
  String? date;
  String? time;
  String? rut;
  String? subrut;
  String? subrutTitle;
  String? pnr;
  dynamic type;
  String? subtotal;
  String? discount;
  int? gender;
  String? currencySymbol;
  String? total;

  Sale({
    this.coach,
    this.fleets,
    this.seat,
    this.dropping,
    this.boarding,
    this.date,
    this.time,
    this.rut,
    this.subrut,
    this.subrutTitle,
    this.pnr,
    this.type,
    this.subtotal,
    this.discount,
    this.gender,
    this.currencySymbol,
    this.total,
  });

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
        coach: json["coach"],
        fleets: json["fleets"],
        seat: json["seat"],
        dropping: json["dropping"],
        boarding: json["boarding"],
        date: json["date"],
        time: json["time"],
        rut: json["route"],
        subrut: json["subRoute"],
        subrutTitle: json["subRouteTitle"],
        pnr: json["pnr"],
        type: json["type"],
        subtotal: json["subtotal"],
        discount: json["discount"],
        gender: json["gender"],
        currencySymbol: json["currencySymbol"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "coach": coach,
        "fleets": fleets,
        "seat": seat,
        "dropping": dropping,
        "boarding": boarding,
        "date": date,
        "time": time,
        "rut": rut,
        "subrut": subrut,
        "subrutTitle": subrutTitle,
        "pnr": pnr,
        "type": type,
        "subtotal": subtotal,
        "discount": discount,
        "gender": gender,
        "currencySymbol": currencySymbol,
        "total": total,
      };
}
