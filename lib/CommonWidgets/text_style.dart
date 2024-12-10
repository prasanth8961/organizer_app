import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle textStyle(double size, Color color, FontWeight fontweight) {
  return GoogleFonts.poppins(
      fontSize: size, color: color, fontWeight: fontweight);
}

TextStyle textStyleWithHeight(
    double size, Color color, FontWeight fontweight, double height) {
  return GoogleFonts.poppins(
      fontSize: size, color: color, fontWeight: fontweight, height: height);
}
