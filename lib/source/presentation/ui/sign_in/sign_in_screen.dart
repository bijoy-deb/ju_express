import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';


import '../../../../core/error/error_message.dart';
import '../../../../di/injection.dart';
import '../../../../route/route_config.dart';
import '../../../data/local/app_shared_preferences.dart';
import '../../../data/model/authentication/request/login_request_model.dart';
import '../../../data/model/authentication/request/resend_otp_request_model.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_images.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/text_styles.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loader.dart';
import '../otp/otp_screen.dart';
import '../otp/widgets/otp_selection_dialog.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isObscure = true;
  final FocusNode userNameFocusNode = FocusNode();
  final _fbKey = GlobalKey<FormState>();
  final FocusNode passwordFocusNode = FocusNode();

  AppSharedPrefs sp = getIt<AppSharedPrefs>();

  final TextEditingController userNameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final bloc = getIt<AuthenticationBloc>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FlutterNativeSplash.remove();
    });
  }

  int _value = 1;

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
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
                  Text(
                    AppLocalizations.of(context)!.login_slogan,
                    textAlign: TextAlign.center,
                    style: AppStyle.textStyleF25W700(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 18.0, right: 18, bottom: 0, top: 22),
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
                            Text(
                              AppLocalizations.of(context)!.mobile_or_mail,
                              style: AppStyle.textStyleF17W600(),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              focusNode: userNameFocusNode,
                              controller: userNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .enter_mobile_or_mail;
                                } else if (!isMobileNumber(value)) {
                                  if (!validateEmail(value)) {
                                    return AppLocalizations.of(context)!
                                        .enter_valid_email;
                                  }
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: customInputDecoration(
                                  hintText: AppLocalizations.of(context)!
                                      .mobile_or_mail),
                            ),
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
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .enter_password;
                                } else {
                                  return null;
                                }
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          "${AppLocalizations.of(context)!.forgot_password}",
                          style: AppStyle.textStyleF17W600(
                              color: AppColors.primaryColor.parseColor()),
                        ),
                        onPressed: () {
                          getIt<AppRoute>()
                              .router
                              .push(RoutePath.forgot_password);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  BlocConsumer<AuthenticationBloc, AuthenticationState>(
                      listener: (context, state) async {
                    if (state is LoginLoaded) {
                      if (state.res.status == 1) {
                        await sp.setAuthCode(state.res.authcode!);
                        await sp.setUserInfo(state.res.data!);
                        showToast(
                            ErrorMessage.getErrorFromMsg(state.res.m).message,
                            success: true);
                        navigateToHome(context);
                      } else if (state.res.status == 3) {
                        String countryCode = state.res.data!.cCode ?? "";
                        String phoneNumber = state.res.data!.cMobile ?? "";
                        String emailAddress = state.res.data!.cEmail ?? "";
                        showDialog(
                            context: context,
                            builder: (_) {
                              AuthenticationBloc bloc2 =
                                  getIt<AuthenticationBloc>();
                              return BlocProvider(
                                create: (context) => bloc2,
                                child: AlertDialog(
                                  title: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .get_verification_code,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.zero,
                                        margin: EdgeInsets.zero,
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .select_one_option_otp,
                                          style: AppStyle.textStyleF17W400(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: OTPSelectionDialog(
                                    phn: phoneNumber,
                                    code: countryCode,
                                    email: emailAddress,
                                    type: (value) {
                                      setState(() {
                                        _value = value;
                                      });
                                    },
                                  ),
                                  actions: <Widget>[
                                    BlocConsumer<AuthenticationBloc,
                                            AuthenticationState>(
                                        listener: (context, state) {
                                      if (state is ResendOtpLoaded) {
                                        if (state.res.status == 1) {
                                          showToast(
                                              ErrorMessage.getErrorFromMsg(
                                                      state.res.m)
                                                  .message,
                                              success: true);
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => OTPScreen(
                                              hasLogin: true,
                                              phn: phoneNumber,
                                              email: emailAddress,
                                              type: _value,
                                              code: countryCode,
                                            ),
                                          ));
                                        } else {
                                          showToast(
                                              ErrorMessage.getErrorFromMsg(
                                                      state.res.m)
                                                  .message,
                                              error: true);
                                        }
                                      } else if (state is DataError) {
                                        showToast(state.error.message,
                                            error: true);
                                      }
                                    }, builder: (context, state) {
                                      return CustomButton(
                                        text: state is DataLoading
                                            ? const CircleLoader()
                                            : Text(AppLocalizations.of(context)!
                                                .submit),
                                        onPressed: state is DataLoading
                                            ? () {}
                                            : () {
                                                ResendOtpRequestModel model =
                                                    ResendOtpRequestModel(
                                                        cCode: _value == 1
                                                            ? countryCode
                                                            : "",
                                                        email: _value == 1
                                                            ? ""
                                                            : emailAddress,
                                                        mobile: _value == 1
                                                            ? phoneNumber
                                                            : "",
                                                        otpResendOption:
                                                            _value == 1
                                                                ? "mobile"
                                                                : "email");
                                                bloc2.add(ResendOtpSubmitEvent(
                                                    model: model));
                                              },
                                      );
                                    })
                                  ],
                                ),
                              );
                            });
                      } else {
                        showToast(
                            ErrorMessage.getErrorFromMsg(state.res.m).message,
                            error: true);
                      }
                    } else if (state is DataError) {
                      showToast(state.error.message, error: true);
                    }
                  }, builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomButton(
                          onPressed: state is DataLoading
                              ? () {}
                              : () {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  if (_fbKey.currentState!.validate()) {
                                    LoginRequestModel model = LoginRequestModel(
                                      mobile:
                                          userNameController.text.contains("@")
                                              ? null
                                              : userNameController.text,
                                      email:
                                          userNameController.text.contains("@")
                                              ? userNameController.text
                                              : null,
                                      password: passwordController.text,
                                    );
                                    bloc.add(LoginSubmitEvent(model: model));
                                  } else if (userNameController.text.isEmpty) {
                                    userNameFocusNode.requestFocus();
                                  } else if (passwordController.text.isEmpty) {
                                    passwordFocusNode.requestFocus();
                                  }
                                },
                          text: state is DataLoading
                              ? const CircleLoader()
                              : Text(
                                  "${AppLocalizations.of(context)!.sign_in}",
                                )),
                    );
                  }),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.dont_have_account,
                        style: AppStyle.textStyleF17W600(color: Colors.black54),
                      ),
                      InkWell(
                        onTap: () {
                          getIt<AppRoute>().router.push(RoutePath.signUp);
                        },
                        child: Text(
                          "${AppLocalizations.of(context)!.sign_up}",
                          style: AppStyle.textStyleF17W600D(
                              color: AppColors.primaryColor.parseColor()),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
