import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../atoms/app_icon_button.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../core/theme/app_duration.dart';

class QuickActionTile extends StatefulWidget {
  final String label;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const QuickActionTile({
    super.key,
    required this.label,
    this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  State<QuickActionTile> createState() => _QuickActionTileState();
}

class _QuickActionTileState extends State<QuickActionTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final hoverBgColor = isDark ? AppColors.darkSurface : AppColors.background;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppDuration.fast,
          padding: const EdgeInsets.all(AppSpacing.p12),
          decoration: BoxDecoration(
            color: _isHovered ? hoverBgColor : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIconButton(
                icon: widget.icon,
                isFilled: true,
                backgroundColor: isDark ? AppColors.darkBorder : AppColors.surface,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
              const SizedBox(height: AppSpacing.p8),
              Text(
                widget.label,
                style: AppTypography.labelMedium.copyWith(color: textColor),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: AppSpacing.p4),
                Text(
                  widget.subtitle!,
                  style: AppTypography.caption.copyWith(color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ],
            ],
          ),
        ),
      ).animate(target: _isHovered ? 1 : 0).scale(
        end: const Offset(1.05, 1.05),
        duration: AppDuration.fast,
      ),
    );
  }
}
