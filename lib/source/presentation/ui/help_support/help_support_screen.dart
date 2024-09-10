import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ju_express/source/utils/Constants.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/app_color.dart';
import '../../../utils/helper_functions.dart';
import '../../widgets/app_bar.dart';
import 'widget/single_item.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.parseColor(),
      appBar: MyAppBar(
        title: AppLocalizations.of(context)!.helpSupport,
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 10),
        children: [
          SingleItem(
            callback: () async {
              Uri uri = Uri(scheme: 'https', path: Constants.domain);
              if (await canLaunchUrl(uri)) {
                launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                showToast(AppLocalizations.of(context)!.something_went_wrong);
              }
            },
            title: "Website",
            prefixIcon: Icon(
              Icons.public,
              size: 30,
              color: AppColors.primaryColor.parseColor(),
            ),
          ),
          SingleItem(
            callback: () async {
              Uri uri = Uri(scheme: 'tel', path: Constants.phone);
              if (await canLaunchUrl(uri)) {
                launchUrl(uri);
              } else {
                showToast(AppLocalizations.of(context)!.something_went_wrong);
              }
            },
            title: AppLocalizations.of(context)!.mobile,
            prefixIcon: Icon(
              Icons.phone,
              size: 30,
              color: AppColors.primaryColor.parseColor(),
            ),
          ),
          SingleItem(
            callback: () async {
              Uri uri = Uri(scheme: 'mailto', path: Constants.email);
              if (await canLaunchUrl(uri)) {
                launchUrl(uri);
              } else {
                showToast(AppLocalizations.of(context)!.something_went_wrong);
              }
            },
            title: AppLocalizations.of(context)!.email,
            prefixIcon: Icon(
              Icons.email,
              size: 30,
              color: AppColors.primaryColor.parseColor(),
            ),
          ),
        ],
      ),
    );
  }
}
