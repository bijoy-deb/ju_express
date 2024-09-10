import 'package:dartz/dartz.dart';
import 'package:ju_express/core/error/error_message.dart';
import 'package:ju_express/source/data/model/departure_details/DepartureDetails.dart';
import 'package:ju_express/source/data/model/departure_details/SeatReserveRes.dart';
import 'package:ju_express/source/data/model/departure_list/departure_list.dart';

abstract class IDepartureRepository {
  Future<Either<ErrorMessage, DepartureListRes>> getDepartureList(
      {required String from, required String to, required date});

  Future<Either<ErrorMessage, DepartureDetails>> getDepartureDetails(
      {required String from,
      required String to,
      required String date,
      required String dID});

  Future<Either<ErrorMessage, SeatReserveRes>> reserveSeat(
      {required String from,
      required String to,
      required String date,
      required String vHash,
      required List<String> dsIDs});
}
