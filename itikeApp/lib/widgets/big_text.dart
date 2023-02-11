import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BigText extends StatelessWidget {
  final Color? color;
  final String text;
  TextAlign textAlign;
  double size;
  BigText({
    Key? key,
    this.color = const Color(0xFF0A2A49),
    required this.text,
    this.size: 30,
    this.textAlign: TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
          color: color,
          fontSize: size,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.none),
    );
  }
}
