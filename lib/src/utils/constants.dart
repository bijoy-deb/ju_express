import 'package:flutter/material.dart';
import 'package:ju_express/src/utils/custom_extensions.dart';

import 'app_color.dart';

class Constants {
  static const String appName = 'JU Express';
  static String currency = '';
  static const String dialCode = '+880';
  static const String countryCode = 'BD';
  static const String domain = 'www.juexpress.com';
  static const String email = 'info@juexpress.com';
  static const String webUrl = 'https://juexpress.co.tz/';

  static InputDecoration inputFieldDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderSide:
          BorderSide(width: 2, color: AppColors.primaryColor.parseColor()),
      borderRadius: BorderRadius.circular(6),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(width: 2, color: AppColors.primaryColor.parseColor()),
      borderRadius: BorderRadius.circular(6),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: "7b7b7b".parseColor()),
      borderRadius: BorderRadius.circular(6),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 2, color: Colors.red),
      borderRadius: BorderRadius.circular(6),
    ),
    contentPadding: const EdgeInsets.all(12),
    fillColor: Colors.white,
    filled: true,
  );

  static bool validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
