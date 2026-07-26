import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import '../../core/theme/neo_design_system.dart';
import 'sync_indicator.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: NeoThemeData.of(context).bg,
      body: Stack(
        children: [
          Column(
            children: [
              const SyncIndicator(),
              Expanded(child: child),
            ],
          ),
          const Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: FloatingBottomNav(),
          ),
        ],
      ),
    );
  }
}

class FloatingBottomNav extends StatelessWidget {
  const FloatingBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final t = NeoThemeData.of(context);
    final dark = t.isDark;

    String active = "home";
    if (location.startsWith('/discover')) active = "discover";
    if (location.startsWith('/applications')) active = "apps";
    if (location.startsWith('/copilot')) active = "ai";
    if (location.startsWith('/planner')) active = "plan";

    final tabs = [
      {"id": "home", "icon": "⊞", "label": "Home", "route": "/"},
      {"id": "discover", "icon": "🏛", "label": "Discover", "route": "/discover"},
      {"id": "apps", "icon": "📋", "label": "Apply", "route": "/applications"},
      {"id": "ai", "icon": "✦", "label": "Copilot", "route": "/copilot"},
      {"id": "plan", "icon": "📅", "label": "Planner", "route": "/planner"},
    ];

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: dark ? const Color(0xEB1C1C1F) : const Color(0xEBFFFFFF),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
        ),
        boxShadow: dark
            ? [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5), blurRadius: 32, offset: const Offset(0, 8)),
                BoxShadow(
                    color: Colors.white.withValues(alpha: 0.04), blurRadius: 0, spreadRadius: 1),
              ]
            : [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12), blurRadius: 32, offset: const Offset(0, 8)),
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04), blurRadius: 0, spreadRadius: 1),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: tabs.map((tab) {
                final isActive = tab["id"] == active;
                return GestureDetector(
                  onTap: () => context.go(tab["route"]!),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    constraints: const BoxConstraints(minWidth: 40),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? (dark
                              ? NeoColors.purple.withValues(alpha: 0.2)
                              : NeoColors.purple.withValues(alpha: 0.12))
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tab["icon"]!,
                          style: TextStyle(
                            fontSize: isActive ? 18 : 16,
                            color: isActive ? (dark ? Colors.white : Colors.black) : t.sub,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            tab["label"]!,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: isActive ? NeoColors.purple : t.sub,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
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
