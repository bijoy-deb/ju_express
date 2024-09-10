part of 'district_list_bloc.dart';

abstract class DistrictListEvent extends Equatable {}

class GetDistrictListData extends DistrictListEvent {
  final bool fromApi;
  GetDistrictListData({this.fromApi = false});
  @override
  List<Object> get props => [];
}

class GetFromWiseToData extends DistrictListEvent {
  final String from;
  GetFromWiseToData({required this.from});
  @override
  List<Object> get props => [];
}
