import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/app_radius.dart';

class ShimmerBlock extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  const ShimmerBlock({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final baseColor = isDark ? AppColors.darkSurface : AppColors.border;
    final highlightColor = isDark ? AppColors.darkBorder : AppColors.background;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: shape == BoxShape.circle ? null : (borderRadius ?? AppRadius.b12),
          shape: shape,
        ),
      ),
    );
  }
}
