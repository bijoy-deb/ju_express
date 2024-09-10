import 'package:flutter/material.dart';
import 'package:ju_express/source/utils/app_color.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';

class SwapButton extends StatefulWidget {
  const SwapButton({required this.callback, super.key});
  final Function() callback;
  @override
  State<SwapButton> createState() => _SwapButtonState();
}

class _SwapButtonState extends State<SwapButton> with TickerProviderStateMixin {
  late AnimationController _controller;
  final Tween<double> turnsTween = Tween<double>(
    begin: 0,
    end: .5,
  );
  bool rotated = false;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35, right: 5),
      child: RotationTransition(
          turns: turnsTween.animate(_controller),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Material(
              child: InkWell(
                onTap: () {
                  if (rotated) {
                    _controller.reverse();
                  } else {
                    _controller.forward();
                  }
                  rotated = !rotated;
                  widget.callback();
                },
                child: Container(
                  // decoration: BoxDecoration(
                  //   border: Border.all(),
                  //   borderRadius: BorderRadius.circular(30),
                  // ),
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/swap.png',
                    height: 28,
                    width: 28,
                    color: AppColors.primaryColor.parseColor(),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
