part of 'departure_bloc.dart';

abstract class DepartureState extends Equatable {
  const DepartureState();
}

class DepartureInitial extends DepartureState {
  @override
  List<Object> get props => [];
}

class DepartureListLoading extends DepartureState {
  @override
  List<Object> get props => [];
}

class DepartureListLoaded extends DepartureState {
  final DepartureListRes res;

  const DepartureListLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class GotError extends DepartureState {
  final ErrorMessage error;

  const GotError(this.error);

  @override
  List<Object> get props => [error];
}

class DepartureDetailsLoading extends DepartureState {
  @override
  List<Object> get props => [];
}

class DepartureDetailsLoaded extends DepartureState {
  final DepartureDetails res;
  final SeatLayoutModel? seatLayoutModel;
  const DepartureDetailsLoaded(this.res, this.seatLayoutModel);

  @override
  List<Object> get props => [res, seatLayoutModel!];
}

class ReservingSeat extends DepartureState {
  @override
  List<Object> get props => [];
}

class SeatReserved extends DepartureState {
  final SeatReserveRes res;

  const SeatReserved(this.res);

  @override
  List<Object> get props => [res];
}
