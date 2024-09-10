import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/source/data/model/departure_details/DepartureDetails.dart';
import 'package:ju_express/source/data/model/departure_details/SeatReserveRes.dart';

import '../../../../core/error/error_message.dart';
import '../../../source/data/model/departure_list/departure_list.dart';
import '../../../source/data/repositories/departure/i_departure_repository.dart';
import 'i_departure_usecase.dart';

@Injectable(as: IDepartureUseCase)
class DepartureUseCase extends IDepartureUseCase {
  late final IDepartureRepository _repository;
  DepartureUseCase(this._repository);

  @override
  Future<Either<ErrorMessage, DepartureListRes>> getDepartureList(
      {required String from, required String to, required date}) {
    return _repository.getDepartureList(from: from, to: to, date: date);
  }

  @override
  Future<Either<ErrorMessage, DepartureDetails>> getDepartureDetails(
      {required String from,
      required String to,
      required String date,
      required String dID}) {
    return _repository.getDepartureDetails(
        from: from, to: to, date: date, dID: dID);
  }

  @override
  Future<Either<ErrorMessage, SeatReserveRes>> reserveSeat(
      {required String from,
      required String to,
      required String date,
      required String vHash,
      required List<String> dsIDs}) {
    return _repository.reserveSeat(
        from: from, to: to, date: date, vHash: vHash, dsIDs: dsIDs);
  }
}
