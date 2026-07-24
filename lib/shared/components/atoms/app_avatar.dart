import 'package:flutter/material.dart';
import 'package:figma_squircle/figma_squircle.dart';
import '../../../core/theme/colors/app_colors.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final bool isSquircle;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 48,
    this.isSquircle = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.background;
    final fallbackColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    Widget content;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      content = Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallback(fallbackColor),
      );
    } else {
      content = _buildFallback(fallbackColor);
    }

    if (isSquircle) {
      return Container(
        width: size,
        height: size,
        decoration: ShapeDecoration(
          color: bgColor,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: size * 0.35,
              cornerSmoothing: 1.0,
            ),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: content,
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: content,
    );
  }

  Widget _buildFallback(Color color) {
    if (name != null && name!.isNotEmpty) {
      return Center(
        child: Text(
          name!.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.4,
          ),
        ),
      );
    }
    return Center(
      child: Icon(
        Icons.person,
        color: color,
        size: size * 0.5,
      ),
    );
  }
}
