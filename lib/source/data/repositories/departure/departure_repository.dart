import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
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
  // Declare ApiClient and AppSharedPrefs instances
  late final ApiClient apiClient;
  final AppSharedPrefs sp;

  // Constructor to initialize ApiClient and AppSharedPrefs
  DepartureRepository(this.apiClient, this.sp);

  /// Fetches the departure list based on provided parameters
  /// Returns Either an [ErrorMessage] or [DepartureListRes]
  @override
  Future<Either<ErrorMessage, DepartureListRes>> getDepartureList({
    required String from,
    required String to,
    required date,
  }) async {
    // Initialize response and errorMessage variables
    DepartureListRes res;
    ErrorMessage errorMessage = ErrorMessage(
      message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
      errorType: ErrorType.ERROR,
    );
    Response? response;

    // API request to get the departure list
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
      },
    );

    // Parse response or return error
    if (response != null) {
      try {
        res = departureListResFromJson(response!.body);
        return Right(res);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return Left(ErrorMessage(
          message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
          errorType: ErrorType.ERROR,
        ));
      }
    } else {
      return Left(errorMessage);
    }
  }

  /// Fetches the departure details based on provided parameters
  /// Returns Either an [ErrorMessage] or [DepartureDetails]
  @override
  Future<Either<ErrorMessage, DepartureDetails>> getDepartureDetails({
    required String from,
    required String to,
    required String date,
    required String dID,
  }) async {
    DepartureDetails res;
    ErrorMessage errorMessage = ErrorMessage(
      message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
      errorType: ErrorType.ERROR,
    );
    Response? response;

    // API request to get departure details
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
      },
    );

    // Parse response or return error
    if (response != null) {
      try {
        res = departureDetailsFromJson(response!.body);
        return Right(res);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return Left(ErrorMessage(
          message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
          errorType: ErrorType.ERROR,
        ));
      }
    } else {
      return Left(errorMessage);
    }
  }

  /// Reserves a seat based on provided parameters
  /// Returns Either an [ErrorMessage] or [SeatReserveRes]
  @override
  Future<Either<ErrorMessage, SeatReserveRes>> reserveSeat({
    required String from,
    required String to,
    required String date,
    required String vHash,
    required List<String> dsIDs,
  }) async {
    // Convert dsIDs list to comma-separated string
    String dsIDComma = dsIDs.join(",");

    SeatReserveRes res;
    ErrorMessage errorMessage = ErrorMessage(
      message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
      errorType: ErrorType.ERROR,
    );
    Response? response;

    // API request to reserve seat
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
      },
    );

    // Parse response or return error
    if (response != null) {
      try {
        res = seatSeatReserveResFromJson(response!.body);
        return Right(res);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return Left(ErrorMessage(
          message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
          errorType: ErrorType.ERROR,
        ));
      }
    } else {
      return Left(errorMessage);
    }
  }
}
