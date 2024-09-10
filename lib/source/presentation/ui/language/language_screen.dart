import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ju_express/source/data/local/app_shared_preferences.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';
import 'package:provider/provider.dart';

import '../../../../di/injection.dart';
import '../../../proviers/app_prefs.dart';
import '../../../utils/app_color.dart';
import '../../widgets/app_bar.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  AppSharedPrefs sp = getIt<AppSharedPrefs>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.parseColor(),
      appBar: MyAppBar(
        title: AppLocalizations.of(context)!.language,
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        padding: const EdgeInsets.only(left: 8, right: 0, bottom: 8, top: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black12)]),
        child: Consumer<AppPrefs>(
          builder: (context, prefs, child) {
            return Material(
              color: Colors.white,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: prefs.locals.entries
                      .map(
                        (e) => Transform.translate(
                          offset: Offset(-10, 0),
                          child: RadioListTile(
                            title: Transform.translate(
                                offset: Offset(-10, 0),
                                child: Text(e.value['name']!)),
                            value: e.key,
                            groupValue: sp.getLnCode(),
                            activeColor: HexColor(AppColors.primaryColor),
                            onChanged: (value) async {
                              prefs.changeLocale(e.key);
                              await sp.setLastDBUpdate(DateTime.now()
                                  .subtract(const Duration(days: 1))
                                  .millisecondsSinceEpoch);
                              // sp.setFromCity(District());
                              // sp.setToCity(District());
                            },
                          ),
                        ),
                      )
                      .toList()),
            );
          },
        ),
      ),
    );
  }
}
