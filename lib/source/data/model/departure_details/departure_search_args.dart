import 'package:ju_express/source/data/model/common/district.dart';

class DepartureSearchArgs {
  DepartureSearchArgs({
    required this.from,
    required this.to,
    required this.date,
  });
  District from;
  District to;
  DateTime date;
}
