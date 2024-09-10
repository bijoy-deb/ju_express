import 'package:ju_express/source/data/model/passenger_info/passenger_info_args.dart';
import 'package:ju_express/source/data/model/passenger_info/ticket_sale_res.dart';

class TripDetailsPayment {
  TripDetailsPayment({required this.saleRes, required this.infoArgs});
  TicketSaleRes saleRes;
  PassengerInfoArgs infoArgs;
}
