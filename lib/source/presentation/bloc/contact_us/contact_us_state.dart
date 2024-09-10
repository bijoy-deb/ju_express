part of 'contact_us_bloc.dart';

abstract class ContactUsState extends Equatable {
  const ContactUsState();
}

class ContactUsInitial extends ContactUsState {
  @override
  List<Object> get props => [];
}

//loading

class SendingMessage extends ContactUsState {
  @override
  List<Object> get props => [];
}

//loaded

class MessageSent extends ContactUsState {
  final StatusMessageRes res;

  const MessageSent(this.res);

  @override
  List<Object> get props => [res];
}

class MessageSentError extends ContactUsState {
  final ErrorMessage error;

  const MessageSentError(this.error);

  @override
  List<Object> get props => [error];
}
