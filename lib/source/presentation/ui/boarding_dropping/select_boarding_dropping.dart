import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';

import '../../../../../core/error/error_message.dart';
import '../../../data/model/departure_details/DepartureDetails.dart';
import '../../../utils/app_color.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/error_widget.dart';

class SelectBoardingDropping extends StatefulWidget {
  const SelectBoardingDropping(
      {required this.stoppage, required this.dropping, Key? key})
      : super(key: key);
  final List<Stoppage> stoppage;
  final bool dropping;
  @override
  State<SelectBoardingDropping> createState() => _SelectBoardingDroppingState();
}

class _SelectBoardingDroppingState extends State<SelectBoardingDropping> {
  ScrollController scrollController = ScrollController();
  List<Stoppage> stoppage = [];

  @override
  void initState() {
    stoppage.addAll(widget.stoppage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor.parseColor(),
        appBar: MyAppBar(
          title: widget.dropping
              ? AppLocalizations.of(context)!.dropping_point
              : AppLocalizations.of(context)!.boarding_point,
          // onSearch: (p0) {
          //   if (p0.isEmpty) {
          //     setState(() {
          //       stoppage.clear();
          //       stoppage.addAll(widget.stoppage);
          //     });
          //   } else {
          //     setState(() {
          //       stoppage.clear();
          //       stoppage.addAll(widget.stoppage.where((element) =>
          //           element.title!.toLowerCase().contains(p0.toLowerCase()) ||
          //           element.cnId!.toLowerCase().contains(p0.toLowerCase())));
          //     });
          //   }
          // },
        ),
        body: Column(
          children: [
            SizedBox(
              height: 4,
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(top: 8, right: 8, left: 8),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: .5),
                        borderRadius: BorderRadius.circular(8)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: .5),
                        borderRadius: BorderRadius.circular(8)),
                    hintText: AppLocalizations.of(context)!.search,
                    prefixIcon: const Icon(Icons.search),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    fillColor: Colors.white,
                    filled: true),
                onChanged: (p0) {
                  if (p0.isEmpty) {
                    setState(() {
                      stoppage.clear();
                      stoppage.addAll(widget.stoppage);
                    });
                  } else {
                    setState(() {
                      stoppage.clear();
                      stoppage.addAll(widget.stoppage.where((element) =>
                          element.title!
                              .toLowerCase()
                              .contains(p0.toLowerCase()) ||
                          element.id!
                              .toLowerCase()
                              .contains(p0.toLowerCase())));
                    });
                  }
                },
              ),
            ),
            stoppage.isNotEmpty
                ? Expanded(
                    child: Scrollbar(
                      controller: scrollController,
                      interactive: true,
                      thumbVisibility: true,
                      thickness: 4,
                      radius: const Radius.circular(6),
                      child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.only(
                              top: 5, right: 8, left: 8, bottom: 8),
                          itemCount: stoppage.length,
                          itemBuilder: (context, i) => Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                color: Colors.white,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(
                                        context, stoppage.elementAt(i));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: AppColors.primaryColor
                                              .parseColor(),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          stoppage[i].title!,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 20,
                                          color: AppColors.primaryColor
                                              .parseColor(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: CustomErrorWidget(
                        errorMessage: ErrorMessage(
                          message: AppLocalizations.of(context)!.no_city,
                          errorType: ErrorType.NO_DATA,
                        ),
                      ),
                    ),
                  ),
          ],
        ));
  }
}
