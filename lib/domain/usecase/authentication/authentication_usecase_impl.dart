import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_message.dart';
import '../../../source/data/model/authentication/request/change_mail_request_model.dart';
import '../../../source/data/model/authentication/request/change_number_request_model.dart';
import '../../../source/data/model/authentication/request/change_password_request_model.dart';
import '../../../source/data/model/authentication/request/forgot_password_request_model.dart';
import '../../../source/data/model/authentication/request/login_request_model.dart';
import '../../../source/data/model/authentication/request/mail_send_otp_request_model.dart';
import '../../../source/data/model/authentication/request/number_send_otp_request_model.dart';
import '../../../source/data/model/authentication/request/otp_verification_request_model.dart';
import '../../../source/data/model/authentication/request/registration_request_model.dart';
import '../../../source/data/model/authentication/request/resend_otp_request_model.dart';
import '../../../source/data/model/authentication/request/reset_password_request_model.dart';
import '../../../source/data/model/authentication/request/update_profile_request_model.dart';
import '../../../source/data/model/authentication/response/change_mail_response_model.dart';
import '../../../source/data/model/authentication/response/change_number_response_model.dart';
import '../../../source/data/model/authentication/response/change_password_response_model.dart';
import '../../../source/data/model/authentication/response/delete_account_response_model.dart';
import '../../../source/data/model/authentication/response/forgot_password_response_model.dart';
import '../../../source/data/model/authentication/response/login_response_model.dart';
import '../../../source/data/model/authentication/response/mail_send_otp_response_model.dart';
import '../../../source/data/model/authentication/response/number_send_otp_response_model.dart';
import '../../../source/data/model/authentication/response/otp_verification_response_model.dart';
import '../../../source/data/model/authentication/response/profile_response_model.dart';
import '../../../source/data/model/authentication/response/registration_response_model.dart';
import '../../../source/data/model/authentication/response/resend_otp_response_model.dart';
import '../../../source/data/model/authentication/response/reset_password_response_model.dart';
import '../../../source/data/model/authentication/response/update_profile_response_model.dart';
import '../../../source/data/repositories/authentication/authentication_repository.dart';
import 'authentication_usecase.dart';

@Injectable(as: AuthenticationUseCase)
class AuthenticationUseCaseImpl extends AuthenticationUseCase {
  late final AuthenticationRepository _repository;
  AuthenticationUseCaseImpl(this._repository);

  @override
  Future<Either<ErrorMessage, RegistrationResponeModel>> customerRegistration(
      {required RegistrationRequestModel model}) async {
    return _repository.customerRegistration(model: model);
  }

  @override
  Future<Either<ErrorMessage, LoginResponseModel>> customerLogin(
      {required LoginRequestModel model}) async {
    return _repository.customerLogin(model: model);
  }

  @override
  Future<Either<ErrorMessage, ChangeMailResponseModel>> changeEmail({
    required ChangeMailRequestModel model,
  }) async {
    return _repository.changeEmail(model: model);
  }

  @override
  Future<Either<ErrorMessage, ChangeNumberResponseModel>> changeNumber({
    required ChangeNumberRequestModel model,
  }) async {
    return _repository.changeNumber(model: model);
  }

  @override
  Future<Either<ErrorMessage, ChangePasswordResponseModel>>
      customerChangePassword({
    required ChangePasswordRequestModel model,
  }) async {
    return _repository.customerChangePassword(model: model);
  }

  @override
  Future<Either<ErrorMessage, DeleteAccountResponseModel>>
      deleteCustomer() async {
    return _repository.deleteCustomer();
  }

  @override
  Future<Either<ErrorMessage, ForgotPasswordResponseModel>>
      customerForgetPassword(
          {required ForgotPasswordRequestModel model}) async {
    return _repository.customerForgetPassword(model: model);
  }

  @override
  Future<Either<ErrorMessage, NumberSendOtpResponseModel>> changeNumberSendOtp({
    required NumberSendOtpRequestModel model,
  }) async {
    return _repository.changeNumberSendOtp(model: model);
  }

  @override
  Future<Either<ErrorMessage, ProfileResponseModel>> loggedInCustomer() async {
    return _repository.loggedInCustomer();
  }

  @override
  Future<Either<ErrorMessage, MailSendOtpResponseModel>> changeEmailSendOtp({
    required MailSendOtpRequestModel model,
  }) async {
    return _repository.changeEmailSendOtp(model: model);
  }

  @override
  Future<Either<ErrorMessage, UpdateProfileResponseModel>> updateCustomer({
    required UpdateProfileRequestModel model,
  }) async {
    return _repository.updateCustomer(model: model);
  }

  @override
  Future<Either<ErrorMessage, OtpVerificationResponseModel>> regOTPverification(
      {required OtpVerificationRequestModel model}) async {
    return _repository.regOTPverification(model: model);
  }

  @override
  Future<Either<ErrorMessage, ResendOtpResponseModel>> regOtpResend(
      {required ResendOtpRequestModel model}) async {
    return _repository.regOtpResend(model: model);
  }

  @override
  Future<Either<ErrorMessage, ResetPasswordResponseModel>>
      customerResetPassword({required ResetPasswordRequestModel model}) async {
    return _repository.customerResetPassword(model: model);
  }
}
