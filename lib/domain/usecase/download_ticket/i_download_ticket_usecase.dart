import 'package:dartz/dartz.dart';

import '../../../../core/error/error_message.dart';
import '../../../source/data/model/download_ticket/download_ticket_res.dart';

abstract class IDownloadTicketUseCase {
  Future<Either<ErrorMessage, DownloadTicketRes>> getDownloadTicketData(
      {required String mobile, required String cCode, required String pnr});
}
