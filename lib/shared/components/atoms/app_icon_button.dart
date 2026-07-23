import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_radius.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/app_duration.dart';

class AppIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isFilled;
  final bool isSmall;
  final Color? color;
  final Color? backgroundColor;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.isFilled = false,
    this.isSmall = false,
    this.color,
    this.backgroundColor,
  });

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = widget.onPressed == null;
    
    final defaultIconColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final defaultBgColor = isDark ? AppColors.darkSurface : AppColors.background;

    final iconColor = isDisabled 
        ? (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)
        : (widget.color ?? (widget.isFilled ? Colors.white : defaultIconColor));
        
    final bgColor = widget.isFilled
        ? (isDisabled ? (isDark ? AppColors.darkBorder : AppColors.border) : (widget.backgroundColor ?? AppColors.primary))
        : (_isHovered ? defaultBgColor : Colors.transparent);

    final size = widget.isSmall ? 32.0 : 40.0;
    final iconSize = widget.isSmall ? 18.0 : 22.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: AppDuration.fast,
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: AppRadius.b100, // Circular squircle / capsule
          ),
          child: Icon(
            widget.icon,
            size: iconSize,
            color: iconColor,
          ),
        ),
      ).animate(target: _isPressed ? 1 : 0).scale(
        end: const Offset(0.90, 0.90),
        duration: AppDuration.fast,
      ),
    );
  }
}
