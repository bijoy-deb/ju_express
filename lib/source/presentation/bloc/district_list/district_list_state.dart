part of 'district_list_bloc.dart';

abstract class DistrictListState extends Equatable {
  const DistrictListState();
}

class DistrictListInitial extends DistrictListState {
  @override
  List<Object> get props => [];
}

//loading

class DistrictListLoading extends DistrictListState {
  @override
  List<Object> get props => [];
}

//loaded

class DistrictListLoaded extends DistrictListState {
  final dynamic res;

  const DistrictListLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class DistrictListError extends DistrictListState {
  final ErrorMessage error;

  const DistrictListError(this.error);

  @override
  List<Object> get props => [error];
}
