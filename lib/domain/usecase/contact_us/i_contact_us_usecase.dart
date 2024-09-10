import 'package:dartz/dartz.dart';
import 'package:ju_express/source/data/model/common/status_message_res.dart';

import '../../../../core/error/error_message.dart';

abstract class IContactUsUseCase {
  Future<Either<ErrorMessage, StatusMessageRes>> sendMessage({
    required String name,
    required String email,
    required String mobile,
    required String cCode,
    required String message,
  });
}
