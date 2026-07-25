import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryAccent,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryAccent,
        surface: AppColors.surface,
        error: AppColors.red,
        onPrimary: AppColors.background,
        onSurface: AppColors.text,
        onError: AppColors.text,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          color: AppColors.text,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.5,
        ),
        displayMedium: baseTextTheme.displayMedium?.copyWith(
          color: AppColors.text,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.0,
        ),
        displaySmall: baseTextTheme.displaySmall?.copyWith(
          color: AppColors.text,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          color: AppColors.text,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          color: AppColors.text,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(
          color: AppColors.text,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          color: AppColors.text,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          color: AppColors.text,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
        titleSmall: baseTextTheme.titleSmall?.copyWith(
          color: AppColors.text,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: AppColors.text,
          letterSpacing: 0,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: AppColors.text,
          letterSpacing: 0,
        ),
        bodySmall: baseTextTheme.bodySmall?.copyWith(
          color: AppColors.text,
          letterSpacing: 0,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith( // All uppercase labels
          color: AppColors.text,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
        labelMedium: baseTextTheme.labelMedium?.copyWith(
          color: AppColors.text,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
        ),
        labelSmall: baseTextTheme.labelSmall?.copyWith(
          color: AppColors.text,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.text),
      ),
    );
  }
}
