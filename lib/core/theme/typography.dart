import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Typography & Text Styles for MuseCam AI
class MuseTypography {
  MuseTypography._();

  // Display / Hero text: Urbanist
  static TextStyle displayXL = GoogleFonts.urbanist(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.5,
    color: MuseColors.textPrimary,
  );

  static TextStyle displayLg = GoogleFonts.urbanist(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: MuseColors.textPrimary,
  );

  static TextStyle displayMd = GoogleFonts.urbanist(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: MuseColors.textPrimary,
  );

  static TextStyle displaySm = GoogleFonts.urbanist(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: MuseColors.textPrimary,
  );

  // Body / Labels: DM Sans
  static TextStyle bodyLg = GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: MuseColors.textPrimary,
  );

  static TextStyle bodyMd = GoogleFonts.dmSans(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: MuseColors.textPrimary,
  );

  static TextStyle bodySm = GoogleFonts.dmSans(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: MuseColors.textPrimary,
  );

  static TextStyle labelLg = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: MuseColors.textPrimary,
  );

  static TextStyle labelMd = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: MuseColors.textPrimary,
  );

  static TextStyle labelSm = GoogleFonts.dmSans(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: MuseColors.textSecondary,
  );

  // Monospace / HUD data: JetBrains Mono
  static TextStyle monoLg = GoogleFonts.robotoMono(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: MuseColors.textPrimary,
  );

  static TextStyle monoMd = GoogleFonts.robotoMono(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: MuseColors.textPrimary,
  );

  static TextStyle monoSm = GoogleFonts.robotoMono(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: MuseColors.textPrimary,
  );

  // Secondary text colors
  static TextStyle bodyLgSecondary = bodyLg.copyWith(
    color: MuseColors.textSecondary,
  );

  static TextStyle bodyMdSecondary = bodyMd.copyWith(
    color: MuseColors.textSecondary,
  );

  static TextStyle bodySmSecondary = bodySm.copyWith(
    color: MuseColors.textSecondary,
  );
}
