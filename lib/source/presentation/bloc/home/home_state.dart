part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

//loading

class HomePageIntLoading extends HomeState {
  @override
  List<Object> get props => [];
}

//loaded

class HomePageIntLoaded extends HomeState {
  final HomePageIntRes res;

  const HomePageIntLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class HomePageIntError extends HomeState {
  final ErrorMessage error;

  const HomePageIntError(this.error);

  @override
  List<Object> get props => [error];
}

class RemoteConfigLoaded extends HomeState {
  @override
  List<Object> get props => [];
}

class RemoteConfigError extends HomeState {
  @override
  List<Object> get props => [];
}
