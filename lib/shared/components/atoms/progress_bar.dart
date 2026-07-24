import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_duration.dart';

class ProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color? color;
  final Color? backgroundColor;
  final double height;
  final bool animated;

  const ProgressBar({
    super.key,
    required this.progress,
    this.color,
    this.backgroundColor,
    this.height = 6.0,
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final clampedProgress = progress.clamp(0.0, 1.0);

    final activeColor = color ?? AppColors.primary;
    final bgColor =
        backgroundColor ?? (isDark ? AppColors.darkSurface : AppColors.border);

    Widget bar = LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: height,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: AppRadius.b100, // Capsule
              ),
            ),
            AnimatedContainer(
              duration: AppDuration.normal,
              curve: Curves.easeOutCubic,
              height: height,
              width: constraints.maxWidth * clampedProgress,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: AppRadius.b100,
              ),
            ),
          ],
        );
      },
    );

    if (animated) {
      return bar.animate().fade(duration: AppDuration.fast);
    }
    return bar;
  }
}
