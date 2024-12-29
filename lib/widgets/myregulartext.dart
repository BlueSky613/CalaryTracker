import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ketodiet/utils/colors_utils.dart';

class MyRegularText extends StatelessWidget {
  final String label;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? align;
  final int? maxlines;
  final TextDecoration? decoration;
  final Paint? foreground;
  final TextStyle? style;
  final double? letterSpacing;
  final String? fontFamily;
  final  double? height;
  final  bool? isHeading;

  const MyRegularText({
    Key? key,
    required this.label,
    required this.isHeading,
    this.color = textColor,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.normal,
    this.align = TextAlign.center,
    this.foreground,
    this.maxlines,
    this.fontFamily,
    this.letterSpacing,
    this.style,
    this.height,
    this.decoration = TextDecoration.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: align,
      maxLines: maxlines,
      overflow: TextOverflow.ellipsis,
      style:style?? ((isHeading!)? GoogleFonts.syne : GoogleFonts.inter)(
        textStyle: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight ?? FontWeight.w600,
            foreground:foreground,
            fontFamily: fontFamily,
            letterSpacing:letterSpacing?? 0,
            height: height??1.1,
            fontStyle: FontStyle.normal,
            decoration: decoration),
      ),
    );
  }
}
