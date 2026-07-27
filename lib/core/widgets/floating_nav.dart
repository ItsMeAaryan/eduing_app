import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FloatingNav extends StatelessWidget {
  final String activeId;
  final ValueChanged<String> onChange;

  const FloatingNav({
    super.key,
    required this.activeId,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      {'id': 'home', 'icon': '⊞', 'label': 'Home'},
      {'id': 'uni', 'icon': '🏛', 'label': 'Discover'},
      {'id': 'apps', 'icon': '📋', 'label': 'Apply'},
      {'id': 'ai', 'icon': '✦', 'label': 'Copilot'},
      {'id': 'plan', 'icon': '📅', 'label': 'Planner'},
    ];

    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 16,
      left: 16,
      right: 16,
      height: 62,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xF21A1A1A), // rgba(26,26,26,0.95)
          borderRadius: BorderRadius.circular(31),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x99000000), // rgba(0,0,0,0.6)
              blurRadius: 32,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(31),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: tabs.map((tab) {
                final isOn = tab['id'] == activeId;
                return GestureDetector(
                  onTap: () => onChange(tab['id'] as String),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    constraints: const BoxConstraints(minWidth: 44),
                    decoration: BoxDecoration(
                      color: isOn ? const Color(0x1F3DFF54) : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tab['icon'] as String,
                          style: TextStyle(
                            fontSize: isOn ? 18 : 15,
                            color: isOn ? Colors.white : Colors.white.withValues(alpha: 0.4), // approx grayscale/opacity
                          ),
                        ),
                        if (isOn) ...[
                          const SizedBox(height: 2),
                          Text(
                            tab['label'] as String,
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryAccent,
                              letterSpacing: 0.04 * 8, // 0.04em
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
