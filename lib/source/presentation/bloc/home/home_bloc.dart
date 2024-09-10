import 'package:equatable/equatable.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/source/data/model/home/home_page_int_res.dart';

import '../../../../core/error/error_message.dart';
import '../../../../domain/usecase/home/i_home_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IHomeUseCase _useCase;
  HomeBloc(this._useCase) : super(HomeInitial()) {
    on<GetRemoteConfig>((event, emit) async {
      try {
        FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
        final Map<String, dynamic> defaults = <String, dynamic>{};
        await remoteConfig.setDefaults(defaults);
        await remoteConfig.setConfigSettings(
          RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 5),
            minimumFetchInterval: const Duration(seconds: 10),
          ),
        );
        await remoteConfig.fetchAndActivate();

        emit(RemoteConfigLoaded());
      } catch (e) {
        print(e);
        emit(RemoteConfigError());
      }
    });
    on<GetHomePageInt>((event, emit) async {
      emit(HomePageIntLoading());
      var result = await _useCase.getHomePageInt();
      result.fold(
          (l) => emit(HomePageIntError(l)), (r) => emit(HomePageIntLoaded(r)));
    });
  }
}
