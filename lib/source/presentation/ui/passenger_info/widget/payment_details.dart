import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ju_express/source/data/model/passenger_info/cupon_details.dart';
import 'package:ju_express/source/presentation/ui/passenger_info/widget/passenger_input_layout.dart';

import '../../../../data/model/balance/balance_res.dart';
import '../../../../data/model/passenger_info/passenger_info_args.dart';
import '../../../../utils/helper_functions.dart';
import 'bus_card_layout.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails(
      {required this.controller,
      required this.infoArgs,
      required this.voucherApplied,
      required this.couponCodeRes,
      required this.busCardLayoutController,
      Key? key})
      : super(key: key);
  final PassengerInfoArgs infoArgs;
  final List<PassengerInputLayoutController> controller;
  final bool voucherApplied;
  final CouponCodeRes couponCodeRes;
  final BusCardLayoutController busCardLayoutController;

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  String selectedSeatString = "";
  double subTotal = 0;
  double processFee = 0;
  double discount = 0.0;
  double customerDiscount = 0.0;
  dynamic totalPayable = 0;

  @override
  void initState() {
    for (int i = 0; i < widget.infoArgs.seats.length; i++) {
      if (selectedSeatString.isNotEmpty) {
        selectedSeatString += ",${widget.infoArgs.seats[i].seatName}";
      } else {
        selectedSeatString = widget.infoArgs.seats[i].seatName;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    subTotal = getSubtotal();
    customerDiscount = calculateCustomerDiscount(
        widget.busCardLayoutController.balanceRes, subTotal - discount);

    processFee = widget.infoArgs.processFeeType == 1
        ? (widget.infoArgs.processFee / 100) * subTotal
        : widget.infoArgs.processFee * widget.infoArgs.seats.length;

    if (widget.voucherApplied) {
      discount = calculateVoucherDiscount(widget.couponCodeRes, subTotal);
    } else {
      discount = calculateSeatDiscount(widget.infoArgs, subTotal);
    }
    widget.infoArgs.totalPayable = subTotal + processFee - discount;
    widget.busCardLayoutController.totalPayable = totalPayable;
    setState(() {});

    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.payment_info,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 1,
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    )),
                Expanded(
                    child: Text(
                  withCurrencyFormat(
                      widget.busCardLayoutController.balanceRes?.customer
                              ?.balance ??
                          "0.0",
                      format: true,
                      symbol: true),
                  style: const TextStyle(fontSize: 15),
                )),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                    width: 120,
                    child: Text(
                      AppLocalizations.of(context)!.subtotal,
                      style: const TextStyle(fontSize: 15),
                    )),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Text(
                      ":",
                      style: TextStyle(fontSize: 15),
                    )),
                Expanded(
                    child: Text(
                  withCurrencyFormat(subTotal, format: true, symbol: true),
                  style: const TextStyle(fontSize: 15),
                )),
              ],
            ),
            if (discount > 0) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                      width: 120,
                      child: Text(
                        widget.voucherApplied
                            ? AppLocalizations.of(context)!.coupon_discount
                            : AppLocalizations.of(context)!.discount,
                        style: const TextStyle(fontSize: 15),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        ":",
                        style: TextStyle(fontSize: 15),
                      )),
                  Expanded(
                      child: Text(
                    withCurrencyFormat(
                      discount,
                    ),
                    style: const TextStyle(fontSize: 15),
                  )),
                ],
              ),
            ],
            if (processFee > 0) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                      width: 120,
                      child: Text(
                        AppLocalizations.of(context)!.processing_fee,
                        style: const TextStyle(fontSize: 15),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        ":",
                        style: TextStyle(fontSize: 15),
                      )),
                  Expanded(
                      child: Text(
                    withCurrencyFormat(
                      processFee,
                    ),
                    style: const TextStyle(fontSize: 15),
                  )),
                ],
              ),
            ],
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              withCurrencyFormat(widget.infoArgs.totalPayable,
                  symbol: true, format: true),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              AppLocalizations.of(context)!.total_payable,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }

  double getSubtotal() {
    double subTotal = 0;
    for (int i = 0; i < widget.infoArgs.seats.length; i++) {
      subTotal += getSeatPrice(
          tftID: widget.controller[i].selectFairType ?? "0",
          fareDetails: widget.infoArgs.seats[i].fareDetails!);
    }

    return subTotal;
  }

  double calculateVoucherDiscount(
      CouponCodeRes couponCodeRes, double subtotal) {
    double discount = 0.0;
    if (couponCodeRes.discountType == "1") {
      discount = subtotal * (double.parse(couponCodeRes.discount!) / 100);
    } else {
      discount =
          double.parse(couponCodeRes.discount!) * widget.infoArgs.seats.length;
    }
    return discount;
  }

  double calculateSeatDiscount(
      PassengerInfoArgs passengerInfo, double subtotal) {
    if (passengerInfo.departure.fareDetails?.discountDetails?.type == 1) {
      return (passengerInfo.departure.fareDetails!.discountDetails!.value! /
              100) *
          subtotal;
    }
    return passengerInfo.departure.fareDetails!.discountDetails!.value! *
        passengerInfo.seats.length;
  }

  double calculateCustomerDiscount(BalanceRes? args, double subtotal) {
    double discount = 0;
    if (args != null) {
      if (args.customer?.discountType == "1") {
        discount += (args.customer!.discount! / 100) * subtotal;
      } else {
        discount += args.customer!.discount! * widget.infoArgs.seats.length;
      }
    }

    return discount;
  }
}
