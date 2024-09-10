import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../core/error/error_message.dart';
import '../../../../../di/injection.dart';
import '../../../../data/local/app_shared_preferences.dart';
import '../../../../data/model/balance/balance_res.dart';
import '../../../../data/model/home/home_page_int_res.dart';
import '../../../../utils/helper_functions.dart';
import '../../../bloc/passenger_info/passenger_info_bloc.dart';

class BusCardLayout extends StatefulWidget {
  const BusCardLayout({
    Key? key,
    required this.busCardLayoutController,
  }) : super(key: key);

  final BusCardLayoutController busCardLayoutController;

  @override
  State<BusCardLayout> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<BusCardLayout> {
  FocusNode busCardFocusNode = FocusNode();
  FocusNode pinFocusNode = FocusNode();
  final bloc = getIt<PassengerInfoBloc>();
  AppSharedPrefs sp = getIt<AppSharedPrefs>();
  late HomePageIntRes homePageIntRes = sp.getHomePageInt();
  @override
  void initState() {
    widget.busCardLayoutController.checkData = () {
      if (widget.busCardLayoutController.formKey.currentState!.validate()) {
        return true;
      }
      if (widget.busCardLayoutController.busCardController.text.isEmpty) {
        busCardFocusNode.requestFocus();
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.please_enter_your_card_number,
            backgroundColor: Colors.red);
        return false;
      } else if (widget.busCardLayoutController.pinController.text.isEmpty) {
        pinFocusNode.requestFocus();
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.please_enter_your_pin,
            backgroundColor: Colors.red);
        return false;
      } else {
        return true;
      }
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Form(
        key: widget.busCardLayoutController.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              AppLocalizations.of(context)!.passenger_info,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            const Divider(
              color: Colors.black,
              thickness: 1,
            ),
            if (widget.busCardLayoutController.balanceRes == null)
              const SizedBox(
                height: 5,
              ),
            if (widget.busCardLayoutController.balanceRes != null) ...[
              Row(
                children: [
                  SizedBox(
                      width: 120,
                      child: Text(
                        AppLocalizations.of(context)!.bus_card,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        ":",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      )),
                  Expanded(
                      child: Text(
                    widget.busCardLayoutController.balanceRes?.customer
                            ?.busCard ??
                        "",
                    style: const TextStyle(fontSize: 15),
                  )),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                      width: 120,
                      child: Text(
                        AppLocalizations.of(context)!.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        ":",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      )),
                  Expanded(
                      child: Text(
                    "${widget.busCardLayoutController.balanceRes?.customer?.firstName ?? ""} ${widget.busCardLayoutController.balanceRes?.customer?.lastName ?? ""}",
                    style: const TextStyle(fontSize: 15),
                  )),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                      width: 120,
                      child: Text(
                        AppLocalizations.of(context)!.mobile,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        ":",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      )),
                  Expanded(
                      child: Text(
                    "${widget.busCardLayoutController.balanceRes?.customer?.cCode ?? ""} ${widget.busCardLayoutController.balanceRes?.customer?.mobile ?? ""}",
                    style: const TextStyle(fontSize: 15),
                  )),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                      width: 120,
                      child: Text(
                        AppLocalizations.of(context)!.type,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        ":",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      )),
                  Expanded(
                      child: Text(
                    widget.busCardLayoutController.balanceRes?.customer
                            ?.tftTitle ??
                        "",
                    style: const TextStyle(fontSize: 15),
                  )),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                      width: 120,
                      child: Text(
                        AppLocalizations.of(context)!.balance,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        ":",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      )),
                  Expanded(
                      child: Text(
                    withCurrencyFormat(
                        widget.busCardLayoutController.balanceRes?.customer
                                ?.balance ??
                            "0.0",
                        symbol: true,
                        format: true),
                    style: const TextStyle(fontSize: 15),
                  )),
                ],
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              const SizedBox(
                height: 5,
              ),
            ],
            TextFormField(
              controller: widget.busCardLayoutController.busCardController,
              keyboardType: TextInputType.name,
              focusNode: busCardFocusNode,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!.enter_mobile;
                }
              },
              decoration: InputDecoration(
                counterText: "",
                border: const OutlineInputBorder(),
                label: asteriskSignMethod(
                    isRequired: true,
                    label: AppLocalizations.of(context)!.bus_card_or_mobile),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: widget.busCardLayoutController.pinController,
              focusNode: pinFocusNode,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!.please_enter_your_pin;
                }
              },
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.pin,
                border: const OutlineInputBorder(),
                label: asteriskSignMethod(
                  isRequired: true,
                  label: AppLocalizations.of(context)!.pin,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onPressed,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: BlocConsumer(
                  bloc: bloc,
                  builder: (context, state) {
                    if (state is CustomerBalanceLoding) {
                      return const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Colors.white,
                        ),
                      );
                    } else {
                      return Text(AppLocalizations.of(context)!.check_balance);
                    }
                  },
                  listener: (context, state) {
                    print("state is $state");
                    if (state is CustomerBalanceSuccess) {
                      if (state.res.status == 1) {
                        showToast(
                            ErrorMessage.getErrorFromMsg(state.res.m).message,
                            success: true);
                        widget.busCardLayoutController.updateData();
                      } else {
                        Fluttertoast.showToast(
                            msg: ErrorMessage.getErrorFromMsg(state.res.m!)
                                .message,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                      widget.busCardLayoutController.updateData();
                    } else if (state is CustomerBalanceFailed) {
                      Fluttertoast.showToast(
                          msg: state.error.message,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      widget.busCardLayoutController.updateData();
                    }
                    ;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed() {
    if (widget.busCardLayoutController.checkData()) {
      bloc.add(CustomerBalance(
          busCard:
              widget.busCardLayoutController.busCardController.text.toString(),
          pin: widget.busCardLayoutController.pinController.text.toString()));
    }
  }
}

class BusCardLayoutController extends ChangeNotifier {
  TextEditingController busCardController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  BalanceRes? balanceRes;
  dynamic totalPayable = 0;
  final formKey = GlobalKey<FormState>();
  bool Function() checkData = () {
    return false;
  };
  void Function() updateData = () {};
}
