import 'package:flutter/material.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';

class MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? labelColor;
  final Color? valueColor;
  final IconData? icon;
  final String? trend;
  final bool isPositiveTrend;

  const MetricItem({
    super.key,
    required this.label,
    required this.value,
    this.labelColor,
    this.valueColor,
    this.icon,
    this.trend,
    this.isPositiveTrend = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: labelColor ?? (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.p8),
        ],
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
        if (trend != null) ...[
          const SizedBox(height: AppSpacing.p4),
          Row(
            children: [
              Icon(
                isPositiveTrend ? Icons.arrow_upward : Icons.arrow_downward,
                size: 12,
                color: isPositiveTrend ? AppColors.success : AppColors.error,
              ),
              const SizedBox(width: 4),
              Text(
                trend!,
                style: AppTypography.caption.copyWith(
                  color: isPositiveTrend ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
