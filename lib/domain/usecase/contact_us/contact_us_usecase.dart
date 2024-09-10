import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/source/data/model/common/status_message_res.dart';

import '../../../../core/error/error_message.dart';
import '../../../source/data/repositories/contact_us/i_contact_us_repository.dart';
import 'i_contact_us_usecase.dart';

@Injectable(as: IContactUsUseCase)
class ContactUsUseCase extends IContactUsUseCase {
  late final IContactUsRepository _repository;
  ContactUsUseCase(this._repository);

  @override
  Future<Either<ErrorMessage, StatusMessageRes>> sendMessage({
    required String name,
    required String email,
    required String mobile,
    required String cCode,
    required String message,
  }) {
    return _repository.sendMessage(
        name: name, email: email, mobile: mobile, cCode: cCode, msg: message);
  }
}
