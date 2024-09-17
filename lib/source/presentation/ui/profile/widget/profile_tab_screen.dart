import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';

import '../../../../../di/injection.dart';
import '../../../../../route/route_config.dart';
import '../../../../data/local/app_shared_preferences.dart';
import '../../../../data/model/authentication/response/login_response_model.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../utils/text_styles.dart';
import '../../../widgets/header.dart';
import '../../help_support/widget/single_item.dart';

class ProfileTabScreen extends StatefulWidget {
  const ProfileTabScreen({super.key});

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  AppSharedPrefs sp = getIt<AppSharedPrefs>();
  late UserInfo userInfo;
  late String authCode;
  final router = getIt<AppRoute>().router;
  @override
  void initState() {
    userInfo = sp.getUserInfo();
    authCode = sp.getAuthCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.parseColor(),
      body: Column(
        children: [
          const Header(),
          authCode.isEmpty
              ? Center(
                  child: Container(
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(22.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 60,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(context)!.guest,
                            style: AppStyle.textStyleF17W600().copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {
                              getIt<AppRoute>().router.push(RoutePath.signIn);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.sign_in,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Flexible(
                  child: ListView(
                    padding: const EdgeInsets.only(
                      top: 5,
                      left: 10,
                      right: 10,
                    ),
                    children: [
                      if (authCode.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 15, top: 4),
                          child: Text(
                            AppLocalizations.of(context)!.profile,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SingleItem(
                          callback: () async {
                            await router.push(RoutePath.profile);
                            setState(() {});
                          },
                          title: AppLocalizations.of(context)!.profile,
                          prefixIcon: Icon(
                            Icons.person,
                            color: AppColors.primaryColor.parseColor(),
                          ),
                        ),
                        SingleItem(
                          callback: () {
                            router.push(RoutePath.viewHistory);
                          },
                          title: AppLocalizations.of(context)!.history,
                          prefixIcon: Icon(
                            Icons.history,
                            color: AppColors.primaryColor.parseColor(),
                          ),
                        ),
                        SingleItem(
                          callback: () async {
                            showToast("Coming soon");
                          },
                          title: AppLocalizations.of(context)!.deposit,
                          prefixIcon: Icon(
                            Icons.attach_money_sharp,
                            color: AppColors.primaryColor.parseColor(),
                          ),
                        ),
                        SingleItem(
                          callback: () async {
                            showToast("Coming soon");
                          },
                          title: AppLocalizations.of(context)!.statement,
                          prefixIcon: Icon(
                            Icons.book_outlined,
                            color: AppColors.primaryColor.parseColor(),
                          ),
                        ),
                        SingleItem(
                          callback: () {
                            showLogoutDialog();
                          },
                          title: AppLocalizations.of(context)!.logout,
                          prefixIcon: Icon(
                            Icons.logout,
                            color: AppColors.primaryColor.parseColor(),
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ],
                  ),
                )
        ],
      ),
    );
  }

  showLogoutDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(20),
            title: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.logout,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.are_you_sure_to_logout,
                        style: AppStyle.textStyleF17W600(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.no,
                    style: TextStyle(fontSize: 16),
                  )),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    bool success = await logout();
                    if (success) {
                      navigateToHome(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.white),
                  child: Text(
                    AppLocalizations.of(context)!.yes,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ))
            ],
          );
        });
  }
}
