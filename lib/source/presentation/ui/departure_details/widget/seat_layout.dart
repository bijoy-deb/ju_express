import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ju_express/source/utils/app_images.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';
import 'package:ju_express/source/utils/helper_functions.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/model/departure_details/BusSeat.dart';
import '../../../../data/model/departure_details/SelectedSeatModel.dart';
import '../../../../utils/app_color.dart';

class SeatLayout extends StatefulWidget {
  SeatLayout(
      {Key? key,
      required this.seats,
      required this.seatColumn,
      required this.publishSubject,
      required this.selectedPosition,
      required this.maxSeat})
      : super(key: key);
  final List<BusSeat> seats;
  final int seatColumn;
  List<int> selectedPosition = [];
  final int maxSeat;

  PublishSubject<SelectedSeatModel> publishSubject;
  List<BusSeat> getSelectedSeat() {
    if (selectedPosition.isEmpty) {
      return [];
    } else {
      List<BusSeat> busSeats = [];
      for (int i = 0; i < selectedPosition.length; i++) {
        busSeats.add(seats.elementAt(selectedPosition.elementAt(i)));
      }
      return busSeats;
    }
  }

  @override
  State<SeatLayout> createState() => _SeatLayoutState();
}

class _SeatLayoutState extends State<SeatLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: HexColor(AppColors.backgroundColor),
        ),
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.zero,
        child: StaggeredGrid.count(
          crossAxisCount: widget.seatColumn,
          children: List.generate(widget.seats.length, (index) {
            var item = widget.seats[index];

            int c = 1;
            if (item.row != "") {
              c = int.parse(item.row);
            }
            int r = 1;
            if (item.col != "") {
              r = int.parse(item.col);
            }
            return StaggeredGridTile.count(
                crossAxisCellCount: r,
                mainAxisCellCount: c,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: InkResponse(
                    onTap: () => {seatClick(index)},
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: getSeat(widget.seats[index], index),
                      ),
                    ),
                  ),
                ));
          }),
        ));
  }

  Widget getSeat(BusSeat busSeat, int position) {
    if ("driver".equalsIgnoreCase(busSeat.seatName)) {
      return Image.asset(AppImages.driver);
    } else if ("door".equalsIgnoreCase(busSeat.seatName)) {
      return Image.asset(AppImages.door);
    } else if (busSeat.dsID.isEmpty && busSeat.seatName.isNotEmpty) {
      return SizedBox(
          width: double.infinity,
          child: Center(
              child: Text(
            busSeat.seatName.toUpperCase(),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          )));
    } else if ("".equalsIgnoreCase(busSeat.seatName)) {
      return Container();
    } else {
      return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            border: Border.all(
                color: HexColor(getBorderColor(
                    busSeat.forSale, position, busSeat.gender!))),
            color: HexColor(getColor(
              busSeat.forSale,
              position,
              busSeat.gender!,
            )),
          ),
          child: Center(
              child: Text(
            busSeat.seatName,
            style: TextStyle(
                color: AppColors.seatName.parseColor(),
                fontWeight: FontWeight.w700),
          )));
    }
  }

  String getColor(int forSale, int position, dynamic gender) {
    if (widget.selectedPosition.contains(position)) {
      return AppColors.seatSelected;
    }
    if (forSale == 1) {
      return AppColors.seatAvailable;
    }

    // if(forSale==0){
    //     if(int.parse(gender.toString())==2){
    //       return AppColors.seatSelectedLadies;
    //     }
    //
    // }

    return AppColors.seatSold;
  }

  String getBorderColor(int forSale, int position, dynamic gender) {
    if (widget.selectedPosition.contains(position)) {
      return AppColors.seatSelected;
    }
    if (forSale == 1) {
      return AppColors.seatAvailable;
    }
    if (forSale == 0) {
      return AppColors.seatSold;
    }

    return AppColors.backgroundColor;
  }

  void seatClick(int position) {
    setState(() {
      var temp = widget.selectedPosition;
      if (widget.seats.elementAt(position).forSale == 1) {
        if (widget.selectedPosition.contains(position)) {
          temp.remove(position);
        } else {
          if (widget.maxSeat > widget.selectedPosition.length) {
            temp.add(position);
          } else {
            showToast(
                "${AppLocalizations.of(context)!.maximum} ${widget.maxSeat} ${AppLocalizations.of(context)!.can_be_selected}",
                error: true);
          }
        }
        widget.selectedPosition = temp;
      } else {
        if (widget.selectedPosition.contains(position)) {
          temp.remove(position);
        }
      }
    });

    var data = widget.getSelectedSeat();
    SelectedSeatModel seatLayoutModel = SelectedSeatModel();
    seatLayoutModel.changeData(data, widget.selectedPosition);
    widget.publishSubject.add(seatLayoutModel);
  }
}
