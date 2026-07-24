import 'package:flutter/material.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../core/theme/app_duration.dart';

class AppTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const AppTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fillColor = isDark ? AppColors.darkSurface : AppColors.background;
    final hintColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final iconColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: AppTypography.labelMedium.copyWith(color: textColor),
          ),
          const SizedBox(height: AppSpacing.p8),
        ],
        AnimatedContainer(
          duration: AppDuration.fast,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: AppTypography.bodyLarge.copyWith(color: textColor),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTypography.bodyLarge.copyWith(color: hintColor),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: iconColor, size: 20)
                  : null,
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: fillColor,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.p20, vertical: AppSpacing.p16),
              border: OutlineInputBorder(
                borderRadius: AppRadius.b16,
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.b16,
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: AppRadius.b16,
                borderSide:
                    const BorderSide(color: AppColors.error, width: 1.5),
              ),
              errorText: errorText,
            ),
          ),
        ),
      ],
    );
  }
}
