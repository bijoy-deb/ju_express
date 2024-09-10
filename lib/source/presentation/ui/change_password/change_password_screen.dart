import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/error/error_message.dart';
import '../../../../di/injection.dart';
import '../../../../route/route_config.dart';
import '../../../data/local/app_shared_preferences.dart';
import '../../../data/model/authentication/request/change_password_request_model.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/text_styles.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loader.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _fbKey = GlobalKey<FormState>();
  AppSharedPrefs sp = getIt<AppSharedPrefs>();
  final FocusNode currentPasswordFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  bool currentPassisObscure = true;
  bool newPassisObscure = true;
  bool confirmPassisObscure = true;
  final router = getIt<AppRoute>().router;
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final bloc = getIt<AuthenticationBloc>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: MyAppBar(title: AppLocalizations.of(context)!.change_password),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _fbKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.current_password,
                      style: AppStyle.textStyleF17W600(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: customInputDecoration(
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
                        hintText:
                            AppLocalizations.of(context)!.current_password,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: currentPassisObscure,
                      focusNode: currentPasswordFocusNode,
                      controller: currentPasswordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)!.enter_password;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.new_password,
                      style: AppStyle.textStyleF17W600(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: customInputDecoration(
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              newPassisObscure = !newPassisObscure;
                            });
                          },
                          child: Icon(
                            newPassisObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        hintText: AppLocalizations.of(context)!.new_password,
                      ),
                      obscureText: newPassisObscure,
                      focusNode: newPasswordFocusNode,
                      controller: newPasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)!.new_password;
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
                        ),
                      ),
                      obscureText: confirmPassisObscure,
                      focusNode: confirmPasswordFocusNode,
                      controller: confirmPasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)!.confirm_password;
                        } else if (newPasswordController.text !=
                            confirmPasswordController.text) {
                          return AppLocalizations.of(context)!
                              .password_not_matched;
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    BlocConsumer<AuthenticationBloc, AuthenticationState>(
                        listener: (context, state) {
                      if (state is ChangePasswordLoaded) {
                        if (state.res.status == 1) {
                          showToast(
                              AppLocalizations.of(context)!.password_changed,
                              success: true);
                          Navigator.pop(context);
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
                                FocusManager.instance.primaryFocus!.unfocus();
                                if (_fbKey.currentState!.validate()) {
                                  ChangePasswordRequestModel model =
                                      ChangePasswordRequestModel(
                                    oldPassword: currentPasswordController.text,
                                    newPassword: newPasswordController.text,
                                    confirmPassword:
                                        confirmPasswordController.text,
                                  );

                                  bloc.add(
                                      ChangePasswordSubmitEvent(model: model));
                                } else if (currentPasswordController
                                    .text.isEmpty) {
                                  currentPasswordFocusNode.requestFocus();
                                } else if (newPasswordController.text.isEmpty) {
                                  newPasswordFocusNode.requestFocus();
                                } else if (confirmPasswordController
                                    .text.isEmpty) {
                                  confirmPasswordFocusNode.requestFocus();
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
      ),
    );
  }
}
