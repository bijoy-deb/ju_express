import 'dart:io';
import 'dart:math';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ju_express/core/error/error_message.dart';
import 'package:ju_express/source/presentation/bloc/download_ticket/download_ticket_bloc.dart';
import 'package:ju_express/source/presentation/widgets/header.dart';
import 'package:ju_express/source/presentation/widgets/loader.dart';
import 'package:ju_express/source/utils/Constants.dart';
import 'package:ju_express/source/utils/app_color.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';
import 'package:ju_express/source/utils/helper_functions.dart';
import 'package:ju_express/source/utils/phone_validation.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../di/injection.dart';
import '../../../data/model/download_ticket/download_ticket_res.dart';
import '../../../utils/app_images.dart';

class DownloadTicketScreen extends StatefulWidget {
  const DownloadTicketScreen({Key? key}) : super(key: key);

  @override
  State<DownloadTicketScreen> createState() => _DownloadTicketScreenState();
}

class _DownloadTicketScreenState extends State<DownloadTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  String dialCode = Constants.dialCode;
  TextEditingController pnr = TextEditingController();
  TextEditingController mobile = TextEditingController();
  FocusNode pnrFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  final bloc = getIt<DownloadTicketBloc>();
  late final String path;
  int maxPhoneLength = 15;
  String phoneErrorText = "";
  bool isLoading = false;
  List<TicketDetails> ticketDetails = [];
  ExpansionTileController expansionTileController = ExpansionTileController();
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      maxPhoneLength = await getMaxLength(Constants.dialCode);

      setState(() {});
    });
    _setPath();
    super.initState();
  }

  void _setPath() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: BlocProvider(
        create: (context) => bloc,
        child: Column(
          children: [
            const Header(),
            Flexible(
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(blurRadius: 5, color: Colors.black12)
                          ]),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        controller: expansionTileController,
                        title: Text(
                          "${AppLocalizations.of(context)!.download_ticket_msg}",
                          style: TextStyle(fontSize: 17),
                        ),
                        tilePadding: EdgeInsets.zero,
                        shape: InputBorder.none,
                        children: [
                          const Divider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  focusNode: pnrFocus,
                                  controller: pnr,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .enter_pnr;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                        Icons.confirmation_number_outlined),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 15),
                                    border: OutlineInputBorder(),
                                    label: Text(AppLocalizations.of(context)!
                                        .pnr
                                        .toUpperCase()),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  focusNode: mobileFocus,
                                  controller: mobile,
                                  maxLength: maxPhoneLength,
                                  onChanged: _onChangeHandler,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      phoneErrorText =
                                          AppLocalizations.of(context)!
                                              .enter_mobile;
                                    } else if (phoneErrorText.isEmpty) {
                                      return null;
                                    }
                                    return phoneErrorText;
                                  },
                                  decoration: InputDecoration(
                                    counterText: "",
                                    prefixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CountryCodePicker(
                                          padding: EdgeInsets.zero,
                                          barrierColor: Colors.black12,
                                          onChanged: (value) async {
                                            dialCode = value.dialCode! ?? "";

                                            mobile.text = "";
                                            maxPhoneLength = await getMaxLength(
                                                value.dialCode!);
                                            setState(() {
                                              print(
                                                  "maxPhoneLength   :  $maxPhoneLength");
                                            });
                                          },
                                          initialSelection:
                                              Constants.countryCode,
                                          searchDecoration:
                                              const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  contentPadding:
                                                      EdgeInsets.all(3)),
                                          dialogTextStyle: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          favorite: const [
                                            Constants.dialCode,
                                            Constants.countryCode
                                          ],
                                          countryList: codes,
                                          showCountryOnly: false,
                                          showFlag: false,
                                          showDropDownButton: false,
                                          showOnlyCountryWhenClosed: false,
                                          alignLeft: false,
                                        ),
                                        Transform.translate(
                                            offset: Offset(-12, 0),
                                            child: Icon(Icons.arrow_drop_down)),
                                        Transform.translate(
                                          offset: Offset(-10, 0),
                                          child: Container(
                                            width: 1,
                                            height: 30,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    errorText: phoneErrorText.isNotEmpty
                                        ? phoneErrorText
                                        : null,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 15),
                                    border: OutlineInputBorder(),
                                    label: Text(
                                        AppLocalizations.of(context)!.mobile),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: BlocConsumer<DownloadTicketBloc,
                                      DownloadTicketState>(
                                    listener: (context, state) async {
                                      if (state is DownloadTicketError) {
                                        ticketDetails.clear();
                                        setState(() {});
                                        showToast(state.error.message,
                                            error: true);
                                      } else if (state
                                          is DownloadTicketLoaded) {
                                        if (state.res.status == 1) {
                                          ticketDetails =
                                              state.res.ticketDetails!;
                                          expansionTileController.collapse();
                                          setState(() {});
                                        } else if (state.res.status != 1) {
                                          ticketDetails.clear();
                                          setState(() {});
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
                                            padding: const EdgeInsets.all(15),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            backgroundColor: AppColors
                                                .secondaryColor
                                                .parseColor()),
                                        onPressed: (state
                                                is DownloadTicketLoading)
                                            ? () {}
                                            : () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  FocusManager
                                                      .instance.primaryFocus!
                                                      .unfocus();

                                                  bloc.add(
                                                      GetDownloadTicketData(
                                                          cCode: dialCode,
                                                          mobile: mobile
                                                              .text
                                                              .trim(),
                                                          pnr:
                                                              pnr.text.trim()));
                                                } else if (pnr.text.isEmpty) {
                                                  pnrFocus.requestFocus();
                                                } else if (mobile
                                                    .text.isEmpty) {
                                                  mobileFocus.requestFocus();
                                                }
                                              },
                                        child: (state is DownloadTicketLoading)
                                            ? const CircleLoader()
                                            : Text(
                                                AppLocalizations.of(context)!
                                                    .search,
                                              ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (ticketDetails.isNotEmpty)
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          for (TicketDetails e in ticketDetails) ...[
                            Padding(
                              padding: const EdgeInsets.all(12.0)
                                  .copyWith(bottom: 0),
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15, bottom: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    border: Border.all(
                                                      color: Colors.grey
                                                          .withOpacity(.5),
                                                      width: 2,
                                                    ),
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          AppImages.avatar),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        e.name ?? "",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      showMobileNumber(
                                                        mobile:
                                                            "${e.cCode ?? ""}${e.mobile ?? ""}",
                                                        context: context,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        textDecoration:
                                                            TextDecoration.none,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                              children: [
                                                MyArc(
                                                    diameter: 30, isLeft: true),
                                                Expanded(child: MySeparator()),
                                                MyArc(
                                                    diameter: 30,
                                                    isLeft: false),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0, right: 15.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .from,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black38,
                                                          ),
                                                        ),
                                                        Text(
                                                          e.from ?? "",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 17,
                                                            color: AppColors
                                                                .primaryColor
                                                                .parseColor(),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          e!.boarding ?? "",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: 10,
                                                            width: 10,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    color: AppColors
                                                                        .primaryColor
                                                                        .parseColor(),
                                                                    width: 2)),
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                            height: 2,
                                                            child: Container(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .primaryColor
                                                                  .parseColor(),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          55),
                                                            ),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            child: const Icon(
                                                              Icons
                                                                  .directions_bus,
                                                              size: 22,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                            height: 2,
                                                            child: Container(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 10,
                                                            width: 10,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    color: AppColors
                                                                        .primaryColor
                                                                        .parseColor(),
                                                                    width: 2)),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 2,
                                                      ),
                                                    ],
                                                  )),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .to,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black38,
                                                          ),
                                                        ),
                                                        Text(
                                                          e.to ?? "",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .primaryColor
                                                                .parseColor(),
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          e.dropping ?? "",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0, right: 15.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "${e.journyDate ?? ""} ${e.departureTime ?? ""}",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                              children: [
                                                MyArc(
                                                    diameter: 30, isLeft: true),
                                                Expanded(child: MySeparator()),
                                                MyArc(
                                                    diameter: 30,
                                                    isLeft: false),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0, right: 15.0),
                                              child: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .pnr,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                            Text(
                                                              e.diPnr ?? "",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .coach,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                            Text(
                                                              e.coach ?? "",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .seats,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                            Text(
                                                              e.seatNames ?? "",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .fare,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      Text(
                                                        e.salePriceCrSymbol ??
                                                            "",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    backgroundColor:
                                        AppColors.secondaryColor.parseColor()),
                                onPressed: isLoading
                                    ? () {}
                                    : () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await downloadTicket(
                                            ticketDetails.first, context);
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                child: isLoading
                                    ? const CircleLoader()
                                    : Text(
                                        AppLocalizations.of(context)!
                                            .download_ticket,
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onChangeHandler(String value) async {
    if (kDebugMode) {}
    if (value.isEmpty) {
      phoneErrorText = AppLocalizations.of(context)!.enter_mobile;
    } else {
      Map isPhoneValid = await phoneLengthCheck(value.trim(), dialCode!);

      if (isPhoneValid['status']) {
        phoneErrorText = "";
      } else {
        if (isPhoneValid['type'] == PhoneErrorType.invalid) {
          phoneErrorText = AppLocalizations.of(context)!.invalid_mobile_no;
        } else if (isPhoneValid['type'] == PhoneErrorType.short) {
          phoneErrorText =
              "${AppLocalizations.of(context)!.phone_number_must_be} ${isPhoneValid['digit']} ${AppLocalizations.of(context)!.digits}";
        } else if (isPhoneValid['type'] == PhoneErrorType.rangeError) {
          phoneErrorText =
              "${AppLocalizations.of(context)!.phone_number_between} ${isPhoneValid['min']} ${AppLocalizations.of(context)!.and} ${isPhoneValid['max']} ${AppLocalizations.of(context)!.digits}";
        } else {
          phoneErrorText = "";
        }
      }
      if (kDebugMode) {}
    }

    setState(() {});
  }
}

class MyArc extends StatelessWidget {
  final double diameter;
  final bool isLeft;

  const MyArc({super.key, this.diameter = 30, this.isLeft = true});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
        widthFactor: 0.5,
        child: CustomPaint(
          painter: isLeft ? MyPainterLeft() : MyPainterRight(),
          size: Size(diameter, diameter),
        ),
      ),
    );
  }
}

class MyPainterLeft extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = AppColors.backgroundColor.parseColor();
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
      1.5 * pi,
      pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MyPainterRight extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = AppColors.backgroundColor.parseColor();

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
      0.5 * pi,
      pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black38})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
