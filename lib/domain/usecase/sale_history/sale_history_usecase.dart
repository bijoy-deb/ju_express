import 'package:dartz/dartz.dart';

import '../../../core/error/error_message.dart';
import '../../../source/data/model/sale_history/sale_history_request_model.dart';
import '../../../source/data/model/sale_history/sale_history_response_model.dart';

abstract class SaleHistoryUseCase {
  Future<Either<ErrorMessage, SaleHistoryResponseModel>> customerSaleInfo(
      {required SaleHistoryRequestModel model});
}
