import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/source/data/local/app_shared_preferences.dart';

import '../../../../core/error/error_message.dart';
import '../../../source/data/model/district_list/district_list.dart';
import '../../../source/data/model/district_list/from_wise_to.dart';
import '../../../source/data/repositories/district_list/i_district_list_repository.dart';
import 'i_district_list_usecase.dart';

@Injectable(as: IDistrictListUseCase)
class DistrictListUseCase extends IDistrictListUseCase {
  late final IDistrictListRepository _repository;
  final AppSharedPrefs sp;
  DistrictListUseCase(this._repository, this.sp);

  @override
  Future<Either<ErrorMessage, DistrictListRes>> getDistrictList(
      {required bool fromApi}) {
    if (fromApi) {
      return _repository.getDistrictListFromApi();
    }
    if (DateTime.now().difference(
            DateTime.fromMillisecondsSinceEpoch(sp.getLastDBUpdate())) >=
        const Duration(days: 1)) {
      return _repository.getDistrictListFromApi();
    } else {
      return _repository.getDistrictListFromLocal();
    }
  }

  @override
  Future<Either<ErrorMessage, FromWiseToRes>> getFromWiseTo(
      {required String from}) {
    return _repository.getFromWiseTo(from: from);
  }
}
