import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_message.dart';
import '../../../../domain/usecase/authentication/authentication_usecase.dart';
import '../../../data/model/authentication/request/change_mail_request_model.dart';
import '../../../data/model/authentication/request/change_number_request_model.dart';
import '../../../data/model/authentication/request/change_password_request_model.dart';
import '../../../data/model/authentication/request/forgot_password_request_model.dart';
import '../../../data/model/authentication/request/login_request_model.dart';
import '../../../data/model/authentication/request/mail_send_otp_request_model.dart';
import '../../../data/model/authentication/request/number_send_otp_request_model.dart';
import '../../../data/model/authentication/request/otp_verification_request_model.dart';
import '../../../data/model/authentication/request/registration_request_model.dart';
import '../../../data/model/authentication/request/resend_otp_request_model.dart';
import '../../../data/model/authentication/request/reset_password_request_model.dart';
import '../../../data/model/authentication/request/update_profile_request_model.dart';
import '../../../data/model/authentication/response/change_mail_response_model.dart';
import '../../../data/model/authentication/response/change_number_response_model.dart';
import '../../../data/model/authentication/response/change_password_response_model.dart';
import '../../../data/model/authentication/response/delete_account_response_model.dart';
import '../../../data/model/authentication/response/forgot_password_response_model.dart';
import '../../../data/model/authentication/response/login_response_model.dart';
import '../../../data/model/authentication/response/mail_send_otp_response_model.dart';
import '../../../data/model/authentication/response/number_send_otp_response_model.dart';
import '../../../data/model/authentication/response/otp_verification_response_model.dart';
import '../../../data/model/authentication/response/profile_response_model.dart';
import '../../../data/model/authentication/response/registration_response_model.dart';
import '../../../data/model/authentication/response/resend_otp_response_model.dart';
import '../../../data/model/authentication/response/reset_password_response_model.dart';
import '../../../data/model/authentication/response/update_profile_response_model.dart';


part 'authentication_event.dart';
part 'authentication_state.dart';

@injectable
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationUseCase useCase;
  AuthenticationBloc({required this.useCase}) : super(AuthenticationInitial()) {
    on<RegistrationSubmitEvent>((event, emit) async {
      emit(DataLoading());
      var result = await useCase.customerRegistration(model: event.model);
      result.fold(
          (l) => emit(DataError(l)), (r) => emit(RegistrationLoaded(r)));
    });

    on<LoginSubmitEvent>((event, emit) async {
      emit(DataLoading());
      var result = await useCase.customerLogin(model: event.model);
      result.fold((l) => emit(DataError(l)), (r) => emit(LoginLoaded(r)));
    });

    on<ChangeMailSubmitEvent>((event, emit) async {
      emit(DataLoading());
      var result = await useCase.changeEmail(model: event.model);
      result.fold((l) => emit(DataError(l)), (r) => emit(ChangeMailLoaded(r)));
    });

    on<ChangeNumberSubmitEvent>((event, emit) async {
      emit(DataLoading());
      var result = await useCase.changeNumber(model: event.model);
      result.fold(
          (l) => emit(DataError(l)), (r) => emit(ChangeNumberLoaded(r)));
    });

    on<ChangePasswordSubmitEvent>((event, emit) async {
      emit(DataLoading());
      var result = await useCase.customerChangePassword(model: event.model);
      result.fold(
          (l) => emit(DataError(l)), (r) => emit(ChangePasswordLoaded(r)));
    });

    on<DeleteAccountSubmitEvent>((event, emit) async {
      emit(DataLoading());
      var result = await useCase.deleteCustomer();
      result.fold(
          (l) => emit(DataError(l)), (r) => emit(DeleteAccountLoaded(r)));
    });

    on<ForgotPasswordSubmitEvent>((event, emit) async {
      emit(DataLoading());
      var result = await useCase.customerForgetPassword(model: event.model);
      result.fold(
          (l) => emit(DataError(l)), (r) => emit(ForgotPasswordLoaded(r)));
    });

    on<NumberSendOtpSubmitEvent>((event, emit) async {
      emit(DataLoading());
      var result = await useCase.changeNumberSendOtp(model: event.model);
      result.fold(
          (l) => emit(DataError(l)), (r) => emit(NumberSendOtpLoaded(r)));
    });

    on<GetProfileInfoEvent>((event, emit) async {
      emit(DataLoading());

      var result = await useCase.loggedInCustomer();
      result.fold((l) => emit(DataError(l)), (r) => emit(ProfileLoaded(r)));
    });

    on<MailSendOtpSubmitEvent>((event, emit) async {
      emit(DataLoading());
      var result = await useCase.changeEmailSendOtp(model: event.model);
      result.fold((l) => emit(DataError(l)), (r) => emit(MailSendOtpLoaded(r)));
    });

    on<UpdateProfileSubmitEvent>((event, emit) async {
      emit(DataLoading());
      var result = await useCase.updateCustomer(model: event.model);
      result.fold(
          (l) => emit(DataError(l)), (r) => emit(UpdateProfileLoaded(r)));
    });

    on<OtpVerifyEvent>((event, emit) async {
      emit(DataLoading());
      var result = await useCase.regOTPverification(model: event.model);
      result.fold((l) => emit(DataError(l)), (r) => emit(OtpLoaded(r)));
    });

    on<ResendOtpSubmitEvent>((event, emit) async {
      emit(DataLoading());
      var result = await useCase.regOtpResend(model: event.model);
      result.fold((l) => emit(DataError(l)), (r) => emit(ResendOtpLoaded(r)));
    });

    on<ResetPasswordSubmitEvent>((event, emit) async {
      emit(DataLoading());
      var result = await useCase.customerResetPassword(model: event.model);
      result.fold(
          (l) => emit(DataError(l)), (r) => emit(ResetPasswordLoaded(r)));
    });
  }
}
