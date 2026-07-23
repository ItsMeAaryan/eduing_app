import 'package:flutter/material.dart';
import '../molecules/squircle_card.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';

class UniversityCard extends StatelessWidget {
  final String logoUrl;
  final String name;
  final String location;
  final String rank;

  const UniversityCard({
    super.key,
    required this.logoUrl,
    required this.name,
    required this.location,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final subtitleColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return SquircleCard(
      padding: const EdgeInsets.all(AppSpacing.p16),
      hasShadow: true,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(logoUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.p16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.titleMedium.copyWith(color: textColor),
                ),
                const SizedBox(height: AppSpacing.p4),
                Text(
                  location,
                  style: AppTypography.bodyMedium.copyWith(color: subtitleColor),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.p12, vertical: AppSpacing.p4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "#$rank",
              style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
