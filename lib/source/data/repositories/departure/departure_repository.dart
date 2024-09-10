import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/core/api_client/api_client.dart';
import 'package:ju_express/core/error/error_message.dart';
import 'package:ju_express/source/data/model/departure_details/DepartureDetails.dart';
import 'package:ju_express/source/data/model/departure_details/SeatReserveRes.dart';
import 'package:ju_express/source/data/model/departure_list/departure_list.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../di/injection.dart';
import '../../../utils/api_endpoints.dart';
import '../../../utils/global.dart';
import '../../../utils/helper_functions.dart';
import '../../local/app_shared_preferences.dart';
import 'i_departure_repository.dart';

@Injectable(as: IDepartureRepository)
class DepartureRepository extends IDepartureRepository {
  late final ApiClient apiClient;
  final AppSharedPrefs sp;
  DepartureRepository(this.apiClient, this.sp);

  @override
  Future<Either<ErrorMessage, DepartureListRes>> getDepartureList(
      {required String from, required String to, required date}) async {
    DepartureListRes res;
    ErrorMessage errorMessage = ErrorMessage(
        message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
        errorType: ErrorType.ERROR);
    Response? response;
    await apiClient.request(
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: {
          "module": "getDepartureList",
          'license': getLicence(),
          'from': from,
          'to': to,
          'date': date,
          'vuHash': sp.getVHash(),
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
        res = departureListResFromJson(response!.body);

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
  Future<Either<ErrorMessage, DepartureDetails>> getDepartureDetails(
      {required String from,
      required String to,
      required String date,
      required String dID}) async {
    DepartureDetails res;
    ErrorMessage errorMessage = ErrorMessage(
        message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
        errorType: ErrorType.ERROR);
    Response? response;
    await apiClient.request(
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: {
          "module": "loadDepartureDetails",
          'license': getLicence(),
          'from': from,
          'to': to,
          'date': date,
          "dID": dID,
          "version": getIt<PackageInfo>().version,
          "searchRange": "0",
          'vuHash': sp.getVHash(),
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
        res = departureDetailsFromJson(response!.body);
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
  Future<Either<ErrorMessage, SeatReserveRes>> reserveSeat({
    required String from,
    required String to,
    required String date,
    required String vHash,
    required List<String> dsIDs,
  }) async {
    String dsIDComma = "";
    for (int i = 0; i < dsIDs.length; i++) {
      String s = dsIDs.elementAt(i);

      if (dsIDComma.isNotEmpty) {
        dsIDComma += ",$s";
      } else {
        dsIDComma = s;
      }
    }
    SeatReserveRes res;
    ErrorMessage errorMessage = ErrorMessage(
        message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
        errorType: ErrorType.ERROR);
    Response? response;
    await apiClient.request(
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: {
          "module": "newTicketReserve",
          'license': getLicence(),
          'from': from,
          'to': to,
          'date': date,
          'vuHash': vHash,
          "dsIDComma": dsIDComma,
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
        res = seatSeatReserveResFromJson(response!.body);
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
