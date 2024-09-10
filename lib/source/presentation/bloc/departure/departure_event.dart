part of 'departure_bloc.dart';

abstract class DepartureEvent extends Equatable {}

class GetDepartureListData extends DepartureEvent {
  final String from;
  final String to;
  final String date;
  GetDepartureListData(
      {required this.from, required this.to, required this.date});

  @override
  List<Object> get props => [];
}

class GetDepartureDetails extends DepartureEvent {
  final String from;
  final String to;
  final String date;
  final String dID;
  GetDepartureDetails(
      {required this.from,
      required this.to,
      required this.date,
      required this.dID});

  @override
  List<Object> get props => [];
}

class ReserveSeat extends DepartureEvent {
  final String from;
  final String to;
  final String date;
  final String vHash;
  final List<String> dsIDs;
  ReserveSeat(
      {required this.from,
      required this.to,
      required this.date,
      required this.vHash,
      required this.dsIDs});

  @override
  List<Object> get props => [];
}
