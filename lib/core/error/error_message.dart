import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../src/utils/global.dart';

class ErrorMessage {
  final String message;
  final String subtitle;
  final ErrorType errorType;

  ErrorMessage(
      {this.message = '', this.subtitle = '', required this.errorType});

  static ErrorMessage getErrorFromMsg(List<List<dynamic>>? m) {
    if (m != null && m.isNotEmpty) {
      String msg = "";
      for (int i = 0; i < m.length; i++) {
        var item = m.elementAt(i);
        var e = item.elementAt(1);
        if (kDebugMode) {
          print(e);
        }
        if (msg.length > 1) {
          msg += "\n$e";
        } else {
          msg += "$e";
        }
      }
      return ErrorMessage(
          message: msg, errorType: ErrorType.ERROR_WITH_MESSAGE);
    } else {
      return ErrorMessage(
          message: AppLocalizations.of(Globals.context!)!.something_went_wrong,
          errorType: ErrorType.ERROR_WITH_MESSAGE);
    }
  }
}

enum ErrorType { NO_INTERNET, NO_DATA, TIMEOUT, ERROR, ERROR_WITH_MESSAGE }
