import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:ju_express/route/route_config.dart';
import 'package:ju_express/source/data/local/app_shared_preferences.dart';
import 'package:ju_express/source/data/model/departure_details/BusSeat.dart';
import 'package:ju_express/source/data/model/departure_details/DepartureDetails.dart';
import 'package:ju_express/source/data/model/departure_details/SeatLayoutModel.dart';
import 'package:ju_express/source/data/model/departure_details/departure_search_args.dart';
import 'package:ju_express/source/data/model/departure_list/departure_list.dart';
import 'package:ju_express/source/data/model/passenger_info/passenger_info_args.dart';

import 'package:ju_express/source/presentation/bloc/seat_reserve/reserve_seat_bloc.dart'
    as seat;
import 'package:ju_express/source/presentation/ui/departure_details/widget/seat_layout.dart';
import 'package:ju_express/source/presentation/widgets/app_bar.dart';
import 'package:ju_express/source/presentation/widgets/shimmer_effect.dart';
import 'package:ju_express/source/utils/Constants.dart';
import 'package:ju_express/source/utils/app_color.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';
import 'package:ju_express/source/utils/helper_functions.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/error/error_message.dart';
import '../../../../di/injection.dart';
import '../../../data/model/departure_details/SelectedSeatModel.dart';
import '../../../data/model/home/home_page_int_res.dart';
import '../../bloc/departure/departure_bloc.dart';
import '../../widgets/error_widget.dart';

class DepartureDetailsScreen extends StatefulWidget {
  const DepartureDetailsScreen(
      {Key? key,
      required this.searchArgs,
      required this.departure,
      required this.idTypes,
      required this.crSymbol})
      : super(key: key);
  final DepartureSearchArgs searchArgs;
  final Departures departure;
  final List<IdTypes> idTypes;
  final String crSymbol;

  @override
  State<DepartureDetailsScreen> createState() => _DepartureDetailsScreenState();
}

class _DepartureDetailsScreenState extends State<DepartureDetailsScreen> {
  final bloc = getIt<DepartureBloc>();
  final reserveBloc = getIt<seat.ReserveSeatBloc>();
  final prefs = getIt<AppSharedPrefs>();

  late PublishSubject<SelectedSeatModel> publishSubject;
  List<int> _selectedPosition = [];
  String selectedSeatString = "";
  GoRouter router = getIt<AppRoute>().router;
  List<BusSeat> selectedSeats = [];
  List<FairType> fairTypes = [];
  int processFeeType = 1;
  double processFee = 0;
  SeatLayoutModel? seatLayoutModel;
  double seatTotalPrice = 0.0;
  List<Stoppage>? boardingList;
  List<Stoppage>? droppingList;
  @override
  void initState() {
    Constants.currency = widget.crSymbol;
    publishSubject = PublishSubject<SelectedSeatModel>();
    publishSubject.listen((value) {
      setState(() {
        selectedSeatString = "";
        seatTotalPrice = 0.0;
        for (int i = 0; i < value.busSeats.length; i++) {
          if (selectedSeatString.isNotEmpty) {
            selectedSeatString += ",${value.busSeats[i].seatName}";
          } else {
            selectedSeatString = value.busSeats[i].seatName;
          }
          seatTotalPrice +=
              value.busSeats[i].fareDetails?.fare![0].discountedFare ?? 0.0;
        }
        _selectedPosition = value.selectedPosition;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.parseColor(),
      appBar: const MyAppBar(),
      body: BlocProvider(
        create: (context) => reserveBloc,
        child: BlocProvider(
          create: (context) => bloc
            ..add(GetDepartureDetails(
                from: widget.searchArgs.from.distId!,
                to: widget.searchArgs.to.distId!,
                date: widget.searchArgs.date.formatForApi(),
                dID: widget.departure.dId!)),
          child: BlocBuilder<DepartureBloc, DepartureState>(
            builder: (context, state) {
              if (state is DepartureDetailsLoading) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(child: ListShimmer(length: 1, height: 400)),
                      ListShimmer(length: 1, height: 100),
                    ],
                  ),
                );
              } else if (state is DepartureDetailsLoaded) {
                if (state.res.status == 1) {
                  seatLayoutModel = state.seatLayoutModel;
                  fairTypes = state.res.fairType ?? [];
                  boardingList = state.res.boarding;
                  droppingList = state.res.dropping;
                  log("boardingList is: ${boardingList?.length}");
                  if (state.res.charge != null) {
                    Charge charge = state.res.charge!.firstWhere(
                        (element) => element.slug == "PROCESS_FEE",
                        orElse: () => Charge(
                            type: state.res.processFeeType,
                            value: state.res.processFee!));
                    processFeeType = int.parse((charge.type ?? "1").toString());
                    processFee = double.parse(charge.value!);
                  } else {
                    processFeeType =
                        int.parse((state.res.processFeeType ?? "1").toString());
                    processFee = double.parse(state.res.processFee!);
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Column(
                              children: [
                                wrapWithContainer(
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12, right: 12, top: 2),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  //4 box with color
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    color: AppColors
                                                        .seatAvailable
                                                        .parseColor(),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .available,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  //4 box with color
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    color: AppColors.seatSold
                                                        .parseColor(),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .unavailable,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  //4 box with color
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    color: AppColors
                                                        .seatSelected
                                                        .parseColor(),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .selected,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 12, right: 3, left: 3),
                                        child: SeatLayout(
                                          seats:
                                              state.seatLayoutModel!.busSeats,
                                          seatColumn: state
                                              .seatLayoutModel!.numberOfColumn,
                                          publishSubject: publishSubject,
                                          selectedPosition: _selectedPosition,
                                          maxSeat: state.res.maxSeat!,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "${AppLocalizations.of(context)!.selected}: $selectedSeatString",
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            BlocListener<seat.ReserveSeatBloc,
                                seat.ReserveSeatState>(
                              bloc: reserveBloc,
                              listener: (context, state) async {
                                if (state is seat.ReservingSeat) {
                                  EasyLoading.show();
                                } else if (state is seat.SeatReserved) {
                                  EasyLoading.dismiss();
                                  if (state.res.status == 1) {
                                    await getIt<AppSharedPrefs>()
                                        .setVHash(state.res.vuHash ?? "");
                                    await getIt<AppRoute>().router.push(
                                          RoutePath.passengerInfo,
                                          extra: PassengerInfoArgs(
                                            boardingList: boardingList ?? [],
                                            droppingList: droppingList ?? [],
                                            vHash: state.res.vuHash!,
                                            from: widget.searchArgs.from,
                                            to: widget.searchArgs.to,
                                            date: widget.searchArgs.date,
                                            departure: widget.departure,
                                            seats: selectedSeats,
                                            fairTypes: fairTypes,
                                            idTypes: widget.idTypes,
                                            processFeeType: processFeeType,
                                            processFee: processFee,
                                          ),
                                        );
                                    selectedSeatString = "";
                                    _selectedPosition.clear();
                                    seatTotalPrice = 0.0;

                                    bloc.add(GetDepartureDetails(
                                        from: widget.searchArgs.from.distId!,
                                        to: widget.searchArgs.to.distId!,
                                        date: widget.searchArgs.date
                                            .formatForApi(),
                                        dID: widget.departure.dId!));
                                  } else if (state.res.status == 2) {
                                    await getIt<AppSharedPrefs>().setVHash("");
                                    selectedSeats = [];
                                    List<String> dsIDs = [];
                                    for (var position in _selectedPosition) {
                                      selectedSeats.add(
                                          seatLayoutModel!.busSeats[position]);
                                      dsIDs.add(seatLayoutModel!
                                          .busSeats[position].dsID);
                                    }
                                    if (_selectedPosition.isEmpty) {
                                      showToast(
                                          AppLocalizations.of(context)!
                                              .select_seat,
                                          error: true);
                                      return;
                                    }
                                    reserveBloc.add(seat.ReserveSeat(
                                        from: widget.searchArgs.from.distId!,
                                        to: widget.searchArgs.to.distId!,
                                        date: widget.searchArgs.date
                                            .formatForApi(),
                                        vHash:
                                            getIt<AppSharedPrefs>().getVHash(),
                                        dsIDs: dsIDs));
                                  } else if (state.res.status != 1) {
                                    showToast(
                                        ErrorMessage.getErrorFromMsg(
                                                state.res.m)
                                            .message,
                                        error: true);
                                  }
                                } else if (state is seat.GotError) {
                                  EasyLoading.dismiss();
                                  showToast(state.error.message, error: true);
                                }
                              },
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 8),
                                      side: BorderSide(
                                          color: AppColors.secondaryColor
                                              .parseColor(),
                                          width: 1),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      backgroundColor: AppColors.secondaryColor
                                          .parseColor()),
                                  onPressed: () async {
                                    selectedSeats = [];
                                    List<String> dsIDs = [];
                                    for (var position in _selectedPosition) {
                                      selectedSeats.add(state
                                          .seatLayoutModel!.busSeats[position]);
                                      dsIDs.add(state.seatLayoutModel!
                                          .busSeats[position].dsID);
                                    }
                                    if (_selectedPosition.isEmpty) {
                                      showToast(
                                          AppLocalizations.of(context)!
                                              .select_seat,
                                          error: true);
                                      return;
                                    }
                                    reserveBloc.add(seat.ReserveSeat(
                                        from: widget.searchArgs.from.distId!,
                                        to: widget.searchArgs.to.distId!,
                                        date: widget.searchArgs.date
                                            .formatForApi(),
                                        vHash:
                                            getIt<AppSharedPrefs>().getVHash(),
                                        dsIDs: dsIDs));
                                  },
                                  child:
                                      Text(AppLocalizations.of(context)!.next)),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: CustomErrorWidget(
                      errorMessage: ErrorMessage.getErrorFromMsg(state.res.m),
                      onRetry: () {
                        bloc.add(GetDepartureDetails(
                            from: widget.searchArgs.from.distId!,
                            to: widget.searchArgs.to.distId!,
                            date: widget.searchArgs.date.formatForApi(),
                            dID: widget.departure.dId!));
                      },
                    ),
                  );
                }
              } else if (state is GotError) {
                return Center(
                  child: CustomErrorWidget(
                    errorMessage: state.error,
                    onRetry: () {
                      bloc.add(GetDepartureDetails(
                          from: widget.searchArgs.from.distId!,
                          to: widget.searchArgs.to.distId!,
                          date: widget.searchArgs.date.formatForApi(),
                          dID: widget.departure.dId!));
                    },
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
