import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/error/error_message.dart';
import '../../../../di/injection.dart';
import '../../../data/model/authentication/request/forgot_password_request_model.dart';

import '../../../utils/helper_functions.dart';
import '../../../utils/text_styles.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loader.dart';
import '../reset_password/reset_password_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final _fbKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final bloc = getIt<AuthenticationBloc>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: MyAppBar(title: AppLocalizations.of(context)!.forget_password),
        body: SingleChildScrollView(
          child: Form(
            key: _fbKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.mobile_or_mail,
                    style: AppStyle.textStyleF17W600(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    focusNode: focusNode,
                    controller: controller,
                    decoration: customInputDecoration(
                        hintText: AppLocalizations.of(context)!.mobile_or_mail),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<AuthenticationBloc, AuthenticationState>(
                      listener: (context, state) {
                    if (state is ForgotPasswordLoaded) {
                      if (state.res.status == 1) {
                        showToast(
                            ErrorMessage.getErrorFromMsg(state.res.m).message,
                            success: true);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPasswordScreen(
                                    value: controller.text,
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
                              FocusManager.instance.primaryFocus!.unfocus();
                              if (_fbKey.currentState!.validate()) {
                                ForgotPasswordRequestModel model =
                                    ForgotPasswordRequestModel(
                                  email: controller.text.contains("@")
                                      ? controller.text
                                      : null,
                                  mobile: controller.text.contains("@")
                                      ? null
                                      : controller.text,
                                );
                                bloc.add(
                                    ForgotPasswordSubmitEvent(model: model));
                              } else if (controller.text.isEmpty) {
                                focusNode.requestFocus();
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
}
