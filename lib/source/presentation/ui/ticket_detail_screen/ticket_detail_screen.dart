import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ju_express/source/data/model/download_ticket/download_ticket_res.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';

import '../../../../di/injection.dart';
import '../../../../route/route_config.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_images.dart';
import '../../../utils/helper_functions.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/loader.dart';
import '../download_ticket/download_ticket_screen.dart';

class TicketDetailsScreen extends StatefulWidget {
  const TicketDetailsScreen({Key? key, required this.data}) : super(key: key);
  final DownloadTicketRes data;

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        getIt<AppRoute>().router.go(RoutePath.home);
        return false;
      },
      child: Scaffold(
        appBar: MyAppBar(
          leading: IconButton(
            onPressed: () {
              getIt<AppRoute>().router.go(RoutePath.home);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: AppColors.backgroundColor.parseColor(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //success image and title
              Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      AppImages.success,
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .your_ticket_has_been_confirmed,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              for (TicketDetails e in widget.data.ticketDetails!) ...[
                Padding(
                  padding: const EdgeInsets.all(12.0).copyWith(bottom: 0),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(.5),
                                          width: 2,
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(AppImages.avatar),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.name ?? "",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                          showMobileNumber(
                                            mobile:
                                                "${e.cCode ?? ""}${e.mobile ?? ""}",
                                            context: context,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            textDecoration: TextDecoration.none,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                const Row(
                                  children: [
                                    MyArc(diameter: 30, isLeft: true),
                                    Expanded(child: MySeparator()),
                                    MyArc(diameter: 30, isLeft: false),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .from,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black38,
                                              ),
                                            ),
                                            Text(
                                              e.from ?? "",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: AppColors.primaryColor
                                                    .parseColor(),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              e.boarding ?? "",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 10,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: AppColors
                                                            .primaryColor
                                                            .parseColor(),
                                                        width: 2)),
                                              ),
                                              Expanded(

                                                child: Container(
                                                  width: double.infinity,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.primaryColor
                                                      .parseColor(),
                                                  borderRadius:
                                                  BorderRadius.circular(55),
                                                ),
                                                padding: const EdgeInsets.all(8),
                                                child: const Icon(
                                                  Icons.directions_bus,
                                                  size: 22,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  width: double.infinity,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Container(
                                                height: 10,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: AppColors
                                                            .primaryColor
                                                            .parseColor(),
                                                        width: 2)),
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.to,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black38,
                                              ),
                                            ),
                                            Text(
                                              e.to ?? "",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppColors.primaryColor
                                                    .parseColor(),
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              e.dropping ?? "",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${e.journyDate ?? ""} ${e.departureTime ?? ""}",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                const Row(
                                  children: [
                                    MyArc(diameter: 30, isLeft: true),
                                    Expanded(child: MySeparator()),
                                    MyArc(diameter: 30, isLeft: false),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .pnr,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  e.diPnr ?? "",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .coach,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  e.coach ?? "",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .seats,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  e.seatNames ?? "",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.fare,
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            e.salePriceCrSymbol ?? "",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        backgroundColor: AppColors.secondaryColor.parseColor()),
                    onPressed: isLoading
                        ? () {}
                        : () async {
                            setState(() {
                              isLoading = true;
                            });
                            await downloadTicket(
                                widget.data.ticketDetails!.first, context);
                            setState(() {
                              isLoading = false;
                            });
                          },
                    child: isLoading
                        ? const CircleLoader()
                        : Text(
                            AppLocalizations.of(context)!.download_ticket,
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        backgroundColor: AppColors.secondaryColor.parseColor()),
                    onPressed: isLoading
                        ? () {}
                        : () async {
                            getIt<AppRoute>().router.go(RoutePath.home);
                          },
                    child: isLoading
                        ? const CircleLoader()
                        : Text(
                            AppLocalizations.of(context)!.go_to_home,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
