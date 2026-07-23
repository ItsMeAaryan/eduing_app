import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF8B5CF6); // Modern EDUing Purple
  static const Color primaryDark = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFFA78BFA);
  
  static const Color background = Color(0xFFF8F9FB); // Light Mode bg
  static const Color surface = Colors.white; // Light Mode surface
  static const Color textPrimary = Color(0xFF111827); // Very dark gray/black
  static const Color textSecondary = Color(0xFF6B7280); // Gray
  static const Color border = Color(0xFFE5E7EB);
  
  // Legacy
  static const Color secondary = Color(0xFF10C675);
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF111827); // Dark Mode bg
  static const Color darkSurface = Color(0xFF1F2937); // Dark Mode surface
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkBorder = Color(0xFF374151);
  
  // Semantic Colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color successBg = Color(0xFFD1FAE5);
  static const Color error = Color(0xFFEF4444); // Red
  static const Color errorBg = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFF59E0B); // Orange
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF3B82F6); // Blue
  static const Color infoBg = Color(0xFFDBEAFE);

  static const Color darkSuccessBg = Color(0xFF064E3B);
  static const Color darkErrorBg = Color(0xFF7F1D1D);
  static const Color darkWarningBg = Color(0xFF78350F);
  static const Color darkInfoBg = Color(0xFF1E3A8A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient aiGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
