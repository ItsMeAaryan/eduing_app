import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GhostButton extends StatelessWidget {
  final String label;
  final String? icon;
  final VoidCallback? onClick;

  const GhostButton({
    super.key,
    required this.label,
    this.icon,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0x14FFFFFF), // white10 (0.08 alpha * 255 = 20 approx, 0x14 = 20)
          borderRadius: BorderRadius.circular(25),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Text(
                    icon!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
