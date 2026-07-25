import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlowProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final double height;
  final BorderRadiusGeometry? borderRadius;

  const GlowProgressBar({
    super.key,
    required this.value,
    this.color = AppColors.primaryAccent,
    this.height = 4.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(height / 2);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: effectiveRadius,
      ),
      alignment: Alignment.centerLeft,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            height: height,
            width: constraints.maxWidth * (value / 100).clamp(0.0, 1.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: effectiveRadius,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 8,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
