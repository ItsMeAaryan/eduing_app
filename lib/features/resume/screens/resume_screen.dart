import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart';

class ResumeScreen extends StatelessWidget {
  const ResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const int atsScore = 78;
    final sections = [
      {'icon': '👤', 'label': 'Personal Info', 'done': true, 'color': NeoColors.green},
      {'icon': '📚', 'label': 'Education', 'done': true, 'color': NeoColors.green},
      {'icon': '💼', 'label': 'Experience', 'done': false, 'color': NeoColors.yellow},
      {'icon': '🔧', 'label': 'Skills', 'done': true, 'color': NeoColors.green},
      {'icon': '🏆', 'label': 'Achievements', 'done': false, 'color': const Color(0xFFFF6B35)}, // orange
      {'icon': '📋', 'label': 'Projects', 'done': false, 'color': NeoColors.blue},
      {'icon': '🌐', 'label': 'Links & Socials', 'done': false, 'color': NeoColors.purple},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'RESUME BUILDER',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  GreenBtn(label: 'Export', small: true, onClick: () {}),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ATS Score hero
                    NotchedCard(
                      bg: Colors.transparent, // Background via inner container
                      padding: EdgeInsets.zero,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [NeoColors.blue, NeoColors.purple],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ATS SCORE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white.withValues(alpha: 0.5),
                                    letterSpacing: 10 * 0.1,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  '$atsScore',
                                  style: TextStyle(
                                    fontSize: 52,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -2,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Good — 3 improvements suggested',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                ProgressBar(value: atsScore.toDouble(), color: Colors.white.withValues(alpha: 0.9), height: 4),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    ['Keywords', '82%', Colors.white],
                                    ['Format', '90%', Colors.white],
                                    ['Length', '65%', const Color(0xFFFFD700)],
                                  ].map((m) {
                                    final l = m[0] as String;
                                    final v = m[1] as String;
                                    final c = m[2] as Color;
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text('$l: $v', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: c)),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: -10,
                            right: -10,
                            child: FloatingActionBtn(
                              icon: '✦',
                              bg: NeoColors.green,
                              onClick: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // AI suggestions
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: NeoColors.surfDark,
                        border: Border.all(color: NeoColors.yellow.withValues(alpha: 0.13)), // 22 hex approx
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'AI IMPROVEMENTS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: NeoColors.yellow,
                              letterSpacing: 10 * 0.08,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...[
                            "Add 3 more relevant keywords: 'machine learning', 'Python', 'data structures'",
                            "Expand your Projects section — ATS rewards detailed descriptions",
                            "Add quantified achievements: 'Led team of 5', 'Improved X by 40%'",
                          ].asMap().entries.map((e) {
                            final i = e.key;
                            final tip = e.value;
                            return Padding(
                              padding: EdgeInsets.only(bottom: i < 2 ? 10 : 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    margin: const EdgeInsets.only(top: 1),
                                    decoration: BoxDecoration(
                                      color: NeoColors.yellow.withValues(alpha: 0.13),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text('⚡', style: TextStyle(fontSize: 10)),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      tip,
                                      style: const TextStyle(fontSize: 12, color: Colors.white60, height: 1.45),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Resume sections
                    const Text(
                      'RESUME SECTIONS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: NeoColors.subDark,
                        letterSpacing: 10 * 0.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...sections.map((s) {
                      final isDone = s['done'] as bool;
                      final c = s['color'] as Color;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: NeoColors.surfDark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isDone ? c.withValues(alpha: 0.13) : NeoColors.borderDark),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: c.withValues(alpha: 0.09), // 18 hex
                                border: Border.all(color: c.withValues(alpha: 0.2)), // 33 hex
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: Text(s['icon'] as String, style: const TextStyle(fontSize: 18)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s['label'] as String,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    isDone ? 'Completed' : 'Not filled',
                                    style: TextStyle(fontSize: 11, color: isDone ? NeoColors.green : NeoColors.subDark),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: isDone ? NeoColors.green.withValues(alpha: 0.13) : NeoColors.surfDark2,
                                border: Border.all(
                                  color: isDone ? NeoColors.green : NeoColors.borderDark,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                isDone ? '✓' : '+',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDone ? NeoColors.green : NeoColors.subDark,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    
                    // Template picker
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 12),
                      child: Text(
                        'TEMPLATES',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: NeoColors.subDark,
                          letterSpacing: 10 * 0.1,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        {'name': 'Minimal', 'color': Colors.white},
                        {'name': 'Bold', 'color': NeoColors.green},
                        {'name': 'Classic', 'color': NeoColors.blue},
                      ].asMap().entries.map((e) {
                        final i = e.key;
                        final t = e.value;
                        final c = t['color'] as Color;
                        final isActive = i == 1; // Bold selected in design
                        return Expanded(
                          child: Container(
                            height: 60,
                            margin: EdgeInsets.only(right: i < 2 ? 10 : 0),
                            decoration: BoxDecoration(
                              color: NeoColors.surfDark,
                              border: Border.all(
                                color: isActive ? NeoColors.green : NeoColors.borderDark,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 24,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: c.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 16,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: c.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  t['name'] as String,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: isActive ? NeoColors.green : NeoColors.subDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
