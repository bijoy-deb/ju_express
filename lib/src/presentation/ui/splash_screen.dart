import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../di/injection.dart';
import '../../../route/route_config.dart';
import '../../data/local/app_shared_preferences.dart';
import '../../data/local/shared_values.dart';
import '../../proviers/app_prefs.dart';
import '../../utils/app_color.dart';
import '../../utils/helper_functions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool isInternetConnected = true;
  String errorText = "";

  // Method to handle routing logic
  route() async {
    await getSharedValueHelperData();
    Provider.of<AppPrefs>(context, listen: false).init();

    // Check if the app is opened for the first time and navigate accordingly
    if (getIt<AppSharedPreferences>().getFirstTimeOpen()) {
      getIt<AppRoute>().router.go(RoutePath.initPage);
    } else {
      getIt<AppRoute>().router.go(RoutePath.initPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isInternetConnected
        ? Container(
            constraints: const BoxConstraints.expand(),
            color: HexColor(AppColors.primaryColor),
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                // Display a loading spinner
                const Expanded(
                    child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )),
                // Display the app version
                Text(
                  getIt<PackageInfo>().version,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: HexColor(AppColors.primaryColor),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display error message if there's no internet connection
                  Text(
                    errorText,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // Retry button to check internet connection again
                  ElevatedButton(
                    onPressed: () {
                      getIt<InternetConnectionChecker>()
                          .connectionStatus
                          .then((value) {
                        if (value == InternetConnectionStatus.connected) {
                          setState(() {
                            isInternetConnected = true;
                          });
                        } else {
                          setState(() {
                            errorText =
                                AppLocalizations.of(context)!.no_internet;
                            isInternetConnected = false;
                          });
                          showToast(errorText, error: true);
                        }
                      });
                    },
                    child: Text(
                      AppLocalizations.of(context)!.retry,
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
