import 'package:dartz/dartz.dart';
import 'package:ju_express/core/error/error_message.dart';
import 'package:ju_express/source/data/model/district_list/district_list.dart';

import '../../model/district_list/from_wise_to.dart';

abstract class IDistrictListRepository {
  Future<Either<ErrorMessage, DistrictListRes>> getDistrictListFromApi();
  Future<Either<ErrorMessage, DistrictListRes>> getDistrictListFromLocal();
  Future<Either<ErrorMessage, FromWiseToRes>> getFromWiseTo(
      {required String from});
}
