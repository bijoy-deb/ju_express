import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/error/error_message.dart';
import '../../../../di/injection.dart';
import '../../../data/local/app_shared_preferences.dart';
import '../../../data/model/authentication/request/number_send_otp_request_model.dart';

import '../../../utils/Constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/phone_validation.dart';
import '../../../utils/text_styles.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loader.dart';
import 'change_number_send_otp.dart';

class ChangeNumberScreen extends StatefulWidget {
  const ChangeNumberScreen({super.key});

  @override
  State<ChangeNumberScreen> createState() => _ChangeNumberScreenState();
}

class _ChangeNumberScreenState extends State<ChangeNumberScreen> {
  final _fbKey = GlobalKey<FormState>();
  AppSharedPrefs sp = getIt<AppSharedPrefs>();
  final TextEditingController numberController = TextEditingController();
  final FocusNode numberFocusNode = FocusNode();
  int maxPhoneLength = 15;
  String phoneErrorText = "";
  String dialCode = Constants.dialCode;
  final bloc = getIt<AuthenticationBloc>();
  @override
  void initState() {
    Future(() {
      getMaxLength(Constants.dialCode).then((value) => maxPhoneLength = value);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: MyAppBar(title: AppLocalizations.of(context)!.change_number),
        body: SingleChildScrollView(
          child: Form(
            key: _fbKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.mobile,
                    style: AppStyle.textStyleF17W600(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                      focusNode: numberFocusNode,
                      controller: numberController,
                      maxLength: maxPhoneLength,
                      onChanged: _onChangeHandler,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
                      ],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          phoneErrorText =
                              AppLocalizations.of(context)!.enter_mobile;
                        } else if (phoneErrorText.isEmpty) {
                          return null;
                        }
                        return phoneErrorText;
                      },
                      decoration: customInputDecoration(
                              hintText:
                                  AppLocalizations.of(context)!.mobile_number)
                          .copyWith(
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CountryCodePicker(
                              padding: EdgeInsets.zero,
                              barrierColor: Colors.black12,
                              onChanged: (value) async {
                                dialCode = value.dialCode!;

                                numberController.text = "";
                                maxPhoneLength =
                                    await getMaxLength(value.dialCode!);
                                setState(() {
                                  log("maxPhoneLength   :  $maxPhoneLength");
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
                        errorText:
                            phoneErrorText.isNotEmpty ? phoneErrorText : null,
                      )),
                  const SizedBox(height: 20),
                  BlocConsumer<AuthenticationBloc, AuthenticationState>(
                      listener: (context, state) async {
                    if (state is NumberSendOtpLoaded) {
                      if (state.res.status == 1) {
                        showToast(
                            ErrorMessage.getErrorFromMsg(state.res.m).message,
                            success: true);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeNumberOtpScreen(
                                    phone: numberController.text,
                                    phoneCode: dialCode,
                                  )),
                        );
                      } else {
                        showToast(
                            ErrorMessage.getErrorFromMsg(state.res.m).message,
                            error: true);
                      }
                    } else if (state is DataError) {
                      showToast(state.error.message, error: true);
                    }
                  }, builder: (context, state) {
                    return CustomButton(
                      text: state is DataLoading
                          ? const CircleLoader()
                          : Text(AppLocalizations.of(context)!.submit),
                      onPressed: state is DataLoading
                          ? () {}
                          : () {
                              if (_fbKey.currentState!.validate()) {
                                FocusManager.instance.primaryFocus!.unfocus();
                                NumberSendOtpRequestModel model =
                                    NumberSendOtpRequestModel(
                                  changeMobile: numberController.text,
                                  changeCode: dialCode,
                                );

                                bloc.add(
                                    NumberSendOtpSubmitEvent(model: model));
                              } else if (numberController.text.isEmpty) {
                                numberFocusNode.requestFocus();
                              }
                            },
                    );
                  }
                      // },
                      ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onChangeHandler(String value) async {
    if (value.isEmpty) {
      phoneErrorText = AppLocalizations.of(context)!.enter_mobile;
    } else {
      Map isPhoneValid = await phoneLengthCheck(value.trim(), dialCode);

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
}
