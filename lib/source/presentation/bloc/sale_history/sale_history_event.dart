part of 'sale_history_bloc.dart';

abstract class SaleHistoryEvent extends Equatable {}

class GetSaleHistoryEvent extends SaleHistoryEvent {
  final SaleHistoryRequestModel model;

  GetSaleHistoryEvent({required this.model});
  @override
  List<Object> get props => [model];
}
