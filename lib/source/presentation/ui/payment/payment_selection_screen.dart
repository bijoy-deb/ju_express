import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ju_express/source/presentation/ui/payment/web_payment_screen.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';

import '../../../../core/error/error_message.dart';
import '../../../../di/injection.dart';
import '../../../../route/route_config.dart';
import '../../../data/model/passenger_info/ticket_sale_res.dart';
import '../../../utils/app_color.dart';
import '../../../utils/helper_functions.dart';
import '../../bloc/passenger_info/passenger_info_bloc.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/error_widget.dart';

class PaymentSelectionScreen extends StatefulWidget {
  const PaymentSelectionScreen({required this.saleRes, Key? key})
      : super(key: key);
  final TicketSaleRes saleRes;
  @override
  State<PaymentSelectionScreen> createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  int paymentMethod = 0;
  bool timeAvailable = true;
  final passengerBloc = getIt<PassengerInfoBloc>();
  double remainingTimeForPayment = 0.0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) async {
        handleBack(context);
      },
      canPop: false,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
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
            title: AppLocalizations.of(context)!.payment,
          ),
          backgroundColor: HexColor(AppColors.backgroundColor),
          body: BlocProvider(
            create: (context) => passengerBloc,
            child: !timeAvailable
                ? CustomErrorWidget(
                    errorMessage: ErrorMessage(
                      errorType: ErrorType.ERROR_WITH_MESSAGE,
                      message:
                          AppLocalizations.of(context)!.payment_time_exceeded,
                    ),
                    btnText: AppLocalizations.of(context)!.home,
                    onRetry: () {
                      context.go(RoutePath.home);
                    },
                  )
                : SingleChildScrollView(
                    child: Card(
                      margin: const EdgeInsets.all(10.0),
                      elevation: 3,
                      surfaceTintColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Center(
                                  child: TimerWidget(
                                      callback: (double sec) {
                                        remainingTimeForPayment = sec;
                                        if (sec <= 0) {
                                          timeAvailable = false;
                                        }
                                        setState(() {});
                                      },
                                      payWaitTime:
                                          widget.saleRes.payWaitTime ?? 100),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              AppLocalizations.of(context)!.time_remains,
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 22.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    "${AppLocalizations.of(context)!.total_payable}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    )),
                                const SizedBox(width: 10),
                                Text(
                                    "${withCurrencyFormat(widget.saleRes.total)}",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              AppLocalizations.of(context)!
                                  .select_payment_method,
                              style: const TextStyle(fontSize: 17.0),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Container(
                              color: Colors.black,
                              height: 1,
                              width: MediaQuery.of(context).size.width / 2,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: InkWell(
                                      onTap: () {
                                        paymentMethod = 0;
                                        setState(() {});
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Radio(
                                              value: 0,
                                              groupValue: paymentMethod,
                                              onChanged: (a) {
                                                paymentMethod = a!;
                                                setState(() {});
                                              }),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .stripe,
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                            const SizedBox(height: 2.0),
                            SizedBox(
                              height: 52,
                              width: double.infinity,
                              child: BlocConsumer<PassengerInfoBloc,
                                  PassengerInfoState>(
                                listener: (context, state) async {
                                  if (state is InvoiceCreateFailed) {
                                    showToast(state.error.message, error: true);
                                  } else if (state is InvoiceCreated) {
                                    if (state.res.status == 1) {
                                      try {
                                        Navigator.push(
                                            context,
                                            createRoute(WebPaymentScreen(
                                              url: state.res.link!,
                                              vuHash: widget.saleRes.vuHash!,
                                              payID: widget.saleRes.payId!,
                                            )));
                                      } catch (e) {
                                        showToast(
                                            AppLocalizations.of(context)!
                                                .something_went_wrong,
                                            error: true);
                                      }
                                    } else {
                                      showToast(
                                          ErrorMessage.getErrorFromMsg(
                                                  state.res.m)
                                              .message,
                                          error: true);
                                    }
                                  }
                                },
                                builder: (context, state) {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.secondaryColor.parseColor(),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    onPressed: state is CreatingInvoice
                                        ? () {}
                                        : () {
                                            passengerBloc.add(CreateInvoice(
                                              vHash: widget.saleRes.vuHash!,
                                              payID: widget.saleRes.payId!,
                                            ));
                                          },
                                    child: state is CreatingInvoice
                                        ? const SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            AppLocalizations.of(context)!
                                                .pay_now,
                                            style: const TextStyle(fontSize: 18),
                                          ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  handleBack(BuildContext context) {
    if (!timeAvailable) {
      context.go(RoutePath.home);
      return;
    }

    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(AppLocalizations.of(context)!.cancel_payment,
          style: const TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
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

class TimerWidget extends StatefulWidget {
  const TimerWidget(
      {required this.callback, required this.payWaitTime, super.key});
  final double payWaitTime;
  final Function(double) callback;
  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late double seconds = widget.payWaitTime * 60;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        widget.callback(seconds);
        if (seconds > 0) {
          seconds--;
        } else {
          t.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(getFormattedTime(seconds),
        style: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold));
  }
}

String getFormattedTime(double timeInSeconds) {
  int minutes = timeInSeconds ~/ 60;
  double seconds = timeInSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toInt().toString().padLeft(2, '0')}';
}
