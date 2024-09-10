import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/source/data/model/departure_details/SeatReserveRes.dart';
import 'package:ju_express/source/data/model/departure_list/departure_list.dart';

import '../../../../core/error/error_message.dart';
import '../../../../domain/usecase/departure/i_departure_usecase.dart';
import '../../../data/model/departure_details/DepartureDetails.dart';
import '../../../data/model/departure_details/SeatLayoutModel.dart';
import '../../../utils/SeatProcess.dart';

part 'departure_event.dart';
part 'departure_state.dart';

@injectable
class DepartureBloc extends Bloc<DepartureEvent, DepartureState> {
  final IDepartureUseCase _useCase;
  DepartureBloc(this._useCase) : super(DepartureInitial()) {
    on<GetDepartureListData>((event, emit) async {
      emit(DepartureListLoading());
      var result = await _useCase.getDepartureList(
          from: event.from, to: event.to, date: event.date);
      result.fold(
          (l) => emit(GotError(l)), (r) => emit(DepartureListLoaded(r)));
    });

    on<GetDepartureDetails>((event, emit) async {
      emit(DepartureDetailsLoading());
      var result = await _useCase.getDepartureDetails(
          from: event.from, to: event.to, date: event.date, dID: event.dID);
      result.fold((l) => emit(GotError(l)), (r) {
        dynamic seatLayoutModel;
        if (jsonDecode(jsonEncode(r.toJson()))['seatTemplate'] != null) {
          var stType =
              jsonDecode(jsonEncode(r.toJson()))['seatTemplate']['stType'];
          var seatProcess = SeatProcess();
          seatLayoutModel =
              seatProcess.processData(jsonEncode(r.toJson()), stType, r.seats);
        }
        emit(DepartureDetailsLoaded(r, seatLayoutModel));
      });
    });

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
