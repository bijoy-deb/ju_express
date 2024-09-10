import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ju_express/source/data/model/home/home_page_int_res.dart';
import 'package:ju_express/source/data/model/passenger_info/passenger_info_args.dart';
import 'package:ju_express/source/utils/helper_functions.dart';

import '../../../../../di/injection.dart';
import '../../../../data/local/app_shared_preferences.dart';
import '../../../../utils/Constants.dart';
import '../../../../utils/phone_validation.dart';

class InvoiceInputLayoutScreen extends StatefulWidget {
  const InvoiceInputLayoutScreen(
      {super.key,
      required this.invoiceController,
      required this.passengerInfoArgs});
  final InvoiceController invoiceController;

  final PassengerInfoArgs passengerInfoArgs;
  @override
  State<InvoiceInputLayoutScreen> createState() =>
      _InvoiceInputLayoutScreenState();
}

class _InvoiceInputLayoutScreenState extends State<InvoiceInputLayoutScreen> {
  AppSharedPrefs sp = getIt<AppSharedPrefs>();
  HomePageIntRes homePageIntRes = HomePageIntRes();
  int maxPhoneLength = 15;
  List<Map<String, String>> country = [];
  List<DropdownMenuItem<String>> dropdownMenuItemGender = [
    const DropdownMenuItem(value: "1", child: Text("Male")),
    const DropdownMenuItem(value: "2", child: Text("Female")),
  ];
  List<DropdownMenuItem<String>> dropdownMenuItemIdType = [];
  List<DropdownMenuItem<String>> dropdownMenuItemFairType = [];
  String phoneErrorText = "";
  String errorTextEmail = "";
  String dialCode = Constants.dialCode;
  @override
  void initState() {
    homePageIntRes = sp.getHomePageInt();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      maxPhoneLength = await getMaxLength(Constants.dialCode);
      setState(() {});
    });
    for (var i = 0; i < widget.passengerInfoArgs.idTypes.length; i++) {
      dropdownMenuItemIdType.add(DropdownMenuItem(
          value: widget.passengerInfoArgs.idTypes[i].id,
          child: Text(widget.passengerInfoArgs.idTypes[i].title!)));
    }
    for (var i = 0; i < codes.length; i++) {
      if (codes[i]["code"] == "SO") {
        var map = Map<String, String>();
        map["name"] = "Nigeria";
        map["code"] = "NG";
        map["dial_code"] = "+234";
        widget.invoiceController.selectedCountry = map;
        country.add(map);
      } else {
        country.add(codes[i]);
      }
    }
    print("key in init ${widget.invoiceController.formKeyInvoice}");
    for (var i = 0; i < widget.passengerInfoArgs.fairTypes!.length; i++) {
      dropdownMenuItemFairType.add(DropdownMenuItem(
          value: widget.passengerInfoArgs.fairTypes![i].tftId,
          child: Text(widget.passengerInfoArgs.fairTypes![i].tftTitle!)));
    }
    widget.invoiceController.checkData = () {
      if (widget.invoiceController.formKeyInvoice.currentState!.validate()) {
        log("all vakidate");
        return true;
      }
      if (homePageIntRes.inputFields!["altName_invoice"]!.isRequired == 1 &&
          widget.invoiceController.altNameController.text.isEmpty) {
        showToast(AppLocalizations.of(context)!.enter_kin_name, error: true);
        widget.invoiceController.focusNodeNameKin.requestFocus();
        return false;
      } else if (homePageIntRes.inputFields!["altMobile_invoice"]!.isRequired ==
              1 &&
          widget.invoiceController.altPhoneController.text.isEmpty) {
        showToast(AppLocalizations.of(context)!.enter_kin_phone, error: true);
        widget.invoiceController.focusNodePhoneKin.requestFocus();
        return false;
      } else if (homePageIntRes
                  .inputFields!["frist_name_invoice"]!.isRequired ==
              1 &&
          widget.invoiceController.firstNameController.text.isEmpty) {
        showToast(AppLocalizations.of(context)!.enter_first_name, error: true);
        widget.invoiceController.focusNodeFirstName.requestFocus();
        return false;
      } else if (homePageIntRes.inputFields!["last_name_invoice"]!.isRequired ==
              1 &&
          widget.invoiceController.lastNameController.text.isEmpty) {
        showToast(AppLocalizations.of(context)!.enter_last_name, error: true);
        widget.invoiceController.focusNodeLastName.requestFocus();
        return false;
      } else if (homePageIntRes.inputFields!["surname_invoice"]!.isRequired ==
              1 &&
          widget.invoiceController.surNameController.text.isEmpty) {
        showToast(AppLocalizations.of(context)!.enter_surname, error: true);
        widget.invoiceController.focusNodeSurName.requestFocus();
        return false;
      } else if (homePageIntRes.inputFields!["gender_invoice"]!.isRequired ==
              1 &&
          widget.invoiceController.selectedGender == null) {
        showToast(AppLocalizations.of(context)!.select_gender, error: true);
        openDropdown(genderKey);
        widget.invoiceController.focusNodeGender.requestFocus();
        return false;
      } else if (homePageIntRes.inputFields!["type_invoice"]!.isRequired == 1 &&
          widget.invoiceController.selectFairType == null) {
        showToast(AppLocalizations.of(context)!.select_type, error: true);
        openDropdown(fairTypeKey);
        widget.invoiceController.focusNodeType.requestFocus();
        return false;
      } else if ((homePageIntRes.inputFields!["email_invoice"]!.isRequired ==
              1) &&
          (widget.invoiceController.emailNameController.text.isEmpty ||
              !Constants.validateEmail(
                  widget.invoiceController.emailNameController.text))) {
        showToast(AppLocalizations.of(context)!.enter_valid_email, error: true);
        widget.invoiceController.focusNodeEmail.requestFocus();
        return false;
      } else if (homePageIntRes
                  .inputFields!["passenger_id_type_invoice"]!.isRequired ==
              1 &&
          widget.invoiceController.selectIdType == null) {
        showToast(AppLocalizations.of(context)!.select_passenger_id_type,
            error: true);
        widget.invoiceController.focusNodePassengerIdType.requestFocus();

        return false;
      } else if ((widget.invoiceController.selectIdType != "6" &&
              widget.invoiceController.selectIdType != null) &&
          widget.invoiceController.idNoController.text.isEmpty) {
        showToast(
            "${AppLocalizations.of(context)!.please_enter_your} ${widget.passengerInfoArgs.idTypes.firstWhere((element) => element.id == widget.invoiceController.selectIdType, orElse: () => IdTypes(id: "", noLabel: "ID no")).noLabel!.toLowerCase()}",
            error: true);

        return false;
      } else {
        return true;
      }
    };
    super.initState();
  }

  _onChangeHandler(String value) async {
    if (kDebugMode) {
      log("value $value");
    }
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
      if (kDebugMode) {
        log("phoneErrorText $phoneErrorText");
      }
    }

    setState(() {});
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
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10)),
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Form(
        key: widget.invoiceController.formKeyInvoice,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.additional_info,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (homePageIntRes.inputFields!["altName_invoice"]!.fillable == 1)
              const SizedBox(
                height: 10,
              ),
            if (homePageIntRes.inputFields!["altName_invoice"]!.fillable == 1)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: widget.invoiceController.altNameController,
                      focusNode: widget.invoiceController.focusNodeNameKin,
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty &&
                            homePageIntRes.inputFields!["altName_invoice"]!
                                    .isRequired ==
                                1) {
                          return AppLocalizations.of(context)!.enter_kin_name;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.kin_name,
                        border: const OutlineInputBorder(),
                        label: Text(
                          AppLocalizations.of(context)!.kin_name,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            if (homePageIntRes.inputFields!["altMobile_invoice"]!.fillable == 1)
              const SizedBox(
                height: 10,
              ),
            if (homePageIntRes.inputFields!["altMobile_invoice"]!.fillable == 1)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: widget.invoiceController.altPhoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: _onChangeHandler,
                      focusNode: widget.invoiceController.focusNodePhoneKin,
                      maxLength: maxPhoneLength,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty &&
                            homePageIntRes.inputFields!["altMobile_invoice"]!
                                    .isRequired ==
                                1) {
                          return AppLocalizations.of(context)!
                              .please_enter_phone;
                        }
                        if (phoneErrorText.isNotEmpty &&
                            homePageIntRes.inputFields!["altMobile_invoice"]!
                                    .isRequired ==
                                1) {
                          return phoneErrorText;
                        }
                        return null;
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
                                widget.invoiceController.selectedCountry = {
                                  "name": value.name!,
                                  "code": value.code!,
                                  "dial_code": value.dialCode!,
                                };
                                dialCode = value.dialCode! ?? "";
                                widget.invoiceController.cCodeKin =
                                    value.dialCode!;
                                widget.invoiceController.phoneController.text =
                                    "";
                                maxPhoneLength =
                                    await getMaxLength(value.dialCode!);
                                setState(() {});
                              },
                              initialSelection: Constants.countryCode,
                              searchDecoration: const InputDecoration(
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
                        errorText:
                            phoneErrorText.isNotEmpty ? phoneErrorText : null,
                        hintText: AppLocalizations.of(context)!.enter_mobile,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (homePageIntRes.inputFields!["frist_name_invoice"]!.fillable ==
                    1 ||
                homePageIntRes.inputFields!["last_name_invoice"]!.fillable ==
                    1 ||
                homePageIntRes.inputFields!["surname_invoice"]!.fillable == 1)
              const SizedBox(
                height: 10,
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (homePageIntRes
                        .inputFields!["frist_name_invoice"]!.fillable ==
                    1)
                  Flexible(
                    flex: 1,
                    child: TextFormField(
                      controller: widget.invoiceController.firstNameController,
                      focusNode: widget.invoiceController.focusNodeFirstName,
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty &&
                            homePageIntRes.inputFields!["frist_name_invoice"]!
                                    .isRequired ==
                                1) {
                          return (homePageIntRes
                                      .inputFields!["last_name_invoice"]!
                                      .fillable !=
                                  1)
                              ? AppLocalizations.of(context)!.enter_name
                              : AppLocalizations.of(context)!.enter_first_name;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: (homePageIntRes
                                    .inputFields!["last_name_invoice"]!
                                    .fillable !=
                                1)
                            ? (homePageIntRes
                                        .inputFields!["frist_name_invoice"]!
                                        .isRequired ==
                                    1)
                                ? AppLocalizations.of(context)!.name
                                : "${AppLocalizations.of(context)!.name}${AppLocalizations.of(context)!.optional}"
                            : (homePageIntRes
                                        .inputFields!["frist_name_invoice"]!
                                        .isRequired ==
                                    1)
                                ? AppLocalizations.of(context)!.first_name
                                : "${AppLocalizations.of(context)!.first_name}${AppLocalizations.of(context)!.optional}",
                        label: Text(
                          (homePageIntRes.inputFields!["last_name_invoice"]!
                                      .fillable !=
                                  1)
                              ? (homePageIntRes
                                          .inputFields!["frist_name_invoice"]!
                                          .isRequired ==
                                      1)
                                  ? AppLocalizations.of(context)!.name
                                  : "${AppLocalizations.of(context)!.name}${AppLocalizations.of(context)!.optional}"
                              : (homePageIntRes
                                          .inputFields!["frist_name_invoice"]!
                                          .isRequired ==
                                      1)
                                  ? AppLocalizations.of(context)!.first_name
                                  : "${AppLocalizations.of(context)!.first_name}${AppLocalizations.of(context)!.optional}",
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                if (homePageIntRes
                            .inputFields!["frist_name_invoice"]!.fillable ==
                        1 &&
                    (homePageIntRes
                                .inputFields!["last_name_invoice"]!.fillable ==
                            1 ||
                        homePageIntRes
                                .inputFields!["surname_invoice"]!.fillable ==
                            1))
                  const SizedBox(
                    width: 10,
                  ),
                if (homePageIntRes
                        .inputFields!["last_name_invoice"]!.fillable ==
                    1)
                  Flexible(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: TextFormField(
                        controller: widget.invoiceController.lastNameController,
                        keyboardType: TextInputType.name,
                        focusNode: widget.invoiceController.focusNodeLastName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty &&
                              homePageIntRes.inputFields!["last_name_invoice"]!
                                      .isRequired ==
                                  1) {
                            return AppLocalizations.of(context)!
                                .enter_last_name;
                          }
                        },
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: (homePageIntRes
                                        .inputFields!["last_name_invoice"]!
                                        .isRequired ==
                                    1)
                                ? "${AppLocalizations.of(context)!.last_name}"
                                : "${AppLocalizations.of(context)!.last_name}${AppLocalizations.of(context)!.optional}"),
                      ),
                    ),
                  ),
                if (homePageIntRes.inputFields!["surname_invoice"]!.fillable ==
                    1)
                  Flexible(
                    child: TextFormField(
                      controller: widget.invoiceController.surNameController,
                      focusNode: widget.invoiceController.focusNodeSurName,
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty &&
                            homePageIntRes.inputFields!["surname_invoice"]!
                                    .isRequired ==
                                1) {
                          return AppLocalizations.of(context)!.enter_surname;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.surname,
                        border: const OutlineInputBorder(),
                        label: Text(
                          (homePageIntRes.inputFields!["surname_invoice"]!
                                      .isRequired ==
                                  1)
                              ? AppLocalizations.of(context)!.surname
                              : "${AppLocalizations.of(context)!.surname}${AppLocalizations.of(context)!.optional}",
                        ),
                      ),
                    ),
                  )
              ],
            ),
            if (homePageIntRes.inputFields!["gender_invoice"]!.fillable == 1 ||
                homePageIntRes.inputFields!["type_invoice"]!.fillable == 1)
              const SizedBox(
                height: 10,
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (homePageIntRes.inputFields!["gender_invoice"]!.fillable ==
                    1)
                  Expanded(
                    child: DropdownButtonFormField(
                      items: dropdownMenuItemGender,
                      isExpanded: true,
                      key: genderKey,
                      focusNode: widget.invoiceController.focusNodeGender,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.gender),
                      onChanged: (value) {
                        setState(() {
                          widget.invoiceController.selectedGender = value!;
                        });
                      },
                      value: widget.invoiceController.selectedGender,
                    ),
                  ),
                if (homePageIntRes.inputFields!["gender_invoice"]!.fillable ==
                        1 &&
                    homePageIntRes.inputFields!["type_invoice"]!.fillable == 1)
                  const SizedBox(
                    width: 10,
                  ),
                if (homePageIntRes.inputFields!["type_invoice"]!.fillable == 1)
                  Expanded(
                    child: DropdownButtonFormField(
                      items: dropdownMenuItemFairType,
                      isExpanded: true,
                      key: fairTypeKey,
                      focusNode: widget.invoiceController.focusNodeType,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.type),
                      onChanged: (value) {
                        setState(() {
                          widget.invoiceController.selectFairType = value!;
                        });
                        widget.invoiceController.fairTypeChange();
                      },
                      value: widget.invoiceController.selectFairType,
                    ),
                  ),
              ],
            ),
            if (homePageIntRes.inputFields!["email_invoice"]!.fillable == 1)
              const SizedBox(
                height: 10,
              ),
            Row(
              children: [
                if (homePageIntRes.inputFields!["email_invoice"]!.fillable == 1)
                  Flexible(
                    child: TextFormField(
                      controller: widget.invoiceController.emailNameController,
                      focusNode: widget.invoiceController.focusNodeEmail,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        if (homePageIntRes
                                .inputFields!["email_invoice"]!.isRequired ==
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
                          if (value.isNotEmpty &&
                              !Constants.validateEmail(value)) {
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
                            homePageIntRes.inputFields!["email_invoice"]!
                                    .isRequired ==
                                1) {
                          return AppLocalizations.of(context)!.enter_email;
                        } else if (homePageIntRes.inputFields!["email_invoice"]!
                                    .isRequired ==
                                1 &&
                            !Constants.validateEmail(value)) {
                          return AppLocalizations.of(context)!
                              .enter_valid_email;
                        }
                        return null;
                      },
                      //initialValue: widget.model.email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        errorText:
                            errorTextEmail.isNotEmpty ? errorTextEmail : null,
                        labelText: homePageIntRes.inputFields!["email_invoice"]!
                                    .isRequired ==
                                1
                            ? AppLocalizations.of(context)!.email
                            : AppLocalizations.of(context)!.email_optional,
                        hintText: homePageIntRes.inputFields!["email_invoice"]!
                                    .isRequired ==
                                1
                            ? AppLocalizations.of(context)!.email
                            : AppLocalizations.of(context)!.email_optional,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
              ],
            ),
            if (homePageIntRes
                    .inputFields!["passenger_id_type_invoice"]!.fillable ==
                1)
              const SizedBox(
                height: 10,
              ),
            if (homePageIntRes
                    .inputFields!["passenger_id_type_invoice"]!.fillable ==
                1)
              DropdownButtonFormField(
                items: dropdownMenuItemIdType,
                isExpanded: true,
                focusNode: widget.invoiceController.focusNodePassengerIdType,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  border: const OutlineInputBorder(),
                  label: Text(AppLocalizations.of(context)!.id_type),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (homePageIntRes.inputFields!["passenger_id_type_invoice"]!
                              .isRequired ==
                          1 &&
                      widget.invoiceController.selectIdType == null) {
                    return AppLocalizations.of(context)!
                        .select_passenger_id_type;
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    widget.invoiceController.selectIdType = value!;
                  });
                  if (value != "6")
                    widget.invoiceController.focusNodeIdNo.requestFocus();
                },
                value: widget.invoiceController.selectIdType,
              ),
            Visibility(
              visible: widget.invoiceController.selectIdType != "6" &&
                  widget.invoiceController.selectIdType != null,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: widget.invoiceController.idNoController,
                  focusNode: widget.invoiceController.focusNodeIdNo,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "${AppLocalizations.of(context)!.please_enter_your} ${widget.passengerInfoArgs.idTypes.firstWhere((element) => element.id == widget.invoiceController.selectIdType, orElse: () => IdTypes(id: "", noLabel: "ID no")).noLabel!.toLowerCase()}";
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 15),
                    border: const OutlineInputBorder(),
                    label: Text(widget.passengerInfoArgs.idTypes
                        .firstWhere(
                            (element) =>
                                element.id ==
                                widget.invoiceController.selectIdType,
                            orElse: () => IdTypes(id: "", noLabel: ""))
                        .noLabel!),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvoiceController {
  final formKeyInvoice = GlobalKey<FormState>();

  void Function() fairTypeChange = () {};
  TextEditingController phoneController = TextEditingController();
  String cCode = Constants.dialCode;
  String cCodeKin = Constants.dialCode;
  String selectIdType = "6";

  TextEditingController surNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailNameController = TextEditingController();
  TextEditingController altNameController = TextEditingController();
  TextEditingController altPhoneController = TextEditingController();
  TextEditingController idNoController = TextEditingController();
  TextEditingController passengerIdController = TextEditingController();
  String selectedGender = "1";
  String selectFairType = "0";

  Map<String, String> selectedCountry = {
    "code": Constants.countryCode,
    "dial_code": Constants.dialCode,
  };
  Map<String, String> selectedCountryKin = Map();
  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodePassengerIdType = FocusNode();
  FocusNode focusNodeFirstName = FocusNode();
  FocusNode focusNodeLastName = FocusNode();
  FocusNode focusNodeSurName = FocusNode();
  FocusNode focusNodeIdNo = FocusNode();
  FocusNode focusNodeGender = FocusNode();
  FocusNode focusNodeType = FocusNode();
  FocusNode focusNodePhoneKin = FocusNode();
  FocusNode focusNodeNameKin = FocusNode();

  bool Function() checkData = () {
    return false;
  };
}
