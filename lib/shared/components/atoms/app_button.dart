import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';

import '../../../core/theme/app_duration.dart';

enum AppButtonVariant { primary, secondary, outline, text, ghost }
enum AppButtonSize { small, medium, large }

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? customIcon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.customIcon,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: isDisabled ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: AppDuration.fast,
          width: widget.isFullWidth ? double.infinity : null,
          padding: _getPadding(),
          decoration: _getDecoration(isDisabled),
          child: Row(
            mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading) ...[
                SizedBox(
                  width: _getIconSize(),
                  height: _getIconSize(),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(_getTextColor(isDisabled)),
                  ),
                ),
                const SizedBox(width: AppSpacing.p8),
              ] else if (widget.customIcon != null || widget.icon != null) ...[
                widget.customIcon ??
                    Icon(
                      widget.icon,
                      size: _getIconSize(),
                      color: _getTextColor(isDisabled),
                    ),
                const SizedBox(width: AppSpacing.p8),
              ],
              Text(
                widget.text,
                style: AppTypography.button.copyWith(
                  color: _getTextColor(isDisabled),
                  fontSize: _getFontSize(),
                ),
              ),
            ],
          ),
        ),
      ).animate(target: _isPressed ? 1 : 0).scale(
        end: const Offset(0.96, 0.96),
        duration: AppDuration.fast,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.p16, vertical: AppSpacing.p8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.p24, vertical: AppSpacing.p12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: AppSpacing.p32, vertical: AppSpacing.p16);
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case AppButtonSize.small:
        return 14;
      case AppButtonSize.medium:
        return 16;
      case AppButtonSize.large:
        return 18;
    }
  }

  BoxDecoration _getDecoration(bool isDisabled) {
    Color bgColor;
    Color? borderColor;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    switch (widget.variant) {
      case AppButtonVariant.primary:
        bgColor = isDisabled
            ? (isDark ? AppColors.darkBorder : AppColors.border)
            : (_isHovered ? AppColors.primaryDark : AppColors.primary);
        break;
      case AppButtonVariant.secondary:
        bgColor = isDisabled
            ? (isDark ? AppColors.darkBorder : AppColors.border)
            : (_isHovered ? AppColors.darkSurface : AppColors.textPrimary);
        break;
      case AppButtonVariant.outline:
        bgColor = Colors.transparent;
        borderColor = isDisabled
            ? (isDark ? AppColors.darkBorder : AppColors.border)
            : (_isHovered ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.border));
        break;
      case AppButtonVariant.text:
      case AppButtonVariant.ghost:
        bgColor = _isHovered
            ? (isDark ? AppColors.darkSurface : AppColors.background)
            : Colors.transparent;
        break;
    }

    return BoxDecoration(
      color: bgColor,
      borderRadius: AppRadius.b100, // Capsule shape
      border: borderColor != null ? Border.all(color: borderColor, width: 1.5) : null,
    );
  }

  Color _getTextColor(bool isDisabled) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (isDisabled) {
      return isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    }
    
    switch (widget.variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.secondary:
        return Colors.white;
      case AppButtonVariant.outline:
      case AppButtonVariant.text:
      case AppButtonVariant.ghost:
        return isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    }
  }
}
