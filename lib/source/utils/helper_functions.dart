import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:android_download_manager/android_download_manager.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../di/injection.dart';
import '../../route/route_config.dart';
import '../data/local/app_shared_preferences.dart';
import '../data/model/common/district.dart';
import '../data/model/departure_list/departure_list.dart';
import '../data/model/download_ticket/download_ticket_res.dart';

import 'Constants.dart';
import 'app_images.dart';
import 'notification_service.dart';

recordError({required dynamic error, required StackTrace stack}) {
  FirebaseCrashlytics.instance.recordError(error, stack);
}

String getGenderFromInt(type) {
  if (type.toString() == "1") {
    return "Male";
  } else if (type.toString() == "2") {
    return "Female";
  } else {
    return "N/A";
  }
}

String getLicence() {
  if (Platform.isAndroid) {
    return "e5a2b7b6e575bcec43553db853d427fd";
  } else {
    return "e5a2b7b6e575bcec43553db853d427fd";
  }
}

Widget wrapWithContainer({required Widget child}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 5, bottom: 5, left: 0, right: 0),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black12)]),
    child: child,
  );
}

void showToast(String msg, {bool error = false, bool success = false}) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: error
        ? Colors.red
        : success
        ? Colors.green
        : Colors.white,
    textColor: !error && !success ? Colors.black : Colors.white,
    fontSize: 18.0,
  );
}

Future<bool?> handleStoragePermission() async {
  PermissionStatus status = await Permission.storage.request();
  if (status.isPermanentlyDenied) {
    return null;
  } else if (status.isDenied) {
    status = await Permission.storage.request();
    if (status.isDenied) {
      return false;
    }
  }
  return true;
}

showPermissionDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 12),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 150,
                child: Image.asset(
                  AppImages.logo,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.storage_permission_denied,
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              child: Text(
                AppLocalizations.of(context)!.open_settings,
              ),
              onPressed: () {
                openAppSettings();
              },
            )
          ],
        );
      });
}

Future<DateTime?> pickDate(
    {required DateTime selected,
      required BuildContext context,
      DateTime? start}) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selected,
    firstDate: start ?? DateTime.now(),
    lastDate: (start ?? DateTime.now()).add(
      const Duration(days: 365),
    ),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
  );
  return picked;
}

String withCurrencyFormat(dynamic value,
    {bool format = false, bool symbol = false}) {
  if (value is! String) {
    if (format && symbol) {
      return "${Constants.currency} ${NumberFormat("#,##0.00", "en_US").format(value)}";
    } else if (format) {
      return NumberFormat("#,##0.00", "en_US").format(value);
    }
  }
  return "${Constants.currency} $value";
}

bool isLeapYear(int year) =>
    (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

int daysInMonth(int year, int month) {
  const daysInMonth = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  return (month == DateTime.february && isLeapYear(year))
      ? 29
      : daysInMonth[month];
}

bool validateEmail(String value) {
  String pattern = r"^[^@]+@[^@]+\.[^@\.]{2,}$";
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

bool validatePassword(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

downloadTicket(TicketDetails ticketDetails, BuildContext context) async {
  String path;
  Directory directory = Platform.isAndroid
      ? Directory('/storage/emulated/0/Download')
      : await getApplicationDocumentsDirectory();
  String localPath = directory.path;

  final savedDir = Directory(localPath);
  bool hasExisted = await savedDir.exists();
  if (!hasExisted) {
    savedDir.create();
  }
  path = localPath;
  if (Platform.isAndroid) {
    try {
      showToast(AppLocalizations.of(context)!.file_downloading);

      if (await AndroidDownloadManager.enqueue(
        downloadUrl: ticketDetails.pdfLink!,
        downloadPath: '/storage/emulated/0/Download',
        fileName: ticketDetails.fileName!,
      ) >
          1) {
        showToast(AppLocalizations.of(context)!.file_downloaded, success: true);
      } else {
        showToast(AppLocalizations.of(context)!.something_went_wrong,
            error: true);
      }
    } catch (e) {
      showToast(AppLocalizations.of(context)!.something_went_wrong,
          error: true);
    }
  } else if (Platform.isIOS) {
    String filePath =
        "$path${Platform.pathSeparator}${ticketDetails.fileName!}";
    Dio dio = Dio();
    showToast(AppLocalizations.of(context)!.file_downloading);
    try {
      await dio.download(
        ticketDetails.pdfLink!,
        filePath,
        onReceiveProgress: (received, total) {
          if (received == total) {
            showToast(AppLocalizations.of(context)!.file_downloaded,
                success: true);
            NotificationService().showLocalNotification(
                id: Random().nextInt(100),
                title: getIt<PackageInfo>().appName,
                body:
                "Your ticket has been downloaded. ${ticketDetails.rTitle} (${ticketDetails.diPnr}). Tap to View",
                data: jsonEncode({"path": filePath}));
          }
        },
      );
    } catch (e) {
      showToast(AppLocalizations.of(context)!.something_went_wrong,
          error: true);
    }
  }
}

CustomTransitionPage createRoutePage(
    {required LocalKey pageKey, required Widget widget}) {
  return CustomTransitionPage(
    key: pageKey,
    child: widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route createRoute(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

double getSeatPrice({required String tftID, required FareDetails fareDetails}) {
  return fareDetails.fare!
      .firstWhere((element) => element.id == int.parse(tftID),
      orElse: () => fareDetails.fare!.first)
      .currencyFare!;
}

bool isMobileNumber(String value) {
  String pattern = r'^[0-9+-]+$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

Future<bool> logout() async {
  await getIt<AppSharedPrefs>().setAuthCode("");
  await getIt<AppSharedPrefs>().setVHash("");
  await getIt<AppSharedPrefs>().setFromCity(District());
  await getIt<AppSharedPrefs>().setToCity(District());
  return true;
}

InputDecoration customInputDecoration({
  String? labelText,
  String? hintText,
  Widget? suffixIcon,
  Widget? prefixIcon,
}) {
  return InputDecoration(
    errorMaxLines: 3,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
    border: const OutlineInputBorder(),
    labelText: labelText,
    hintText: hintText,
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
  );
}

void navigateToHome(BuildContext context) {
  while (context.canPop() == true) {
    context.pop();
  }
  context.pushReplacement(RoutePath.home);
}

RichText asteriskSignMethod({required bool isRequired, required String label}) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: label,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        if (isRequired)
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
      ],
    ),
  );
}

Widget showMobileNumber(
    {required BuildContext context,
      required String mobile,
      double fontSize = 15,
      Color color = Colors.black,
      TextDecoration textDecoration = TextDecoration.underline,
      FontWeight fontWeight = FontWeight.w400}) {
  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              surfaceTintColor: Colors.white,
              title: Text(mobile),
              actions: [
                TextButton(
                  onPressed: () async {
                    Uri uri = Uri(scheme: 'tel', path: mobile);
                    if (await canLaunchUrl(uri)) {
                      launchUrl(uri);
                    } else {
                      showToast(
                          AppLocalizations.of(context)!.something_went_wrong);
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.call),
                ),
                TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: mobile));
                    showToast(AppLocalizations.of(context)!.copied,
                        success: true);
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.copy),
                ),
              ],
            );
          });
    },
    child: Text(
      mobile,
      style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: 1.35,
          decoration: textDecoration,
          decorationColor: Colors.blue),
    ),
  );
}
