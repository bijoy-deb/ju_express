import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';

import '../../../../core/error/error_message.dart';
import '../../../../di/injection.dart';
import '../../../data/local/app_shared_preferences.dart';
import '../../../data/model/sale_history/sale_history_request_model.dart';
import '../../../utils/app_color.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/text_styles.dart';
import '../../bloc/sale_history/sale_history_bloc.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loader.dart';
import '../../widgets/shimmer_effect.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  AppSharedPrefs sp = getIt<AppSharedPrefs>();
  final bloc = getIt<SaleHistoryBloc>();

  TextEditingController dateController = TextEditingController();

  late DateTime toDate;
  late DateTime fromDate;
  @override
  void initState() {
    fromDate = DateTime.now().subtract(const Duration(days: 6));
    toDate = DateTime.now();
    dateController.text =
        "${fromDate.formatForApi()} to ${toDate.formatForApi()}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc
        ..add(GetSaleHistoryEvent(
            model: SaleHistoryRequestModel(
                toDate: toDate.formatForApi(),
                fromDate: fromDate.formatForApi()))),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor.parseColor(),
        appBar: MyAppBar(title: AppLocalizations.of(context)!.viewHistory),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.date_range,
                  style: AppStyle.textStyleF17W600(),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        autofocus: true,
                        controller: dateController,
                        onTap: () async {
                          await pickDate();
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    BlocBuilder<SaleHistoryBloc, SaleHistoryState>(
                      builder: (context, state) {
                        return ElevatedButton(
                            onPressed: state is DataLoading
                                ? () {}
                                : () {
                                    bloc.add(GetSaleHistoryEvent(
                                      model: SaleHistoryRequestModel(
                                        toDate: toDate.formatForApi(),
                                        fromDate: fromDate.formatForApi(),
                                      ),
                                    ));
                                  },
                            child: state is DataLoading
                                ? const CircleLoader()
                                : Text(AppLocalizations.of(context)!.search));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                BlocBuilder<SaleHistoryBloc, SaleHistoryState>(
                  builder: (context, state) {
                    if (state is SaleHistoryLoaded) {
                      if (state.res.status == 1) {
                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: state.res.sale!.length,
                              itemBuilder: (BuildContext context, int index) {
                                var item = state.res.sale![index];
                                return Column(
                                  children: [
                                    Card(
                                      surfaceTintColor: Colors.white,
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  item.pnr!,
                                                  style: AppStyle
                                                      .textStyleF18W700(),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                            text:
                                                                "${item.pnr}"));
                                                    showToast(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .copied_to_clipboard,
                                                        success: true);
                                                  },
                                                  icon: const Icon(Icons.copy),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.rut!,
                                                      style: AppStyle
                                                          .textStyleF17W400(),
                                                    ),
                                                    Text(
                                                      item.date!,
                                                      style: AppStyle
                                                          .textStyleF17W400(),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${AppLocalizations.of(context)!.seat}: ${item.seat!}",
                                                      style: AppStyle
                                                          .textStyleF17W400(),
                                                    ),
                                                    Text(
                                                      "${item.currencySymbol!} ${item.total!}",
                                                      style: AppStyle
                                                          .textStyleF17W400(),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      } else {
                        return CustomErrorWidget(
                          errorMessage:
                              ErrorMessage.getErrorFromMsg(state.res.m),
                        );
                      }
                    } else if (state is DataLoading) {
                      return const ListShimmer(length: 10, height: 100);
                    } else if (state is DataError) {
                      return Center(
                        child: CustomErrorWidget(
                          errorMessage: state.error,
                          onRetry: () {
                            bloc.add(GetSaleHistoryEvent(
                                model: SaleHistoryRequestModel(
                                    toDate: "", fromDate: "")));
                          },
                        ),
                      );
                    }

                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  pickDate() async {
    final DateTimeRange? result = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2022, 1, 1),
        lastDate: DateTime.now(),
        currentDate: DateTime.now(),
        initialDateRange: DateTimeRange(start: fromDate, end: toDate));

    if (result != null) {
      fromDate = result.start;
      toDate = result.end;
      dateController.text =
          "${fromDate.formatForApi()} ${AppLocalizations.of(context)!.to} ${toDate.formatForApi()}";
    }
  }
}
