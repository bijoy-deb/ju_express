import 'package:dartz/dartz.dart';

import '../../../../core/error/error_message.dart';
import '../../model/authentication/request/change_mail_request_model.dart';
import '../../model/authentication/request/change_number_request_model.dart';
import '../../model/authentication/request/change_password_request_model.dart';
import '../../model/authentication/request/forgot_password_request_model.dart';
import '../../model/authentication/request/login_request_model.dart';
import '../../model/authentication/request/mail_send_otp_request_model.dart';
import '../../model/authentication/request/number_send_otp_request_model.dart';
import '../../model/authentication/request/otp_verification_request_model.dart';
import '../../model/authentication/request/registration_request_model.dart';
import '../../model/authentication/request/resend_otp_request_model.dart';
import '../../model/authentication/request/reset_password_request_model.dart';
import '../../model/authentication/request/update_profile_request_model.dart';
import '../../model/authentication/response/change_mail_response_model.dart';
import '../../model/authentication/response/change_number_response_model.dart';
import '../../model/authentication/response/change_password_response_model.dart';
import '../../model/authentication/response/delete_account_response_model.dart';
import '../../model/authentication/response/forgot_password_response_model.dart';
import '../../model/authentication/response/login_response_model.dart';
import '../../model/authentication/response/mail_send_otp_response_model.dart';
import '../../model/authentication/response/number_send_otp_response_model.dart';
import '../../model/authentication/response/otp_verification_response_model.dart';
import '../../model/authentication/response/profile_response_model.dart';
import '../../model/authentication/response/registration_response_model.dart';
import '../../model/authentication/response/resend_otp_response_model.dart';
import '../../model/authentication/response/reset_password_response_model.dart';
import '../../model/authentication/response/update_profile_response_model.dart';

abstract class AuthenticationRepository {
  Future<Either<ErrorMessage, RegistrationResponeModel>> customerRegistration(
      {required RegistrationRequestModel model});

  Future<Either<ErrorMessage, LoginResponseModel>> customerLogin(
      {required LoginRequestModel model});

  Future<Either<ErrorMessage, ChangeMailResponseModel>> changeEmail(
      {required ChangeMailRequestModel model});

  Future<Either<ErrorMessage, ChangeNumberResponseModel>> changeNumber(
      {required ChangeNumberRequestModel model});

  Future<Either<ErrorMessage, ChangePasswordResponseModel>>
      customerChangePassword({required ChangePasswordRequestModel model});

  Future<Either<ErrorMessage, DeleteAccountResponseModel>> deleteCustomer();

  Future<Either<ErrorMessage, ForgotPasswordResponseModel>>
      customerForgetPassword({required ForgotPasswordRequestModel model});

  Future<Either<ErrorMessage, NumberSendOtpResponseModel>> changeNumberSendOtp(
      {required NumberSendOtpRequestModel model});

  Future<Either<ErrorMessage, ProfileResponseModel>> loggedInCustomer();

  Future<Either<ErrorMessage, MailSendOtpResponseModel>> changeEmailSendOtp(
      {required MailSendOtpRequestModel model});

  Future<Either<ErrorMessage, UpdateProfileResponseModel>> updateCustomer(
      {required UpdateProfileRequestModel model});

  Future<Either<ErrorMessage, OtpVerificationResponseModel>> regOTPverification(
      {required OtpVerificationRequestModel model});
  Future<Either<ErrorMessage, ResendOtpResponseModel>> regOtpResend(
      {required ResendOtpRequestModel model});

  Future<Either<ErrorMessage, ResetPasswordResponseModel>>
      customerResetPassword({required ResetPasswordRequestModel model});
}
