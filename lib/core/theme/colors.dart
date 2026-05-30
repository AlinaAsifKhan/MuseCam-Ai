import 'package:flutter/material.dart';

/// MuseCam AI Color Palette
/// Custom warm, earthy tones with smooth transitions
class MuseColors {
  MuseColors._();

  // Custom Gradient Palette - Warm, Earthy Tones
  static const Color deepMahogany = Color(0xFF4A1E05); // Deepest shadow
  static const Color burntOrange = Color(0xFFA86026); // Rich mid-tone
  static const Color mutedGold = Color(0xFFD39B54); // Bright silken highlight
  static const Color warmSand = Color(0xFFE2B79A); // Pale transition
  static const Color dustyRose = Color(0xFFCD7B81); // Medium pink
  static const Color mauveRoseTaupe = Color(0xFFA6525E); // Base/deeper pink

  // Legacy colors (kept for compatibility)
  static const Color primary = Color(0xFFE8834A); // warm coral-orange
  static const Color secondary = Color(0xFFD4518A); // deep rose-pink
  static const Color gold = Color(0xFFD4922B); // rich amber-gold
  static const Color hotPink = Color(0xFFE0457B); // vivid magenta-pink

  // Backgrounds
  static const Color dark = Color(0xFF0D0C0E); // near-black with warmth
  static const Color surface = Color(0xFF1A1720); // deep muted purple-dark
  static const Color card = Color(0xFF221E2A); // lifted card surface
  static const Color glass = Color(0x22FFFFFF); // glassmorphism fill (13% white)

  // Text
  static const Color textPrimary = Color(0xFFF5F0F0); // warm white
  static const Color textSecondary = Color(0xFFAA9BAA); // muted lavender-grey

  // Accent / Indicators
  static const Color success = Color(0xFF6FEAB9); // mint green (for "perfect!")
  static const Color warning = Color(0xFFFFD166); // amber (for "almost there")
  static const Color danger = Color(0xFFFF6B6B); // soft red (for "off")

  // Shadows & Glows
  static final BoxShadow cardShadow = BoxShadow(
    color: const Color(0xFF000000).withOpacity(0.35),
    blurRadius: 24,
    offset: const Offset(0, 8),
  );

  static final BoxShadow glowShadow = BoxShadow(
    color: mauveRoseTaupe.withOpacity(0.30),
    blurRadius: 32,
    offset: const Offset(0, 4),
  );

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [mutedGold, burntOrange, dustyRose],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(1.0, 1.0),
    colors: [mutedGold, burntOrange, dustyRose],
  );
}
