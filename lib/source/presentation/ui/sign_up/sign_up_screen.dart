import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';


import '../../../../core/error/error_message.dart';
import '../../../../di/injection.dart';
import '../../../../route/route_config.dart';
import '../../../data/local/app_shared_preferences.dart';
import '../../../data/model/authentication/request/registration_request_model.dart';
import '../../../data/model/home/home_page_int_res.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_images.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/phone_validation.dart';
import '../../../utils/text_styles.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loader.dart';
import '../otp/otp_screen.dart';
import '../otp/widgets/otp_selection_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isObscure = true;
  final _fbKey = GlobalKey<FormState>();
  int maxPhoneLength = 15;
  String phoneErrorText = "";
  String dialCode = Constants.dialCode;
  int _value = 1;

  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode surNameFocusNode = FocusNode();
  final FocusNode fatherNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();
  final FocusNode pinFocusNode = FocusNode();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController surNameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  late Map<String, InputField> registrInputFields;
  final bloc = getIt<AuthenticationBloc>();

  @override
  void initState() {
    registrInputFields =
        getIt<AppSharedPrefs>().getHomePageInt().registrInputFields!;
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
        backgroundColor: AppColors.backgroundColor.parseColor(),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                  color: AppColors.primaryColor.parseColor().withOpacity(1),
                  height: MediaQuery.of(context).size.height / 2),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5, top: 5),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            highlightColor: Colors.white30,
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Image.asset(
                        AppImages.logo,
                        height: 50,
                        width: 200,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 15.0, right: 15, bottom: 20, top: 22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Form(
                        key: _fbKey,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (registrInputFields["first_name"]!.fillable ==
                                  1) ...[
                                const SizedBox(height: 20),
                                Text(
                                  AppLocalizations.of(context)!.first_name,
                                  style: AppStyle.textStyleF17W600(),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  focusNode: firstNameFocusNode,
                                  controller: firstNameController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty &&
                                            registrInputFields["first_name"]!
                                                    .isRequired ==
                                                1) {
                                      return registrInputFields["last_name"]!
                                                  .fillable ==
                                              1
                                          ? AppLocalizations.of(context)!
                                              .enter_first_name
                                          : AppLocalizations.of(context)!
                                              .enter_name;
                                    }
                                    return null;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: customInputDecoration(
                                    hintText: registrInputFields["last_name"]!
                                                .fillable ==
                                            1
                                        ? AppLocalizations.of(context)!
                                            .first_name
                                        : AppLocalizations.of(context)!.name,
                                  ),
                                ),
                              ],
                              if (registrInputFields["last_name"]!.fillable ==
                                  1) ...[
                                const SizedBox(height: 20),
                                Text(
                                  AppLocalizations.of(context)!.last_name,
                                  style: AppStyle.textStyleF17W600(),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  focusNode: lastNameFocusNode,
                                  controller: lastNameController,
                                  decoration: customInputDecoration(
                                      hintText: AppLocalizations.of(context)!
                                          .last_name),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty &&
                                            registrInputFields["last_name"]!
                                                    .isRequired ==
                                                1) {
                                      return AppLocalizations.of(context)!
                                          .enter_last_name;
                                    }
                                    return null;
                                  },
                                ),
                              ],
                              if (registrInputFields["surname"]!.fillable ==
                                  1) ...[
                                const SizedBox(height: 20),
                                Text(
                                  AppLocalizations.of(context)!.surname_name,
                                  style: AppStyle.textStyleF17W600(),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  focusNode: surNameFocusNode,
                                  controller: surNameController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: customInputDecoration(
                                      hintText: AppLocalizations.of(context)!
                                          .surname_name),
                                  validator: (value) {
                                    if (value!.isEmpty &&
                                        registrInputFields["surname"]!
                                                .isRequired ==
                                            1) {
                                      return AppLocalizations.of(context)!
                                          .enter_surname;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                              if (registrInputFields["father_name"]!.fillable ==
                                  1) ...[
                                const SizedBox(height: 20),
                                Text(
                                  AppLocalizations.of(context)!.father_name,
                                  style: AppStyle.textStyleF17W600(),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  focusNode: fatherNameFocusNode,
                                  controller: fatherNameController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: customInputDecoration(
                                      hintText: AppLocalizations.of(context)!
                                          .father_name),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty &&
                                        registrInputFields["father_name"]!
                                                .isRequired ==
                                            1) {
                                      return AppLocalizations.of(context)!
                                          .enter_father_name;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                              if (registrInputFields["phone"]!.fillable ==
                                  1) ...[
                                const SizedBox(height: 20),
                                Text(
                                  AppLocalizations.of(context)!.mobile,
                                  style: AppStyle.textStyleF17W600(),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  focusNode: phoneNumberFocusNode,
                                  controller: phoneNumberController,
                                  maxLength: maxPhoneLength,
                                  onChanged: _onChangeHandler,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^[0-9]+$')),
                                  ],
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value!.isEmpty &&
                                        registrInputFields["phone"]!
                                                .isRequired ==
                                            1) {
                                      phoneErrorText =
                                          AppLocalizations.of(context)!
                                              .enter_mobile;
                                    } else if (phoneErrorText.isEmpty) {
                                      return null;
                                    }
                                    return phoneErrorText;
                                  },
                                  decoration: customInputDecoration(
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .mobile_number)
                                      .copyWith(
                                    counterText: "",
                                    prefixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CountryCodePicker(
                                          padding: EdgeInsets.zero,
                                          barrierColor: Colors.black12,
                                          onChanged: (value) async {
                                            dialCode = value.dialCode!;
                                            phoneNumberController.text = "";
                                            maxPhoneLength = await getMaxLength(
                                                value.dialCode!);
                                            setState(() {
                                              log("maxPhoneLength   :  $maxPhoneLength");
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
                                            child: const Icon(
                                                Icons.arrow_drop_down)),
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
                                    errorText: phoneErrorText.isNotEmpty
                                        ? phoneErrorText
                                        : null,
                                  ),
                                ),
                              ],
                              if (registrInputFields["email"]!.fillable ==
                                  1) ...[
                                const SizedBox(height: 20),
                                Text(
                                  AppLocalizations.of(context)!.email,
                                  style: AppStyle.textStyleF17W600(),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  focusNode: emailFocusNode,
                                  controller: emailController,
                                  decoration: customInputDecoration(
                                    hintText:
                                        AppLocalizations.of(context)!.email,
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value!.isNotEmpty) {
                                      if (!validateEmail(value)) {
                                        return AppLocalizations.of(context)!
                                            .enter_valid_email;
                                      }
                                    } else if (registrInputFields["email"]!
                                            .isRequired ==
                                        1) {
                                      return AppLocalizations.of(context)!
                                          .enter_email;
                                    }
                                    return null;
                                  },
                                ),
                              ],
                              if (registrInputFields["password"]!.fillable ==
                                  1) ...[
                                const SizedBox(height: 20),
                                Text(
                                  AppLocalizations.of(context)!.password,
                                  style: AppStyle.textStyleF17W600(),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  obscureText: isObscure,
                                  focusNode: passwordFocusNode,
                                  controller: passwordController,
                                  decoration: customInputDecoration(
                                    hintText:
                                        AppLocalizations.of(context)!.password,
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isObscure = !isObscure;
                                        });
                                      },
                                      child: Icon(
                                        isObscure
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isNotEmpty) {
                                      if (!validatePassword(value)) {
                                        return AppLocalizations.of(context)!
                                            .enter_valid_password;
                                      }
                                    } else if (registrInputFields["password"]!
                                            .isRequired ==
                                        1) {
                                      return AppLocalizations.of(context)!
                                          .enter_password;
                                    }
                                    return null;
                                  },
                                ),
                              ],
                              if (registrInputFields["pin"]!.fillable == 1) ...[
                                const SizedBox(height: 20),
                                Text(
                                  AppLocalizations.of(context)!.pin,
                                  style: AppStyle.textStyleF17W600(),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  obscureText: isObscure,
                                  focusNode: pinFocusNode,
                                  controller: pinController,
                                  decoration: customInputDecoration(
                                    hintText: AppLocalizations.of(context)!.pin,
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isObscure = !isObscure;
                                        });
                                      },
                                      child: Icon(
                                        isObscure
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty &&
                                            registrInputFields["pin"]!
                                                    .isRequired ==
                                                1) {
                                      return AppLocalizations.of(context)!
                                          .enter_pin;
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomButton(
                        text: Text(
                          AppLocalizations.of(context)!.sign_up,
                        ),
                        onPressed: () {
                          FocusManager.instance.primaryFocus!.unfocus();
                          if (_fbKey.currentState!.validate()) {
                            _showDialog(context);
                          } else if (firstNameController.text.isEmpty &&
                              registrInputFields["first_name"]!.isRequired ==
                                  1) {
                            firstNameFocusNode.requestFocus();
                          } else if (lastNameController.text.isEmpty &&
                              registrInputFields["last_name"]!.isRequired ==
                                  1) {
                            lastNameFocusNode.requestFocus();
                          } else if (surNameController.text.isEmpty &&
                              registrInputFields["surname"]!.isRequired == 1) {
                            surNameFocusNode.requestFocus();
                          } else if (fatherNameController.text.isEmpty &&
                              registrInputFields["father_name"]!.isRequired ==
                                  1) {
                            fatherNameFocusNode.requestFocus();
                          } else if ((phoneNumberController.text.isEmpty ||
                                  phoneErrorText.isNotEmpty) &&
                              registrInputFields["phone"]!.isRequired == 1) {
                            phoneNumberFocusNode.requestFocus();
                          } else if ((emailController.text.isEmpty &&
                                  registrInputFields["email"]!.isRequired ==
                                      1) ||
                              (emailController.text.isNotEmpty &&
                                  !validateEmail(emailController.text))) {
                            emailFocusNode.requestFocus();
                          } else if ((emailController.text.isEmpty &&
                                  registrInputFields["password"]!.isRequired ==
                                      1) ||
                              (emailController.text.isNotEmpty &&
                                  !validateEmail(emailController.text))) {
                            passwordFocusNode.requestFocus();
                          } else if (pinController.text.isEmpty &&
                              registrInputFields["pin"]!.isRequired == 1) {
                            pinFocusNode.requestFocus();
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.already_have_account,
                            style: AppStyle.textStyleF17W600(
                                color: Colors.black54),
                          ),
                          InkWell(
                            onTap: () {
                              getIt<AppRoute>().router.push(RoutePath.signIn);
                            },
                            child: Text(
                              " ${AppLocalizations.of(context)!.sign_in}",
                              style: AppStyle.textStyleF17W600D(
                                  color: AppColors.primaryColor.parseColor()),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext _) {
    final bloc = getIt<AuthenticationBloc>();
    showDialog(
        context: _,
        builder: (_) {
          return BlocProvider(
            create: (context) => bloc,
            child: AlertDialog(
              title: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.get_verification_code,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    child: Text(
                      AppLocalizations.of(context)!.select_one_option_otp,
                      style: AppStyle.textStyleF17W400(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              content: OTPSelectionDialog(
                phn: phoneNumberController.text,
                email: emailController.text,
                code: dialCode,
                type: (value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
              actions: <Widget>[
                BlocConsumer<AuthenticationBloc, AuthenticationState>(
                    listener: (context, state) {
                  if (state is RegistrationLoaded) {
                    if (state.res.status == 1) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OTPScreen(
                          hasLogin: false,
                          phn: phoneNumberController.text,
                          type: _value,
                          code: dialCode,
                          email: emailController.text,
                        ),
                      ));
                    } else {
                      showToast(
                          ErrorMessage.getErrorFromMsg(state.res.m).message,
                          error: true);
                    }
                  } else if (state is DataError) {
                    showToast(state.error.message);
                  }
                }, builder: (context, state) {
                  return CustomButton(
                      text: state is DataLoading
                          ? const CircleLoader()
                          : Text(AppLocalizations.of(context)!.submit),
                      onPressed: state is DataLoading
                          ? () {}
                          : () {
                              RegistrationRequestModel model = RegistrationRequestModel(
                                  mobile: registrInputFields["phone"]!.fillable == 1
                                      ? phoneNumberController.text
                                      : null,
                                  code: registrInputFields["phone"]!.fillable == 1
                                      ? dialCode
                                      : null,
                                  firstName:
                                      registrInputFields["first_name"]!.fillable == 1
                                          ? firstNameController.text
                                          : null,
                                  lastName: registrInputFields["last_name"]!.fillable == 1
                                      ? lastNameController.text
                                      : null,
                                  pin: registrInputFields["pin"]!.fillable == 1
                                      ? pinController.text
                                      : null,
                                  fatherName:
                                      registrInputFields["father_name"]!.fillable == 1
                                          ? fatherNameController.text
                                          : null,
                                  sureName: registrInputFields["surname"]!.fillable == 1
                                      ? surNameController.text
                                      : null,
                                  email: registrInputFields["email"]!.fillable == 1
                                      ? emailController.text
                                      : null,
                                  password:
                                      registrInputFields["password"]!.fillable == 1
                                          ? passwordController.text
                                          : null,
                                  sendOption: _value == 1 ? "mobile" : "email");

                              bloc.add(RegistrationSubmitEvent(model: model));
                            });
                })
              ],
            ),
          );
        });
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
    }
    setState(() {});
  }
}
