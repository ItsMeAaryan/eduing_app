import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/widgets/green_button.dart';
import '../providers/auth_provider.dart';

class _Option {
  final String emoji;
  final String label;
  const _Option(this.emoji, this.label);
}

const _options = [
  _Option('🔍', 'Google Search'),
  _Option('📱', 'Instagram'),
  _Option('🐦', 'Twitter / X'),
  _Option('👥', 'Friend or Family'),
  _Option('🎓', 'School / Teacher'),
  _Option('▶️', 'YouTube'),
  _Option('💼', 'LinkedIn'),
  _Option('📰', 'News / Blog'),
  _Option('📋', 'JEE/NEET Forum'),
  _Option('📦', 'App / Play Store'),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final Set<String> _selected = {};
  bool _loading = false;

  void _toggle(String label) {
    setState(() {
      if (_selected.contains(label)) {
        _selected.remove(label);
      } else {
        _selected.add(label);
      }
    });
  }

  Future<void> _continue() async {
    setState(() => _loading = true);

    try {
      // Save referral source to Firestore if any selected
      if (_selected.isNotEmpty) {
        final user = ref.read(authRepositoryProvider).currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'referral_source': _selected.toList()});
        }
      }

      // Mark onboarding complete
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);

      if (mounted) context.go('/home');
    } catch (_) {
      // Non-critical — continue even if Firestore write fails
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
      if (mounted) context.go('/home');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Progress bar ──
            Container(
              height: 3,
              width: double.infinity,
              color: const Color(0xFF1A1A1A),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 1.0,
                child: Container(color: const Color(0xFF3DFF54)),
              ),
            ),

            // ── Scrollable content ──
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Skip button
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: GestureDetector(
                          onTap: _continue,
                          child: const Text(
                            'Skip for now',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white38,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Headline
                    const SizedBox(height: 8),
                    const Text(
                      'How did you\nhear about us?',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.8,
                        height: 1.15,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This helps us improve EDUING for students like you.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white54,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Options grid ──
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2.8,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: _options.map((opt) {
                        final isSelected = _selected.contains(opt.label);
                        return GestureDetector(
                          onTap: () => _toggle(opt.label),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF3DFF54).withValues(alpha: 0.12)
                                  : const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF3DFF54)
                                    : const Color(0xFF2A2A2A),
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  opt.emoji,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    opt.label,
                                    style: TextStyle(
                                      color: isSelected
                                          ? const Color(0xFF3DFF54)
                                          : Colors.white70,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF3DFF54),
                                    size: 16,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 200.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Bottom button ──
            Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, bottom + 24),
              child: GreenButton(
                label: 'Continue →',
                loading: _loading,
                onClick: _continue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
