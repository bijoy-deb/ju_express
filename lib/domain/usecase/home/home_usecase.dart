import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/source/data/model/home/home_page_int_res.dart';

import '../../../core/error/error_message.dart';
import '../../../source/data/local/app_shared_preferences.dart';
import '../../../source/data/repositories/home/i_home_repository.dart';
import '../../../source/proviers/app_prefs.dart';
import 'i_home_usecase.dart';

@Injectable(as: IHomeUseCase)
class HomeUseCase extends IHomeUseCase {
  late final IHomeRepository _repository;
  final AppSharedPrefs prefs;
  HomeUseCase(this._repository, this.prefs);

  @override
  Future<Either<ErrorMessage, HomePageIntRes>> getHomePageInt() {
    if (!AppPrefs.appDataLoaded) {
      return _repository.getHomePageInt();
    } else {
      HomePageIntRes homePageIntRes = prefs.getHomePageInt();
      return Future(() => Right(homePageIntRes));
    }
  }
}
