import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../di/injection.dart';
import '../../../../route/route_config.dart';
import '../../../utils/app_color.dart';
import '../../widgets/app_bar.dart';

class PaymentFail extends StatefulWidget {
  const PaymentFail({required this.error, Key? key}) : super(key: key);
  final String? error;
  @override
  State<PaymentFail> createState() => _PaymentFailState();
}

class _PaymentFailState extends State<PaymentFail> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        getIt<AppRoute>().router.go(RoutePath.home);
        return false;
      },
      child: Scaffold(
        appBar: MyAppBar(
          leading: IconButton(
            onPressed: () {
              getIt<AppRoute>().router.go(RoutePath.home);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(
                   AppLocalizations.of(context)!.payment_failed,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    getIt<AppRoute>().router.go(RoutePath.home);
                  },
                  child: Text(AppLocalizations.of(context)!.home,
                      style: const TextStyle(color: Colors.white, fontSize: 18)),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        HexColor(AppColors.secondaryColor)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  handleBack(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        AppLocalizations.of(context)!.cancel_payment,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      action: SnackBarAction(
        label: "Yes",
        backgroundColor: Colors.white,
        textColor: Colors.black,
        onPressed: () {
          getIt<AppRoute>().router.go(RoutePath.home);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
