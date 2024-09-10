part of 'static_content_bloc.dart';

abstract class StaticContentsState extends Equatable {
  const StaticContentsState();
}

class StaticContentsInitial extends StaticContentsState {
  @override
  List<Object> get props => [];
}

//loading

class StaticContentsLoading extends StaticContentsState {
  @override
  List<Object> get props => [];
}

//loaded

class StaticContentsLoaded extends StaticContentsState {
  final StaticContentRes res;

  const StaticContentsLoaded(this.res);

  @override
  List<Object> get props => [res];
}

class StaticContentsError extends StaticContentsState {
  final ErrorMessage error;

  const StaticContentsError(this.error);

  @override
  List<Object> get props => [error];
}
