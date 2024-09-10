import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';

import '../../../../core/error/error_message.dart';
import '../../../../di/injection.dart';
import '../../../../route/route_config.dart';
import '../../../data/local/app_shared_preferences.dart';
import '../../../data/model/authentication/request/update_profile_request_model.dart';
import '../../../data/model/authentication/response/login_response_model.dart';
import '../../../data/model/home/home_page_int_res.dart';
import '../../../utils/app_color.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/text_styles.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/header.dart';
import '../../widgets/loader.dart';
import '../../widgets/shimmer_effect.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _fbKey = GlobalKey<FormState>();

  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode surNameFocusNode = FocusNode();
  final FocusNode fatherNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController surNameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  AppSharedPrefs sp = getIt<AppSharedPrefs>();

  final bloc = getIt<AuthenticationBloc>();
  final bloc2 = getIt<AuthenticationBloc>();
  late Map<String, InputField> registrInputFields;
  late UserInfo userInfo;
  late String authCode;

  @override
  void initState() {
    userInfo = sp.getUserInfo();
    authCode = sp.getAuthCode();
    registrInputFields =
        getIt<AppSharedPrefs>().getHomePageInt().registrInputFields!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        if (authCode.isNotEmpty) {
          bloc.add(GetProfileInfoEvent());
        }
        return bloc;
      },
      child: Scaffold(
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
                                  getIt<AppRoute>()
                                      .router
                                      .push(RoutePath.signIn);
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
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            BlocConsumer<AuthenticationBloc,
                                AuthenticationState>(
                              listener: (context, state) async {
                                if (state is ProfileLoaded) {
                                  if (state.res.status == 1) {
                                    firstNameController.text =
                                        state.res.data!.cFirstName ?? "";
                                    lastNameController.text =
                                        state.res.data!.cLastName ?? "";
                                    surNameController.text =
                                        state.res.data!.cSureName ?? "";
                                    fatherNameController.text =
                                        state.res.data!.cFatherName ?? "";
                                    phoneNumberController.text =
                                        "${state.res.data!.cCode} ${state.res.data!.cMobile}";
                                    emailController.text =
                                        state.res.data!.cEmail ?? "";
                                  } else if (state.res.status == 4) {
                                    showToast(
                                        ErrorMessage.getErrorFromMsg(
                                                state.res.m)
                                            .message,
                                        error: false);
                                    bool success = await logout();
                                    if (success) {
                                      navigateToHome(context);
                                    }
                                  }
                                }
                              },
                              builder: (context, state) {
                                if (state is DataLoading) {
                                  return const ListShimmer(
                                      length: 1, height: 500);
                                } else if (state is ProfileLoaded) {
                                  if (state.res.status == 1) {
                                    return Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(70),
                                          ),
                                          child: CircleAvatar(
                                            backgroundColor: AppColors
                                                .primaryColor
                                                .parseColor()
                                                .withOpacity(.8),
                                            radius: 70,
                                            child: Text(
                                              "${state.res.data!.cFirstName!.isNotEmpty ? state.res.data!.cFirstName![0] : ""}${state.res.data!.cSureName!.isNotEmpty ? state.res.data!.cSureName![0] : ""}${state.res.data!.cLastName!.isNotEmpty ? state.res.data!.cLastName![0] : ""}",
                                              style: AppStyle.textStyleF45W700(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(25),
                                                  topRight:
                                                      Radius.circular(25))),
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 40),
                                            child: Form(
                                              key: _fbKey,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (registrInputFields[
                                                              "first_name"]!
                                                          .fillable ==
                                                      1) ...[
                                                    const SizedBox(height: 20),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .first_name,
                                                      style: AppStyle
                                                          .textStyleF17W600(),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    TextFormField(
                                                      focusNode:
                                                          firstNameFocusNode,
                                                      controller:
                                                          firstNameController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value
                                                                    .trim()
                                                                    .isEmpty &&
                                                                registrInputFields[
                                                                            "first_name"]!
                                                                        .isRequired ==
                                                                    1) {
                                                          return registrInputFields[
                                                                          "last_name"]!
                                                                      .fillable ==
                                                                  1
                                                              ? AppLocalizations
                                                                      .of(
                                                                          context)!
                                                                  .enter_first_name
                                                              : AppLocalizations
                                                                      .of(context)!
                                                                  .enter_name;
                                                        }
                                                        return null;
                                                      },
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      decoration:
                                                          customInputDecoration(
                                                        hintText: registrInputFields[
                                                                        "last_name"]!
                                                                    .fillable ==
                                                                1
                                                            ? AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .first_name
                                                            : AppLocalizations
                                                                    .of(context)!
                                                                .name,
                                                      ),
                                                    ),
                                                  ],
                                                  if (registrInputFields[
                                                              "last_name"]!
                                                          .fillable ==
                                                      1) ...[
                                                    const SizedBox(height: 20),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .last_name,
                                                      style: AppStyle
                                                          .textStyleF17W600(),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    TextFormField(
                                                      focusNode:
                                                          lastNameFocusNode,
                                                      controller:
                                                          lastNameController,
                                                      decoration: customInputDecoration(
                                                          hintText:
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .last_name),
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value
                                                                    .trim()
                                                                    .isEmpty &&
                                                                registrInputFields[
                                                                            "last_name"]!
                                                                        .isRequired ==
                                                                    1) {
                                                          return AppLocalizations
                                                                  .of(context)!
                                                              .enter_last_name;
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ],
                                                  if (registrInputFields[
                                                              "surname"]!
                                                          .fillable ==
                                                      1) ...[
                                                    const SizedBox(height: 20),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .surname_name,
                                                      style: AppStyle
                                                          .textStyleF17W600(),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    TextFormField(
                                                      focusNode:
                                                          surNameFocusNode,
                                                      controller:
                                                          surNameController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      decoration: customInputDecoration(
                                                          hintText:
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .surname_name),
                                                      validator: (value) {
                                                        if (value!.isEmpty &&
                                                            registrInputFields[
                                                                        "surname"]!
                                                                    .isRequired ==
                                                                1) {
                                                          return AppLocalizations
                                                                  .of(context)!
                                                              .enter_surname;
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                  if (registrInputFields[
                                                              "father_name"]!
                                                          .fillable ==
                                                      1) ...[
                                                    const SizedBox(height: 20),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .father_name,
                                                      style: AppStyle
                                                          .textStyleF17W600(),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    TextFormField(
                                                      focusNode:
                                                          fatherNameFocusNode,
                                                      controller:
                                                          fatherNameController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: customInputDecoration(
                                                          hintText:
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .father_name),
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      validator: (value) {
                                                        if (value!.isEmpty &&
                                                            registrInputFields[
                                                                        "father_name"]!
                                                                    .isRequired ==
                                                                1) {
                                                          return AppLocalizations
                                                                  .of(context)!
                                                              .enter_father_name;
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                  if (registrInputFields[
                                                              "phone"]!
                                                          .fillable ==
                                                      1) ...[
                                                    const SizedBox(height: 20),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .mobile,
                                                      style: AppStyle
                                                          .textStyleF17W600(),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    TextFormField(
                                                      readOnly: true,
                                                      obscureText: false,
                                                      focusNode:
                                                          phoneNumberFocusNode,
                                                      controller:
                                                          phoneNumberController,
                                                      decoration:
                                                          customInputDecoration(
                                                              hintText:
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .mobile),
                                                    ),
                                                    Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        onTap: () async {
                                                          await context.push(
                                                              RoutePath
                                                                  .change_number);
                                                          bloc.add(
                                                            GetProfileInfoEvent(),
                                                          );
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 8),
                                                              child: Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .change,
                                                                style: AppStyle
                                                                    .textStyleF17W600(
                                                                        color: Colors
                                                                            .red),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  if (registrInputFields[
                                                              "email"]!
                                                          .fillable ==
                                                      1) ...[
                                                    const SizedBox(height: 20),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .email,
                                                      style: AppStyle
                                                          .textStyleF17W600(),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    TextFormField(
                                                      readOnly: true,
                                                      obscureText: false,
                                                      focusNode: emailFocusNode,
                                                      controller:
                                                          emailController,
                                                      decoration:
                                                          customInputDecoration(
                                                              hintText:
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .email),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        await context.push(
                                                            RoutePath
                                                                .change_mail);
                                                        bloc.add(
                                                          GetProfileInfoEvent(),
                                                        );
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 5),
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .change,
                                                              style: AppStyle
                                                                  .textStyleF17W600(
                                                                      color: Colors
                                                                          .red),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                  const SizedBox(height: 20),
                                                  BlocProvider(
                                                    create: (context) => bloc2,
                                                    child: BlocConsumer<
                                                        AuthenticationBloc,
                                                        AuthenticationState>(
                                                      listener: (context,
                                                          state) async {
                                                        print(
                                                            "state is $state");
                                                        if (state
                                                            is UpdateProfileLoaded) {
                                                          if (state
                                                                  .res.status ==
                                                              1) {
                                                            UserInfo user = sp
                                                                .getUserInfo();
                                                            user.cFirstName =
                                                                firstNameController
                                                                        .text ??
                                                                    "";
                                                            user.cLastName =
                                                                lastNameController
                                                                        .text ??
                                                                    "";
                                                            user.cSureName =
                                                                surNameController
                                                                        .text ??
                                                                    "";
                                                            user.cEmail =
                                                                emailController
                                                                        .text ??
                                                                    "";
                                                            await sp
                                                                .setUserInfo(
                                                                    user);
                                                            showToast(
                                                                ErrorMessage.getErrorFromMsg(
                                                                        state
                                                                            .res
                                                                            .m)
                                                                    .message,
                                                                success: true);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          } else if (state
                                                                  .res.status ==
                                                              4) {
                                                            showToast(
                                                                ErrorMessage.getErrorFromMsg(
                                                                        state
                                                                            .res
                                                                            .m)
                                                                    .message,
                                                                error: false);
                                                            getIt<AppRoute>()
                                                                .router
                                                                .go(RoutePath
                                                                    .home);
                                                          } else {
                                                            showToast(
                                                                ErrorMessage.getErrorFromMsg(
                                                                        state
                                                                            .res
                                                                            .m)
                                                                    .message,
                                                                error: true);
                                                          }
                                                        } else if (state
                                                            is DataError) {
                                                          showToast(
                                                              state.error
                                                                  .message,
                                                              error: true);
                                                        }
                                                      },
                                                      builder:
                                                          (context, state) {
                                                        return CustomButton(
                                                          text: state
                                                                  is DataLoading
                                                              ? const CircleLoader()
                                                              : Text(AppLocalizations
                                                                      .of(context)!
                                                                  .update),
                                                          onPressed: state
                                                                  is DataLoading
                                                              ? () {}
                                                              : () {
                                                                  FocusManager
                                                                      .instance
                                                                      .primaryFocus!
                                                                      .unfocus();
                                                                  if (_fbKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    UpdateProfileRequestModel
                                                                        model =
                                                                        UpdateProfileRequestModel(
                                                                      firstName: registrInputFields["first_name"]!.fillable ==
                                                                              1
                                                                          ? firstNameController
                                                                              .text
                                                                          : null,
                                                                      lastName: registrInputFields["last_name"]!.fillable ==
                                                                              1
                                                                          ? lastNameController
                                                                              .text
                                                                          : null,
                                                                      surName: registrInputFields["surname"]!.fillable ==
                                                                              1
                                                                          ? surNameController
                                                                              .text
                                                                          : null,
                                                                      fatherName: registrInputFields["father_name"]!.fillable ==
                                                                              1
                                                                          ? fatherNameController
                                                                              .text
                                                                          : null,
                                                                      email: emailController
                                                                          .text,
                                                                    );
                                                                    bloc2.add(UpdateProfileSubmitEvent(
                                                                        model:
                                                                            model));
                                                                  } else if (firstNameController
                                                                          .text
                                                                          .isEmpty &&
                                                                      registrInputFields["first_name"]!
                                                                              .isRequired ==
                                                                          1) {
                                                                    firstNameFocusNode
                                                                        .requestFocus();
                                                                  } else if (lastNameController
                                                                          .text
                                                                          .isEmpty &&
                                                                      registrInputFields["last_name"]!
                                                                              .isRequired ==
                                                                          1) {
                                                                    lastNameFocusNode
                                                                        .requestFocus();
                                                                  } else if (surNameController
                                                                          .text
                                                                          .isEmpty &&
                                                                      registrInputFields["surname"]!
                                                                              .isRequired ==
                                                                          1) {
                                                                    surNameFocusNode
                                                                        .requestFocus();
                                                                  } else if (fatherNameController
                                                                          .text
                                                                          .isEmpty &&
                                                                      registrInputFields["father_name"]!
                                                                              .isRequired ==
                                                                          1) {
                                                                    fatherNameFocusNode
                                                                        .requestFocus();
                                                                  }
                                                                },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return CustomErrorWidget(
                                        errorMessage:
                                            ErrorMessage.getErrorFromMsg(
                                                state.res.m));
                                  }
                                } else if (state is DataError) {
                                  return CustomErrorWidget(
                                      errorMessage: state.error);
                                }
                                return SizedBox();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          )),
    );
  }
}
