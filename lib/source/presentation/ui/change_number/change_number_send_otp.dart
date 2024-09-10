import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/error/error_message.dart';
import '../../../../di/injection.dart';
import '../../../data/local/app_shared_preferences.dart';
import '../../../data/model/authentication/request/change_number_request_model.dart';
import '../../../data/model/authentication/response/login_response_model.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/text_styles.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loader.dart';

class ChangeNumberOtpScreen extends StatefulWidget {
  const ChangeNumberOtpScreen({
    Key? key,
    required this.phone,
    required this.phoneCode,
  }) : super(key: key);
  final String phone;
  final String phoneCode;
  @override
  _ChangeNumberOtpScreenState createState() => _ChangeNumberOtpScreenState();
}

class _ChangeNumberOtpScreenState extends State<ChangeNumberOtpScreen> {
  var otpFocusNode = FocusNode();
  final TextEditingController otpController = TextEditingController();

  AppSharedPrefs sp = getIt<AppSharedPrefs>();
  final bloc = getIt<AuthenticationBloc>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: MyAppBar(
          title: AppLocalizations.of(context)!.verify,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.enter_otp_sent} ${AppLocalizations.of(context)!.mobile.toLowerCase()}: ${widget.phoneCode}${widget.phone}",
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      if (state is ChangeNumberLoaded) {
                        if (state.res.status == 1) {
                          showToast(
                              ErrorMessage.getErrorFromMsg(state.res.m).message,
                              success: true);
                          UserInfo user = sp.getUserInfo();
                          user.cCode = widget.phoneCode;
                          user.cMobile = widget.phone;
                          await sp.setUserInfo(user);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } else {
                          showToast(
                              ErrorMessage.getErrorFromMsg(state.res.m).message,
                              error: true);
                        }
                      } else if (state is DataError) {
                        showToast(state.error.message);
                      }
                    },
                    builder: (context, state) {
                      return CustomButton(
                          onPressed: state is DataLoading
                              ? () {}
                              : () {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  if (formKey.currentState!.validate()) {
                                    ChangeNumberRequestModel model =
                                        ChangeNumberRequestModel(
                                      changeMobile: widget.phone,
                                      changeCode: widget.phoneCode,
                                      otp: otpController.text,
                                    );
                                    bloc.add(
                                        ChangeNumberSubmitEvent(model: model));
                                  } else {
                                    otpFocusNode.requestFocus();
                                  }
                                },
                          text: state is DataLoading
                              ? const CircleLoader()
                              : Text(AppLocalizations.of(context)!.submit));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
