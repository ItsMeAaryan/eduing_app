import 'package:flutter/material.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing/app_spacing.dart';

class AppChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const AppChip({
    super.key,
    required this.label,
    this.icon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isSelected 
        ? AppColors.primary
        : (isDark ? AppColors.darkSurface : AppColors.background);
        
    final textColor = isSelected
        ? Colors.white
        : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary);
        
    final borderColor = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.darkBorder : AppColors.border);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p16, vertical: AppSpacing.p8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppRadius.b100, // Capsule shape
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: textColor),
              const SizedBox(width: AppSpacing.p8),
            ],
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
