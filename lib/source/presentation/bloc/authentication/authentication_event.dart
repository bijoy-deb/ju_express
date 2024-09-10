part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {}

class RegistrationSubmitEvent extends AuthenticationEvent {
  final RegistrationRequestModel model;

  RegistrationSubmitEvent({required this.model});
  @override
  List<Object> get props => [model];
}

class LoginSubmitEvent extends AuthenticationEvent {
  final LoginRequestModel model;

  LoginSubmitEvent({required this.model});
  @override
  List<Object> get props => [model];
}

class ChangeMailSubmitEvent extends AuthenticationEvent {
  final ChangeMailRequestModel model;

  ChangeMailSubmitEvent({required this.model});
  @override
  List<Object> get props => [model];
}

class ChangeNumberSubmitEvent extends AuthenticationEvent {
  final ChangeNumberRequestModel model;

  ChangeNumberSubmitEvent({required this.model});
  @override
  List<Object> get props => [model];
}

class ChangePasswordSubmitEvent extends AuthenticationEvent {
  final ChangePasswordRequestModel model;

  ChangePasswordSubmitEvent({required this.model});
  @override
  List<Object> get props => [model];
}

class DeleteAccountSubmitEvent extends AuthenticationEvent {
  DeleteAccountSubmitEvent();
  @override
  List<Object> get props => [];
}

class ForgotPasswordSubmitEvent extends AuthenticationEvent {
  final ForgotPasswordRequestModel model;

  ForgotPasswordSubmitEvent({required this.model});
  @override
  List<Object> get props => [model];
}

class NumberSendOtpSubmitEvent extends AuthenticationEvent {
  final NumberSendOtpRequestModel model;

  NumberSendOtpSubmitEvent({required this.model});
  @override
  List<Object> get props => [model];
}

class GetProfileInfoEvent extends AuthenticationEvent {
  GetProfileInfoEvent();
  @override
  List<Object> get props => [];
}

class MailSendOtpSubmitEvent extends AuthenticationEvent {
  final MailSendOtpRequestModel model;

  MailSendOtpSubmitEvent({required this.model});
  @override
  List<Object> get props => [model];
}

class UpdateProfileSubmitEvent extends AuthenticationEvent {
  final UpdateProfileRequestModel model;

  UpdateProfileSubmitEvent({required this.model});
  @override
  List<Object> get props => [model];
}

class OtpVerifyEvent extends AuthenticationEvent {
  final OtpVerificationRequestModel model;

  OtpVerifyEvent({required this.model});
  @override
  List<Object> get props => [model];
}

class ResendOtpSubmitEvent extends AuthenticationEvent {
  final ResendOtpRequestModel model;

  ResendOtpSubmitEvent({required this.model});
  @override
  List<Object> get props => [model];
}

class ResetPasswordSubmitEvent extends AuthenticationEvent {
  final ResetPasswordRequestModel model;

  ResetPasswordSubmitEvent({required this.model});
  @override
  List<Object> get props => [model];
}
