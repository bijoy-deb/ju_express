import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';

import '../../../../core/error/error_message.dart';
import '../../../../di/injection.dart';
import '../../../../route/route_config.dart';
import '../../../utils/app_color.dart';
import '../../../utils/helper_functions.dart';
import '../../bloc/passenger_info/passenger_info_bloc.dart';
import '../../widgets/app_bar.dart';

class PaymentConfirmScreen extends StatefulWidget {
  const PaymentConfirmScreen(
      {required this.vuHash, required this.payId, super.key});
  final String vuHash;
  final String payId;
  @override
  State<PaymentConfirmScreen> createState() => _PaymentConfirmScreenState();
}

class _PaymentConfirmScreenState extends State<PaymentConfirmScreen> {
  final bloc = getIt<PassengerInfoBloc>();
  int maxAttempt = 2;
  late Timer timer;
  String error = "";
  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      bloc.add(CheckPayment(vHash: widget.vuHash, payID: widget.payId));
      maxAttempt--;
      if (maxAttempt <= 0) {
        timer.cancel();
        context.go(RoutePath.paymentFail, extra: error);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          bloc..add(CheckPayment(vHash: widget.vuHash, payID: widget.payId)),
      child: BlocListener<PassengerInfoBloc, PassengerInfoState>(
        listener: (context, state) {
          if (state is PaymentSuccess) {
            if (state.res.status == 1) {
              timer.cancel();
              getIt<AppRoute>()
                  .router
                  .push(RoutePath.ticketDetails, extra: state.res);
            } else {
              error = ErrorMessage.getErrorFromMsg(state.res.m).message;
            }
          } else if (state is PaymentFailed) {
            showToast(state.error.message, error: true);
          }
        },
        child: WillPopScope(
          onWillPop: () async {
            handleBack(context);
            return false;
          },
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor.parseColor(),
            appBar: MyAppBar(
              leading: IconButton(
                onPressed: () {
                  handleBack(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              title: AppLocalizations.of(context)!.payment_confirmation,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator()),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      AppLocalizations.of(context)!.checking_payment,
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                ),
              ),
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
        AppLocalizations.of(context)!.cancel_confirmation,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.yes,
        textColor: Colors.black,
        backgroundColor: Colors.white,
        onPressed: () {
          context.go(RoutePath.home);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
