import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';


import '../../../../data/model/departure_list/departure_list.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_images.dart';

class DepartureListItem extends StatefulWidget {
  const DepartureListItem(
      {Key? key,
      required this.departure,
      required this.callbackAllStation,
      required this.callbackSelect})
      : super(key: key);
  final Departures departure;
  final Function() callbackAllStation;
  final Function() callbackSelect;
  @override
  State<DepartureListItem> createState() => _DepartureListItemState();
}

class _DepartureListItemState extends State<DepartureListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.callbackSelect();
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 5, bottom: 5, left: 0, right: 0),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black12)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.departure.bTitle.toString(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor.parseColor()),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.departure.dTime}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${widget.departure.dStartPoint}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.06,
                          height: 2,
                          child: Container(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${widget.departure.dDurationTime}",
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.06,
                          height: 2,
                          child: Container(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${widget.departure.dArTime}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        textAlign: TextAlign.end,
                        "${widget.departure.dEndPoint}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.departure.coach} ${widget.departure.ftTitle} ${widget.departure.isAc}",
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 3, bottom: 5, left: 2),
                        child: GestureDetector(
                          onTap: () {
                            widget.callbackAllStation();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.all_stations,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: widget
                              .departure.fareDetails!.discountDetails!.value! >
                          0,
                      child: Text(
                        "${widget.departure.currencySymbol} ${widget.departure.fareDetails?.fare?[0].currencyFare?.toStringAsFixed(2)}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            decorationThickness: 3,
                            decoration: TextDecoration.lineThrough),
                      ),
                    ),
                    Text(
                      "${widget.departure.currencySymbol} ${widget.departure.fareDetails?.fare?[0].discountedFare?.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: AppColors.primaryColor.parseColor(),
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "${widget.departure.seatAvail} ${AppLocalizations.of(context)!.seats} ${AppLocalizations.of(context)!.left}",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ],
                )
              ],
            ),
            if (widget.departure.amenities!.isNotEmpty)
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                margin: const EdgeInsets.only(top: 4),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.departure.amenities!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Tooltip(
                        triggerMode: TooltipTriggerMode.tap,
                        message:
                            widget.departure.amenities!.elementAt(index).title,
                        child: FadeInImage.assetNetwork(
                            height: 27,
                            width: 27,
                            placeholder: AppImages.miniLoader,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                AppImages.icon,
                                height: 27,
                                width: 27,
                              );
                            },
                            image: widget.departure.amenities!
                                .elementAt(index)
                                .icon),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
