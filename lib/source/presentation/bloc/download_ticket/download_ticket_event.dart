part of 'download_ticket_bloc.dart';

abstract class DownloadTicketEvent extends Equatable {}

class GetDownloadTicketData extends DownloadTicketEvent {
  final String mobile;
  final String cCode;
  final String pnr;
  GetDownloadTicketData(
      {required this.mobile, required this.pnr, required this.cCode});
  @override
  List<Object> get props => [mobile, pnr, cCode];
}
