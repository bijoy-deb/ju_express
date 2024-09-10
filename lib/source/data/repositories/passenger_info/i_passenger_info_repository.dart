import 'package:dartz/dartz.dart';
import 'package:ju_express/source/data/model/common/status_message_res.dart';
import 'package:ju_express/source/data/model/download_ticket/download_ticket_res.dart';
import 'package:ju_express/source/data/model/passenger_info/cupon_details.dart';

import '../../../../core/error/error_message.dart';
import '../../model/balance/balance_res.dart';
import '../../model/passenger_info/stripe_invoice_res.dart';
import '../../model/passenger_info/ticket_sale_prams.dart';
import '../../model/passenger_info/ticket_sale_res.dart';

abstract class IPassengerInfoRepository {
  Future<Either<ErrorMessage, TicketSaleRes>> ticketSale(
      {required TicketSalePrams ticketSalePrams});

  Future<Either<ErrorMessage, DownloadTicketRes>> paymentConfirm(
      {required String vHash, required String payID});
  Future<Either<ErrorMessage, CouponCodeRes>> couponVerify({
    required String couponCode,
    required String dIDs,
    required String from,
    required String to,
  });

  Future<Either<ErrorMessage, StripeInvoiceRes>> stripeInvoiceCreate(
      {required String vHash, required String payID});

  Future<Either<ErrorMessage, BalanceRes>> getCustomerBalance(
      {required String busCard, required String pin});

  Future<Either<ErrorMessage, StatusMessageRes>> push(
      {required String mobile,
      required String refID,
      required double amount,
      required String url,
      required String type});
}
