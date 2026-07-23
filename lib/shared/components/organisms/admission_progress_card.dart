import 'package:flutter/material.dart';

import '../molecules/squircle_card.dart';
import '../molecules/metric_item.dart';
import '../atoms/app_button.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';

class AdmissionProgressCard extends StatelessWidget {
  final int readinessPercentage;
  final int applicationsCount;
  final int documentsCount;
  final VoidCallback onImproveWithAI;

  const AdmissionProgressCard({
    super.key,
    required this.readinessPercentage,
    required this.applicationsCount,
    required this.documentsCount,
    required this.onImproveWithAI,
  });

  @override
  Widget build(BuildContext context) {
    return SquircleCard(
      color: AppColors.primary,
      hasShadow: true,
      padding: const EdgeInsets.all(AppSpacing.p24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your Admission Progress",
                style: AppTypography.titleMedium.copyWith(color: Colors.white),
              ),
              const Icon(Icons.school_outlined, color: Colors.white, size: 28),
            ],
          ),
          const SizedBox(height: AppSpacing.p24),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Overall Readiness",
                      style: AppTypography.labelMedium.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: AppSpacing.p4),
                    Text(
                      "$readinessPercentage%",
                      style: AppTypography.display.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: AppSpacing.p16),
                    AppButton(
                      text: "Improve with AI",
                      icon: Icons.auto_awesome,
                      variant: AppButtonVariant.secondary,
                      size: AppButtonSize.small,
                      onPressed: onImproveWithAI,
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 100,
                color: Colors.white24,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.p24),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MetricItem(
                      label: "Applications",
                      value: applicationsCount.toString(),
                      labelColor: Colors.white70,
                      valueColor: Colors.white,
                    ),
                    const SizedBox(height: AppSpacing.p16),
                    MetricItem(
                      label: "Documents",
                      value: documentsCount.toString(),
                      labelColor: Colors.white70,
                      valueColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
