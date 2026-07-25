import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/green_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<int> _selected = [];

  final List<Map<String, dynamic>> _options = [
    {'icon': '🏛', 'label': 'Find universities', 'color': const Color(0xFF3DFF54)},
    {'icon': '📋', 'label': 'Track applications', 'color': const Color(0xFFFF6B35)},
    {'icon': '🎓', 'label': 'Get scholarships', 'color': const Color(0xFFFF3B7A)},
    {'icon': '📝', 'label': 'Write SOPs', 'color': const Color(0xFF3B5BFF)},
    {'icon': '🎤', 'label': 'Interview prep', 'color': const Color(0xFFF5A623)},
    {'icon': '📄', 'label': 'Manage documents', 'color': const Color(0xFF34C759)},
    {'icon': '🔮', 'label': 'AI guidance', 'color': const Color(0xFFC084FC)},
    {'icon': '📅', 'label': 'Plan deadlines', 'color': const Color(0xFFFF6B35)},
  ];

  void _toggle(int i) {
    setState(() {
      if (_selected.contains(i)) {
        _selected.remove(i);
      } else {
        _selected.add(i);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 3,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: AppColors.primaryAccent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.8,
                          height: 1.15,
                          fontFamily: 'Inter',
                        ),
                        children: [
                          TextSpan(text: 'How will you\n', style: TextStyle(color: AppColors.text)),
                          TextSpan(text: 'use ', style: TextStyle(color: AppColors.text)),
                          TextSpan(text: 'EDUING?', style: TextStyle(color: AppColors.primaryAccent)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Select all that apply.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.text60,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(_options.length, (i) {
                      final o = _options[i];
                      final on = _selected.contains(i);
                      final color = o['color'] as Color;

                      return GestureDetector(
                        onTap: () => _toggle(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 44,
                          padding: const EdgeInsets.only(left: 14, right: 16),
                          decoration: BoxDecoration(
                            color: on ? color.withValues(alpha: 0.13) : AppColors.surface, // roughly 22 hex
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: on ? color : AppColors.border,
                              width: 1.5,
                            ),
                            boxShadow: on
                                ? [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.2), // roughly 33 hex
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                o['icon'] as String,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                o['label'] as String,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: on ? color : AppColors.text60,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: GreenButton(
                  label: 'Continue to home →',
                  disabled: _selected.isEmpty,
                  onClick: () => context.go('/home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
