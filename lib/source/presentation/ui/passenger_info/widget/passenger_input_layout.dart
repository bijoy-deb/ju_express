import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ju_express/source/data/local/app_shared_preferences.dart';
import 'package:ju_express/source/data/model/departure_details/DepartureDetails.dart';
import 'package:ju_express/source/data/model/departure_list/departure_list.dart';
import 'package:ju_express/source/data/model/home/home_page_int_res.dart';
import 'package:ju_express/source/utils/helper_functions.dart';
import 'package:ju_express/source/utils/phone_validation.dart';

import '../../../../../di/injection.dart';
import '../../../../data/model/departure_details/BusSeat.dart';
import '../../../../utils/Constants.dart';

class PassengerInputLayout extends StatefulWidget {
  const PassengerInputLayout({
    Key? key,
    required this.seats,
    required this.fairTypes,
    required this.controller,
    required this.idTypes,
    required this.isLead,
    required this.fareDetails,
  }) : super(key: key);
  final BusSeat seats;
  final List<FairType> fairTypes;
  final List<IdTypes> idTypes;
  final FareDetails fareDetails;
  final PassengerInputLayoutController controller;
  final bool isLead;

  @override
  State<PassengerInputLayout> createState() => _PassengerInputLayoutState();
}

class _PassengerInputLayoutState extends State<PassengerInputLayout> {
  bool isLoading = false;
  List<DropdownMenuItem<String>> dropdownMenuItemGender = [
    const DropdownMenuItem(value: "1", child: Text("Male")),
    const DropdownMenuItem(value: "2", child: Text("Female")),
  ];

  List<DropdownMenuItem<String>> dropdownMenuItemIdType = [];
  List<DropdownMenuItem<String>> dropdownMenuItemFairType = [];

  FocusNode focusNodePhone = FocusNode();
  FocusNode focusNodeFName = FocusNode();
  FocusNode focusNodeLName = FocusNode();
  FocusNode focusNodeSurName = FocusNode();

  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodeGender = FocusNode();
  FocusNode focusNodeType = FocusNode();
  FocusNode focusNodeAltName = FocusNode();
  FocusNode focusNodeAltPhone = FocusNode();
  FocusNode focusNodeIdNo = FocusNode();
  FocusNode focusNodePassengerIdType = FocusNode();
  int maxPhoneLength = 15;
  String errorTextEmail = "";
  String dialCode = Constants.dialCode;
  AppSharedPrefs sp = getIt<AppSharedPrefs>();
  late HomePageIntRes homePageIntRes = sp.getHomePageInt();
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      maxPhoneLength = await getMaxLength(Constants.dialCode);
      print("maxPhoneLength   :  $maxPhoneLength");

      setState(() {});
    });
    for (var i = 0; i < widget.fairTypes.length; i++) {
      dropdownMenuItemFairType.add(DropdownMenuItem(
          value: widget.fairTypes[i].tftId,
          child: Text(widget.fairTypes[i].tftTitle!)));
    }
    for (var i = 0; i < widget.idTypes.length; i++) {
      dropdownMenuItemIdType.add(DropdownMenuItem(
          value: widget.idTypes[i].id, child: Text(widget.idTypes[i].title!)));
    }

    widget.controller.checkData = () {
      if (homePageIntRes.inputFields!["mobile_seat"]!.isRequired == 1 &&
          widget.controller.phoneController.text.length < maxPhoneLength) {
        showToast(AppLocalizations.of(context)!.enter_mobile, error: true);
        focusNodePhone.requestFocus();
        return false;
      } else if (homePageIntRes.inputFields!["frist_name_seat"]!.isRequired ==
              1 &&
          widget.controller.fNameController.text.isEmpty) {
        showToast(AppLocalizations.of(context)!.enter_first_name, error: true);
        focusNodeFName.requestFocus();
        return false;
      } else if (homePageIntRes.inputFields!["last_name_seat"]!.isRequired ==
              1 &&
          widget.controller.lNameController.text.isEmpty) {
        showToast(AppLocalizations.of(context)!.enter_last_name, error: true);
        focusNodeLName.requestFocus();
        return false;
      } else if (homePageIntRes.inputFields!["surname_seat"]!.isRequired == 1 &&
          widget.controller.surNameController.text.isEmpty) {
        showToast(AppLocalizations.of(context)!.enter_surname, error: true);
        focusNodeSurName.requestFocus();
        return false;
      } else if (homePageIntRes.inputFields!["gender_seat"]!.isRequired == 1 &&
          widget.controller.selectedGender == null) {
        showToast(AppLocalizations.of(context)!.select_gender, error: true);
        openDropdown(genderKey);
        focusNodeGender.requestFocus();
        return false;
      } else if (homePageIntRes.inputFields!["type_seat"]!.isRequired == 1 &&
          widget.controller.selectFairType == null) {
        showToast(AppLocalizations.of(context)!.select_type, error: true);
        openDropdown(fairTypeKey);
        focusNodeType.requestFocus();
        return false;
      } else if ((homePageIntRes.inputFields!["email_seat"]!.isRequired == 1) &&
          (widget.controller.emailController.text.isEmpty ||
              !Constants.validateEmail(
                  widget.controller.emailController.text))) {
        showToast(AppLocalizations.of(context)!.enter_valid_email, error: true);
        focusNodeEmail.requestFocus();
        return false;
      } else if ((homePageIntRes.inputFields!["altName_seat"]!.isRequired ==
              1) &&
          (widget.controller.altNameController.text.isEmpty)) {
        showToast(AppLocalizations.of(context)!.enter_kin_name, error: true);
        focusNodeAltName.requestFocus();
        return false;
      } else if ((homePageIntRes.inputFields!["altMobile_seat"]!.isRequired ==
              1) &&
          widget.controller.altPhoneController.text.length < maxPhoneLength) {
        showToast(AppLocalizations.of(context)!.enter_kin_phone, error: true);
        focusNodeAltPhone.requestFocus();
        return false;
      } else if (homePageIntRes
                  .inputFields!["passenger_id_type_seat"]!.isRequired ==
              1 &&
          widget.controller.selectIdType == null) {
        showToast(AppLocalizations.of(context)!.select_passenger_id_type,
            error: true);
        focusNodePassengerIdType.requestFocus();

        return false;
      } else if ((widget.controller.selectIdType != "6" &&
              widget.controller.selectIdType != null) &&
          widget.controller.idNoController.text.isEmpty) {
        focusNodeIdNo.requestFocus();
        showToast(
            "${AppLocalizations.of(context)!.please_enter_your} ${widget.idTypes.firstWhere((element) => element.id == widget.controller.selectIdType, orElse: () => IdTypes(id: "", noLabel: "ID no")).noLabel!.toLowerCase()}",
            error: true);

        return false;
      } else {
        return true;
      }
    };

    super.initState();
  }

  GlobalKey genderKey = GlobalKey();
  GlobalKey fairTypeKey = GlobalKey();

  void openDropdown(GlobalKey key) {
    try {
      GestureDetector detector = GestureDetector();
      void searchForGestureDetector(BuildContext element) {
        element.visitChildElements((element) {
          if (element.widget is GestureDetector) {
            detector = element.widget as GestureDetector;
            return;
          } else {
            searchForGestureDetector(element);
          }

          return;
        });
      }

      searchForGestureDetector(key.currentContext!);

      detector.onTap!();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(6)),
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.event_seat,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.seat} ${widget.seats.seatName}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        if (widget.isLead)
                          Text(
                            "(${AppLocalizations.of(context)!.lead_passenger})",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                      ],
                    )
                  ],
                ),
              ),
              //i want to show the seat price
              Text(
                withCurrencyFormat(
                  getSeatPrice(
                      tftID: widget.controller.selectFairType ?? "0",
                      fareDetails: widget.fareDetails),
                ),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          if (homePageIntRes.inputFields!["mobile_seat"]!.fillable == 1)
            const SizedBox(
              height: 10,
            ),
          if (homePageIntRes.inputFields!["mobile_seat"]!.fillable == 1)
            TextFormField(
              controller: widget.controller.phoneController,
              keyboardType: TextInputType.phone,
              focusNode: focusNodePhone,
              maxLength: maxPhoneLength,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: _onChangeHandler,
              validator: (value) {
                if (value!.isEmpty) {
                  widget.controller.phoneErrorText =
                      AppLocalizations.of(context)!.enter_mobile;
                } else if (widget.controller.phoneErrorText.isEmpty) {
                  return null;
                }
                return widget.controller.phoneErrorText;
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
                        widget.controller.cCode = value.dialCode!;

                        dialCode = value.dialCode! ?? "";
                        widget.controller.phoneController.text = "";
                        maxPhoneLength = await getMaxLength(value.dialCode!);
                        setState(() {
                          print("maxPhoneLength   :  $maxPhoneLength");
                        });
                      },
                      initialSelection: Constants.countryCode,
                      searchDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(3)),
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
                        offset: const Offset(-12, 0),
                        child: const Icon(Icons.arrow_drop_down)),
                    Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Container(
                        width: 1,
                        height: 30,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                errorText: widget.controller.phoneErrorText.isNotEmpty
                    ? widget.controller.phoneErrorText
                    : null,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                border: const OutlineInputBorder(),
                label: Text(AppLocalizations.of(context)!.mobile),
              ),
            ),
          if (homePageIntRes.inputFields!["frist_name_seat"]!.fillable == 1 ||
              homePageIntRes.inputFields!["surname_seat"]!.fillable == 1 ||
              homePageIntRes.inputFields!["last_name_seat"]!.fillable == 1)
            const SizedBox(
              height: 10,
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (homePageIntRes.inputFields!["frist_name_seat"]!.fillable == 1)
                Expanded(
                  child: TextFormField(
                    controller: widget.controller.fNameController,
                    focusNode: focusNodeFName,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty &&
                          homePageIntRes.inputFields!["frist_name_seat"]!
                                  .isRequired ==
                              1) {
                        return (homePageIntRes
                                    .inputFields!["last_name_seat"]!.fillable !=
                                1)
                            ? AppLocalizations.of(context)!.enter_name
                            : AppLocalizations.of(context)!.enter_first_name;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: (homePageIntRes
                                  .inputFields!["last_name_seat"]!.fillable !=
                              1)
                          ? (homePageIntRes.inputFields!["frist_name_seat"]!
                                      .isRequired ==
                                  1)
                              ? AppLocalizations.of(context)!.name
                              : "${AppLocalizations.of(context)!.name}${AppLocalizations.of(context)!.optional}"
                          : (homePageIntRes.inputFields!["frist_name_seat"]!
                                      .isRequired ==
                                  1)
                              ? AppLocalizations.of(context)!.first_name
                              : "${AppLocalizations.of(context)!.first_name}${AppLocalizations.of(context)!.optional}",
                      border: OutlineInputBorder(),
                      label: Text(
                        (homePageIntRes
                                    .inputFields!["last_name_seat"]!.fillable !=
                                1)
                            ? (homePageIntRes.inputFields!["frist_name_seat"]!
                                        .isRequired ==
                                    1)
                                ? AppLocalizations.of(context)!.name
                                : "${AppLocalizations.of(context)!.name}${AppLocalizations.of(context)!.optional}"
                            : (homePageIntRes.inputFields!["frist_name_seat"]!
                                        .isRequired ==
                                    1)
                                ? AppLocalizations.of(context)!.first_name
                                : "${AppLocalizations.of(context)!.first_name}${AppLocalizations.of(context)!.optional}",
                      ),
                    ),
                  ),
                ),
              if (homePageIntRes.inputFields!["frist_name_seat"]!.fillable ==
                      1 &&
                  (homePageIntRes.inputFields!["surname_seat"]!.fillable == 1 ||
                      homePageIntRes.inputFields!["last_name_seat"]!.fillable ==
                          1))
                const SizedBox(
                  width: 10,
                ),
              if (homePageIntRes.inputFields!["last_name_seat"]!.fillable == 1)
                Expanded(
                  child: TextFormField(
                    controller: widget.controller.lNameController,
                    focusNode: focusNodeLName,
                    keyboardType: TextInputType.name,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty &&
                          homePageIntRes
                                  .inputFields!["last_name_seat"]!.isRequired ==
                              1) {
                        return AppLocalizations.of(context)!.enter_last_name;
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: (homePageIntRes
                                    .inputFields!["last_name_seat"]!
                                    .isRequired ==
                                1)
                            ? "${AppLocalizations.of(context)!.last_name}"
                            : "${AppLocalizations.of(context)!.last_name}${AppLocalizations.of(context)!.optional}"),
                  ),
                ),
              if (homePageIntRes.inputFields!["surname_seat"]!.fillable == 1)
                Expanded(
                  child: TextFormField(
                    controller: widget.controller.surNameController,
                    focusNode: focusNodeSurName,
                    keyboardType: TextInputType.name,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty &&
                          homePageIntRes
                                  .inputFields!["surname_seat"]!.isRequired ==
                              1) {
                        return AppLocalizations.of(context)!.enter_surname;
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: (homePageIntRes
                                  .inputFields!["surname_seat"]!.isRequired ==
                              1)
                          ? AppLocalizations.of(context)!.surname
                          : "${AppLocalizations.of(context)!.surname}${AppLocalizations.of(context)!.optional}",
                    ),
                  ),
                )
            ],
          ),
          if (homePageIntRes.inputFields!["gender_seat"]!.fillable == 1 ||
              homePageIntRes.inputFields!["type_seat"]!.fillable == 1)
            const SizedBox(
              height: 10,
            ),
          Row(
            children: [
              if (homePageIntRes.inputFields!["gender_seat"]!.fillable == 1)
                Expanded(
                  child: DropdownButtonFormField(
                    items: dropdownMenuItemGender,
                    isExpanded: true,
                    key: genderKey,
                    focusNode: focusNodeGender,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                      border: OutlineInputBorder(),
                      label: Text(AppLocalizations.of(context)!.gender),
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.controller.selectedGender = value!;
                      });
                    },
                    value: widget.controller.selectedGender,
                  ),
                ),
              if (homePageIntRes.inputFields!["gender_seat"]!.fillable == 1 &&
                  homePageIntRes.inputFields!["type_seat"]!.fillable == 1)
                const SizedBox(
                  width: 10,
                ),
              if (homePageIntRes.inputFields!["type_seat"]!.fillable == 1)
                Expanded(
                  child: DropdownButtonFormField(
                    items: dropdownMenuItemFairType,
                    isExpanded: true,
                    key: fairTypeKey,
                    focusNode: focusNodeType,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                      border: OutlineInputBorder(),
                      label: Text(AppLocalizations.of(context)!.type),
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.controller.selectFairType = value!;
                      });
                      widget.controller.fairTypeChange();
                    },
                    value: widget.controller.selectFairType,
                  ),
                ),
            ],
          ),
          if (homePageIntRes.inputFields!["email_seat"]!.fillable == 1)
            const SizedBox(
              height: 10,
            ),
          if (homePageIntRes.inputFields!["email_seat"]!.fillable == 1)
            TextFormField(
                controller: widget.controller.emailController,
                focusNode: focusNodeEmail,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  if (homePageIntRes.inputFields!["email_seat"]!.isRequired ==
                      1) {
                    if (value.isEmpty) {
                      errorTextEmail =
                          AppLocalizations.of(context)!.enter_valid_email;
                    } else if (!Constants.validateEmail(value)) {
                      errorTextEmail =
                          AppLocalizations.of(context)!.enter_valid_email;
                    } else {
                      errorTextEmail = "";
                    }
                  } else {
                    if (value.isNotEmpty && !Constants.validateEmail(value)) {
                      errorTextEmail =
                          AppLocalizations.of(context)!.enter_valid_email;
                    } else if (value.isNotEmpty) {
                      errorTextEmail = "";
                    }
                  }
                  setState(() {});
                },
                validator: (value) {
                  if (value!.isEmpty &&
                      homePageIntRes.inputFields!["email_seat"]!.isRequired ==
                          1) {
                    return AppLocalizations.of(context)!.enter_email;
                  } else if (homePageIntRes
                              .inputFields!["email_seat"]!.isRequired ==
                          1 &&
                      !Constants.validateEmail(value)) {
                    return AppLocalizations.of(context)!.enter_valid_email;
                  }
                  return null;
                },
                decoration: InputDecoration(
                    errorText:
                        errorTextEmail.isNotEmpty ? errorTextEmail : null,
                    labelText:
                        homePageIntRes.inputFields!["email_seat"]!.isRequired ==
                                1
                            ? AppLocalizations.of(context)!.email
                            : AppLocalizations.of(context)!.email_optional,
                    border: OutlineInputBorder(),
                    hintText:
                        homePageIntRes.inputFields!["email_seat"]!.isRequired ==
                                1
                            ? AppLocalizations.of(context)!.email
                            : AppLocalizations.of(context)!.email_optional)),
          if (homePageIntRes.inputFields!["altName_seat"]!.fillable == 1)
            const SizedBox(
              height: 10,
            ),
          if (homePageIntRes.inputFields!["altName_seat"]!.fillable == 1)
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.controller.altNameController,
                    focusNode: focusNodeAltName,
                    keyboardType: TextInputType.name,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty &&
                          homePageIntRes
                                  .inputFields!["altName_seat"]!.isRequired ==
                              1) {
                        return AppLocalizations.of(context)!.enter_kin_name;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.kin_name,
                      border: OutlineInputBorder(),
                      label: Text(
                        AppLocalizations.of(context)!.kin_name,
                      ),
                    ),
                  ),
                )
              ],
            ),
          if (homePageIntRes.inputFields!["altMobile_seat"]!.fillable == 1)
            SizedBox(
              height: 10,
            ),
          if (homePageIntRes.inputFields!["altMobile_seat"]!.fillable == 1)
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.controller.altPhoneController,
                    focusNode: focusNodeAltPhone,
                    keyboardType: TextInputType.phone,
                    maxLength: maxPhoneLength,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: _onChangeHandler,
                    validator: (value) {
                      if (value!.isEmpty &&
                          homePageIntRes
                                  .inputFields!["altMobile_seat"]!.isRequired ==
                              1) {
                        return AppLocalizations.of(context)!.enter_kin_phone;
                      }
                      if (widget.controller.phoneErrorTextKin.isNotEmpty &&
                          homePageIntRes
                                  .inputFields!["altMobile_seat"]!.isRequired ==
                              1) {
                        return widget.controller.phoneErrorTextKin;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: AppLocalizations.of(context)!.kin_phone,
                      border: OutlineInputBorder(),
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CountryCodePicker(
                            padding: EdgeInsets.zero,
                            barrierColor: Colors.black12,
                            onChanged: (value) async {
                              widget.controller.selectedCountry = {
                                "name": value.name!,
                                "code": value.code!,
                                "dial_code": value.dialCode!,
                              };
                              dialCode = value.dialCode!;
                              widget.controller.altPhoneController.text = "";
                              maxPhoneLength =
                                  await getMaxLength(value.dialCode!);
                              setState(() {});
                            },
                            initialSelection: Constants.countryCode,
                            searchDecoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(3),
                            ),
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
                      errorText: widget.controller.phoneErrorTextKin.isNotEmpty
                          ? widget.controller.phoneErrorTextKin
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 15),
                    ),
                  ),
                )
              ],
            ),
          if (homePageIntRes.inputFields!["passenger_id_type_seat"]!.fillable ==
              1)
            SizedBox(
              height: 10,
            ),
          if (homePageIntRes.inputFields!["passenger_id_type_seat"]!.fillable ==
              1)
            DropdownButtonFormField(
              items: dropdownMenuItemIdType,
              isExpanded: true,
              focusNode: focusNodePassengerIdType,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                border: OutlineInputBorder(),
                label: Text(AppLocalizations.of(context)!.id_type),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (homePageIntRes.inputFields!["passenger_id_type_seat"]!
                            .isRequired ==
                        1 &&
                    widget.controller.selectIdType == null) {
                  return AppLocalizations.of(context)!.select_passenger_id_type;
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  widget.controller.selectIdType = value!;
                });
                if (value != "6") focusNodeIdNo.requestFocus();
              },
              value: widget.controller.selectIdType,
            ),
          Visibility(
            visible: widget.controller.selectIdType != "6" &&
                widget.controller.selectIdType != null,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: widget.controller.idNoController,
                focusNode: focusNodeIdNo,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "${AppLocalizations.of(context)!.please_enter_your} ${widget.idTypes.firstWhere((element) => element.id == widget.controller.selectIdType, orElse: () => IdTypes(id: "", noLabel: "ID no")).noLabel!.toLowerCase()}";
                  }
                },
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  border: const OutlineInputBorder(),
                  label: Text(widget.idTypes
                      .firstWhere(
                          (element) =>
                              element.id == widget.controller.selectIdType,
                          orElse: () => IdTypes(id: "", noLabel: ""))
                      .noLabel!),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onChangeHandler(String value) async {
    if (kDebugMode) {
      log("value $value");
    }
    if (value.isEmpty) {
      widget.controller.phoneErrorText =
          AppLocalizations.of(context)!.enter_mobile;
      widget.controller.phoneErrorTextKin =
          AppLocalizations.of(context)!.enter_mobile;
    } else {
      Map isPhoneValid = await phoneLengthCheck(value.trim(), dialCode!);

      if (isPhoneValid['status']) {
        widget.controller.phoneErrorText = "";
        widget.controller.phoneErrorTextKin = "";
      } else {
        if (isPhoneValid['type'] == PhoneErrorType.invalid) {
          widget.controller.phoneErrorText =
              AppLocalizations.of(context)!.invalid_mobile_no;
          widget.controller.phoneErrorTextKin =
              AppLocalizations.of(context)!.invalid_mobile_no;
        } else if (isPhoneValid['type'] == PhoneErrorType.short) {
          widget.controller.phoneErrorText =
              "${AppLocalizations.of(context)!.phone_number_must_be} ${isPhoneValid['digit']} ${AppLocalizations.of(context)!.digits}";
          widget.controller.phoneErrorTextKin =
              "${AppLocalizations.of(context)!.phone_number_must_be} ${isPhoneValid['digit']} ${AppLocalizations.of(context)!.digits}";
        } else if (isPhoneValid['type'] == PhoneErrorType.rangeError) {
          widget.controller.phoneErrorText =
              "${AppLocalizations.of(context)!.phone_number_between} ${isPhoneValid['min']} ${AppLocalizations.of(context)!.and} ${isPhoneValid['max']} ${AppLocalizations.of(context)!.digits}";
          widget.controller.phoneErrorTextKin =
              "${AppLocalizations.of(context)!.phone_number_between} ${isPhoneValid['min']} ${AppLocalizations.of(context)!.and} ${isPhoneValid['max']} ${AppLocalizations.of(context)!.digits}";
        } else {
          widget.controller.phoneErrorText = "";
          widget.controller.phoneErrorTextKin = "";
        }
      }
      if (kDebugMode) {
        log("phoneErrorText ${widget.controller.phoneErrorText}");
      }
    }

    setState(() {});
  }
}

class PassengerInputLayoutController extends ChangeNotifier {
  PassengerInputLayoutController(this.seat);

  BusSeat seat;
  String? selectedGender;
  String? selectFairType;
  String phoneErrorText = "";
  String phoneErrorTextKin = "";
  String selectIdType = "6";
  String cCode = Constants.dialCode;
  String cCodeKin = Constants.dialCode;

  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController surNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController altNameController = TextEditingController();
  TextEditingController altPhoneController = TextEditingController();
  TextEditingController idNoController = TextEditingController();

  Map<String, String> selectedCountry = {
    "code": Constants.countryCode,
    "dial_code": Constants.dialCode,
  };

  bool Function() checkData = () {
    return false;
  };

  void Function() fairTypeChange = () {};

  void printData() {
    if (kDebugMode) {
      log("fname ${fNameController.text}");

      log("lname ${lNameController.text}");

      log("phone ${phoneController.text}");

      log("gender $selectedGender");

      log("fairType $selectFairType");

      log("country $selectedCountry");
    }
  }
}
