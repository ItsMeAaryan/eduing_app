import 'package:flutter/material.dart';
import 'colors/app_colors.dart';

class AppShadow {
  static List<BoxShadow> soft(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: isDark
            ? Colors.black.withValues(alpha: 0.3)
            : AppColors.primary.withValues(alpha: 0.04),
        blurRadius: 16,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: isDark
            ? Colors.black.withValues(alpha: 0.2)
            : AppColors.primary.withValues(alpha: 0.02),
        blurRadius: 4,
        offset: const Offset(0, 2),
        spreadRadius: 0,
      ),
    ];
  }

  static List<BoxShadow> medium(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: isDark
            ? Colors.black.withValues(alpha: 0.4)
            : AppColors.primary.withValues(alpha: 0.08),
        blurRadius: 24,
        offset: const Offset(0, 8),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: isDark
            ? Colors.black.withValues(alpha: 0.2)
            : AppColors.primary.withValues(alpha: 0.04),
        blurRadius: 8,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
    ];
  }

  static List<BoxShadow> float(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: isDark
            ? Colors.black.withValues(alpha: 0.5)
            : AppColors.primary.withValues(alpha: 0.12),
        blurRadius: 32,
        offset: const Offset(0, 16),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: isDark
            ? Colors.black.withValues(alpha: 0.3)
            : AppColors.primary.withValues(alpha: 0.06),
        blurRadius: 12,
        offset: const Offset(0, 6),
        spreadRadius: 0,
      ),
    ];
  }
}
