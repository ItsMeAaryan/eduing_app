import 'package:flutter/material.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing/app_spacing.dart';

enum StatusType {
  notStarted,
  inProgress,
  draft,
  submitted,
  underReview,
  accepted,
  rejected,
  visa,
  completed
}

class StatusPill extends StatelessWidget {
  final StatusType type;
  final String? customText;

  const StatusPill({
    super.key,
    required this.type,
    this.customText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor;
    Color textColor;
    String label = customText ?? _getDefaultLabel();

    switch (type) {
      case StatusType.accepted:
      case StatusType.completed:
        bgColor = isDark ? AppColors.darkSuccessBg : AppColors.successBg;
        textColor = AppColors.success;
        break;
      case StatusType.rejected:
        bgColor = isDark ? AppColors.darkErrorBg : AppColors.errorBg;
        textColor = AppColors.error;
        break;
      case StatusType.inProgress:
      case StatusType.submitted:
      case StatusType.visa:
        bgColor = isDark ? AppColors.darkInfoBg : AppColors.infoBg;
        textColor = AppColors.info;
        break;
      case StatusType.draft:
      case StatusType.underReview:
        bgColor = isDark ? AppColors.darkWarningBg : AppColors.warningBg;
        textColor = AppColors.warning;
        break;
      case StatusType.notStarted:
        bgColor = isDark ? AppColors.darkSurface : AppColors.background;
        textColor =
            isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.p12, vertical: AppSpacing.p4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.b100, // Capsule
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getDefaultLabel() {
    switch (type) {
      case StatusType.notStarted:
        return "Not Started";
      case StatusType.inProgress:
        return "In Progress";
      case StatusType.draft:
        return "Draft";
      case StatusType.submitted:
        return "Submitted";
      case StatusType.underReview:
        return "Under Review";
      case StatusType.accepted:
        return "Accepted";
      case StatusType.rejected:
        return "Rejected";
      case StatusType.visa:
        return "Visa";
      case StatusType.completed:
        return "Completed";
    }
  }
}
