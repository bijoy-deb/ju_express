import 'BusSeat.dart';

class SelectedSeatModel {
  List<BusSeat> busSeats = [];
  List<int> selectedPosition = [];

  void changeData(List<BusSeat> seats, List<int> positions) {
    busSeats = seats;
    selectedPosition = positions;
  }
}
