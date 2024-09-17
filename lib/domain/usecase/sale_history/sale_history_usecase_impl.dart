import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/domain/usecase/sale_history/sale_history_usecase.dart';

import '../../../core/error/error_message.dart';
import '../../../source/data/model/sale_history/sale_history_request_model.dart';
import '../../../source/data/model/sale_history/sale_history_response_model.dart';
import '../../../source/data/repositories/sale_history/sale_history_repository.dart';

@Injectable(as: SaleHistoryUseCase)
class AuthenticationUseCaseImpl extends SaleHistoryUseCase {
  late final SaleHistoryRepository _repository;
  AuthenticationUseCaseImpl(this._repository);

  @override
  Future<Either<ErrorMessage, SaleHistoryResponseModel>> customerSaleInfo(
      {required SaleHistoryRequestModel model}) async {
    return _repository.customerSaleInfo(model: model);
  }
}
