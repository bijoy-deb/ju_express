part of 'passenger_info_bloc.dart';

abstract class PassengerInfoEvent extends Equatable {
  const PassengerInfoEvent();
}

class TicketSaleEvent extends PassengerInfoEvent {
  final TicketSalePrams ticketSalePrams;

  const TicketSaleEvent(this.ticketSalePrams);

  @override
  List<Object?> get props => [ticketSalePrams];
}

class CheckPayment extends PassengerInfoEvent {
  final String vHash;
  final String payID;

  const CheckPayment({required this.vHash, required this.payID});

  @override
  List<Object?> get props => [vHash, payID];
}

class Push extends PassengerInfoEvent {
  final double amount;
  final String mobile;
  final String refID;
  final String url;
  final String type;

  const Push(
      {required this.amount,
      required this.mobile,
      required this.refID,
      required this.url,
      required this.type});

  @override
  List<Object?> get props => [amount, mobile, refID, url, type];
}

class CouponVerify extends PassengerInfoEvent {
  final String couponCode;
  final String dIDs;
  final String from;
  final String to;
  const CouponVerify(
      {required this.couponCode,
      required this.dIDs,
      required this.from,
      required this.to});

  @override
  List<Object> get props => [couponCode, dIDs, from, to];
}

class CreateInvoice extends PassengerInfoEvent {
  final String vHash;
  final String payID;

  const CreateInvoice({required this.vHash, required this.payID});

  @override
  List<Object?> get props => [vHash, payID];
}

class CustomerBalance extends PassengerInfoEvent {
  final String busCard;
  final String pin;

  const CustomerBalance({required this.busCard, required this.pin});

  @override
  List<Object?> get props => [busCard, pin];
}
