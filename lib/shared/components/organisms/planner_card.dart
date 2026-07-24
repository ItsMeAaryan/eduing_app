import 'package:flutter/material.dart';
import '../molecules/squircle_card.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';

class PlannerCard extends StatelessWidget {
  final String title;
  final String date;
  final String type;

  const PlannerCard({
    super.key,
    required this.title,
    required this.date,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return SquircleCard(
      padding: const EdgeInsets.all(AppSpacing.p16),
      hasShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type,
                style: AppTypography.labelMedium
                    .copyWith(color: AppColors.primary),
              ),
              Icon(Icons.calendar_today_outlined,
                  size: 16, color: secondaryTextColor),
            ],
          ),
          const SizedBox(height: AppSpacing.p12),
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(color: textColor),
          ),
          const SizedBox(height: AppSpacing.p8),
          Text(
            date,
            style: AppTypography.bodyMedium.copyWith(color: secondaryTextColor),
          ),
        ],
      ),
    );
  }
}
