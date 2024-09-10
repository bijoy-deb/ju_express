part of 'contact_us_bloc.dart';

abstract class ContactUsEvent extends Equatable {}

class SendMessage extends ContactUsEvent {
  final String name;
  final String email;
  final String mobile;
  final String cCode;
  final String message;

  SendMessage({
    required this.name,
    required this.email,
    required this.mobile,
    required this.cCode,
    required this.message,
  });
  @override
  List<Object> get props => [name, email, mobile, cCode, message];
}
