part of 'sale_history_bloc.dart';

abstract class SaleHistoryState extends Equatable {
  const SaleHistoryState();
}

class SaleHistoryInitial extends SaleHistoryState {
  @override
  List<Object> get props => [];
}

class DataLoading extends SaleHistoryState {
  @override
  List<Object> get props => [];
}

class DataError extends SaleHistoryState {
  final ErrorMessage error;

  const DataError(this.error);

  @override
  List<Object> get props => [error];
}

class SaleHistoryLoaded extends SaleHistoryState {
  final SaleHistoryResponseModel res;

  const SaleHistoryLoaded(this.res);

  @override
  List<Object> get props => [res];
}
