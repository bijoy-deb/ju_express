import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/error/error_message.dart';
import '../../../../di/injection.dart';
import '../../../../route/route_config.dart';
import '../../../data/local/app_shared_preferences.dart';
import '../../../data/model/authentication/response/login_response_model.dart';
import '../../../utils/app_color.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/text_styles.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loader.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  AppSharedPrefs sp = getIt<AppSharedPrefs>();

  bool isAgreed1 = false;
  bool isAgreed2 = false;

  final bloc = getIt<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: MyAppBar(title: AppLocalizations.of(context)!.delete_account),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.delete_account_header,
                        style: AppStyle.textStyleF17W600(),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            activeColor: HexColor(AppColors.primaryColor),
                            value: isAgreed1,
                            onChanged: (value) => setState(() {
                              isAgreed1 = !isAgreed1;
                            }),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                AppLocalizations.of(context)!.no_longer_access,
                                style: AppStyle.textStyleF16W400(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            activeColor: HexColor(AppColors.primaryColor),
                            value: isAgreed2,
                            onChanged: (value) => setState(() {
                              isAgreed2 = !isAgreed2;
                            }),
                          ),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.loose_data,
                              style: AppStyle.textStyleF16W400(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0).copyWith(top: 0),
              child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if (state is DeleteAccountLoaded) {
                    if (state.res.status == 1) {
                      sp.setAuthCode("");
                      sp.setUserInfo(UserInfo());
                      showToast(
                          ErrorMessage.getErrorFromMsg(state.res.m).message,
                          success: true);
                      getIt<AppRoute>().router.go(RoutePath.home);
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
                        : Text(AppLocalizations.of(context)!.delete_account),
                    onPressed: state is DataLoading
                        ? () {}
                        : () {
                            isAgreed2 && isAgreed1
                                ? showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text(
                                            AppLocalizations.of(context)!
                                                .delete_account,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: Text(
                                            AppLocalizations.of(context)!
                                                .are_you_sure,
                                            style: const TextStyle(
                                                height: 1.5, fontSize: 14),
                                          ),
                                          contentPadding: const EdgeInsets.only(
                                              top: 10,
                                              left: 20,
                                              right: 20,
                                              bottom: 10),
                                          actions: [
                                            const SizedBox(height: 10),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .no,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                )),
                                            const SizedBox(width: 20),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  FocusManager
                                                      .instance.primaryFocus!
                                                      .unfocus();

                                                  bloc.add(
                                                      DeleteAccountSubmitEvent());
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    side: const BorderSide(
                                                      // width: 5.0,
                                                      color: Colors.white,
                                                    ),
                                                    backgroundColor:
                                                        Colors.white),
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .yes,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                )),
                                          ],
                                        ))
                                : showToast(
                                    AppLocalizations.of(context)!
                                        .check_required_field,
                                    error: true);
                          },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
