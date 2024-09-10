import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ju_express/source/data/local/app_shared_preferences.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';
import 'package:provider/provider.dart';

import '../../../../di/injection.dart';
import '../../../../route/route_config.dart';
import '../../../proviers/app_prefs.dart';
import '../../../utils/app_color.dart';

class InitLangScreen extends StatefulWidget {
  const InitLangScreen({Key? key}) : super(key: key);

  @override
  State<InitLangScreen> createState() => _InitLangScreenState();
}

class _InitLangScreenState extends State<InitLangScreen> {
  AppSharedPrefs sp = getIt<AppSharedPrefs>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor.parseColor(),
      body: Consumer<AppPrefs>(
        builder: (context, prefs, child) {
          return Padding(
            padding: const EdgeInsets.only(top: 150, bottom: 70),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/language.png',
                    width: 110,
                    color: Colors.white,
                  ),
                  Column(
                    children: [
                      Row(),
                      Text(
                        AppLocalizations.of(context)!.select_language,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      for (var e in prefs.locals.entries)
                        Container(
                          width: 180,
                          height: 45,
                          margin: EdgeInsets.only(bottom: 25),
                          child: ElevatedButton(
                            onPressed: () async {
                              prefs.changeLocale(e.key);
                              getIt<AppRoute>().router.push(RoutePath.intro);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 2,
                                      color: e.key == sp.getLnCode()
                                          ? AppColors.primaryColor.parseColor()
                                          : Colors.white),
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: e.key != sp.getLnCode()
                                  ? AppColors.primaryColor.parseColor()
                                  : Colors.white,
                              foregroundColor: e.key == sp.getLnCode()
                                  ? AppColors.primaryColor.parseColor()
                                  : Colors.white,
                            ),
                            child: Text(
                              e.value['name']!,
                            ),
                          ),
                        ),
                    ],
                  )
                ]),
          );
        },
      ),
    );
  }
}
