import 'package:flutter/material.dart';

class AppColors {
  static const String primaryColor = "0C1037";
  static const String secondaryColor = "00AEEf";
  static const String backgroundColor = "ededed";
  static const String primaryTextColor = "212121";
  static const String headerTextColor = "ffffff";
  static const String seatSelected = "#FFC107";
  static const String seatSold = "#FF0000";
  static const String seatAvailable = "#08750a";
  static const String seatName = "#ffffff";
  static Map<int, Color> getCustomColor(Color color) {
    return {
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color.withOpacity(0.6),
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1.0),
    };
  }

  static int hexToInt(String hex) {
    return int.parse(hex.substring(1, 6), radix: 16) + 0xFF000000;
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
