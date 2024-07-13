import 'package:flutter/material.dart';
import 'package:ju_express/src/utils/custom_extensions.dart';

import '../data/local/shared_values.dart';
import '../utils/app_color.dart';

class AppPrefs extends ChangeNotifier {
  late Locale locale = Locale(
    locals.entries
        .firstWhere((element) => element.key == lnCode.$,
        orElse: () => locals.entries.first)
        .value['code']!,
  );
  Color color = AppColors.primaryColor.parseColor();
  static bool appDataLoaded = false;
  void changeLocale(String value) async {
    lnCode.$ = value;
    locale = Locale(
      locals.entries
          .firstWhere((element) => element.key == lnCode.$,
          orElse: () => locals.entries.first)
          .value['code']!,
    );

    notifyListeners();
  }

  Map<String, Map<String, String>> locals = {
    "1": {"code": "en", "name": "English"}
  };

  List<Locale> supportedLanguage = [
    const Locale('en'),
  ];

  void init() {
    locale = Locale(
      locals.entries
          .firstWhere((element) => element.key == lnCode.$,
              orElse: () => locals.entries.first)
          .value['code']!,
    );
    notifyListeners();
  }
}
