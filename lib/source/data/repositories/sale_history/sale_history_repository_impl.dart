import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api_client/api_client.dart';
import '../../../../core/error/error_message.dart';
import '../../../utils/api_endpoints.dart';
import '../../../utils/helper_functions.dart';
import '../../local/app_shared_preferences.dart';
import '../../local/shared_values.dart';
import '../../model/sale_history/sale_history_request_model.dart';
import '../../model/sale_history/sale_history_response_model.dart';
import 'sale_history_repository.dart';

@Injectable(as: SaleHistoryRepository)
class SaleHistoryRepositoryImpl extends SaleHistoryRepository {
  late final ApiClient apiClient;
  late final AppSharedPrefs sp;
  SaleHistoryRepositoryImpl(this.apiClient, this.sp);

  @override
  Future<Either<ErrorMessage, SaleHistoryResponseModel>> customerSaleInfo(
      {required SaleHistoryRequestModel model}) async {
    ErrorMessage errorMessage = ErrorMessage(
        message: "Something went wrong", errorType: ErrorType.ERROR);
    Response? response;
    SaleHistoryResponseModel? responseModel;
    Map body = {
      "module": "customerSaleInfo",
      'license': getLicence(),
      "authcode": sp.getAuthCode(),
      "version": appVersion.$,
      "ln": lnCode.$,
    };
    body.addAll(model.toJson());
    await apiClient.request(
        header: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: body,
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          errorMessage = data;
        });

    if (response != null) {
      try {
        responseModel = saleHistoryResponseModelFromJson(response!.body);

        return Right(responseModel);
      } catch (e) {
        log("Exception $e");
        return Left(ErrorMessage(
            message: "Something went wrong", errorType: ErrorType.ERROR));
      }
    } else {
      return Left(errorMessage);
    }
  }
}
