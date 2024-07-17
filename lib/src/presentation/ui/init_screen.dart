import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ju_express/src/utils/custom_extensions.dart';
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


class InitScreen extends StatefulWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  State<InitScreen> createState() => InitScreenState();
}

class InitScreenState extends State<InitScreen> {
  AppSharedPreferences sp = getIt<AppSharedPreferences>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FlutterNativeSplash.remove();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor.parseColor(),
      body: Consumer<AppPrefs>(
        builder: (context, prefs, child) {
          return Padding(
            padding: const EdgeInsets.only(top: 150, bottom: 70),
            child: Column(

                children: [
                  Image.asset(
                    'assets/images/logo-white.png',
                    width: 273,
                    height: 82,
                    color: Colors.white,
                  ),
                  const Text(
                    "An effortless trip to your next destination",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),

                   Expanded(child: Container()),
                   Column(

                     mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Row(),
                      Container(
                        width: 250,
                        height: 50,
                        margin: const EdgeInsets.only(bottom: 25),
                        child: ElevatedButton(
                          onPressed: () async {
                            // prefs.changeLocale(e.key);
                            // await getIt<AppSharedPreferences>()
                            //     .setFirstTimeOpen(false);
                            // getIt<AppRoute>().router.go(RoutePath.home);
                          },
                          style: ElevatedButton.styleFrom(
                            //text color
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 3,
                                    color:
                                    HexColor(AppColors.secondaryColor)),
                                borderRadius: BorderRadius.circular(25)),
                            backgroundColor: HexColor(AppColors.secondaryColor),
                            foregroundColor: HexColor(AppColors.secondaryColor),
                          ),
                          child: const Text(
                            style: TextStyle(color: Colors.white),
                           "Login",
                          ),
                        ),
                      ),
                      Container(
                        width: 250,
                        height: 50,
                        margin: const EdgeInsets.only(bottom: 25),
                        child: ElevatedButton(
                          onPressed: () async {
                            // prefs.changeLocale(e.key);
                            // await getIt<AppSharedPreferences>()
                            //     .setFirstTimeOpen(false);
                            // getIt<AppRoute>().router.go(RoutePath.home);
                          },
                          style: ElevatedButton.styleFrom(
                            //text color
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 3,
                                    color:
                                    HexColor(AppColors.secondaryColor)),
                                borderRadius: BorderRadius.circular(25)),
                            backgroundColor: HexColor(AppColors.secondaryColor),
                            foregroundColor: HexColor(AppColors.secondaryColor),
                          ),
                          child: const Text(
                            style: TextStyle(color: Colors.white),
                            "Registration",
                          ),
                        ),
                      ),
                      const Text(
                        "Continue as Guest",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ]),
          );
        },
      ),
    );
  }
}

