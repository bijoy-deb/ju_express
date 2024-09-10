import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_message.dart';
import '../../../../domain/usecase/download_ticket/i_download_ticket_usecase.dart';
import '../../../data/model/download_ticket/download_ticket_res.dart';

part 'download_ticket_event.dart';
part 'download_ticket_state.dart';

@injectable
class DownloadTicketBloc
    extends Bloc<DownloadTicketEvent, DownloadTicketState> {
  final IDownloadTicketUseCase _useCase;
  DownloadTicketBloc(this._useCase) : super(DownloadTicketInitial()) {
    on<GetDownloadTicketData>((event, emit) async {
      emit(DownloadTicketLoading());
      var result = await _useCase.getDownloadTicketData(
          mobile: event.mobile, pnr: event.pnr, cCode: event.cCode);
      result.fold((l) => emit(DownloadTicketError(l)),
          (r) => emit(DownloadTicketLoaded(r)));
    });
  }
}
