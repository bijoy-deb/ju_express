import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_message.dart';
import '../../../../domain/usecase/district_list/i_district_list_usecase.dart';

part 'district_list_event.dart';
part 'district_list_state.dart';

@injectable
class DistrictListBloc extends Bloc<DistrictListEvent, DistrictListState> {
  final IDistrictListUseCase _useCase;
  DistrictListBloc(this._useCase) : super(DistrictListInitial()) {
    on<GetDistrictListData>((event, emit) async {
      emit(DistrictListLoading());
      var result = await _useCase.getDistrictList(fromApi: event.fromApi);
      result.fold((l) => emit(DistrictListError(l)),
          (r) => emit(DistrictListLoaded(r)));
    });

    on<GetFromWiseToData>((event, emit) async {
      emit(DistrictListLoading());
      var result = await _useCase.getFromWiseTo(from: event.from);
      result.fold((l) => emit(DistrictListError(l)),
          (r) => emit(DistrictListLoaded(r)));
    });
  }
}
