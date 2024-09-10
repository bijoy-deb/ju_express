import 'package:dartz/dartz.dart';
import 'package:ju_express/core/error/error_message.dart';
import 'package:ju_express/source/data/model/common/status_message_res.dart';

abstract class IContactUsRepository {
  Future<Either<ErrorMessage, StatusMessageRes>> sendMessage({
    required String name,
    required String email,
    required String mobile,
    required String cCode,
    required String msg,
  });
}
