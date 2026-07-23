import 'package:flutter/material.dart';
import '../molecules/squircle_card.dart';
import '../atoms/status_pill.dart';
import '../atoms/progress_bar.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';

class PremiumApplicationCard extends StatelessWidget {
  final String logoUrl;
  final String universityName;
  final String course;
  final StatusType status;
  final String deadline;
  final double progress;
  final VoidCallback onTap;
  final VoidCallback onMenuTap;

  const PremiumApplicationCard({
    super.key,
    required this.logoUrl,
    required this.universityName,
    required this.course,
    required this.status,
    required this.deadline,
    required this.progress,
    required this.onTap,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return SquircleCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.p20),
      hasShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : AppColors.background,
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
                      universityName,
                      style: AppTypography.titleMedium.copyWith(color: textColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.p4),
                    Text(
                      course,
                      style: AppTypography.bodyMedium.copyWith(color: secondaryTextColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.p8),
                    StatusPill(type: status),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                color: secondaryTextColor,
                onPressed: onMenuTap,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.p24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deadline,
                    style: AppTypography.bodyMedium.copyWith(color: textColor, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Deadline",
                    style: AppTypography.labelMedium.copyWith(color: secondaryTextColor),
                  ),
                ],
              ),
              Text(
                "${(progress * 100).toInt()}%",
                style: AppTypography.titleMedium.copyWith(color: textColor),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.p8),
          ProgressBar(
            progress: progress,
            color: _getProgressColor(),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor() {
    switch (status) {
      case StatusType.accepted:
      case StatusType.completed:
        return AppColors.success;
      case StatusType.draft:
      case StatusType.underReview:
        return AppColors.warning;
      case StatusType.rejected:
        return AppColors.error;
      case StatusType.inProgress:
      case StatusType.submitted:
      case StatusType.visa:
        return AppColors.primary;
      case StatusType.notStarted:
        return AppColors.textSecondary;
    }
  }
}
