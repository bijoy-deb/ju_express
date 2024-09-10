import '../departure_list/departure_list.dart';

class BusSeat {
  String dsID;
  String seatName;
  String seatStatus;
  int forSale;
  String sc = "0";
  dynamic gender;
  FareDetails? fareDetails;

  BusSeat(this.dsID, this.seatName, this.seatStatus, this.forSale, this.sc,
      {this.gender, this.fareDetails});

  factory BusSeat.fromJson(Map<String, dynamic> json) {
    return BusSeat(json['dsID'], json['seatName'], json['seatStatus'],
        json['forSale'], json['sc'],
        gender: json['gender'],
        fareDetails: json['fareDetails'] == null
            ? null
            : FareDetails.fromJson(json['fareDetails']));
  }

  Map<String, dynamic> toJson() => {
    "dsID": dsID,
    "seatName": seatName,
    "seatStatus": seatStatus,
    "forSale": forSale,
    "sc": sc,
    "gender": gender,
    "fareDetails": fareDetails?.toJson(),
  };
}