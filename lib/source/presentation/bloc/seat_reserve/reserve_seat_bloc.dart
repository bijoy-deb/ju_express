import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/source/data/model/departure_details/SeatReserveRes.dart';

import '../../../../core/error/error_message.dart';
import '../../../../domain/usecase/departure/i_departure_usecase.dart';

part 'reserve_seat_event.dart';
part 'reserve_seat_state.dart';

@injectable
class ReserveSeatBloc extends Bloc<ReserveSeatEvent, ReserveSeatState> {
  final IDepartureUseCase _useCase;
  ReserveSeatBloc(this._useCase) : super(DepartureInitial()) {
    on<ReserveSeat>((event, emit) async {
      emit(ReservingSeat());
      var result = await _useCase.reserveSeat(
          from: event.from,
          to: event.to,
          date: event.date,
          dsIDs: event.dsIDs,
          vHash: event.vHash);
      result.fold((l) => emit(GotError(l)), (r) => emit(SeatReserved(r)));
    });
  }
}
