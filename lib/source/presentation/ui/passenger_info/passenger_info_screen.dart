import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ju_express/source/data/local/app_shared_preferences.dart';
import 'package:ju_express/source/data/model/home/home_page_int_res.dart';
import 'package:ju_express/source/data/model/passenger_info/cupon_details.dart';
import 'package:ju_express/source/data/model/passenger_info/passenger_info_args.dart';
import 'package:ju_express/source/data/model/passenger_info/ticket_sale_prams.dart';
import 'package:ju_express/source/data/model/payment_confirm/trip_details.dart';
import 'package:ju_express/source/presentation/bloc/passenger_info/passenger_info_bloc.dart';
import 'package:ju_express/source/presentation/ui/passenger_info/widget/bus_card_layout.dart';
import 'package:ju_express/source/presentation/ui/passenger_info/widget/invoice_input_layout.dart';
import 'package:ju_express/source/presentation/ui/passenger_info/widget/passenger_input_layout.dart';
import 'package:ju_express/source/presentation/ui/passenger_info/widget/payment_details.dart';
import 'package:ju_express/source/presentation/ui/passenger_info/widget/trip_details.dart';
import 'package:ju_express/source/utils/Constants.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';
import 'package:ju_express/source/utils/helper_functions.dart';

import '../../../../core/error/error_message.dart';
import '../../../../di/injection.dart';
import '../../../../route/route_config.dart';
import '../../../data/model/departure_details/DepartureDetails.dart';
import '../../../utils/app_color.dart';
import '../../widgets/app_bar.dart';

class PassengerInfoScreen extends StatefulWidget {
  const PassengerInfoScreen({required this.infoArgs, Key? key})
      : super(key: key);
  final PassengerInfoArgs infoArgs;
  @override
  State<PassengerInfoScreen> createState() => _PassengerInfoScreenState();
}

class _PassengerInfoScreenState extends State<PassengerInfoScreen> {
  double discount = 0.0;
  double totalPayable = 0.0;
  String CuponCode = "";
  String discountType = "0";
  bool voucherApplied = false;

  TextEditingController textEditingControllerCoupon = TextEditingController();
  CouponCodeRes cuponCodeRes = CouponCodeRes(status: 0);
  List<GlobalKey> dataKey = [];
  GlobalKey keyInvoice = GlobalKey();
  FocusNode boardingFocus = FocusNode();
  FocusNode droppingFocus = FocusNode();
  GlobalKey boardingKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  TextEditingController boardingPoint = TextEditingController();
  TextEditingController droppingPoint = TextEditingController();
  Stoppage boarding = Stoppage();
  Stoppage dropping = Stoppage();
  InvoiceController invoiceInformationController = InvoiceController();
  List<PassengerInputLayoutController> controller = [];
  final bloc = getIt<PassengerInfoBloc>();
  bool isInvoiceValidationNeeded = false;
  bool isInvoice = false;
  bool havePromo = false;
  HomePageIntRes homePageIntRes = HomePageIntRes();
  AppSharedPrefs sp = getIt<AppSharedPrefs>();
  BusCardLayoutController busCardLayoutController = BusCardLayoutController();
  @override
  void initState() {
    if (widget.infoArgs.boardingList != null &&
        widget.infoArgs.boardingList!.isNotEmpty) {
      boarding = widget.infoArgs.boardingList!.first;
      boardingPoint.text = boarding.title!;
      widget.infoArgs.boarding = boarding;
    }
    if (widget.infoArgs.droppingList != null &&
        widget.infoArgs.droppingList!.isNotEmpty) {
      dropping = widget.infoArgs.droppingList!.first;
      droppingPoint.text = dropping.title!;
      widget.infoArgs.dropping = dropping;
    }
    homePageIntRes = sp.getHomePageInt();
    homePageIntRes.inputFields!.values.forEach((element) {
      if (element.type == "invoice") {
        if (element.fillable == 1) {
          isInvoice = true;
          print(element.id);
          if (element.isRequired == 1) {
            isInvoiceValidationNeeded = true;
            return;
          }
        }
      }
    });

    for (int i = 0; i < widget.infoArgs.seats.length; i++) {
      var c = PassengerInputLayoutController(widget.infoArgs.seats[i]);
      c.fairTypeChange = () {
        setState(() {});
      };
      controller.add(c);
      dataKey.add(GlobalKey());
    }
    dataKey.add(GlobalKey());
    busCardLayoutController.updateData = () {
      setState(() {});
    };
    totalPayable = widget.infoArgs.totalPayable;
    print("totalPayable is $totalPayable");
    super.initState();
  }

  void calculatePrice() {}
  bool isAgreed = true;
  final router = getIt<AppRoute>().router;
  @override
  Widget build(BuildContext context) {
    print("isInvoiceValidationNeeded ${widget.infoArgs.boarding}");
    totalPayable = widget.infoArgs.totalPayable;
    print("totalPayable is $totalPayable");
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor.parseColor(),
        appBar: const MyAppBar(),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      wrapWithContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.contact_info,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Column(
                              children: List.generate(
                                  widget.infoArgs.seats.length, (index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: index + 1 !=
                                              widget.infoArgs.seats.length
                                          ? 10
                                          : 0),
                                  child: PassengerInputLayout(
                                    key: dataKey[index],
                                    seats: widget.infoArgs.seats[index],
                                    controller: controller[index],
                                    fairTypes: widget.infoArgs.fairTypes,
                                    idTypes: widget.infoArgs.idTypes,
                                    isLead: index == 0 &&
                                        widget.infoArgs.seats.length > 1,
                                    fareDetails:
                                        widget.infoArgs.departure.fareDetails!,
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              AppLocalizations.of(context)!
                                  .ticket_will_be_sent_to,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      if (isInvoice)
                        wrapWithContainer(
                            child: InvoiceInputLayoutScreen(
                          key: keyInvoice,
                          passengerInfoArgs: widget.infoArgs,
                          invoiceController: invoiceInformationController,
                        )),
                      wrapWithContainer(
                        child: SizedBox(
                          key: boardingKey,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .stoppage_information,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.boarding_point,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: boardingPoint,
                                  focusNode: boardingFocus,
                                  readOnly: true,
                                  onTap: () async {
                                    Stoppage? selected = await router.push(
                                        RoutePath.selectBoardingDropping,
                                        extra: {
                                          'stoppage':
                                              widget.infoArgs.boardingList,
                                          'dropping': false
                                        }) as Stoppage?;
                                    if (selected != null) {
                                      boardingPoint.text = selected.title!;
                                      boarding = selected;
                                      widget.infoArgs.boarding = selected;
                                      setState(() {});
                                    }
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .select_boarding;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: const Icon(
                                      Icons.arrow_drop_down,
                                      size: 22,
                                    ),
                                    prefixIcon:
                                        const Icon(Icons.location_on_outlined),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 15),
                                    border: const OutlineInputBorder(),
                                    hintText: AppLocalizations.of(context)!
                                        .boarding_point,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.dropping_point,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: droppingPoint,
                                  focusNode: droppingFocus,
                                  readOnly: true,
                                  onTap: () async {
                                    Stoppage? selected = await router.push(
                                        RoutePath.selectBoardingDropping,
                                        extra: {
                                          'stoppage':
                                              widget.infoArgs.droppingList,
                                          'dropping': true
                                        }) as Stoppage?;
                                    if (selected != null) {
                                      droppingPoint.text = selected.title!;
                                      dropping = selected;
                                      widget.infoArgs.dropping = selected;
                                      setState(() {});
                                    }
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .select_dropping;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: const Icon(
                                      Icons.arrow_drop_down,
                                      size: 22,
                                    ),
                                    prefixIcon:
                                        const Icon(Icons.location_on_outlined),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 15),
                                    border: const OutlineInputBorder(),
                                    hintText: AppLocalizations.of(context)!
                                        .dropping_point,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      wrapWithContainer(
                          child: TripDetails(infoArgs: widget.infoArgs)),
                      wrapWithContainer(
                          child: BusCardLayout(
                        busCardLayoutController: busCardLayoutController,
                      )),

                      wrapWithContainer(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PaymentDetails(
                            busCardLayoutController: busCardLayoutController,
                            infoArgs: widget.infoArgs,
                            controller: controller,
                            couponCodeRes: cuponCodeRes,
                            voucherApplied: voucherApplied,
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                activeColor: HexColor(AppColors.primaryColor),
                                value: havePromo,
                                onChanged: (value) => setState(() {
                                  havePromo = !havePromo;
                                }),
                              ),
                              Text(
                                AppLocalizations.of(context)!.have_promo_code,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          if (havePromo)
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: discount > 0,
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    DottedBorder(
                                                      color: Colors.green,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                              decoration:
                                                                  const BoxDecoration(),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        4.0),
                                                                child: Text(
                                                                  "$CuponCode",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              )),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "$discount ${discountType == 1 ? "%" : Constants.currency} off",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 15,
                                                                    right: 8.0),
                                                            child: Row(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      voucherApplied =
                                                                          false;
                                                                      CuponCode =
                                                                          "";
                                                                      discount =
                                                                          0.0;
                                                                      textEditingControllerCoupon
                                                                          .clear();
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    color: Colors
                                                                        .red,
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                      visible: discount > 0,
                                      child: const SizedBox(height: 15)),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              textEditingControllerCoupon,
                                          onChanged: (value) {
                                            CuponCode = value;
                                            setState(() {});
                                          },
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            labelText:
                                                AppLocalizations.of(context)!
                                                    .promo_code,
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .promo_code,
                                            suffixIcon: BlocProvider(
                                              create: (context) => bloc,
                                              child: BlocListener<
                                                  PassengerInfoBloc,
                                                  PassengerInfoState>(
                                                listener:
                                                    (context, state) async {
                                                  if (state
                                                      is CouponCodeApplied) {
                                                    EasyLoading.dismiss();
                                                    if (state.res.status == 1) {
                                                      setState(() {
                                                        voucherApplied = true;
                                                        cuponCodeRes =
                                                            state.res;
                                                        discountType = state
                                                            .res.discountType!;
                                                        discount = double.parse(
                                                            state.res.discount
                                                                .toString());
                                                        CuponCode =
                                                            textEditingControllerCoupon
                                                                .text;
                                                      });
                                                    } else if (state
                                                            .res.status !=
                                                        1) {
                                                      voucherApplied = false;
                                                      CuponCode = "";
                                                      setState(() {
                                                        textEditingControllerCoupon
                                                            .clear();
                                                      });
                                                      showToast(
                                                          ErrorMessage
                                                                  .getErrorFromMsg(
                                                                      state.res
                                                                          .m)
                                                              .message,
                                                          error: true);
                                                    }
                                                  } else if (state
                                                      is PushFailed) {
                                                    EasyLoading.dismiss();
                                                    showToast(
                                                        state.error.message,
                                                        error: true);
                                                  }
                                                },
                                                child: TextButton(
                                                  onPressed: () {
                                                    if (bloc.state
                                                        is PushLoading) {
                                                      return;
                                                    }
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    if (CuponCode.isNotEmpty) {
                                                      bloc.add(CouponVerify(
                                                          couponCode: CuponCode,
                                                          dIDs: widget.infoArgs
                                                              .departure.dId!,
                                                          from: widget.infoArgs
                                                              .from.distId!,
                                                          to: widget.infoArgs.to
                                                              .distId!));
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg: AppLocalizations
                                                                  .of(context)!
                                                              .enter_cupon_code,
                                                          backgroundColor:
                                                              HexColor(AppColors
                                                                  .primaryColor),
                                                          textColor:
                                                              Colors.white);
                                                    }
                                                  },
                                                  child: BlocBuilder<
                                                      PassengerInfoBloc,
                                                      PassengerInfoState>(
                                                    builder: (context, state) {
                                                      if (state
                                                          is PushLoading) {
                                                        return const SizedBox(
                                                          height: 21,
                                                          width: 21,
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 2.0,
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                    Color>(
                                                              Colors
                                                                  .blue, // Change to your desired color
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        return const Text("Apply");
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            suffixStyle: TextStyle(
                                                color: HexColor(
                                                    AppColors.primaryColor),
                                                fontWeight: FontWeight.bold),
                                            border: const OutlineInputBorder(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      )),
                      // wrapWithContainer(
                      //   child: Transform.translate(
                      //     offset: Offset(-10, 0),
                      //     child: Row(
                      //       children: [
                      //         Checkbox(
                      //           key: dataKey.last,
                      //           value: isAgreed,
                      //           onChanged: (value) => setState(() {
                      //             isAgreed = !isAgreed;
                      //           }),
                      //         ),
                      //         Flexible(
                      //             child: RichText(
                      //           text: TextSpan(
                      //             text: AppLocalizations.of(context)!.i_agree,
                      //             style: TextStyle(
                      //               fontSize: 15,
                      //               color: AppColors.primaryColor.parseColor(),
                      //               fontWeight: FontWeight.w700,
                      //               fontFamily: 'CenturyGothic',
                      //             ),
                      //             children: [
                      //               TextSpan(
                      //                 text:
                      //                     " ${AppLocalizations.of(context)!.terms_and_conditions}, ",
                      //                 style: TextStyle(
                      //                   color:
                      //                       HexColor(AppColors.secondaryColor),
                      //                 ),
                      //                 recognizer: TapGestureRecognizer()
                      //                   ..onTap = () {
                      //                     router.push(RoutePath.staticContent,
                      //                         extra: 'termsAndConditions');
                      //                   },
                      //               ),
                      //               TextSpan(
                      //                 text: AppLocalizations.of(context)!
                      //                     .privacy_policy,
                      //                 style: TextStyle(
                      //                   color:
                      //                       HexColor(AppColors.secondaryColor),
                      //                 ),
                      //                 recognizer: TapGestureRecognizer()
                      //                   ..onTap = () {
                      //                     router.push(RoutePath.staticContent,
                      //                         extra: 'privacyPolicy');
                      //                   },
                      //               ),
                      //               TextSpan(
                      //                 text:
                      //                     " ${AppLocalizations.of(context)!.and} ",
                      //               ),
                      //               TextSpan(
                      //                 text:
                      //                     "${AppLocalizations.of(context)!.refund_policy}.",
                      //                 style: TextStyle(
                      //                   color:
                      //                       HexColor(AppColors.secondaryColor),
                      //                 ),
                      //                 recognizer: TapGestureRecognizer()
                      //                   ..onTap = () {
                      //                     router.push(RoutePath.staticContent,
                      //                         extra: 'refundPolicy');
                      //                   },
                      //               ),
                      //             ],
                      //           ),
                      //         ))
                      //       ],
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
            BlocProvider(
              create: (context) => bloc,
              child: BlocListener<PassengerInfoBloc, PassengerInfoState>(
                listener: (context, state) async {
                  if (state is TicketSaleLoading) {
                    EasyLoading.show();
                  } else if (state is TicketSaleSuccess) {
                    EasyLoading.dismiss();
                    if (state.ticketSaleRes.status == 1) {
                      TripDetailsPayment details = TripDetailsPayment(
                          saleRes: state.ticketSaleRes,
                          infoArgs: widget.infoArgs);
                      router.push(RoutePath.paymentSelectionScreen,
                          extra: state.ticketSaleRes);
                    } else if (state.ticketSaleRes.status != 1) {
                      showToast(
                          ErrorMessage.getErrorFromMsg(state.ticketSaleRes.m)
                              .message,
                          error: true);
                    }
                  } else if (state is TicketSaleFail) {
                    EasyLoading.dismiss();
                    showToast(state.error.message, error: true);
                  }
                },
                child: Material(
                  color: AppColors.secondaryColor.parseColor(),
                  child: InkWell(
                    onTap: () async {
                      FocusManager.instance.primaryFocus!.unfocus();
                      for (int i = 0; i < (controller.length); i++) {
                        var checkData = controller[i].checkData();
                        if (!checkData) {
                          Scrollable.ensureVisible(dataKey[i].currentContext!);
                          return;
                        }
                      }
                      if (isInvoiceValidationNeeded) {
                        var checkInvoiceData =
                            invoiceInformationController.checkData();
                        if (!checkInvoiceData) {
                          Scrollable.ensureVisible(keyInvoice.currentContext!);
                          return;
                        }
                      }
                      //boarding dropping validation with _formKey
                      if (!_formKey.currentState!.validate()) {
                        if (widget.infoArgs.boarding == null) {
                          Scrollable.ensureVisible(boardingKey.currentContext!);
                          showToast(
                              AppLocalizations.of(context)!.select_boarding,
                              error: true);
                          return;
                        }
                        if (widget.infoArgs.dropping == null) {
                          Scrollable.ensureVisible(boardingKey.currentContext!);
                          showToast(
                              AppLocalizations.of(context)!.select_dropping,
                              error: true);
                          return;
                        }
                      }
                      // if (!isAgreed) {
                      //   showToast(AppLocalizations.of(context)!.policy_agree,
                      //       error: true);
                      //   Scrollable.ensureVisible(dataKey.last.currentContext!);
                      //   return;
                      // }
                      proceed();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .proceed_to_pay
                              .toUpperCase(),
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  proceed() async {
    Map<String, String> seats = {};
    for (int i = 0; i < (controller.length); i++) {
      seats.addAll({
        "seats[$i][dsID]": controller[i].seat.dsID,
        if (homePageIntRes.inputFields!["type_seat"]!.fillable == 1)
          "seats[$i][tftID]": controller[i].selectFairType.toString(),
        if (homePageIntRes.inputFields!["frist_name_seat"]!.fillable == 1)
          "seats[$i][firstName]": controller[i].fNameController.text.toString(),
        if (homePageIntRes.inputFields!["last_name_seat"]!.fillable == 1)
          "seats[$i][lastName]": controller[i].lNameController.text.toString(),
        if (homePageIntRes.inputFields!["surname_seat"]!.fillable == 1)
          "seats[$i][sureName]":
              controller[i].surNameController.text.toString(),
        if (homePageIntRes.inputFields!["email_seat"]!.fillable == 1)
          "seats[$i][email]": controller[i].emailController.text.toString(),
        if (homePageIntRes.inputFields!["gender_seat"]!.fillable == 1)
          "seats[$i][sex]": controller[i].selectedGender.toString(),
        if (homePageIntRes.inputFields!["mobile_seat"]!.fillable == 1)
          "seats[$i][mobile]": controller[i].phoneController.text.toString(),
        if (homePageIntRes.inputFields!["mobile_seat"]!.fillable == 1)
          "seats[$i][cCode]": controller[i].cCode.toString(),
        if (homePageIntRes.inputFields!["passenger_id_type_seat"]!.fillable ==
            1)
          "seats[$i][idType]": controller[i].selectIdType ?? "",
        if (homePageIntRes.inputFields!["passenger_id_seat"]!.fillable == 1)
          "seats[$i][idNo]": controller[i].idNoController.text,
        if (homePageIntRes.inputFields!["altName_seat"]!.fillable == 1)
          "seats[$i][alternativeName]": controller[i].altNameController.text,
        if (homePageIntRes.inputFields!["altMobile_seat"]!.fillable == 1)
          "seats[$i][alternativeNumber]":
              "${controller[i].selectedCountry["dial_code"].toString()}${controller[i].altPhoneController.text}",
      });
    }
    TicketSalePrams ticketSalePrams = TicketSalePrams(
      vuHash: widget.infoArgs.vHash,
      from: widget.infoArgs.from.distId!,
      to: widget.infoArgs.to.distId!,
      date: widget.infoArgs.date.formatForApi(),
      dID: widget.infoArgs.departure.dId!,
      boarding: widget.infoArgs.boarding?.id ?? "",
      dropping: widget.infoArgs.dropping?.id ?? "",
      seats: seats,
      idType:
          homePageIntRes.inputFields!["passenger_id_type_invoice"]!.fillable ==
                  1
              ? invoiceInformationController.selectIdType.toString()
              : null,
      idNo: homePageIntRes.inputFields!["passenger_id_invoice"]!.fillable == 1
          ? invoiceInformationController.idNoController.text
          : null,
      cCode: homePageIntRes.inputFields!["altMobile_invoice"]!.fillable == 1
          ? invoiceInformationController.cCodeKin.toString()
          : null,
      alternativeNumber:
          homePageIntRes.inputFields!["altMobile_invoice"]!.fillable == 1
              ? invoiceInformationController.altPhoneController.text
              : null,
      firstName:
          homePageIntRes.inputFields!["frist_name_invoice"]!.fillable == 1
              ? invoiceInformationController.firstNameController.text
              : null,
      lastName: homePageIntRes.inputFields!["last_name_invoice"]!.fillable == 1
          ? invoiceInformationController.lastNameController.text
          : null,
      sureName: homePageIntRes.inputFields!["surname_invoice"]!.fillable == 1
          ? invoiceInformationController.surNameController.text
          : null,
      alternativeName:
          homePageIntRes.inputFields!["altName_invoice"]!.fillable == 1
              ? invoiceInformationController.altNameController.text
              : null,
      sex: homePageIntRes.inputFields!["gender_invoice"]!.fillable == 1
          ? invoiceInformationController.selectedGender.toString()
          : null,
      email: homePageIntRes.inputFields!["email_invoice"]!.fillable == 1
          ? invoiceInformationController.emailNameController.text
          : null,
      promoCode: CuponCode,
    );
    // print("sale data ${ticketSalePrams.toJson()}");
    bloc.add(TicketSaleEvent(ticketSalePrams));
  }
}
