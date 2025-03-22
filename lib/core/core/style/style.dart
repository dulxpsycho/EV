import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyleHandler {
  static headingStyle({double? fontSize, Color? color}) =>
      TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: color);
  static subheadingStyle({double? fontSize, Color? color}) =>
      TextStyle(fontSize: fontSize, color: color);
  static var detailpgstyle =
      const TextStyle(fontSize: 17, fontWeight: FontWeight.w600);
  static googleheadingStyle({double? fontSize, Color? color}) =>
      GoogleFonts.poppins(
          fontSize: fontSize, fontWeight: FontWeight.bold, color: color);
}
