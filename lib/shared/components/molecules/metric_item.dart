import 'package:flutter/material.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';

class MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? labelColor;
  final Color? valueColor;

  const MetricItem({
    super.key,
    required this.label,
    required this.value,
    this.labelColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: labelColor ?? (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: AppSpacing.p4),
        Text(
          value,
          style: AppTypography.titleLarge.copyWith(
            color: valueColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
