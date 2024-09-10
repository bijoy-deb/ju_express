import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ju_express/core/error/error_message.dart';
import 'package:ju_express/source/presentation/widgets/loader.dart';
import 'package:ju_express/source/utils/Constants.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';
import 'package:ju_express/source/utils/helper_functions.dart';
import 'package:ju_express/source/utils/phone_validation.dart';

import '../../../../di/injection.dart';
import '../../../utils/app_color.dart';
import '../../bloc/contact_us/contact_us_bloc.dart';
import '../../widgets/app_bar.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  String dialCode = Constants.dialCode;
  int maxPhoneLength = 15;
  String phoneErrorText = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController message = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode messageFocus = FocusNode();
  final bloc = getIt<ContactUsBloc>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      maxPhoneLength = await getMaxLength(Constants.dialCode);

      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: BlocProvider(
        create: (context) => bloc,
        child: Scaffold(
            backgroundColor: AppColors.backgroundColor.parseColor(),
            appBar: MyAppBar(
              title: AppLocalizations.of(context)!.contactUs,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: wrapWithContainer(
                  child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.leave_a_msg,
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        focusNode: nameFocus,
                        controller: name,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(context)!.enter_name;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.account_circle_outlined),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
                          border: OutlineInputBorder(),
                          label: Text(AppLocalizations.of(context)!.name),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: emailFocus,
                        controller: email,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(context)!.enter_email;
                          } else if (!validateEmail(value)) {
                            return AppLocalizations.of(context)!
                                .enter_valid_email;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
                          border: OutlineInputBorder(),
                          label: Text(AppLocalizations.of(context)!.email),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: mobileFocus,
                        controller: mobile,
                        maxLength: maxPhoneLength,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        onChanged: _onChangeHandler,
                        validator: (value) {
                          if (value!.isEmpty) {
                            phoneErrorText =
                                AppLocalizations.of(context)!.enter_mobile;
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
                                  dialCode = value.dialCode!;

                                  mobile.text = "";
                                  maxPhoneLength =
                                      await getMaxLength(value.dialCode!);
                                  setState(() {
                                    if (kDebugMode) {
                                      print(
                                        "maxPhoneLength   :  $maxPhoneLength");
                                    }
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
                          errorText:
                              phoneErrorText.isNotEmpty ? phoneErrorText : null,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
                          border: OutlineInputBorder(),
                          label: Text(AppLocalizations.of(context)!.mobile),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: messageFocus,
                        controller: message,
                        maxLines: null,
                        minLines: 2,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(context)!.enter_message;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.message_outlined),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
                          border: OutlineInputBorder(),
                          label: Text(AppLocalizations.of(context)!.message),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: BlocConsumer<ContactUsBloc, ContactUsState>(
                          listener: (context, state) async {
                            if (state is MessageSentError) {
                              showToast(state.error.message, error: true);
                            } else if (state is MessageSent) {
                              if (state.res.status == 1) {
                                showToast(
                                    ErrorMessage.getErrorFromMsg(state.res.m)
                                        .message,
                                    success: true);
                              } else if (state.res.status != 1) {
                                showToast(
                                    ErrorMessage.getErrorFromMsg(state.res.m)
                                        .message,
                                    error: true);
                              }
                            }
                          },
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: (state is SendingMessage)
                                  ? () {}
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        FocusManager.instance.primaryFocus!
                                            .unfocus();

                                        bloc.add(SendMessage(
                                          cCode: dialCode,
                                          mobile: mobile.text.trim(),
                                          name: name.text.trim(),
                                          email: email.text.trim(),
                                          message: message.text.trim(),
                                        ));
                                      } else if (name.text.isEmpty) {
                                        nameFocus.requestFocus();
                                      } else if (email.text.isEmpty) {
                                        emailFocus.requestFocus();
                                      } else if (mobile.text.isEmpty) {
                                        mobileFocus.requestFocus();
                                      } else if (message.text.isEmpty) {
                                        messageFocus.requestFocus();
                                      }
                                    },
                              child: (state is SendingMessage)
                                  ? CircleLoader()
                                  : Text(
                                      AppLocalizations.of(context)!.send,
                                    ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )),
            )),
      ),
    );
  }

  _onChangeHandler(String value) async {
    if (kDebugMode) {
      log("value $value");
    }
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
