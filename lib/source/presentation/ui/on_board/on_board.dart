import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ju_express/source/data/local/app_shared_preferences.dart';
import 'package:ju_express/source/utils/app_color.dart';
import 'package:ju_express/source/utils/app_images.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';

import '../../../../di/injection.dart';
import '../../../../route/route_config.dart';
import '../../../proviers/app_prefs.dart';
import '../../../utils/Constants.dart';
import '../../bloc/home/home_bloc.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  AppSharedPrefs sp = getIt<AppSharedPrefs>();
  final router = getIt<AppRoute>().router;
  final bloc = getIt<HomeBloc>();
  final bool showRegister = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc..add(GetHomePageInt()),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) async {
          if (state is HomePageIntLoaded) {
            log("state is $state");
            if (state.res.status == 1) {
              showRegister == true;
              AppPrefs.appDataLoaded = true;
              getIt<AppSharedPrefs>().setHomePageInt(state.res);
              log("HomePageIntLoaded is ${getIt<AppSharedPrefs>().getHomePageInt()}");
            }
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.primaryColor.parseColor(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages.icon,
                          color: Colors.white,
                          height: 120,
                          width: 100,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          Constants.appName,
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)!.onBoard_slogan,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.secondaryColor.parseColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: () {
                            getIt<AppRoute>().router.push(RoutePath.signIn);
                          },
                          child: Text(AppLocalizations.of(context)!.login,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ))),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.secondaryColor.parseColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: showRegister
                              ? null
                              : () {
                                  getIt<AppRoute>()
                                      .router
                                      .push(RoutePath.signUp);
                                },
                          child:
                              Text(AppLocalizations.of(context)!.registration,
                                  style: TextStyle(
                                    color: !showRegister
                                        ? Colors.white
                                        : Colors.grey,
                                    fontSize: 18,
                                  ))),
                    ),
                    TextButton(
                        onPressed: () {
                          sp.setFirstEntry(false);
                          router.go(RoutePath.home);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.continue_as_guest,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        )),
                    const SizedBox(height: 15),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
