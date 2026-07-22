import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF4353FF);
  static const Color primaryDark = Color(0xFF3342CC);
  static const Color secondary = Color(0xFF10C675);
  static const Color background = Color(0xFFF8F9FB);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0E0F14);
  static const Color darkSurface = Color(0xFF161820);
  static const Color darkTextPrimary = Color(0xFFE2E8F0);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  
  // Semantic Colors
  static const Color success = Color(0xFF10C675);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4353FF), Color(0xFF6B78FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient aiGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF4353FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
