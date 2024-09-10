import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/source/data/model/common/status_message_res.dart';
import 'package:ju_express/source/data/model/download_ticket/download_ticket_res.dart';
import 'package:ju_express/source/data/model/passenger_info/ticket_sale_prams.dart';


import '../../../../core/error/error_message.dart';
import '../../../../domain/usecase/passenger_info/i_passenger_info_usecase.dart';
import '../../../data/model/balance/balance_res.dart';
import '../../../data/model/passenger_info/cupon_details.dart';
import '../../../data/model/passenger_info/stripe_invoice_res.dart';
import '../../../data/model/passenger_info/ticket_sale_res.dart';

part 'passenger_info_event.dart';
part 'passenger_info_state.dart';

@injectable
class PassengerInfoBloc extends Bloc<PassengerInfoEvent, PassengerInfoState> {
  IPassengerInfoUseCase passengerInfoUseCase;

  PassengerInfoBloc(this.passengerInfoUseCase) : super(PassengerInfoInitial()) {
    on<TicketSaleEvent>((event, emit) async {
      emit(TicketSaleLoading());
      var prams = event.ticketSalePrams;

      var result =
          await passengerInfoUseCase.ticketSale(ticketSalePrams: prams);

      result.fold(
          (l) => emit(TicketSaleFail(l)), (r) => emit(TicketSaleSuccess(r)));
    });

    on<CheckPayment>((event, emit) async {
      emit(CheckingPayment());
      var result = await passengerInfoUseCase.paymentConfirm(
          vHash: event.vHash, payID: event.payID);

      result.fold(
          (l) => emit(PaymentFailed(l)), (r) => emit(PaymentSuccess(r)));
    });

    on<Push>((event, emit) async {
      emit(PushLoading());
      var result = await passengerInfoUseCase.push(
          mobile: event.mobile,
          refID: event.refID,
          amount: event.amount,
          url: event.url,
          type: event.type);

      result.fold((l) => emit(PushFailed(l)), (r) => emit(PushLoaded(r)));
    });

    on<CouponVerify>((event, emit) async {
      emit(PushLoading());
      var result = await passengerInfoUseCase.couponVerify(
          couponCode: event.couponCode,
          dIDs: event.dIDs,
          from: event.from,
          to: event.to);
      result.fold(
          (l) => emit(PushFailed(l)), (r) => emit(CouponCodeApplied(r)));
    });
    on<CreateInvoice>((event, emit) async {
      emit(CreatingInvoice());
      var result = await passengerInfoUseCase.stripeInvoiceCreate(
          vHash: event.vHash, payID: event.payID);
      result.fold(
          (l) => emit(InvoiceCreateFailed(l)), (r) => emit(InvoiceCreated(r)));
    });
    on<CustomerBalance>((event, emit) async {
      emit(CustomerBalanceLoding());
      var result = await passengerInfoUseCase.getCustomerBalance(
          busCard: event.busCard, pin: event.pin);
      result.fold((l) => emit(CustomerBalanceFailed(l)),
          (r) => emit(CustomerBalanceSuccess(r)));
    });
  }
}
