import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/core/api_client/api_client.dart';
import 'package:ju_express/core/error/error_message.dart';
import 'package:ju_express/source/data/model/common/status_message_res.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../di/injection.dart';
import '../../../utils/api_endpoints.dart';
import '../../../utils/global.dart';
import '../../../utils/helper_functions.dart';
import '../../local/app_shared_preferences.dart';
import 'i_contact_us_repository.dart';

@Injectable(as: IContactUsRepository)
class ContactUsRepository extends IContactUsRepository {
  late final ApiClient apiClient;
  ContactUsRepository(this.apiClient);

  @override
  Future<Either<ErrorMessage, StatusMessageRes>> sendMessage({
    required String name,
    required String email,
    required String mobile,
    required String cCode,
    required String msg,
  }) async {
    StatusMessageRes res;
    ErrorMessage errorMessage = ErrorMessage(
        message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
        errorType: ErrorType.ERROR);
    Response? response;
    await apiClient.request(
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: {
          "module": "sendContactMessage",
          'license': getLicence(),
          "name": name,
          "email": email,
          "mobile": mobile,
          "cCode": cCode,
          "message": msg,
          "version": getIt<PackageInfo>().version,
          "ln": getIt<AppSharedPrefs>().getLnCode()
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
        res = statusMsgResFromJson(response!.body);
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
