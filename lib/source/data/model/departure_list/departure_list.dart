import 'dart:convert';

DepartureListRes departureListResFromJson(String str) =>
    DepartureListRes.fromJson(json.decode(str));

class DepartureListRes {
  int? status;
  List<Departures>? departures;
  List<List<String>>? m;

  DepartureListRes({
    this.status,
    this.departures,
    this.m,
  });

  factory DepartureListRes.fromJson(Map<String, dynamic> json) =>
      DepartureListRes(
        status: json["status"],
        departures: json["departures"] == null
            ? []
            : List<Departures>.from(
            json["departures"]!.map((x) => Departures.fromJson(x))),
        m: json["m"] == null
            ? []
            : List<List<String>>.from(
            json["m"]!.map((x) => List<String>.from(x.map((x) => x)))),
      );
}

class Departures {
  String? dId;
  int? seatAvail;
  String? ftTitle;
  List<dynamic>? amenities;
  String? isAc;
  String? rTitle;
  String? bTitle;
  String? currencySymbol;
  String? brandLogo;
  dynamic dTime;
  dynamic dArTime;
  dynamic dDurationTime;
  String? dStartPoint;
  String? dEndPoint;
  String? coach;
  String? maker;
  List<AllStation>? allStation;
  FareDetails? fareDetails;

  Departures({
    this.dId,
    this.seatAvail,
    this.ftTitle,
    this.amenities,
    this.isAc,
    this.rTitle,
    this.bTitle,
    this.brandLogo,
    this.dTime,
    this.dArTime,
    this.dDurationTime,
    this.dStartPoint,
    this.dEndPoint,
    this.coach,
    this.maker,
    this.allStation,
    this.fareDetails,
    this.currencySymbol,
  });

  factory Departures.fromJson(Map<String, dynamic> json) => Departures(
    dId: json["dID"],
    seatAvail: json["seatAvail"],
    ftTitle: json["ftTitle"],
    amenities: json["amenities"] == null
        ? []
        : List<dynamic>.from(json["amenities"]!.map((x) => x)),
    isAc: json["isAC"],
    rTitle: json["rTitle"],
    bTitle: json["bTitle"],
    currencySymbol: json["currencySymbol"] ?? "",
    brandLogo: json["brandLogo"],
    dTime: json["dTime"],
    dArTime: json["dArTime"],
    dDurationTime: json["dDurationTime"],
    dStartPoint: json["dStartPoint"],
    dEndPoint: json["dEndPoint"],
    coach: json["coach"],
    maker: json["maker"],
    allStation: json["allStation"] == null
        ? []
        : List<AllStation>.from(
        json["allStation"]!.map((x) => AllStation.fromJson(x))),
    fareDetails: json["fareDetails"] == null
        ? null
        : FareDetails.fromJson(json["fareDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "dID": dId,
    "seatAvail": seatAvail,
    "ftTitle": ftTitle,
    "amenities": List<dynamic>.from(amenities!.map((x) => x)),
    "isAC": isAc,
    "rTitle": rTitle,
    "bTitle": bTitle,
    "currencySymbol": currencySymbol,
    "brandLogo": brandLogo,
    "dTime": dTime,
    "dArTime": dArTime,
    "dDurationTime": dDurationTime,
    "dStartPoint": dStartPoint,
    "dEndPoint": dEndPoint,
    "coach": coach,
    "maker": maker,
    "allStation": List<dynamic>.from(allStation!.map((x) => x.toJson())),
    //  "fareDetails": fareDetails?.toJson(),
  };
}

class AllStation {
  String? servicePointId;
  String? time;
  String? title;
  String? servicePointTitle;

  AllStation({
    this.servicePointId,
    this.time,
    this.title,
    this.servicePointTitle,
  });

  factory AllStation.fromJson(Map<String, dynamic> json) => AllStation(
    servicePointId: json["servicePointId"],
    time: json["time"],
    title: json["title"],
    servicePointTitle: json["servicePointTitle"],
  );

  //make to json method for this class
  Map<String, dynamic> toJson() => {
    "servicePointId": servicePointId,
    "time": time,
    "title": title,
    "servicePointTitle": servicePointTitle,
  };
}

class FareDetails {
  List<Fare>? fare;
  DiscountDetails? discountDetails;

  FareDetails({
    this.fare,
    this.discountDetails,
  });
  factory FareDetails.fromJson(Map<String, dynamic> json) => FareDetails(
    fare: json["fare"] == null
        ? []
        : List<Fare>.from(json["fare"]!.map((x) => Fare.fromJson(x))),
    discountDetails: json["discountDetails"] == null
        ? null
        : DiscountDetails.fromJson(json["discountDetails"]),
  );
  Map<String, dynamic> toJson() => {
    "fare": List<dynamic>.from(fare!.map((x) => x.toJson())),
    "discountDetails": discountDetails?.toJson(),
  };
}

class DiscountDetails {
  int? type;
  double? value;

  DiscountDetails({
    this.type,
    this.value,
  });

  factory DiscountDetails.fromJson(Map<String, dynamic> json) =>
      DiscountDetails(
        type: json["type"],
        value: double.tryParse(json["value"].toString()),
      );

  Map<String, dynamic> toJson() => {
    "type": type,
    "value": value,
  };
}

class Fare {
  double? currencyFare;
  double? discountedFare;
  double? baseFare;
  int? id;

  Fare({
    this.currencyFare,
    this.discountedFare,
    this.baseFare,
    this.id,
  });

  factory Fare.fromJson(Map<String, dynamic> json) => Fare(
    currencyFare: double.tryParse(json["currencyFare"].toString()),
    discountedFare: double.tryParse(json["discountedFare"].toString()),
    baseFare: double.tryParse(json["baseFare"].toString()),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "currencyFare": currencyFare,
    "discountedFare": discountedFare,
    "baseFare": baseFare,
    "id": id,
  };
}