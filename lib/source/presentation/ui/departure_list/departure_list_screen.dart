import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:ju_express/core/error/error_message.dart';
import 'package:ju_express/di/injection.dart';

// -----------------------------------
// Widgets, Blocs and UI Components
// -----------------------------------


import 'package:ju_express/source/data/model/departure_details/departure_search_args.dart';

import 'package:ju_express/source/presentation/bloc/departure/departure_bloc.dart';
import 'package:ju_express/source/presentation/ui/departure_list/widget/departure_list.dart';
import 'package:ju_express/source/presentation/widgets/error_widget.dart';
import 'package:ju_express/source/presentation/widgets/shimmer_effect.dart';
import 'package:ju_express/source/utils/app_color.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';
import 'widget/my_date_picker.dart';

// lib/my_library.dart
export 'package:ju_express/source/presentation/ui/departure_list/departure_list_screen.dart';


/// This is the screen for displaying the list of departures.
/// Class: DepartureListScreen
class DepartureListScreen extends StatefulWidget {
  const DepartureListScreen({Key? key, required this.searchArgs})
      : super(key: key);
  final DepartureSearchArgs searchArgs;

  /// The createState() method is defined in the StatefulWidget class.
  /// This state object holds the mutable data and the build logic of the widget.
  /// is called once when the widget is first created.
  /// It provides the stateful widget with its State object, allowing it to rebuild its UI when the state changes.
  @override
  State<DepartureListScreen> createState() => DepartureListScreenState();
}

/// This is the screen for displaying the list of departures.
///
/// Class: _DepartureListScreenState
class DepartureListScreenState extends State<DepartureListScreen> {
  final bloc = getIt<DepartureBloc>();
  late DepartureSearchArgs searchArgs = widget.searchArgs;
  final MyDatePickerController _myDatePickerController =
  MyDatePickerController();

  /// dispose() is called when the state object is being removed permanently.
  /// It is commonly used to clean up resources such as streams, controllers, or listeners.
  @override
  void dispose() {
    _myDatePickerController.dispose();
    super.dispose();
  }

  @override
  /// The build() method defines the widget’s UI. It is called whenever the widget needs to be redrawn,
  /// usually after a state change.
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor.parseColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor.parseColor(),
          body: BlocProvider(
            create: (context) => bloc
              ..add(GetDepartureListData(
                  from: searchArgs.from.distId!,
                  to: searchArgs.to.distId!,
                  date: searchArgs.date.formatForApi())),
            child: Column(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.parseColor(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                searchArgs.from.distTitle!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                width: 8,
                                height: 2,
                                margin:
                                const EdgeInsets.only(left: 4, right: 4, top: 3),
                                color: Colors.white,
                              ),
                              Text(searchArgs.to.distTitle!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                          Text(
                            DateFormat('E, d MMM yyyy').format(searchArgs.date),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                MyDatePicker(
                  onDateChanged: (p0) {
                    if (searchArgs.date != p0) {
                      searchArgs.date = p0;
                      bloc.add(GetDepartureListData(
                          from: searchArgs.from.distId!,
                          to: searchArgs.to.distId!,
                          date: searchArgs.date.formatForApi()));
                    }
                  },
                  controller: _myDatePickerController,
                  selectedDate: searchArgs.date,
                  initialDate: DateTime.now(),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: BlocBuilder<DepartureBloc, DepartureState>(
                    builder: (context, state) {
                      if (state is DepartureListLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ListShimmer(length: 10, height: 100),
                        );
                      } else if (state is DepartureListLoaded) {
                        if (state.res.status == 1) {
                          if (state.res.departures!.isEmpty) {
                            return CustomErrorWidget(
                              errorMessage: ErrorMessage(
                                errorType: ErrorType.NO_DATA,
                                message: AppLocalizations.of(context)!.no_trips,
                                subtitle: AppLocalizations.of(context)!
                                    .no_trips_subtitle,
                              ),
                            );
                          } else {
                            return DepartureList(
                              res: state.res,
                              searchArgs: searchArgs,
                            );
                          }
                        } else {
                          return CustomErrorWidget(
                            errorMessage:
                            ErrorMessage.getErrorFromMsg(state.res.m),
                            onRetry: () {
                              bloc.add(GetDepartureListData(
                                  from: searchArgs.from.distId!,
                                  to: searchArgs.to.distId!,
                                  date: searchArgs.date.formatForApi()));
                            },
                          );
                        }
                      } else if (state is GotError) {
                        return CustomErrorWidget(
                          errorMessage: state.error,
                          onRetry: () {
                            bloc.add(GetDepartureListData(
                                from: searchArgs.from.distId!,
                                to: searchArgs.to.distId!,
                                date: searchArgs.date.formatForApi()));
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}