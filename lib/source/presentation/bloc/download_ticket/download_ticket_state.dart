part of 'download_ticket_bloc.dart';

abstract class DownloadTicketState extends Equatable {
  const DownloadTicketState();
}

class DownloadTicketInitial extends DownloadTicketState {
  @override
  List<Object> get props => [];
}

//loading

class DownloadTicketLoading extends DownloadTicketState {
  @override
  List<Object> get props => [];
}

//loaded

class DownloadTicketLoaded extends DownloadTicketState {
  final DownloadTicketRes res;

  const DownloadTicketLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class DownloadTicketError extends DownloadTicketState {
  final ErrorMessage error;

  const DownloadTicketError(this.error);

  @override
  List<Object> get props => [error];
}
