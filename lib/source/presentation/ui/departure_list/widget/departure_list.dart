import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ju_express/source/data/model/departure_details/departure_search_args.dart';
import 'package:ju_express/source/presentation/bloc/departure/departure_bloc.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../../di/injection.dart';
import '../../../../../route/route_config.dart';
import '../../../../data/local/app_shared_preferences.dart';
import '../../../../data/model/departure_list/departure_list.dart';
import '../../../../utils/app_color.dart';
import 'list_item.dart';

/// Widget that displays a list of departures.
class DepartureList extends StatefulWidget {
  const DepartureList({
    required this.res,
    required this.searchArgs,
    Key? key
  }) : super(key: key);

  /// List of departure results
  final DepartureListRes res;

  /// Search arguments used for filtering the list
  final DepartureSearchArgs searchArgs;

  @override
  State<DepartureList> createState() => _DepartureListState();
}

class _DepartureListState extends State<DepartureList> {
  // Controller for managing scroll behavior
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: scrollController,
      interactive: true,
      thumbVisibility: true,
      thickness: 4,
      radius: const Radius.circular(6),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.only(right: 8, left: 8, bottom: 10),
        children: [
          // Header displaying total trips found
          Padding(
            padding: const EdgeInsets.only(left: 0, top: 3),
            child: Text(
              "${AppLocalizations.of(context)!.total} ${widget.res.departures!.length} ${AppLocalizations.of(context)!.trips_found}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 3),

          // List of departure items
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.res.departures!.length,
              itemBuilder: (context, i) => DepartureListItem(
                departure: widget.res.departures![i],
                callbackSelect: () async {
                  await getIt<AppRoute>().router.push(
                      RoutePath.departureDetails,
                      extra: {
                        'search': widget.searchArgs,
                        'departure': widget.res.departures![i],
                        'idTypes': getIt<AppSharedPrefs>().getHomePageInt().idType,
                        'crSymbol': widget.res.departures![i].currencySymbol
                      }
                  );

                  // Fetch new data after selection
                  context.read<DepartureBloc>().add(
                      GetDepartureListData(
                          from: widget.searchArgs.from.distId!,
                          to: widget.searchArgs.to.distId!,
                          date: widget.searchArgs.date.formatForApi()
                      )
                  );
                },
                callbackAllStation: () {
                  _showAllStations(widget.res.departures![i]);
                },
              )
          ),
        ],
      ),
    );
  }

  /// Show all stations in a modal bottom sheet
  void _showAllStations(Departures departure) {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (_) => Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * .9
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Modal header
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 2),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.all_stations,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor.parseColor(),
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(color: Colors.grey),

              // Stations list
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ListView.builder(
                    itemCount: departure.allStation!.length,
                    itemBuilder: (context, index) {
                      var station = departure.allStation![index];
                      return TimelineTile(
                        isFirst: station.title == departure.dStartPoint,
                        isLast: station.title == departure.dEndPoint,
                        alignment: TimelineAlign.manual,
                        beforeLineStyle: LineStyle(
                          color: AppColors.primaryColor.parseColor(),
                        ),
                        afterLineStyle: LineStyle(
                          color: AppColors.primaryColor.parseColor(),
                        ),
                        lineXY: .3,
                        indicatorStyle: IndicatorStyle(
                          width: 28,
                          height: 28,
                          color: AppColors.primaryColor.parseColor(),
                          indicator: Container(
                            decoration: BoxDecoration(
                                color: station.title == departure.dStartPoint ||
                                    station.title == departure.dEndPoint
                                    ? AppColors.primaryColor.parseColor()
                                    : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: HexColor(AppColors.primaryColor)
                                )
                            ),
                            child: Center(
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                  color: (station.title == departure.dStartPoint ||
                                      station.title == departure.dEndPoint)
                                      ? Colors.white
                                      : HexColor(AppColors.primaryColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                        endChild: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 10),
                          child: Text(
                            "${station.title}",
                            style: (station.title == departure.dStartPoint ||
                                station.title == departure.dEndPoint)
                                ? const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14
                            )
                                : null,
                          ),
                        ),
                        startChild: Container(
                          constraints: const BoxConstraints(minHeight: 40),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: Text(
                              "${station.time}",
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        )
    );
  }
}
