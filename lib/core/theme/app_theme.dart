import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

/// MuseCam AI Theme Configuration
class MuseAppTheme {
  MuseAppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Primary color scheme
      primaryColor: MuseColors.mauveRoseTaupe,
      scaffoldBackgroundColor: MuseColors.dark,
      
      // Color scheme
      colorScheme: ColorScheme.dark(
        primary: MuseColors.mauveRoseTaupe,
        secondary: MuseColors.dustyRose,
        surface: MuseColors.surface,
        background: MuseColors.dark,
        error: MuseColors.danger,
        onPrimary: MuseColors.textPrimary,
        onSecondary: MuseColors.textPrimary,
        onSurface: MuseColors.textPrimary,
        onBackground: MuseColors.textPrimary,
        onError: MuseColors.dark,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: MuseColors.dark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: MuseTypography.displaySm,
        iconTheme: const IconThemeData(color: MuseColors.textPrimary),
      ),

      // Text Themes
      textTheme: TextTheme(
        displayLarge: MuseTypography.displayXL,
        displayMedium: MuseTypography.displayLg,
        displaySmall: MuseTypography.displayMd,
        headlineSmall: MuseTypography.displaySm,
        bodyLarge: MuseTypography.bodyLg,
        bodyMedium: MuseTypography.bodyMd,
        bodySmall: MuseTypography.bodySm,
        labelLarge: MuseTypography.labelLg,
        labelMedium: MuseTypography.labelMd,
        labelSmall: MuseTypography.labelSm,
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MuseColors.mauveRoseTaupe,
          foregroundColor: MuseColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: MuseTypography.labelLg,
          elevation: 0,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MuseColors.mauveRoseTaupe,
          textStyle: MuseTypography.labelLg,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: MuseColors.mauveRoseTaupe,
          side: const BorderSide(color: MuseColors.mauveRoseTaupe),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          textStyle: MuseTypography.labelLg,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        fillColor: MuseColors.surface,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: MuseColors.surface),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: MuseColors.surface),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: MuseColors.primary, width: 2),
        ),
        labelStyle: MuseTypography.bodyMdSecondary,
        hintStyle: MuseTypography.bodyMdSecondary,
      ),

      // Bottom Navigation Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: MuseColors.surface.withOpacity(0.8),
        selectedItemColor: MuseColors.primary,
        unselectedItemColor: MuseColors.textSecondary,
        selectedLabelStyle: MuseTypography.labelSm,
        unselectedLabelStyle: MuseTypography.labelSm,
        elevation: 0,
      ),
    );
  }
}
