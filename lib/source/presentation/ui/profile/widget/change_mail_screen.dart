import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/error/error_message.dart';
import '../../../../../di/injection.dart';
import '../../../../data/local/app_shared_preferences.dart';
import '../../../../data/model/authentication/request/mail_send_otp_request_model.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../utils/text_styles.dart';
import '../../../bloc/authentication/authentication_bloc.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/loader.dart';
import 'change_mail_otp_screen.dart';

class ChangeMailScreen extends StatefulWidget {
  const ChangeMailScreen({super.key});

  @override
  State<ChangeMailScreen> createState() => _ChangeMailScreenState();
}

class _ChangeMailScreenState extends State<ChangeMailScreen> {
  final _fbKey = GlobalKey<FormState>();
  AppSharedPrefs sp = getIt<AppSharedPrefs>();
  final TextEditingController mailController = TextEditingController();
  final FocusNode mailFocusNode = FocusNode();
  final bloc = getIt<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: MyAppBar(title: AppLocalizations.of(context)!.change_mail),
        body: SingleChildScrollView(
          child: Form(
            key: _fbKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.email,
                    style: AppStyle.textStyleF17W600(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    focusNode: mailFocusNode,
                    controller: mailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: customInputDecoration(
                        hintText: AppLocalizations.of(context)!.email),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    autofocus: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!.enter_email;
                      } else if (!validateEmail(value)) {
                        return AppLocalizations.of(context)!.enter_valid_email;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<AuthenticationBloc, AuthenticationState>(
                    listener: (context, state) {
                      if (state is MailSendOtpLoaded) {
                        if (state.res.status == 1) {
                          showToast("Otp sent successfully", success: true);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeMailOtpScreen(
                                      email: mailController.text,
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
                    },
                    builder: (context, state) {
                      return CustomButton(
                        text: state is DataLoading
                            ? const CircleLoader()
                            : Text(AppLocalizations.of(context)!.submit),
                        onPressed: state is DataLoading
                            ? () {}
                            : () {
                                if (_fbKey.currentState!.validate()) {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  MailSendOtpRequestModel model =
                                      MailSendOtpRequestModel(
                                    changeEmail: mailController.text,
                                  );
                                  bloc.add(
                                      MailSendOtpSubmitEvent(model: model));
                                } else if (mailController.text.isEmpty) {
                                  mailFocusNode.requestFocus();
                                }
                              },
                      );
                    },
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
