import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/spacing/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadow.dart';

class FloatingBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navColor = isDark
        ? AppColors.darkSurface.withOpacity(0.8)
        : AppColors.surface.withOpacity(0.85);

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.p24, vertical: AppSpacing.p16),
        decoration: BoxDecoration(
          borderRadius: AppRadius.b100,
          boxShadow: AppShadow.float(context),
        ),
        child: ClipRRect(
          borderRadius: AppRadius.b100,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.p16, vertical: AppSpacing.p12),
              color: navColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_filled,
                    label: "Home",
                    isActive: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _NavItem(
                    icon: Icons.account_balance_outlined,
                    activeIcon: Icons.account_balance,
                    label: "Universities",
                    isActive: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  _NavItem(
                    icon: Icons.article_outlined,
                    activeIcon: Icons.article,
                    label: "Applications",
                    isActive: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),
                  _NavItem(
                    icon: Icons.star_border_outlined,
                    activeIcon: Icons.star,
                    label: "Scholarships",
                    isActive: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                  _NavItem(
                    icon: Icons.calendar_month_outlined,
                    activeIcon: Icons.calendar_month,
                    label: "Planner",
                    isActive: currentIndex == 4,
                    onTap: () => onTap(4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const activeColor = AppColors.primary;
    final inactiveColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final activeBg = isDark
        ? AppColors.primary.withOpacity(0.2)
        : AppColors.primary.withOpacity(0.1);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.p16, vertical: AppSpacing.p8),
        decoration: BoxDecoration(
          color: isActive ? activeBg : Colors.transparent,
          borderRadius: AppRadius.b100,
        ),
        child: Row(
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? activeColor : inactiveColor,
              size: 24,
            ),
            if (isActive) ...[
              const SizedBox(width: AppSpacing.p8),
              Text(
                label,
                style: const TextStyle(
                  color: activeColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
