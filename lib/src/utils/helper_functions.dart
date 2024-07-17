import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app_images.dart';
import 'constants.dart';


recordError({required dynamic error, required StackTrace stack}) {
  // FirebaseCrashlytics.instance.recordError(error, stack);
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
    return "7faacbe6a18e525184e5157b29757b07";
  } else {
    return "d0293fbe7fa35ddbe46c63f5a4697206";
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
    fontSize: 16.0,
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
          insetPadding: EdgeInsets.symmetric(horizontal: 12),
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
    {required DateTime selected, required BuildContext context}) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selected,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(
      const Duration(days: 365),
    ),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
  );
  return picked;
}

String withCurrencyFormat(dynamic value,
    {bool format = true, bool symbol = true}) {
  if (value is! String) {
    if (format && symbol) {
      return "${Constants.currency} ${NumberFormat("#,##0.00", "en_US").format(value)}";
    } else if (format) {
      return NumberFormat("#,##0.00", "en_US").format(value);
    }
  }
  return "${Constants.currency} $value";
}

double getPriceFromCPrice(dynamic value) {
  double price = 0;
  if (value is Map) {
    var keys = value.keys.toList();
    price = value[keys.first].toDouble();
  } else if (value is List) {
    price = value[0].toDouble();
  }
  return price;
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

// downloadTicket(TicketDetails ticketDetails, BuildContext context) async {
//   String path;
//   Directory directory = Platform.isAndroid
//       ? Directory('/storage/emulated/0/Download')
//       : await getApplicationDocumentsDirectory();
//   String localPath = directory.path;
//
//   final savedDir = Directory(localPath);
//   bool hasExisted = await savedDir.exists();
//   if (!hasExisted) {
//     savedDir.create();
//   }
//   path = localPath;
//   if (Platform.isAndroid) {
//     try {
//       showToast(AppLocalizations.of(context)!.file_downloading);
//
//       if (await AndroidDownloadManager.enqueue(
//             downloadUrl: ticketDetails.pdfLink!,
//             downloadPath: '/storage/emulated/0/Download',
//             fileName: ticketDetails.fileName!,
//           ) >
//           1) {
//         showToast(AppLocalizations.of(context)!.file_downloaded, success: true);
//       } else {
//         showToast(AppLocalizations.of(context)!.something_went_wrong,
//             error: true);
//       }
//     } catch (e) {
//       showToast(AppLocalizations.of(context)!.something_went_wrong,
//           error: true);
//     }
//   } else if (Platform.isIOS) {
//     String filePath =
//         "$path${Platform.pathSeparator}${ticketDetails.fileName!}";
//     Dio dio = Dio();
//     showToast(AppLocalizations.of(context)!.file_downloading);
//     try {
//       await dio.download(
//         ticketDetails.pdfLink!,
//         filePath,
//         onReceiveProgress: (received, total) {
//           if (received == total) {
//             showToast(AppLocalizations.of(context)!.file_downloaded,
//                 success: true);
//             NotificationService().showLocalNotification(
//                 id: Random().nextInt(100),
//                 title: GetIt.instance<PackageInfo>().appName,
//                 body:
//                     "${AppLocalizations.of(context)!.your_ticket_has_been_downloaded}. ${ticketDetails.rTitle} (${ticketDetails.diPnr}). ${AppLocalizations.of(context)!.tap_to_view}",
//                 data: jsonEncode({"path": filePath}));
//           }
//         },
//       );
//     } catch (e) {
//       showToast(AppLocalizations.of(context)!.something_went_wrong,
//           error: true);
//     }
//   }
// }

// double getSeatPrice({required String tftID, required FareDetails fareDetails}) {
//   return fareDetails.fare!
//       .firstWhere((element) => element.id == int.parse(tftID),
//           orElse: () => fareDetails.fare!.first)
//       .currencyFare!;
// }
