import 'package:flutter/material.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';

import '../../utils/app_color.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppBar().preferredSize.height +
          MediaQuery.of(context).padding.top +
          20,
      width: double.infinity,
      color: AppColors.primaryColor.parseColor(),
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 6, bottom: 8),
      child: Center(
        child: Image.asset(
          'assets/images/logo-white.png',
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
