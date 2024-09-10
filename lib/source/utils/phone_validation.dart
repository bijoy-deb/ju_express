import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PhoneCode {
  final String code;
  final List<int> lengths;

  PhoneCode(this.code, this.lengths);
}

///
/// phoneLengthCheck(String phoneNumber, String cCode)
/// This function is used to check the length of the phone number
Future<Map<String, dynamic>> phoneLengthCheck(
    String phoneNumber, String cCode) async {
  phoneNumber = phoneNumber.replaceAll("-", "");
  phoneNumber = phoneNumber.replaceAll(" ", "");
  // read json data from the path assets/mobile_number_length.json
  if (kDebugMode) {
    log("phoneLengthCheck ccode $phoneNumber ${phoneNumber.trim().replaceAll("-", "").length}");
  }

  try {
    var data = await rootBundle.loadString('assets/mobile_number_length.json');
    var jsonData = json.decode(data);

    final phoneCodes = jsonData['phoneCodes'];

    bool codeFound = false;
    for (final codeData in phoneCodes) {
      final phoneCode =
          PhoneCode(codeData['code'], List<int>.from(codeData['lengths']));

      if (phoneCode.code == cCode) {
        codeFound = true;
        if (phoneCode.lengths
            .contains(phoneNumber.trim().replaceAll("-", "").length)) {
          return {
            'type': PhoneErrorType.ok,
            'status': true,
          };
        } else {
          if (phoneCode.lengths.length == 1) {
            return {
              'type': PhoneErrorType.short,
              'digit': phoneCode.lengths[0],
              'status': false,
            };
          } else {
            final minLen = phoneCode.lengths
                .reduce((value, element) => value < element ? value : element);
            final maxLen = phoneCode.lengths
                .reduce((value, element) => value > element ? value : element);
            return {
              'type': PhoneErrorType.rangeError,
              'min': minLen,
              'max': maxLen,
              'status': false,
            };
          }
        }
      }
    }
    if (codeFound) {
      return {
        'type': PhoneErrorType.invalid,
        'status': false,
      };
    } else {
      if (phoneNumber.trim().replaceAll("-", "").length >= 8) {
        return {
          'type': PhoneErrorType.ok,
          'status': true,
        };
      } else {
        return {
          'type': PhoneErrorType.invalid,
          'status': false,
        };
      }
    }
  } catch (e) {
    log('phoneLengthCheck error $e');
    if (phoneNumber.trim().replaceAll("-", "").length >= 8) {
      return {
        'type': PhoneErrorType.ok,
        'status': true,
      };
    } else {
      return {
        'type': PhoneErrorType.invalid,
        'status': false,
      };
    }
  }
}

//get max length of from country code
Future<int> getMaxLength(String cCode) async {
  // read json data from the path assets/mobile_number_length.json
  if (kDebugMode) {
    log('getMaxLength ccode $cCode');
  }
  try {
    var data = await rootBundle.loadString('assets/mobile_number_length.json');
    var jsonData = json.decode(data);
    final phoneCodes = jsonData['phoneCodes'];
    for (final codeData in phoneCodes) {
      final phoneCode =
          PhoneCode(codeData['code'], List<int>.from(codeData['lengths']));
      if (phoneCode.code == cCode) {
        return phoneCode.lengths
            .reduce((value, element) => value > element ? value : element);
      }
    }

    return 20;
  } catch (e) {
    20;
  }
  return 20;
}

enum PhoneErrorType { invalid, rangeError, short, ok }
