import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/source/data/model/download_ticket/download_ticket_res.dart';

import '../../../../core/error/error_message.dart';

import '../../../source/data/repositories/download_ticket/i_download_ticket_repository.dart';
import 'i_download_ticket_usecase.dart';

@Injectable(as: IDownloadTicketUseCase)
class DownloadTicketUseCase extends IDownloadTicketUseCase {
  late final IDownloadTicketRepository _repository;
  DownloadTicketUseCase(this._repository);

  @override
  Future<Either<ErrorMessage, DownloadTicketRes>> getDownloadTicketData(
      {required String mobile, required String cCode, required String pnr}) {
    return _repository.getDownloadTicketData(
        mobile: mobile, pnr: pnr, cCode: cCode);
  }
}
