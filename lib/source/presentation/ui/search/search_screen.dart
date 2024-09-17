import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ju_express/route/route_config.dart';
import 'package:ju_express/source/data/local/app_shared_preferences.dart';
import 'package:ju_express/source/data/model/departure_details/departure_search_args.dart';
import 'package:ju_express/source/presentation/bloc/home/home_bloc.dart';
import 'package:ju_express/source/presentation/ui/search/widget/swap_button.dart';
import 'package:ju_express/source/presentation/widgets/shimmer_effect.dart';
import 'package:ju_express/source/utils/app_color.dart';
import 'package:ju_express/source/utils/app_images.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';

import '../../../../di/injection.dart';
import '../../../data/model/common/district.dart';
import '../../../proviers/app_prefs.dart';
import '../../../utils/helper_functions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  AppSharedPrefs sp = getIt<AppSharedPrefs>();
  late District fromCity;
  late District toCity;
  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();
  FocusNode fromFocus = FocusNode();
  FocusNode toFocus = FocusNode();
  FocusNode departureFocus = FocusNode();
  GoRouter router = getIt<AppRoute>().router;
  final bloc = getIt<HomeBloc>();
  String scrollerText = "abc";

  @override
  void initState() {
    fromCity = District(); //sp.getFromCity();
    toCity = District(); //sp.getToCity();
    from.text = fromCity.distTitle ?? "";
    to.text = toCity.distTitle ?? "";
    selectedDate = DateTime.now();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: BlocProvider(
        create: (context) => bloc..add(GetHomePageInt()),
        child: Stack(
          children: [
            Container(
              height: (MediaQuery.of(context).size.height) / 2,
              color: AppColors.primaryColor.parseColor().withOpacity(.95),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0)
                  .copyWith(bottom: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: SizedBox(
                              width: double.infinity,
                              height: AppBar().preferredSize.height + 60),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo-white.png',
                          height: 60,
                        ),
                      ],
                    ),
                    SizedBox(height: AppBar().preferredSize.height - 20),
                    Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            wrapWithContainer(
                                child: Stack(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .from,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Image.asset(
                                              AppImages.city,
                                              height: 35,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            focusNode: fromFocus,
                                            controller: from,
                                            readOnly: true,
                                            onTap: () async {
                                              District? selected =
                                                  await router.push(RoutePath
                                                          .districtList)
                                                      as District?;
                                              if (selected != null) {
                                                from.text = selected.distTitle!;
                                                fromCity = selected;
                                                await sp.setFromCity(selected);
                                              }
                                            },
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty) {
                                                return AppLocalizations.of(
                                                        context)!
                                                    .selectFromCity;
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 15),
                                              border: InputBorder.none,
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .select_from_city,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.to,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Image.asset(
                                              AppImages.city,
                                              height: 35,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            focusNode: toFocus,
                                            controller: to,
                                            readOnly: true,
                                            onTap: () async {
                                              if (fromCity.distId == null) {
                                                showToast(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .select_from,
                                                    error: true);
                                                return;
                                              } else {
                                                District? selected =
                                                    await router.push(
                                                        RoutePath.districtList,
                                                        extra: fromCity
                                                            .distId) as District?;
                                                if (selected != null) {
                                                  to.text = selected.distTitle!;
                                                  toCity = selected;
                                                  await sp.setToCity(selected);
                                                }
                                              }
                                            },
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty) {
                                                return AppLocalizations.of(
                                                        context)!
                                                    .selectToCity;
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 15),
                                              border: InputBorder.none,
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .select_to_city,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SwapButton(
                                    callback: () async {
                                      District temp = fromCity;
                                      from.text = to.text;
                                      fromCity = toCity;
                                      await sp.setFromCity(fromCity);
                                      to.text = temp.distTitle!;
                                      toCity = temp;
                                      await sp.setToCity(toCity);
                                    },
                                  ),
                                )
                              ],
                            )),
                            wrapWithContainer(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.departure_date,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        DateTime? picked = await pickDate(
                                            selected: selectedDate,
                                            context: context);
                                        if (picked != null) {
                                          selectedDate = picked;
                                          setState(() {});
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(Icons.calendar_month),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            DateFormat('dd')
                                                .format(selectedDate),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            DateFormat('MMM')
                                                .format(selectedDate),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            DateFormat('yyyy')
                                                .format(selectedDate),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedDate = DateTime.now();
                                        });
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.today,
                                        style: TextStyle(
                                            color: AppColors.primaryColor
                                                .parseColor(),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.secondaryColor.parseColor(),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    router.push(RoutePath.departureList,
                                        extra: DepartureSearchArgs(
                                            from: fromCity,
                                            to: toCity,
                                            date: selectedDate));
                                  } else if (fromCity.distId == null) {
                                    fromFocus.requestFocus();
                                  } else if (toCity.distId == null) {
                                    toFocus.requestFocus();
                                  }
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.searchBus,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    BlocConsumer<HomeBloc, HomeState>(
                      builder: (context, state) {
                        if (state is HomePageIntLoading) {
                          return const Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              ListShimmer(length: 1, height: 40),
                              ListShimmer(length: 1, height: 200),
                            ],
                          );
                        } else if (state is HomePageIntLoaded) {
                          if (state.res.status == 1) {
                            log("pop list ${state.res.popularBusTripsList}");
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (state.res.popularBusTripsList != null &&
                                      state.res.popularBusTripsList!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, bottom: 8.0),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .popular_bus_trips,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  if (state.res.popularBusTripsList != null &&
                                      state.res.popularBusTripsList!.isNotEmpty)
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          for (var data in state
                                              .res.popularBusTripsList!) ...[
                                            Container(
                                              margin: EdgeInsets.only(
                                                left: 5,
                                                right: 5,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 8, left: 4),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  onTap: () {
                                                    router.push(
                                                        RoutePath.departureList,
                                                        extra:
                                                            DepartureSearchArgs(
                                                                from: District(
                                                                  distId:
                                                                      data.from,
                                                                  distTitle: data
                                                                      .route
                                                                      ?.split(
                                                                          "to")[0],
                                                                ),
                                                                to: District(
                                                                  distId:
                                                                      data.to,
                                                                  distTitle: data
                                                                      .route
                                                                      ?.split(
                                                                          "to")[1],
                                                                ),
                                                                date: DateTime
                                                                    .now()));
                                                  },
                                                  child: Ink(
                                                    child: Container(
                                                      height: 130,
                                                      width: 200,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 2,
                                                              horizontal: 2),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        image: DecorationImage(
                                                          image:
                                                              CachedNetworkImageProvider(
                                                                  data.image!),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8.0,
                                                                    top: 8),
                                                            child: Text(
                                                              data.route!,
                                                              style: const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8.0,
                                                                    bottom: 8),
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          4,
                                                                      horizontal:
                                                                          8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.7),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child: Text(
                                                                data.cheapestTripAmount ??
                                                                    "",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .yellow,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }
                        }
                        return const SizedBox.shrink();
                      },
                      listener: (context, state) async {
                        if (state is HomePageIntLoaded) {
                          if (state.res.status == 1) {
                            AppPrefs.appDataLoaded = true;
                            getIt<AppSharedPrefs>().setHomePageInt(state.res);
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
