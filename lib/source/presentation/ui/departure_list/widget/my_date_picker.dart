import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import 'package:ju_express/source/utils/custom_extensions.dart';

import '../../../../utils/app_color.dart';

class MyDatePicker extends StatefulWidget {
  const MyDatePicker(
      {Key? key,
      required this.onDateChanged,
      required this.initialDate,
      required this.controller,
      required this.selectedDate})
      : super(key: key);
  final Function(DateTime) onDateChanged;
  final DateTime initialDate;

  final DateTime selectedDate;

  final MyDatePickerController controller;

  @override
  State<MyDatePicker> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    selectedDate = DateTime(widget.selectedDate.year, widget.selectedDate.month,
        widget.selectedDate.day);
    currentMonth = selectedDate;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //scroll to selected date
      scrollController.animateTo(
          (selectedDate.day - widget.initialDate.day) * 50.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn);
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    List<DateTime> dates = List.generate(
        30, (index) => widget.initialDate.add(Duration(days: index)));
    return Container(
      child: Column(
        children: [
          Container(
            height: 42,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Scrollbar(
              controller: scrollController,
              thickness: 2,
              thumbVisibility: false,
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (context, index) {
                  DateTime date = dates[index];
                  String label;
                  if (index == 0) {
                    label = AppLocalizations.of(context)!.today;
                  } else if (index == 1) {
                    label = AppLocalizations.of(context)!.tomorrow;
                  } else {
                    label = DateFormat('d MMM').format(date);
                  }

                  bool isSelected = date.year == selectedDate.year &&
                      date.month == selectedDate.month &&
                      date.day == selectedDate.day;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.secondaryColor.parseColor()
                                : Colors.white,
                            border: Border.all(
                                color: isSelected
                                    ? HexColor(AppColors.primaryColor)
                                    : Colors.black45),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: TextButton(
                            onPressed: () {
                              widget.onDateChanged(date);
                              setState(() {
                                selectedDate = date;
                              });
                            },
                            style: ButtonStyle(
                              overlayColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              foregroundColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              shadowColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              elevation: WidgetStateProperty.all(0),
                              padding: WidgetStateProperty.all(EdgeInsets.zero),
                              shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25))),
                            ),
                            child: Center(
                              child: Text(
                                label,
                                style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyDatePickerController extends ChangeNotifier {
  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;

  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }
}
