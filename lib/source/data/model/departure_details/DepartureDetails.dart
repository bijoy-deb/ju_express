// To parse this JSON data, do
//
//     final departureDetails = departureDetailsFromJson(jsonString);

import 'dart:convert';

import '../departure_list/departure_list.dart';

DepartureDetails departureDetailsFromJson(String str) =>
    DepartureDetails.fromJson(json.decode(str));

String departureDetailsToJson(DepartureDetails data) =>
    json.encode(data.toJson());

class DepartureDetails {
  int? status;
  List<FairType>? fairType;
  String? processFeeType;
  String? processFee;
  dynamic seatTemplate;
  int? maxSeat;
  List<Stoppage>? boarding;
  List<Stoppage>? dropping;
  List<Charge>? charge;
  List<Seat>? seats;
  List<List<String>>? m;

  DepartureDetails({
    this.status,
    this.fairType,
    this.processFeeType,
    this.processFee,
    this.maxSeat,
    this.boarding,
    this.dropping,
    this.charge,
    this.seats,
    this.m,
    this.seatTemplate,
  });

  factory DepartureDetails.fromJson(Map<String, dynamic> json) =>
      DepartureDetails(
        status: json["status"],
        fairType: json["fairType"] == null
            ? []
            : List<FairType>.from(
                json["fairType"]!.map((x) => FairType.fromJson(x))),
        processFeeType: json["processFeeType"].toString(),
        processFee: json["processFee"].toString(),
        seatTemplate: json["seatTemplate"],
        maxSeat: json["maxSeat"],
        boarding: json["boarding"] == null
            ? []
            : List<Stoppage>.from(
                json["boarding"]!.map((x) => Stoppage.fromJson(x))),
        dropping: json["dropping"] == null
            ? []
            : List<Stoppage>.from(
                json["dropping"]!.map((x) => Stoppage.fromJson(x))),
        charge: json["charge"] == null
            ? []
            : List<Charge>.from(json["charge"]!.map((x) => Charge.fromJson(x))),
        seats: json["seats"] == null
            ? []
            : List<Seat>.from(json["seats"]!.map((x) => Seat.fromJson(x))),
        m: json["m"] == null
            ? []
            : List<List<String>>.from(
                json["m"]!.map((x) => List<String>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "fairType": fairType == null
            ? []
            : List<dynamic>.from(fairType!.map((x) => x.toJson())),
        "processFeeType": processFeeType,
        "processFee": processFee,
        "seatTemplate": seatTemplate,
        "maxSeat": maxSeat,
        "boarding": boarding == null
            ? []
            : List<dynamic>.from(boarding!.map((x) => x.toJson())),
        "dropping": dropping == null
            ? []
            : List<dynamic>.from(dropping!.map((x) => x.toJson())),
        "charge": charge == null
            ? []
            : List<dynamic>.from(charge!.map((x) => x.toJson())),
        "seats": seats == null
            ? []
            : List<dynamic>.from(seats!.map((x) => x.toJson())),
        "m": m == null
            ? []
            : List<dynamic>.from(
                m!.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}

class Stoppage {
  String? id;
  String? title;
  String? time;

  Stoppage({
    this.id,
    this.title,
    this.time,
  });

  factory Stoppage.fromJson(Map<String, dynamic> json) => Stoppage(
        id: json["id"].toString(),
        title: json["title"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "time": time,
      };
}

class Charge {
  String? slug;
  String? title;
  String? type;
  String? cType;
  String? value;

  Charge({
    this.slug,
    this.title,
    this.type,
    this.cType,
    this.value,
  });

  factory Charge.fromJson(Map<String, dynamic> json) => Charge(
        slug: json["slug"],
        title: json["title"],
        type: json["type"].toString(),
        cType: json["cType"].toString(),
        value: json["value"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "slug": slug,
        "title": title,
        "type": type,
        "cType": cType,
        "value": value,
      };
}

class FairType {
  String? tftId;
  String? tftTitle;
  int? isDob;
  int? isDoBrequired;
  int? isicNumber;
  int? isicNumberRequired;
  int? passServiceCharge;
  int? passServiceChargeReturn;

  FairType({
    this.tftId,
    this.tftTitle,
    this.isDob,
    this.isDoBrequired,
    this.isicNumber,
    this.isicNumberRequired,
    this.passServiceCharge,
    this.passServiceChargeReturn,
  });

  factory FairType.fromJson(Map<String, dynamic> json) => FairType(
        tftId: json["tftID"],
        tftTitle: json["tftTitle"],
        isDob: json["isDOB"],
        isDoBrequired: json["isDOBrequired"],
        isicNumber: json["isicNumber"],
        isicNumberRequired: json["isicNumberRequired"],
        passServiceCharge: json["passServiceCharge"],
        passServiceChargeReturn: json["passServiceChargeReturn"],
      );

  Map<String, dynamic> toJson() => {
        "tftID": tftId,
        "tftTitle": tftTitle,
        "isDOB": isDob,
        "isDOBrequired": isDoBrequired,
        "isicNumber": isicNumber,
        "isicNumberRequired": isicNumberRequired,
        "passServiceCharge": passServiceCharge,
        "passServiceChargeReturn": passServiceChargeReturn,
      };
}

class Seat {
  int? dsId;
  String? seatName;
  int? seatStatus;
  int? forSale;
  String? gender;
  dynamic dsData;
  dynamic soldBy;
  FareDetails? fareDetails;

  Seat({
    this.dsId,
    this.seatName,
    this.seatStatus,
    this.forSale,
    this.gender,
    this.dsData,
    this.soldBy,
    this.fareDetails,
  });

  factory Seat.fromJson(Map<String, dynamic> json) => Seat(
        dsId: json["dsID"],
        seatName: json["seatName"],
        seatStatus: json["seatStatus"],
        forSale: json["forSale"],
        gender: json["gender"].toString(),
        dsData: json["dsData"],
        soldBy: json["soldBy"],
        fareDetails: json["fareDetails"] == null
            ? null
            : FareDetails.fromJson(json["fareDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "dsID": dsId,
        "seatName": seatName,
        "seatStatus": seatStatus,
        "forSale": forSale,
        "gender": gender,
        "dsData": dsData,
        "soldBy": soldBy,
      };
}
