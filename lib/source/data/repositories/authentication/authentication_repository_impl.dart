import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api_client/api_client.dart';
import '../../../../core/error/error_message.dart';
import '../../../utils/api_endpoints.dart';
import '../../../utils/helper_functions.dart';
import '../../local/app_shared_preferences.dart';
import '../../local/shared_values.dart';
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
import 'authentication_repository.dart';

@Injectable(as: AuthenticationRepository)
class AuthenticationRepositoryImpl extends AuthenticationRepository {
  late final ApiClient apiClient;
  late final AppSharedPrefs sp;
  AuthenticationRepositoryImpl(this.apiClient, this.sp);

  @override
  Future<Either<ErrorMessage, RegistrationResponeModel>> customerRegistration(
      {required RegistrationRequestModel model}) async {
    ErrorMessage errorMessage = ErrorMessage(
        message: "Something went wrong", errorType: ErrorType.ERROR);
    Response? response;
    RegistrationResponeModel? responseModel;
    Map body = {
      "module": "customerRegistration",
      'license': getLicence(),
      "version": appVersion.$,
      "ln": lnCode.$,
    };
    body.addAll(model.toJson());
    await apiClient.request(
        header: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: body,
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          errorMessage = data;
        });

    if (response != null) {
      try {
        responseModel = registrationResponeModelFromJson(response!.body);
        return Right(responseModel);
      } catch (e) {
        log("Exception $e");
        return Left(ErrorMessage(
            message: "Something went wrong", errorType: ErrorType.ERROR));
      }
    } else {
      return Left(errorMessage);
    }
  }

  @override
  Future<Either<ErrorMessage, LoginResponseModel>> customerLogin(
      {required LoginRequestModel model}) async {
    ErrorMessage errorMessage = ErrorMessage(
        message: "Something went wrong", errorType: ErrorType.ERROR);
    Response? response;
    LoginResponseModel? responseModel;
    Map body = {
      "module": "customerLogin",
      'license': getLicence(),
      "version": appVersion.$,
      "ln": lnCode.$,
    };
    body.addAll(model.toJson());
    await apiClient.request(
        header: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: body,
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          errorMessage = data;
        });

    if (response != null) {
      try {
        responseModel = loginResponseModelFromJson(response!.body);
        return Right(responseModel);
      } catch (e) {
        log("Exception $e");
        return Left(ErrorMessage(
            message: "Something went wrong", errorType: ErrorType.ERROR));
      }
    } else {
      return Left(errorMessage);
    }
  }

  @override
  Future<Either<ErrorMessage, ChangeMailResponseModel>> changeEmail(
      {required ChangeMailRequestModel model}) async {
    ErrorMessage errorMessage = ErrorMessage(
        message: "Something went wrong", errorType: ErrorType.ERROR);
    Response? response;
    ChangeMailResponseModel? responseModel;
    Map body = {
      "module": "changeEmail",
      'license': getLicence(),
      "authcode": sp.getAuthCode(),
      "version": appVersion.$,
      "ln": lnCode.$,
    };
    body.addAll(model.toJson());
    await apiClient.request(
        header: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: body,
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          errorMessage = data;
        });

    if (response != null) {
      try {
        responseModel = changeMailResponseModelFromJson(response!.body);
        return Right(responseModel);
      } catch (e) {
        log("Exception $e");
        return Left(ErrorMessage(
            message: "Something went wrong", errorType: ErrorType.ERROR));
      }
    } else {
      return Left(errorMessage);
    }
  }

  @override
  Future<Either<ErrorMessage, ChangeNumberResponseModel>> changeNumber(
      {required ChangeNumberRequestModel model}) async {
    ErrorMessage errorMessage = ErrorMessage(
        message: "Something went wrong", errorType: ErrorType.ERROR);
    Response? response;
    ChangeNumberResponseModel? responseModel;
    Map body = {
      "module": "changeNumber",
      'license': getLicence(),
      "authcode": sp.getAuthCode(),
      "version": appVersion.$,
      "ln": lnCode.$,
    };
    body.addAll(model.toJson());
    await apiClient.request(
        header: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: body,
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          errorMessage = data;
        });

    if (response != null) {
      try {
        responseModel = changeNumberResponseModelFromJson(response!.body);

        return Right(responseModel);
      } catch (e) {
        log("Exception $e");
        return Left(ErrorMessage(
            message: "Something went wrong", errorType: ErrorType.ERROR));
      }
    } else {
      return Left(errorMessage);
    }
  }

  @override
  Future<Either<ErrorMessage, ChangePasswordResponseModel>>
      customerChangePassword(
          {required ChangePasswordRequestModel model}) async {
    ErrorMessage errorMessage = ErrorMessage(
        message: "Something went wrong", errorType: ErrorType.ERROR);
    Response? response;
    ChangePasswordResponseModel? responseModel;
    Map body = {
      "module": "customerChangePassword",
      'license': getLicence(),
      "authcode": sp.getAuthCode(),
      "version": appVersion.$,
      "ln": lnCode.$,
    };
    body.addAll(model.toJson());
    await apiClient.request(
        header: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: body,
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          errorMessage = data;
        });

    if (response != null) {
      try {
        responseModel = changePasswordResponseModelFromJson(response!.body);

        return Right(responseModel);
      } catch (e) {
        log("Exception $e");
        return Left(ErrorMessage(
            message: "Something went wrong", errorType: ErrorType.ERROR));
      }
    } else {
      return Left(errorMessage);
    }
  }

  @override
  Future<Either<ErrorMessage, DeleteAccountResponseModel>>
      deleteCustomer() async {
    ErrorMessage errorMessage = ErrorMessage(
        message: "Something went wrong", errorType: ErrorType.ERROR);
    Response? response;
    DeleteAccountResponseModel? responseModel;
    Map body = {
      "module": "deleteCustomer",
      'license': getLicence(),
      "version": appVersion.$,
      "authcode": sp.getAuthCode(),
      "ln": lnCode.$,
    };
    await apiClient.request(
        header: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: body,
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          errorMessage = data;
        });

    if (response != null) {
      try {
        responseModel = deleteAccountResponseModelFromJson(response!.body);

        return Right(responseModel);
      } catch (e) {
        log("Exception $e");
        return Left(ErrorMessage(
            message: "Something went wrong", errorType: ErrorType.ERROR));
      }
    } else {
      return Left(errorMessage);
    }
  }

  @override
  Future<Either<ErrorMessage, ForgotPasswordResponseModel>>
      customerForgetPassword(
          {required ForgotPasswordRequestModel model}) async {
    ErrorMessage errorMessage = ErrorMessage(
        message: "Something went wrong", errorType: ErrorType.ERROR);
    Response? response;
    ForgotPasswordResponseModel? responseModel;
    Map body = {
      "module": "customerForgetPassword",
      'license': getLicence(),
      "version": appVersion.$,
      "ln": lnCode.$,
    };
    body.addAll(model.toJson());
    await apiClient.request(
        header: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: body,
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          errorMessage = data;
        });

    if (response != null) {
      try {
        responseModel = forgotPasswordResponseModelFromJson(response!.body);

        return Right(responseModel);
      } catch (e) {
        log("Exception $e");
        return Left(ErrorMessage(
            message: "Something went wrong", errorType: ErrorType.ERROR));
      }
    } else {
      return Left(errorMessage);
    }
  }

  @override
  Future<Either<ErrorMessage, NumberSendOtpResponseModel>> changeNumberSendOtp(
      {required NumberSendOtpRequestModel model}) async {
    ErrorMessage errorMessage = ErrorMessage(
        message: "Something went wrong", errorType: ErrorType.ERROR);
    Response? response;
    NumberSendOtpResponseModel? responseModel;
    Map body = {
      "module": "changeNumberSendOtp",
      'license': getLicence(),
      "version": appVersion.$,
      "authcode": sp.getAuthCode(),
      "ln": lnCode.$,
    };
    body.addAll(model.toJson());
    await apiClient.request(
        header: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: body,
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          errorMessage = data;
        });

    if (response != null) {
      try {
        responseModel = numberSendOtpResponseModelFromJson(response!.body);

        return Right(responseModel);
      } catch (e) {
        log("Exception $e");
        return Left(ErrorMessage(
            message: "Something went wrong", errorType: ErrorType.ERROR));
      }
    } else {
      return Left(errorMessage);
    }
  }

  @override
  Future<Either<ErrorMessage, ProfileResponseModel>> loggedInCustomer() async {
    ErrorMessage errorMessage = ErrorMessage(
        message: "Something went wrong", errorType: ErrorType.ERROR);
    Response? response;
    ProfileResponseModel? responseModel;

    Map body = {
      "module": "loggedInCustomer",
      'license': getLicence(),
      "authCode": sp.getAuthCode(),
      "version": appVersion.$,
      "ln": lnCode.$,
    };
    await apiClient.request(
        header: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: body,
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          errorMessage = data;
        });

    if (response != null) {
      try {
        responseModel = profileResponseModelFromJson(response!.body);
        return Right(responseModel);
      } catch (e) {
        log("Exception $e");
        return Left(ErrorMessage(
            message: "Something went wrong", errorType: ErrorType.ERROR));
      }
    } else {
      return Left(errorMessage);
    }
  }

  @override
  Future<Either<ErrorMessage, MailSendOtpResponseModel>> changeEmailSendOtp(
      {required MailSendOtpRequestModel model}) async {
    ErrorMessage errorMessage = ErrorMessage(
        message: "Something went wrong", errorType: ErrorType.ERROR);
    Response? response;
    MailSendOtpResponseModel? responseModel;
    Map body = {
      "module": "changeEmailSendOtp",
      'license': getLicence(),
      "authcode": sp.getAuthCode(),
      "version": appVersion.$,
      "ln": lnCode.$,
    };
    body.addAll(model.toJson());
    await apiClient.request(
        header: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: body,
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          errorMessage = data;
        });

    if (response != null) {
      try {
        responseModel = mailSendOtpResponseModelFromJson(response!.body);

        return Right(responseModel);
      } catch (e) {
        log("Exception $e");
        return Left(ErrorMessage(
            message: "Something went wrong", errorType: ErrorType.ERROR));
      }
    } else {
      return Left(errorMessage);
    }
  }

  @override
  Future<Either<ErrorMessage, UpdateProfileResponseModel>> updateCustomer(
      {required UpdateProfileRequestModel model}) async {
    ErrorMessage errorMessage = ErrorMessage(
        message: "Something went wrong", errorType: ErrorType.ERROR);
    Response? response;
    UpdateProfileResponseModel? responseModel;
    Map body = {
      "module": "updateCustomer",
      'license': getLicence(),
      "authcode": sp.getAuthCode(),
      "version": appVersion.$,
      "ln": lnCode.$,
    };
    body.addAll(model.toJson());
    await apiClient.request(
        header: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: body,
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          errorMessage = data;
        });

    if (response != null) {
      try {
        responseModel = updateProfileResponseModelFromJson(response!.body);

        return Right(responseModel);
      } catch (e) {
        log("Exception $e");
        return Left(ErrorMessage(
            message: "Something went wrong", errorType: ErrorType.ERROR));
      }
    } else {
      return Left(errorMessage);
    }
  }

  @override
  Future<Either<ErrorMessage, OtpVerificationResponseModel>> regOTPverification(
      {required OtpVerificationRequestModel model}) async {
    ErrorMessage errorMessage = ErrorMessage(
        message: "Something went wrong", errorType: ErrorType.ERROR);
    Response? response;
    OtpVerificationResponseModel? responseModel;
    Map body = {
      "module": "regOTPverification",
      'license': getLicence(),
      "version": appVersion.$,
      "ln": lnCode.$,
    };
    body.addAll(model.toJson());
    await apiClient.request(
        header: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: body,
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          errorMessage = data;
        });

    if (response != null) {
      try {
        responseModel = otpVerificationResponseModelFromJson(response!.body);

        return Right(responseModel);
      } catch (e) {
        log("Exception $e");
        return Left(ErrorMessage(
            message: "Something went wrong", errorType: ErrorType.ERROR));
      }
    } else {
      return Left(errorMessage);
    }
  }

  @override
  Future<Either<ErrorMessage, ResendOtpResponseModel>> regOtpResend(
      {required ResendOtpRequestModel model}) async {
    ErrorMessage errorMessage = ErrorMessage(
        message: "Something went wrong", errorType: ErrorType.ERROR);
    Response? response;
    ResendOtpResponseModel? responseModel;
    Map body = {
      "module": "regOtpResend",
      'license': getLicence(),
      "version": appVersion.$,
      "ln": lnCode.$,
    };
    body.addAll(model.toJson());
    await apiClient.request(
        header: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: body,
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          errorMessage = data;
        });

    if (response != null) {
      try {
        responseModel = resendOtpResponseModelFromJson(response!.body);
        return Right(responseModel);
      } catch (e) {
        log("Exception $e");
        return Left(ErrorMessage(
            message: "Something went wrong", errorType: ErrorType.ERROR));
      }
    } else {
      return Left(errorMessage);
    }
  }

  @override
  Future<Either<ErrorMessage, ResetPasswordResponseModel>>
      customerResetPassword({required ResetPasswordRequestModel model}) async {
    ErrorMessage errorMessage = ErrorMessage(
        message: "Something went wrong", errorType: ErrorType.ERROR);
    Response? response;
    ResetPasswordResponseModel? responseModel;
    Map body = {
      "module": "customerResetPassword",
      'license': getLicence(),
      "version": appVersion.$,
      "ln": lnCode.$,
    };
    body.addAll(model.toJson());
    await apiClient.request(
        header: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        url: APIEndPoints.webApi(),
        method: Method.POST,
        body: body,
        onSuccess: (data) {
          response = data;
        },
        onError: (data) {
          errorMessage = data;
        });

    if (response != null) {
      try {
        responseModel = resetPasswordResponseModelFromJson(response!.body);

        return Right(responseModel);
      } catch (e) {
        log("Exception $e");
        return Left(ErrorMessage(
            message: "Something went wrong", errorType: ErrorType.ERROR));
      }
    } else {
      return Left(errorMessage);
    }
  }
}
