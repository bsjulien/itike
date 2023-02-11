import 'package:flutter/material.dart';
import 'package:itike/utils/colors.dart';
import 'package:itike/widgets/small_text.dart';

class Button extends StatelessWidget {
  final String text;
  double width;
  Button({Key? key, required this.text, this.width = 262}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 57,
      child: Center(
          child: SmallText(
        text: text,
        size: 17,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      )),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.buttonBgColor),
    );
  }
}
