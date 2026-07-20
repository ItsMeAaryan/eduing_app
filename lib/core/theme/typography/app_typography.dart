import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextStyle get display => GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.5,
  );

  static TextStyle get headline => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static TextStyle get title => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get body => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get label => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get button => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}
