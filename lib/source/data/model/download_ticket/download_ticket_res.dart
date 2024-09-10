import 'dart:convert';

DownloadTicketRes downloadTicketResFromJson(String str) =>
    DownloadTicketRes.fromJson(json.decode(str));

class DownloadTicketRes {
  int? status;
  List<TicketDetails>? ticketDetails;
  List<List<dynamic>>? m;

  DownloadTicketRes({
    this.status,
    this.ticketDetails,
    this.m,
  });

  factory DownloadTicketRes.fromJson(Map<String, dynamic> json) =>
      DownloadTicketRes(
        status: json["status"],
        ticketDetails: json["ticketDetails"] == null
            ? []
            : json["ticketDetails"] is List
                ? List<TicketDetails>.from(json["ticketDetails"]!
                    .map((x) => TicketDetails.fromJson(x)))
                : [TicketDetails.fromJson(json["ticketDetails"])],
        m: json["m"] == null
            ? []
            : List<List<dynamic>>.from(
                json["m"]!.map((x) => List<dynamic>.from(x.map((x) => x)))),
      );
}

class TicketDetails {
  String? diPnr;
  String? boarding;
  String? dropping;
  String? journyDate;
  String? departureTime;
  String? coach;
  String? rTitle;
  String? ftTitle;
  String? seatNames;
  String? salePriceCrSymbol;
  String? totalSeat;
  String? bTitle;
  String? fileName;
  String? pdfLink;
  String? name;
  String? mobile;
  String? cCode;
  String? from;
  String? to;

  TicketDetails({
    this.diPnr,
    this.boarding,
    this.dropping,
    this.journyDate,
    this.departureTime,
    this.coach,
    this.rTitle,
    this.ftTitle,
    this.seatNames,
    this.salePriceCrSymbol,
    this.totalSeat,
    this.bTitle,
    this.fileName,
    this.pdfLink,
    this.name,
    this.mobile,
    this.cCode,
    this.from,
    this.to,
  });

  factory TicketDetails.fromJson(Map<String, dynamic> json) => TicketDetails(
        diPnr: json["diPNR"],
        boarding: json["boarding"],
        dropping: json["dropping"],
        journyDate: json["journyDate"],
        departureTime: json["departureTime"],
        coach: json["coach"],
        rTitle: json["rTitle"],
        ftTitle: json["ftTitle"],
        seatNames: json["seatNames"],
        salePriceCrSymbol: json["salePriceCrSymbol"].toString(),
        totalSeat: json["totalSeat"].toString(),
        bTitle: json["bTitle"],
        fileName: json["fileName"],
        pdfLink: json["pdfLink"],
        name: json["cName"],
        mobile: json["cMobile"],
        cCode: json["cCode"],
        from: json["from"],
        to: json["to"],
      );
}
