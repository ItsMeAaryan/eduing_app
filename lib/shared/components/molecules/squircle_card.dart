import 'package:flutter/material.dart';
import 'package:figma_squircle/figma_squircle.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/app_shadow.dart';

class SquircleCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double cornerRadius;
  final bool hasShadow;
  final VoidCallback? onTap;

  const SquircleCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.cornerRadius = 24.0,
    this.hasShadow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? AppColors.darkSurface : AppColors.surface;

    Widget card = Container(
      padding: padding,
      decoration: ShapeDecoration(
        color: color ?? defaultColor,
        shadows: hasShadow ? AppShadow.soft(context) : null,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: cornerRadius,
            cornerSmoothing: 1.0,
          ),
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: card,
        ),
      );
    }

    return card;
  }
}
