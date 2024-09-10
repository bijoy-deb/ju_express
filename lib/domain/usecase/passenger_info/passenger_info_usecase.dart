import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/core/error/error_message.dart';
import 'package:ju_express/source/data/model/common/status_message_res.dart';
import 'package:ju_express/source/data/model/download_ticket/download_ticket_res.dart';
import 'package:ju_express/source/data/model/passenger_info/cupon_details.dart';
import 'package:ju_express/source/data/model/passenger_info/ticket_sale_prams.dart';
import 'package:ju_express/source/data/model/passenger_info/ticket_sale_res.dart';
import 'package:ju_express/source/data/repositories/passenger_info/i_passenger_info_repository.dart';

import '../../../source/data/model/balance/balance_res.dart';
import '../../../source/data/model/passenger_info/stripe_invoice_res.dart';
import 'i_passenger_info_usecase.dart';

@Injectable(as: IPassengerInfoUseCase)
class PassengerInfoUseCase extends IPassengerInfoUseCase {
  IPassengerInfoRepository passengerInfoRepository;
  PassengerInfoUseCase(this.passengerInfoRepository);

  @override
  Future<Either<ErrorMessage, TicketSaleRes>> ticketSale(
      {required TicketSalePrams ticketSalePrams}) {
    return passengerInfoRepository.ticketSale(ticketSalePrams: ticketSalePrams);
  }

  @override
  Future<Either<ErrorMessage, DownloadTicketRes>> paymentConfirm(
      {required String vHash, required String payID}) {
    return passengerInfoRepository.paymentConfirm(vHash: vHash, payID: payID);
  }

  @override
  Future<Either<ErrorMessage, StatusMessageRes>> push(
      {required String mobile,
      required String refID,
      required double amount,
      required String url,
      required String type}) {
    return passengerInfoRepository.push(
        mobile: mobile, refID: refID, amount: amount, url: url, type: type);
  }

  @override
  Future<Either<ErrorMessage, CouponCodeRes>> couponVerify(
      {required String couponCode,
      required String dIDs,
      required String from,
      required String to}) {
    return passengerInfoRepository.couponVerify(
        couponCode: couponCode, dIDs: dIDs, from: from, to: to);
  }

  @override
  Future<Either<ErrorMessage, StripeInvoiceRes>> stripeInvoiceCreate(
      {required String vHash, required String payID}) {
    return passengerInfoRepository.stripeInvoiceCreate(
        vHash: vHash, payID: payID);
  }

  @override
  Future<Either<ErrorMessage, BalanceRes>> getCustomerBalance(
      {required String busCard, required String pin}) {
    return passengerInfoRepository.getCustomerBalance(
        busCard: busCard, pin: pin);
  }
}
