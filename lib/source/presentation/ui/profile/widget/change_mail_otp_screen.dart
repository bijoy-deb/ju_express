import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';

import '../../../../../core/error/error_message.dart';
import '../../../../../di/injection.dart';
import '../../../../data/local/app_shared_preferences.dart';
import '../../../../data/model/authentication/request/change_mail_request_model.dart';
import '../../../../data/model/authentication/response/login_response_model.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../utils/text_styles.dart';
import '../../../bloc/authentication/authentication_bloc.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/loader.dart';

class ChangeMailOtpScreen extends StatefulWidget {
  const ChangeMailOtpScreen({
    Key? key,
    required this.email,
  }) : super(key: key);
  final String email;
  @override
  _ChangeMailOtpScreenState createState() => _ChangeMailOtpScreenState();
}

class _ChangeMailOtpScreenState extends State<ChangeMailOtpScreen> {
  var otpFocusNode = FocusNode();
  final TextEditingController otpController = TextEditingController();
  String otp = "";
  AppSharedPrefs sp = getIt<AppSharedPrefs>();
  final bloc = getIt<AuthenticationBloc>();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor.parseColor(),
        appBar: MyAppBar(
          title: AppLocalizations.of(context)!.verify,
        ),
        body: SizedBox(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.enter_otp_sent} ${AppLocalizations.of(context)!.email.toLowerCase()} ${widget.email}",
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!.enter_otp;
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            focusNode: otpFocusNode,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    BlocConsumer<AuthenticationBloc, AuthenticationState>(
                        listener: (context, state) async {
                      if (state is ChangeMailLoaded) {
                        if (state.res.status == 1) {
                          showToast(
                              ErrorMessage.getErrorFromMsg(state.res.m).message,
                              success: true);
                          UserInfo user = sp.getUserInfo();
                          user.cEmail = widget.email;
                          await sp.setUserInfo(user);

                          Navigator.pop(context);
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
                          onPressed: state is DataLoading
                              ? () {}
                              : () {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  if (formKey.currentState!.validate()) {
                                    ChangeMailRequestModel model =
                                        ChangeMailRequestModel(
                                      changeEmail: widget.email,
                                      otp: otpController.text,
                                    );
                                    bloc.add(
                                        ChangeMailSubmitEvent(model: model));
                                  } else {
                                    otpFocusNode.requestFocus();
                                  }
                                },
                          text: state is DataLoading
                              ? const CircleLoader()
                              : Text(AppLocalizations.of(context)!.submit));
                    } // },
                        ),
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
