import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../source/utils/app_color.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  Color parseColor() {
    try {
      return HexColor(this);
    } catch (e) {
      if (kDebugMode) {
        print("error: $e this: $this");
      }
      return Colors.white;
    }
  }

  bool equalsIgnoreCase(String other) {
    return toLowerCase() == other.toLowerCase();
  }
}

extension DateTimeExtension on DateTime {
  String formatForApi() {
    return DateFormat('dd-MM-yyyy').format(this);
  }
}
