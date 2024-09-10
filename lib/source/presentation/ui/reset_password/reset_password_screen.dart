import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/error/error_message.dart';
import '../../../../di/injection.dart';
import '../../../../route/route_config.dart';
import '../../../data/model/authentication/request/reset_password_request_model.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/text_styles.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loader.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String value;
  const ResetPasswordScreen({super.key, required this.value});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController otpController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode otpFocusNode = FocusNode();

  final FocusNode passwordFocusNode = FocusNode();

  final FocusNode confirmPasswordocusNode = FocusNode();

  bool currentPassisObscure = true;

  bool confirmPassisObscure = true;
  final bloc = getIt<AuthenticationBloc>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: MyAppBar(title: AppLocalizations.of(context)!.reset_password),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.otp,
                    style: AppStyle.textStyleF17W600(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    focusNode: otpFocusNode,
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: customInputDecoration(
                        hintText: AppLocalizations.of(context)!.otp),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!.enter_otp;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.password,
                    style: AppStyle.textStyleF17W600(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: currentPassisObscure,
                    focusNode: passwordFocusNode,
                    controller: passwordController,
                    textInputAction: TextInputAction.next,
                    decoration: customInputDecoration(
                      hintText: AppLocalizations.of(context)!.password,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            currentPassisObscure = !currentPassisObscure;
                          });
                        },
                        child: Icon(
                          currentPassisObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!.enter_password;
                      } else if (!validatePassword(value)) {
                        return AppLocalizations.of(context)!
                            .enter_valid_password;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.confirm_password,
                    style: AppStyle.textStyleF17W600(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: confirmPassisObscure,
                    focusNode: confirmPasswordocusNode,
                    controller: confirmPasswordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: customInputDecoration(
                        hintText:
                            AppLocalizations.of(context)!.confirm_password,
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              confirmPassisObscure = !confirmPassisObscure;
                            });
                          },
                          child: Icon(
                            confirmPassisObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!
                            .enter_confirm_password;
                      } else if (passwordController.text !=
                          confirmPasswordController.text) {
                        return AppLocalizations.of(context)!
                            .password_not_matched;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<AuthenticationBloc, AuthenticationState>(
                      listener: (context, state) {
                    if (state is ResetPasswordLoaded) {
                      if (state.res.status == 1) {
                        showToast(
                            ErrorMessage.getErrorFromMsg(state.res.m).message,
                            success: true);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        getIt<AppRoute>().router.push(RoutePath.signIn);
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
                              if (_formKey.currentState!.validate()) {
                                FocusManager.instance.primaryFocus!.unfocus();

                                ResetPasswordRequestModel model =
                                    ResetPasswordRequestModel(
                                  email: widget.value.contains("@")
                                      ? widget.value
                                      : null,
                                  mobile: widget.value.contains("@")
                                      ? null
                                      : widget.value,
                                  confirmPassword:
                                      confirmPasswordController.text,
                                  otp: otpController.text,
                                  password: passwordController.text,
                                );
                                bloc.add(
                                    ResetPasswordSubmitEvent(model: model));
                              } else if (otpController.text.isEmpty) {
                                otpFocusNode.requestFocus();
                              } else if (passwordController.text.isEmpty) {
                                passwordFocusNode.requestFocus();
                              } else if (confirmPasswordController
                                  .text.isEmpty) {
                                confirmPasswordocusNode.requestFocus();
                              }
                            },
                    );
                  }),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
