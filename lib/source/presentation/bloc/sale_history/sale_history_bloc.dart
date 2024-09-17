import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_message.dart';
import '../../../../domain/usecase/sale_history/sale_history_usecase.dart';
import '../../../data/model/sale_history/sale_history_request_model.dart';
import '../../../data/model/sale_history/sale_history_response_model.dart';

part 'sale_history_event.dart';
part 'sale_history_state.dart';

@injectable
class SaleHistoryBloc extends Bloc<SaleHistoryEvent, SaleHistoryState> {
  final SaleHistoryUseCase useCase;
  SaleHistoryBloc({required this.useCase}) : super(SaleHistoryInitial()) {
    on<GetSaleHistoryEvent>((event, emit) async {
      emit(DataLoading());
      var result = await useCase.customerSaleInfo(model: event.model);
      result.fold((l) => emit(DataError(l)), (r) => emit(SaleHistoryLoaded(r)));
    });
  }
}
