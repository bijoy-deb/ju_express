import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_message.dart';
import '../../../../domain/usecase/static_content/i_static_content_usecase.dart';
import '../../../data/model/static_content/static_content_res.dart';


part 'static_content_event.dart';
part 'static_content_state.dart';

@injectable
class StaticContentsBloc
    extends Bloc<StaticContentsEvent, StaticContentsState> {
  final IStaticContentsUseCase _useCase;
  StaticContentsBloc(this._useCase) : super(StaticContentsInitial()) {
    on<GetStaticContentsData>((event, emit) async {
      emit(StaticContentsLoading());
      var result = await _useCase.getStaticContents();
      result.fold((l) => emit(StaticContentsError(l)),
          (r) => emit(StaticContentsLoaded(r)));
    });
  }
}
