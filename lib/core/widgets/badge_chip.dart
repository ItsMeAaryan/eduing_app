import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BadgeChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color? bg;

  const BadgeChip({
    super.key,
    required this.label,
    this.color = AppColors.primaryAccent,
    this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bg ?? color.withValues(alpha: 0.13), // 22 hex = 13% opacity
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.26), // 44 hex = 26% opacity
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: 0.08 * 9, // 0.08em
            ),
          ),
        ],
      ),
    );
  }
}
