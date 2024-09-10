import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ju_express/route/route_config.dart';

import 'package:ju_express/source/proviers/app_prefs.dart';
import 'package:ju_express/source/utils/app_color.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';
import 'package:provider/provider.dart';
import 'package:shared_value/shared_value.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'di/injection.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..maxConnectionsPerHost = 5
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

myMain() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = MyHttpOverrides();
    configLoading(HexColor(AppColors.primaryColor));
    await configureInjection();
    runApp(ChangeNotifierProvider(
      create: (context) => AppPrefs(),
      child: SharedValue.wrapApp(const MyApp()),
    ));
  }, (error, stackTrack) {});
}


void configLoading(Color color) {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 30.0
    ..radius = 5.0
    ..progressColor = Colors.white
    ..backgroundColor = color
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppPrefs>(
      builder: (context, prefs, child) {
        // configLoading(prefs.color);
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: prefs.locale,

          title: "Constants.appName",
          color: Colors.white,
          theme: ThemeData(
              useMaterial3: true,
              fontFamily: 'CenturyGothic',
              colorSchemeSeed: prefs.color,
              appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(color: Colors.white), // 1
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor.parseColor(),
                      foregroundColor: Colors.white,
                      textStyle:
                      const TextStyle(fontSize: 20, fontFamily: 'Vidaloka'),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: AppColors.primaryColor.parseColor(),
                          ),
                          borderRadius: BorderRadius.circular(5))))),
          routerConfig: getIt<AppRoute>().router,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}