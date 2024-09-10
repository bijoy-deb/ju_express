import 'package:flutter/material.dart';

class AppStyle {
  static TextStyle textStyleF17W600({Color color = Colors.black}) {
    return TextStyle(color: color, fontSize: 17, fontWeight: FontWeight.w600);
  }

  static TextStyle textStyleF16W400({Color color = Colors.black}) {
    return TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w400);
  }

  static TextStyle textStyleF17W400({Color color = Colors.black}) {
    return TextStyle(color: color, fontSize: 17, fontWeight: FontWeight.w400);
  }

  static TextStyle textStyleF17W600D({Color color = Colors.black}) {
    return TextStyle(
        color: color,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline);
  }

  static TextStyle textStyleF18W700({Color color = Colors.black}) {
    return TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w700);
  }

  static TextStyle textStyleF25W700({Color color = Colors.black}) {
    return TextStyle(color: color, fontSize: 25, fontWeight: FontWeight.w700);
  }

  static TextStyle textStyleF20W700({Color color = Colors.black}) {
    return TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w700);
  }

  static TextStyle textStyleF45W700({Color color = Colors.black}) {
    return TextStyle(color: color, fontSize: 65, fontWeight: FontWeight.normal);
  }
}
