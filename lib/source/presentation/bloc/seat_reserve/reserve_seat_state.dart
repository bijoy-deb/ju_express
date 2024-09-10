part of 'reserve_seat_bloc.dart';

abstract class ReserveSeatState extends Equatable {
  const ReserveSeatState();
}

class DepartureInitial extends ReserveSeatState {
  @override
  List<Object> get props => [];
}

class GotError extends ReserveSeatState {
  final ErrorMessage error;

  const GotError(this.error);

  @override
  List<Object> get props => [error];
}

class ReservingSeat extends ReserveSeatState {
  @override
  List<Object> get props => [];
}

class SeatReserved extends ReserveSeatState {
  final SeatReserveRes res;

  const SeatReserved(this.res);

  @override
  List<Object> get props => [res];
}
