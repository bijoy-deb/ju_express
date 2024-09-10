import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ju_express/source/utils/text_styles.dart';

import '../../../../core/error/error_message.dart';
import '../../../../di/injection.dart';
import '../../../../route/route_config.dart';
import '../../../data/local/app_shared_preferences.dart';
import '../../../data/model/authentication/request/otp_verification_request_model.dart';
import '../../../data/model/authentication/request/resend_otp_request_model.dart';
import '../../../utils/helper_functions.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loader.dart';
import 'widgets/otp_selection_dialog.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen(
      {Key? key,
      required this.phn,
      required this.code,
      required this.email,
      required this.type,
      required this.hasLogin})
      : super(key: key);
  final String phn;
  final String code;
  final String email;
  final int type;
  final bool hasLogin;
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late int _value = widget.type;

  var otpFocusNode = FocusNode();
  final TextEditingController otpController = TextEditingController();

  AppSharedPrefs sp = getIt<AppSharedPrefs>();
  GoRouter router = getIt<AppRoute>().router;
  final bloc = getIt<AuthenticationBloc>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var check = _value == 1 ? widget.code + widget.phn : widget.email;
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: MyAppBar(
          title: AppLocalizations.of(context)!.verify,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.enter_otp_sent} ${_value == 1 ? AppLocalizations.of(context)!.mobile.toLowerCase() : AppLocalizations.of(context)!.email.toLowerCase()}: $check",
                          style: AppStyle.textStyleF17W400(),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: formKey,
                          child: TextFormField(
                            controller: otpController,
                            decoration: customInputDecoration(
                              labelText: AppLocalizations.of(context)!.otp,
                              prefixIcon: const Icon(Icons.pin_outlined),
                            ),
                            focusNode: otpFocusNode,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!.enter_otp;
                              }

                              return null;
                            },
                            autofocus: true,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        widget.hasLogin == false
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      final bloc = getIt<AuthenticationBloc>();
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return BlocProvider(
                                              create: (context) => bloc,
                                              child: AlertDialog(
                                                title: Column(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)!
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
                                                        AppLocalizations.of(
                                                                context)!
                                                            .select_one_option_otp,
                                                        style: AppStyle
                                                            .textStyleF17W400(),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                content: OTPSelectionDialog(
                                                  phn: widget.phn,
                                                  code: widget.code,
                                                  email: widget.email,
                                                  type: (value) {
                                                    setState(() {
                                                      _value = value;
                                                    });
                                                  },
                                                ),
                                                actions: <Widget>[
                                                  BlocConsumer<
                                                          AuthenticationBloc,
                                                          AuthenticationState>(
                                                      listener:
                                                          (context, state) {
                                                    if (state
                                                        is ResendOtpLoaded) {
                                                      if (state.res.status ==
                                                          1) {
                                                        showToast(
                                                            ErrorMessage
                                                                    .getErrorFromMsg(
                                                                        state
                                                                            .res
                                                                            .m)
                                                                .message,
                                                            success: true);
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      } else {
                                                        showToast(
                                                            ErrorMessage
                                                                    .getErrorFromMsg(
                                                                        state
                                                                            .res
                                                                            .m)
                                                                .message,
                                                            error: true);
                                                      }
                                                    } else if (state
                                                        is DataError) {
                                                      showToast(
                                                          state.error.message,
                                                          error: true);
                                                    }
                                                  }, builder: (context, state) {
                                                    return CustomButton(
                                                      text: state is DataLoading
                                                          ? const CircleLoader()
                                                          : Text(AppLocalizations
                                                                  .of(context)!
                                                              .submit),
                                                      onPressed:
                                                          state is DataLoading
                                                              ? () {}
                                                              : () {
                                                                  ResendOtpRequestModel model = ResendOtpRequestModel(
                                                                      cCode: _value ==
                                                                              1
                                                                          ? widget
                                                                              .code
                                                                          : "",
                                                                      email: _value ==
                                                                              1
                                                                          ? ""
                                                                          : widget
                                                                              .email,
                                                                      mobile: _value ==
                                                                              1
                                                                          ? widget
                                                                              .phn
                                                                          : "",
                                                                      otpResendOption: _value ==
                                                                              1
                                                                          ? "mobile"
                                                                          : "email");
                                                                  bloc.add(
                                                                      ResendOtpSubmitEvent(
                                                                          model:
                                                                              model));
                                                                },
                                                    );
                                                  })
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.resend,
                                      style: AppStyle.textStyleF17W400(),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  BlocConsumer<AuthenticationBloc, AuthenticationState>(
                      listener: (context, state) {
                    if (state is OtpLoaded) {
                      if (state.res.status == 1) {
                        sp.setAuthCode(state.res.authcode!);
                        sp.setUserInfo(state.res.data!);
                        showToast(
                            ErrorMessage.getErrorFromMsg(state.res.m).message,
                            success: true);
                        navigateToHome(context);
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: CustomButton(
                        text: state is DataLoading
                            ? const CircleLoader()
                            : Text(AppLocalizations.of(context)!.submit),
                        onPressed: state is DataLoading
                            ? () {}
                            : () {
                                if (formKey.currentState!.validate()) {
                                  OtpVerificationRequestModel model =
                                      OtpVerificationRequestModel(
                                          otpCode: otpController.text,
                                          mail: _value == 1 ? "" : widget.email,
                                          phone: _value == 1 ? widget.phn : "");
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  bloc.add(OtpVerifyEvent(model: model));
                                } else {
                                  otpFocusNode.requestFocus();
                                }
                              },
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
