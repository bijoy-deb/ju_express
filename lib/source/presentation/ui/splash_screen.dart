import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ju_express/source/data/local/app_shared_preferences.dart';
import 'package:ju_express/source/utils/Constants.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../../../route/route_config.dart';
import '../../../core/network/network_info.dart';

import '../../../di/injection.dart';
import '../../proviers/app_prefs.dart';
import '../../utils/app_color.dart';
import '../../utils/helper_functions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  NetworkInfoImpl networkInfoImpl = getIt<NetworkInfoImpl>();
  PackageInfo packageInfo = getIt<PackageInfo>();
  bool errorOccurred = true;
  @override
  void initState() {
    getIt<InternetConnectionChecker>().connectionStatus.then((value) {
      if (value == InternetConnectionStatus.connected) {
        checkUpdate();
      } else {
        errorText = AppLocalizations.of(context)!.no_internet;
        errorOccurred = false;
        showToast(errorText, error: true);
        setState(() {});
      }
    });
    try {
      FirebaseMessaging.instance.getToken().then((value) {
        Constants.pushID = value!;
      });
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  route() async {
    Provider.of<AppPrefs>(context, listen: false).init();
    if (getIt<AppSharedPrefs>().getFirstEntry()) {
      getIt<AppRoute>().router.go(RoutePath.onBoard);
    } else {
      getIt<AppRoute>().router.go(RoutePath.home);
    }
  }

  String errorText = "";
  @override
  Widget build(BuildContext context) {
    return errorOccurred
        ? Container(
            constraints: const BoxConstraints.expand(),
            color: HexColor(AppColors.primaryColor),
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                const Expanded(
                    child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )),
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
                  Text(
                    errorText,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      getIt<InternetConnectionChecker>()
                          .connectionStatus
                          .then((value) {
                        if (value == InternetConnectionStatus.connected) {
                          setState(() {
                            errorOccurred = true;
                          });
                          checkUpdate();
                        } else {
                          setState(() {
                            errorText =
                                AppLocalizations.of(context)!.no_internet;
                            errorOccurred = false;
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

  Future<void> checkUpdate() async {
    if (await checkForUpdate()) {
      if (Platform.isAndroid) {
        var result = await InAppUpdate.performImmediateUpdate();
        if (result != AppUpdateResult.success) {
          errorOccurred = false;

          setState(() {});
        } else {
          route();
        }
      } else {
        final newVersionPlus = NewVersionPlus(iOSId: packageInfo.packageName);
        final status = await newVersionPlus.getVersionStatus();

        newVersionPlus.showUpdateDialog(
            context: context,
            dialogText:
                "${AppLocalizations.of(context)!.update_text} ${status?.localVersion} to ${status?.storeVersion} ",
            versionStatus: status!,
            allowDismissal: false);
      }
    } else {
      route();
    }
  }

  Future<bool> checkForUpdate() async {
    bool isNeedUpdate = false;
    if (Platform.isAndroid) {
      await InAppUpdate.checkForUpdate().then((info) {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          isNeedUpdate = true;
        }
      }).catchError((e) {
        log(e.toString());
      });
    } else {
      final newVersionPlus = NewVersionPlus(iOSId: packageInfo.packageName);
      final status = await newVersionPlus.getVersionStatus();
      isNeedUpdate = status?.canUpdate ?? false;
    }

    return isNeedUpdate;
  }
}
