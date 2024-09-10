import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../di/injection.dart';
import '../../../../route/route_config.dart';
import '../../../data/local/app_shared_preferences.dart';
import '../../../data/model/authentication/response/login_response_model.dart';
import '../../../utils/app_color.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/text_styles.dart';
import '../../widgets/header.dart';
import '../help_support/widget/single_item.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  AppSharedPrefs sp = getIt<AppSharedPrefs>();
  final router = getIt<AppRoute>().router;
  late UserInfo userInfo;
  late String authCode;
  @override
  void initState() {
    userInfo = sp.getUserInfo();
    authCode = sp.getAuthCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userInfo = sp.getUserInfo();
    authCode = sp.getAuthCode();
    return Column(
      children: [
        const Header(),
        // Container(
        //   margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        //   decoration: BoxDecoration(
        //     color: AppColors.primaryColor.parseColor(),
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.all(10),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             ClipOval(
        //               child: FadeInImage(
        //                 height: 60,
        //                 width: 60,
        //                 image: AssetImage(
        //                   AppImages.avatar,
        //                 ),
        //                 placeholder: AssetImage(AppImages.avatar),
        //               ),
        //             ),
        //             const SizedBox(
        //               width: 15,
        //             ),
        //             authCode.isEmpty
        //                 ? Flexible(
        //                     child: Column(
        //                       mainAxisAlignment: MainAxisAlignment.center,
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         Text(AppLocalizations.of(context)!.guest,
        //                             style: AppStyle.textStyleF20W700(
        //                                 color: Colors.white)),
        //                         Material(
        //                           color: Colors.transparent,
        //                           child: InkWell(
        //                             onTap: () {
        //                               getIt<AppRoute>()
        //                                   .router
        //                                   .push(RoutePath.signIn);
        //                             },
        //                             borderRadius: BorderRadius.circular(10),
        //                             child: Padding(
        //                               padding: const EdgeInsets.all(8.0),
        //                               child: Text(
        //                                   AppLocalizations.of(context)!.login,
        //                                   style: AppStyle.textStyleF18W700(
        //                                       color: AppColors.secondaryColor
        //                                           .parseColor())),
        //                             ),
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   )
        //                 : Flexible(
        //                     child: Column(
        //                       mainAxisAlignment: MainAxisAlignment.center,
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         Text(
        //                           "${userInfo.cFirstName ?? ""} ${userInfo.cSureName ?? ""} ${userInfo.cLastName ?? ""}",
        //                           style: const TextStyle(
        //                               color: Colors.white,
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 16),
        //                         ),
        //                         Padding(
        //                           padding:
        //                               const EdgeInsets.symmetric(vertical: 2.0),
        //                           child: Text(
        //                             "${userInfo.cCode ?? ""} ${userInfo.cMobile ?? ""}",
        //                             style: const TextStyle(
        //                                 color: Colors.white, fontSize: 16),
        //                           ),
        //                         ),
        //                         Text(
        //                           userInfo.cEmail ?? "",
        //                           style: const TextStyle(
        //                               color: Colors.white, fontSize: 16),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Flexible(
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
                // SingleItem(
                //   callback: () {
                //     router.push(RoutePath.changePassword);
                //   },
                //   title: AppLocalizations.of(context)!.change_password,
                //   prefixIcon: Icon(
                //     Icons.password,
                //     color: AppColors.primaryColor.parseColor(),
                //   ),
                // ),
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

              SingleItem(
                callback: () {
                  router.push(RoutePath.staticContent, extra: 'aboutUs');
                },
                title: AppLocalizations.of(context)!.aboutUs,
                prefixIcon: Icon(
                  Icons.info_rounded,
                  color: AppColors.primaryColor.parseColor(),
                ),
              ),
              // SingleItem(
              //   callback: () {
              //     router.push(RoutePath.helpAndSupport);
              //   },
              //   title: AppLocalizations.of(context)!.helpSupport,
              //   prefixIcon: Icon(
              //     Icons.support_agent,
              //     color: AppColors.primaryColor.parseColor(),
              //   ),
              // ),
              SingleItem(
                callback: () {
                  router.push(RoutePath.contactUs);
                },
                title: AppLocalizations.of(context)!.contactUs,
                prefixIcon: Icon(
                  Icons.call,
                  color: AppColors.primaryColor.parseColor(),
                ),
              ),

              SingleItem(
                callback: () {
                  router.push(RoutePath.staticContent,
                      extra: 'termsAndConditions');
                },
                title: AppLocalizations.of(context)!.termsAndConditions,
                prefixIcon: Icon(
                  // FontAwesomeIcons.fileContract,
                  Icons.gavel,
                  color: AppColors.primaryColor.parseColor(),
                ),
              ),
              SingleItem(
                callback: () {
                  router.push(RoutePath.staticContent, extra: 'privacyPolicy');
                },
                title: AppLocalizations.of(context)!.privacyPolicy,
                prefixIcon: Icon(
                  Icons.policy,
                  color: AppColors.primaryColor.parseColor(),
                ),
              ),
              SingleItem(
                callback: () {
                  router.push(RoutePath.staticContent,
                      extra: 'cancellationPolicy');
                },
                title: AppLocalizations.of(context)!.cancellationPolicy,
                prefixIcon: Icon(
                  Icons.policy,
                  color: AppColors.primaryColor.parseColor(),
                ),
              ),
              SingleItem(
                callback: () {
                  router.push(RoutePath.staticContent, extra: 'refundPolicy');
                },
                title: AppLocalizations.of(context)!.refund_policy,
                prefixIcon: Icon(
                  Icons.policy,
                  color: AppColors.primaryColor.parseColor(),
                ),
              ),
              if (1 == 0)
                SingleItem(
                  callback: () {
                    router.push(RoutePath.staticContent, extra: 'refundPolicy');
                  },
                  title: AppLocalizations.of(context)!.refundPolicy,
                  prefixIcon: Icon(
                    FontAwesomeIcons.moneyCheck,
                    color: AppColors.primaryColor.parseColor(),
                  ),
                ),

              Visibility(
                visible: true,
                child: SingleItem(
                  callback: () {
                    router.push(RoutePath.language);
                  },
                  title: AppLocalizations.of(context)!.language,
                  prefixIcon: Icon(
                    Icons.language,
                    color: AppColors.primaryColor.parseColor(),
                  ),
                ),
              ),
              SingleItem(
                callback: () {
                  String link = Constants.webUrl;
                  if (Platform.isAndroid) {
                    link =
                        "https://play.google.com/store/apps/details?id=${getIt<PackageInfo>().packageName}";
                  } else if (Platform.isIOS) {
                    link = Constants.webUrl;
                  } else {
                    link = Constants.webUrl;
                  }
                  Share.share(link);
                },
                title: AppLocalizations.of(context)!.share,
                prefixIcon: Icon(
                  Icons.share,
                  color: AppColors.primaryColor.parseColor(),
                ),
              ),

              const SizedBox(height: 20),
              // authCode.isEmpty
              //     ? Container()
              //     : SingleItem(
              //         callback: () {
              //           getIt<AppRoute>().router.push(RoutePath.deleteAccount);
              //         },
              //         title: AppLocalizations.of(context)!.delete_account,
              //         prefixIcon: Icon(
              //           Icons.delete,
              //           color: AppColors.primaryColor.parseColor(),
              //         ),
              //       ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 15, top: 10),
                  child: Text(
                    "${AppLocalizations.of(context)!.version} : ${getIt<PackageInfo>().version}",
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
