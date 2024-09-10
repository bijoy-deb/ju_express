import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/core/api_client/api_client.dart';
import 'package:ju_express/core/error/error_message.dart';
import 'package:ju_express/source/data/local/app_shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../di/injection.dart';
import '../../../utils/api_endpoints.dart';
import '../../../utils/global.dart';
import '../../../utils/helper_functions.dart';
import '../../model/static_content/static_content_res.dart';
import 'i_static_content_repository.dart';

@Injectable(as: IStaticContentsRepository)
class StaticContentsRepository extends IStaticContentsRepository {
  late final ApiClient apiClient;
  StaticContentsRepository(this.apiClient);

  @override
  Future<Either<ErrorMessage, StaticContentRes>> getStaticContents() async {
    StaticContentRes res;
    ErrorMessage errorMessage = ErrorMessage(
        message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
        errorType: ErrorType.ERROR);
    Response? response;
    await apiClient.request(
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: {
          "module": "staticContents",
          'license': getLicence(),
          "version": getIt<PackageInfo>().version,
          "ln": getIt<AppSharedPrefs>().getLnCode(),
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
        res = staticContentResFromJson(response!.body);
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
