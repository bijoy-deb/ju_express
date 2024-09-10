import 'package:dartz/dartz.dart';
import 'package:ju_express/core/error/error_message.dart';

import '../../model/download_ticket/download_ticket_res.dart';

abstract class IDownloadTicketRepository {
  Future<Either<ErrorMessage, DownloadTicketRes>> getDownloadTicketData(
      {required String mobile, required String cCode, required String pnr});
}
