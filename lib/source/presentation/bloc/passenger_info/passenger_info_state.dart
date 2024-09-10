part of 'passenger_info_bloc.dart';

abstract class PassengerInfoState extends Equatable {
  const PassengerInfoState();
}

class PassengerInfoInitial extends PassengerInfoState {
  @override
  List<Object> get props => [];
}

class TicketSaleLoading extends PassengerInfoState {
  @override
  List<Object> get props => [];
}

class TicketSaleSuccess extends PassengerInfoState {
  final TicketSaleRes ticketSaleRes;
  const TicketSaleSuccess(this.ticketSaleRes);

  @override
  List<Object> get props => [ticketSaleRes];
}

class TicketSaleFail extends PassengerInfoState {
  final ErrorMessage error;
  const TicketSaleFail(this.error);

  @override
  List<Object> get props => [error];
}

class CheckingPayment extends PassengerInfoState {
  @override
  List<Object> get props => [];
}

class PaymentSuccess extends PassengerInfoState {
  final DownloadTicketRes res;
  const PaymentSuccess(this.res);

  @override
  List<Object> get props => [res];
}

class PaymentFailed extends PassengerInfoState {
  final ErrorMessage error;
  const PaymentFailed(this.error);

  @override
  List<Object> get props => [error];
}

class CreatingInvoice extends PassengerInfoState {
  @override
  List<Object> get props => [];
}

class PushLoading extends PassengerInfoState {
  @override
  List<Object> get props => [];
}

class PushLoaded extends PassengerInfoState {
  final StatusMessageRes res;
  const PushLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class PushFailed extends PassengerInfoState {
  final ErrorMessage error;
  const PushFailed(this.error);

  @override
  List<Object> get props => [error];
}

class CouponCodeApplied extends PassengerInfoState {
  final CouponCodeRes res;

  const CouponCodeApplied(this.res);

  @override
  List<Object> get props => [res];
}

class InvoiceCreated extends PassengerInfoState {
  final StripeInvoiceRes res;
  const InvoiceCreated(this.res);

  @override
  List<Object> get props => [res];
}

class InvoiceCreateFailed extends PassengerInfoState {
  final ErrorMessage error;
  const InvoiceCreateFailed(this.error);

  @override
  List<Object> get props => [error];
}

class CustomerBalanceLoding extends PassengerInfoState {
  @override
  List<Object> get props => [];
}

class CustomerBalanceSuccess extends PassengerInfoState {
  final BalanceRes res;
  const CustomerBalanceSuccess(this.res);

  @override
  List<Object> get props => [res];
}

class CustomerBalanceFailed extends PassengerInfoState {
  final ErrorMessage error;
  const CustomerBalanceFailed(this.error);

  @override
  List<Object> get props => [error];
}
