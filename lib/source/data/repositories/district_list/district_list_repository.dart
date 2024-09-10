import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/core/api_client/api_client.dart';
import 'package:ju_express/core/error/error_message.dart';
import 'package:ju_express/source/data/model/district_list/district_list.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../di/injection.dart';
import '../../../utils/api_endpoints.dart';
import '../../../utils/global.dart';
import '../../../utils/helper_functions.dart';
import '../../local/app_shared_preferences.dart';
import '../../local/database_helper.dart';
import '../../model/district_list/from_wise_to.dart';
import 'i_district_list_repository.dart';

@Injectable(as: IDistrictListRepository)
class DistrictListRepository extends IDistrictListRepository {
  late final ApiClient apiClient;
  final AppSharedPrefs sp;
  final DataBaseHelper dbHelper;
  DistrictListRepository(this.apiClient, this.sp, this.dbHelper);

  @override
  Future<Either<ErrorMessage, DistrictListRes>> getDistrictListFromApi() async {
    DistrictListRes res;
    ErrorMessage errorMessage = ErrorMessage(
        message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
        errorType: ErrorType.ERROR);
    Response? response;
    await apiClient.request(
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: {
          "module": "getDistrictList",
          'license': getLicence(),
          "version": getIt<PackageInfo>().version,
          "ln": sp.getLnCode(),
        },
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          log("onError ${data.errorType}");
          errorMessage = data;
        });

    if (response != null) {
      try {
        res = districtListResFromJson(response!.body);
        await dbHelper.clearDistricts();
        await dbHelper.insertDistricts(res.districts!);
        await sp.setLastDBUpdate(DateTime.now().millisecondsSinceEpoch);
        return Right(res);
      } catch (e) {
        print(e);
        return Left(ErrorMessage(
            message:
                AppLocalizations.of(Globals.context!)!.something_went_wrong,
            errorType: ErrorType.ERROR));
      }
    } else {
      return Left(errorMessage);
    }
  }

  @override
  Future<Either<ErrorMessage, DistrictListRes>>
      getDistrictListFromLocal() async {
    DistrictListRes res = DistrictListRes(status: 1, m: []);
    ErrorMessage errorMessage = ErrorMessage(
        message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
        errorType: ErrorType.ERROR);
    try {
      await dbHelper.getDistricts().then((value) => res.districts = value);
      return Right(res);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Left(ErrorMessage(
          message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
          errorType: ErrorType.ERROR));
    }
  }

  @override
  Future<Either<ErrorMessage, FromWiseToRes>> getFromWiseTo(
      {required String from}) async {
    FromWiseToRes res;
    ErrorMessage errorMessage = ErrorMessage(
        message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
        errorType: ErrorType.ERROR);
    Response? response;
    await apiClient.request(
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: {
          "module": "getFromWiseTo",
          "from": from,
          'license': getLicence(),
          "version": getIt<PackageInfo>().version,
          "ln": sp.getLnCode(),
        },
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          log("onError ${data.errorType}");
          errorMessage = data;
        });

    if (response != null) {
      try {
        res = fromWiseToResFromJson(response!.body);
        return Right(res);
      } catch (e) {
        print(e);
        return Left(ErrorMessage(
            message:
                AppLocalizations.of(Globals.context!)!.something_went_wrong,
            errorType: ErrorType.ERROR));
      }
    } else {
      return Left(errorMessage);
    }
  }
}
