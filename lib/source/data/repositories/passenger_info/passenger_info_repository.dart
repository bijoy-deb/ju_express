import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/source/data/local/app_shared_preferences.dart';
import 'package:ju_express/source/data/model/common/status_message_res.dart';
import 'package:ju_express/source/data/model/download_ticket/download_ticket_res.dart';
import 'package:ju_express/source/data/model/passenger_info/cupon_details.dart';
import 'package:ju_express/source/data/repositories/passenger_info/i_passenger_info_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/api_client/api_client.dart';
import '../../../../core/error/error_message.dart';
import '../../../../di/injection.dart';
import '../../../utils/api_endpoints.dart';
import '../../../utils/global.dart';
import '../../../utils/helper_functions.dart';
import '../../model/balance/balance_res.dart';
import '../../model/passenger_info/stripe_invoice_res.dart';
import '../../model/passenger_info/ticket_sale_prams.dart';
import '../../model/passenger_info/ticket_sale_res.dart';

@Injectable(as: IPassengerInfoRepository)
class PassengerInfoRepository extends IPassengerInfoRepository {
  late final ApiClient apiClient;
  PassengerInfoRepository(this.apiClient);

  @override
  Future<Either<ErrorMessage, TicketSaleRes>> ticketSale(
      {required TicketSalePrams ticketSalePrams}) async {
    TicketSaleRes ticketSaleRes = TicketSaleRes(status: 0);
    ErrorMessage errorMessage = ErrorMessage(
        message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
        errorType: ErrorType.ERROR);
    Map body = {
      "module": "ticketSale",
      'license': getLicence(),
      "version": getIt<PackageInfo>().version,
      "ln": getIt<AppSharedPrefs>().getLnCode(),
      "authcode": getIt<AppSharedPrefs>().getAuthCode().isNotEmpty
          ? getIt<AppSharedPrefs>().getAuthCode()
          : ""
    };
    body.addAll(ticketSalePrams.toJson());
    Response? response;
    await apiClient.request(
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: body,
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          log("onError ${data.errorType}");
          errorMessage = data;
        });

    if (response != null) {
      try {
        ticketSaleRes = ticketSaleResFromJson(response!.body);
        return Right(ticketSaleRes);
      } catch (e) {
        log("Exception $e");
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
  Future<Either<ErrorMessage, DownloadTicketRes>> paymentConfirm(
      {required String vHash, required String payID}) async {
    DownloadTicketRes res;
    ErrorMessage errorMessage = ErrorMessage(
        message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
        errorType: ErrorType.ERROR);
    Response? response;
    await apiClient.request(
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: {
          "module": "paymentConfirm",
          'license': getLicence(),
          'vuHash': vHash,
          'payID': payID,
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
        res = downloadTicketResFromJson(response!.body);
        return Right(res);
      } catch (e) {
        log("Exception $e");
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
  Future<Either<ErrorMessage, StripeInvoiceRes>> stripeInvoiceCreate(
      {required String vHash, required String payID}) async {
    StripeInvoiceRes res;
    ErrorMessage errorMessage = ErrorMessage(
        message: "Something went wrong", errorType: ErrorType.ERROR);
    Response? response;
    await apiClient.request(
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: {
          "module": "stripeInvoiceCreate",
          'license': getLicence(),
          'vuHash': vHash,
          'payID': payID,
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
        res = stripeInvoiceResFromJson(response!.body);
        return Right(res);
      } catch (e) {
        log("Exception $e");
        return Left(ErrorMessage(
            message: "Something went wrong", errorType: ErrorType.ERROR));
      }
    } else {
      return Left(errorMessage);
    }
  }

  @override
  Future<Either<ErrorMessage, StatusMessageRes>> push(
      {required String mobile,
      required String refID,
      required double amount,
      required String url,
      required String type}) async {
    StatusMessageRes res;
    ErrorMessage errorMessage = ErrorMessage(
        message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
        errorType: ErrorType.ERROR);
    Response? response;
    await apiClient.request(
        url: url,
        method: Method.POST,
        header: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "type": type,
          'amount': amount.toStringAsFixed(2),
          'msisdn': mobile,
          'reference': refID,
        }),
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          log("onError ${data.errorType}");
          errorMessage = data;
        });

    if (response != null) {
      try {
        if (response!.body == "0") {
          res = StatusMessageRes(status: 1);
          return Right(res);
        } else {
          res = StatusMessageRes(
            status: 0,
          );
          return Right(res);
        }
      } catch (e) {
        log("Exception $e");
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
  Future<Either<ErrorMessage, CouponCodeRes>> couponVerify(
      {required String couponCode,
      required String dIDs,
      required String from,
      required String to}) async {
    CouponCodeRes res;
    ErrorMessage errorMessage = ErrorMessage(
        message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
        errorType: ErrorType.ERROR);
    Response? response;
    await apiClient.request(
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: {
          'module': 'promoDetails',
          'promoCode': couponCode,
          'license': getLicence(),
          "version": getIt<PackageInfo>().version,
          "ln": getIt<AppSharedPrefs>().getLnCode(),
          "dIDs[]": dIDs,
          "from": from,
          "to": to,
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
        res = couponCodeResFromJson(response!.body);
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
  Future<Either<ErrorMessage, BalanceRes>> getCustomerBalance(
      {required String busCard, required String pin}) async {
    BalanceRes res;
    ErrorMessage errorMessage = ErrorMessage(
        message: "Something went wrong", errorType: ErrorType.ERROR);
    Response? response;
    Map<String, dynamic> body = {
      "module": "getCustomer",
      "mobile": busCard,
      "pin": pin,
      'license': getLicence(),
      "version": getIt<PackageInfo>().version,
    };
    await apiClient.request(
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: body,
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          log("onError ${data.errorType}");
          errorMessage = data;
        });

    if (response != null) {
      try {
        res = balanceResFromJson(response!.body);
        return Right(res);
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
