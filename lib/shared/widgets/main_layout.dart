import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:ui';
import '../../core/theme/colors/app_colors.dart';

import 'sync_indicator.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Column(
        children: [
          const SyncIndicator(),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: const FloatingBottomNav(),
    );
  }
}

class FloatingBottomNav extends StatelessWidget {
  const FloatingBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;
    if (location.startsWith('/universities')) currentIndex = 1;
    if (location.startsWith('/applications')) currentIndex = 2;
    if (location.startsWith('/ai')) currentIndex = 3;
    if (location.startsWith('/planner')) currentIndex = 4;
    if (location.startsWith('/profile')) currentIndex = 5;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(
                  icon: Iconsax.home,
                  label: 'Home',
                  isSelected: currentIndex == 0,
                  onTap: () => context.go('/'),
                ),
                _NavItem(
                  icon: Iconsax.building,
                  label: 'Universities',
                  isSelected: currentIndex == 1,
                  onTap: () => context.go('/universities'),
                ),
                _NavItem(
                  icon: Iconsax.document,
                  label: 'Applications',
                  isSelected: currentIndex == 2,
                  onTap: () => context.go('/applications'),
                ),
                _NavItem(
                  icon: Iconsax.magic_star,
                  label: 'AI Copilot',
                  isSelected: currentIndex == 3,
                  onTap: () => context.go('/ai'),
                ),
                _NavItem(
                  icon: Iconsax.calendar_1,
                  label: 'Planner',
                  isSelected: currentIndex == 4,
                  onTap: () => context.go('/planner'),
                ),
                _NavItem(
                  icon: Iconsax.profile_circle,
                  label: 'Profile',
                  isSelected: currentIndex == 5,
                  onTap: () => context.go('/profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 12,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.textSecondary,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
