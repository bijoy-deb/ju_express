import 'package:flutter/material.dart';

class CircleLoader extends StatelessWidget {
  const CircleLoader({this.color = Colors.white, Key? key}) : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 23,
      width: 23,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: color,
      ),
    );
  }
}
