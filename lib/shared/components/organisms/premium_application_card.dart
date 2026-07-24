import 'package:flutter/material.dart';

import '../molecules/squircle_card.dart';
import '../atoms/status_pill.dart';
import '../atoms/progress_bar.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../core/theme/app_duration.dart';

class PremiumApplicationCard extends StatefulWidget {
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
  State<PremiumApplicationCard> createState() => _PremiumApplicationCardState();
}

class _PremiumApplicationCardState extends State<PremiumApplicationCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final scale = _isPressed ? 0.98 : (_isHovered ? 1.01 : 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: scale,
          duration: AppDuration.fast,
          curve: Curves.easeOutCubic,
          child: Stack(
            children: [
              // Main Card Body
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 12),
                child: SquircleCard(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.p24,
                    left: AppSpacing.p48, // Space for the overlapping logo
                    right: AppSpacing.p24,
                    bottom: AppSpacing.p24,
                  ),
                  hasShadow: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.universityName,
                                  style: AppTypography.titleLarge.copyWith(
                                    color: textColor,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppSpacing.p4),
                                Text(
                                  widget.course,
                                  style: AppTypography.bodyMedium
                                      .copyWith(color: secondaryTextColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_horiz),
                            color: secondaryTextColor,
                            onPressed: widget.onMenuTap,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.p32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Deadline",
                                style: AppTypography.labelMedium
                                    .copyWith(color: secondaryTextColor),
                              ),
                              const SizedBox(height: AppSpacing.p4),
                              Text(
                                widget.deadline,
                                style: AppTypography.titleMedium.copyWith(
                                    color: textColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            "${(widget.progress * 100).toInt()}%",
                            style: AppTypography.titleMedium.copyWith(
                                color: textColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.p12),
                      ProgressBar(
                        progress: widget.progress,
                        color: _getProgressColor(),
                      ),
                    ],
                  ),
                ),
              ),

              // Floating Interlocking Logo
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : Colors.white,
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(widget.logoUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Floating Status Pill
              Positioned(
                top: 8,
                right: -8, // Slight overflow for dynamic feel
                child: StatusPill(type: widget.status),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getProgressColor() {
    switch (widget.status) {
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
