part of 'reserve_seat_bloc.dart';

abstract class ReserveSeatEvent extends Equatable {}

class ReserveSeat extends ReserveSeatEvent {
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
