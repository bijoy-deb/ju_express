import '../common/district.dart';
import '../departure_details/BusSeat.dart';
import '../departure_details/DepartureDetails.dart';
import '../departure_list/departure_list.dart';
import '../home/home_page_int_res.dart';

class PassengerInfoArgs {
  PassengerInfoArgs({
    required this.vHash,
    required this.from,
    required this.to,
    required this.date,
    required this.departure,
    required this.seats,
    this.boarding,
    this.dropping,
    required this.boardingList,
    required this.droppingList,
    required this.fairTypes,
    required this.idTypes,
    required this.processFee,
    required this.processFeeType,
    this.totalPayable = 0,
  });

  String vHash;
  District from;
  District to;
  DateTime date;
  Departures departure;
  List<BusSeat> seats;
  Stoppage? boarding;
  Stoppage? dropping;
  List<FairType> fairTypes;
  List<IdTypes> idTypes;
  List<Stoppage>? boardingList;
  List<Stoppage>? droppingList;
  int processFeeType;
  double processFee;
  double totalPayable = 0;

  Map<String, dynamic> toJson() => {
        "v_hash": vHash,
        "from": from.toJson(),
        "to": to.toJson(),
        "date": date.toIso8601String(),
        "departure": departure.toJson(),
        "seats": List<dynamic>.from(seats.map((x) => x.toJson())),
        "boarding": boarding?.toJson(),
        "dropping": dropping?.toJson(),
        "fair_types": List<dynamic>.from(fairTypes.map((x) => x.toJson())),
        "id_types": List<dynamic>.from(idTypes.map((x) => x.toJson())),
        "boardingList": boardingList?.map((x) => x.toJson()).toList(),
        "droppingList": droppingList?.map((x) => x.toJson()).toList(),
        "process_fee_type": processFeeType,
        "process_fee": processFee,
      };

  factory PassengerInfoArgs.fromJson(Map<String, dynamic> json) =>
      PassengerInfoArgs(
        vHash: json["v_hash"],
        from: District.fromJson(json["from"]),
        to: District.fromJson(json["to"]),
        date: DateTime.parse(json["date"]),
        departure: Departures.fromJson(json["departure"]),
        seats:
            List<BusSeat>.from(json["seats"].map((x) => BusSeat.fromJson(x))),
        boarding: Stoppage.fromJson(json["boarding"]),
        dropping: Stoppage.fromJson(json["dropping"]),
        boardingList: List<Stoppage>.from(
            json["boardingList"].map((x) => Stoppage.fromJson(x))),
        droppingList: List<Stoppage>.from(
            json["droppingList"].map((x) => Stoppage.fromJson(x))),
        fairTypes: List<FairType>.from(
            json["fair_types"].map((x) => FairType.fromJson(x))),
        idTypes: List<IdTypes>.from(
            json["id_types"].map((x) => IdTypes.fromJson(x))),
        processFeeType: json["process_fee_type"],
        processFee: json["process_fee"].toDouble(),
      );
}
