import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SmallText extends StatelessWidget {
  final Color? color;
  final String text;
  final FontWeight? fontWeight;
  TextOverflow overflow;
  double size;

  SmallText(
      {Key? key,
      this.color = const Color(0xB10A2A49),
      required this.text,
      this.size: 14,
      this.fontWeight = FontWeight.w500,
      this.overflow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overflow,
      style: GoogleFonts.poppins(
          color: color,
          fontSize: size,
          fontWeight: fontWeight,
          decoration: TextDecoration.none),
    );
  }
}
