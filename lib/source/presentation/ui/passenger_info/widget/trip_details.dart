import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/model/passenger_info/passenger_info_args.dart';

class TripDetails extends StatefulWidget {
  const TripDetails({required this.infoArgs, this.showTitle = true, Key? key})
      : super(key: key);
  final PassengerInfoArgs infoArgs;
  final bool showTitle;
  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  String selectedSeatString = "";
  @override
  void initState() {
    for (int i = 0; i < widget.infoArgs.seats.length; i++) {
      if (selectedSeatString.isNotEmpty) {
        selectedSeatString += ",${widget.infoArgs.seats[i].seatName}";
      } else {
        selectedSeatString = widget.infoArgs.seats[i].seatName;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showTitle)
          Text(
            AppLocalizations.of(context)!.details_trip,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        Row(
          children: [
            SizedBox(
                width: 120,
                child: Text(
                  AppLocalizations.of(context)!.route,
                  style: const TextStyle(fontSize: 15),
                )),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  ":",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                )),
            Expanded(
                child: Text(
              widget.infoArgs.departure.rTitle!,
              style: const TextStyle(fontSize: 14.5),
            )),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            SizedBox(
                width: 120,
                child: Text(
                  AppLocalizations.of(context)!.coach,
                  style: const TextStyle(fontSize: 15),
                )),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  ":",
                  style: TextStyle(fontSize: 15),
                )),
            Expanded(
                child: Text(
              "${widget.infoArgs.departure.coach} ${widget.infoArgs.departure.ftTitle} ${widget.infoArgs.departure.isAc}",
              style: const TextStyle(fontSize: 15),
            )),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            SizedBox(
                width: 120,
                child: Text(
                  AppLocalizations.of(context)!.departure,
                  style: const TextStyle(fontSize: 15),
                )),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  ":",
                  style: TextStyle(fontSize: 15),
                )),
            Expanded(
                child: Text(
              "${widget.infoArgs.date.toLocal()}".split(" ").first +
                  " " +
                  "${widget.infoArgs.departure.dTime ?? ""}",
              style: const TextStyle(fontSize: 15),
            )),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            SizedBox(
                width: 120,
                child: Text(
                  "${AppLocalizations.of(context)!.seat}(s)",
                  style: const TextStyle(fontSize: 15),
                )),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  ":",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                )),
            Expanded(
                child: Text(
              selectedSeatString,
              style: const TextStyle(fontSize: 15),
            )),
          ],
        ),
      ],
    );
  }
}
