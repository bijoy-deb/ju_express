import 'package:dartz/dartz.dart';

import '../../../../core/error/error_message.dart';
import '../../model/sale_history/sale_history_request_model.dart';
import '../../model/sale_history/sale_history_response_model.dart';

abstract class SaleHistoryRepository {
  Future<Either<ErrorMessage, SaleHistoryResponseModel>> customerSaleInfo(
      {required SaleHistoryRequestModel model});
}
