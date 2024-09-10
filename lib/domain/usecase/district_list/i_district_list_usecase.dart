import 'package:dartz/dartz.dart';

import '../../../../core/error/error_message.dart';
import '../../../source/data/model/district_list/district_list.dart';
import '../../../source/data/model/district_list/from_wise_to.dart';

abstract class IDistrictListUseCase {
  Future<Either<ErrorMessage, DistrictListRes>> getDistrictList(
      {required bool fromApi});
  Future<Either<ErrorMessage, FromWiseToRes>> getFromWiseTo({
    required String from,
  });
}
