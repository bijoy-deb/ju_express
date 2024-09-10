part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class DataLoading extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class DataError extends AuthenticationState {
  final ErrorMessage error;

  const DataError(this.error);

  @override
  List<Object> get props => [error];
}

class RegistrationLoaded extends AuthenticationState {
  final RegistrationResponeModel res;

  const RegistrationLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class LoginLoaded extends AuthenticationState {
  final LoginResponseModel res;

  const LoginLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class ChangeMailLoaded extends AuthenticationState {
  final ChangeMailResponseModel res;

  const ChangeMailLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class ChangeNumberLoaded extends AuthenticationState {
  final ChangeNumberResponseModel res;

  const ChangeNumberLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class ChangePasswordLoaded extends AuthenticationState {
  final ChangePasswordResponseModel res;

  const ChangePasswordLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class DeleteAccountLoaded extends AuthenticationState {
  final DeleteAccountResponseModel res;

  const DeleteAccountLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class ForgotPasswordLoaded extends AuthenticationState {
  final ForgotPasswordResponseModel res;

  const ForgotPasswordLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class NumberSendOtpLoaded extends AuthenticationState {
  final NumberSendOtpResponseModel res;

  const NumberSendOtpLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class ProfileLoaded extends AuthenticationState {
  final ProfileResponseModel res;

  const ProfileLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class MailSendOtpLoaded extends AuthenticationState {
  final MailSendOtpResponseModel res;

  const MailSendOtpLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class UpdateProfileLoaded extends AuthenticationState {
  final UpdateProfileResponseModel res;

  const UpdateProfileLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class OtpLoaded extends AuthenticationState {
  final OtpVerificationResponseModel res;

  const OtpLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class ResendOtpLoaded extends AuthenticationState {
  final ResendOtpResponseModel res;

  const ResendOtpLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class ResetPasswordLoaded extends AuthenticationState {
  final ResetPasswordResponseModel res;

  const ResetPasswordLoaded(this.res);

  @override
  List<Object> get props => [res];
}
