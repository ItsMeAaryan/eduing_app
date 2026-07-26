import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart';
import '../../../core/widgets/floating_nav.dart';

class CopilotScreen extends StatelessWidget {
  const CopilotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {'icon': '📝', 'label': 'SOP Builder', 'sub': 'Draft & refine', 'color': NeoColors.purple, 'route': '/sop'},
      {'icon': '👤', 'label': 'Resume AI', 'sub': 'ATS optimized', 'color': NeoColors.blue, 'route': '/resume'},
      {'icon': '🎤', 'label': 'Mock Interview', 'sub': 'AI feedback', 'color': const Color(0xFF1C8A5E), 'route': '/interview'},
      {'icon': '📄', 'label': 'Vault Analysis', 'sub': 'Doc insights', 'color': NeoColors.yellow, 'route': '/vault'},
      {'icon': '🎓', 'label': 'Uni Recommender', 'sub': 'AI matched', 'color': const Color(0xFFFF6B35), 'route': '/recommend'},
      {'icon': '✍️', 'label': 'Essay Writer', 'sub': 'Personal stmt', 'color': const Color(0xFFFF3B7A), 'route': '/essay'},
    ];

    return Scaffold(
      backgroundColor: NeoColors.bgDark,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    const Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI STRATEGIST',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: NeoColors.green,
                              letterSpacing: 10 * 0.12,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Copilot',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Hero readiness card
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        NotchedCard(
                          bg: Colors.transparent, // Background handled by inner container
                          padding: EdgeInsets.zero,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [NeoColors.purple, NeoColors.blue],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'OVERALL READINESS',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white.withValues(alpha: 0.6),
                                    letterSpacing: 10 * 0.1,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  '82%',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -2,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'SOP, resume & interview ready',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                ProgressBar(value: 82, color: Colors.white.withValues(alpha: 0.9), height: 4),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Powered by Gemini AI',
                                      style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.4)),
                                    ),
                                    Text(
                                      '3 tasks left',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white.withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: FloatingActionBtn(
                            icon: '✦',
                            bg: NeoColors.green,
                            onClick: () {}, // Handled by outer wrapper or default
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // AI Chat shortcut
                    GestureDetector(
                      onTap: () => context.push('/copilot/chat'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: NeoColors.green.withValues(alpha: 0.09), // roughly 18 hex
                          border: Border.all(color: NeoColors.green.withValues(alpha: 0.26), width: 1.5), // roughly 44 hex
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: NeoColors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: const Text('✦', style: TextStyle(fontSize: 18, color: Colors.black)),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ask Copilot anything',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Chat with your AI admission expert',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: NeoColors.subDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Text('→', style: TextStyle(fontSize: 18, color: NeoColors.green)),
                          ],
                        ),
                      ),
                    ),

                    // Feature grid
                    const Text(
                      'AI TOOLS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: NeoColors.subDark,
                        letterSpacing: 10 * 0.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.95,
                      ),
                      itemCount: features.length,
                      itemBuilder: (context, index) {
                        final f = features[index];
                        final Color color = f['color'] as Color;
                        return GestureDetector(
                          onTap: () => context.push(f['route'] as String),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: NeoColors.surfDark,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: color.withValues(alpha: 0.13)), // roughly 22 hex
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.13),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Text(f['icon'] as String, style: const TextStyle(fontSize: 20)),
                                ),
                                Text(
                                  f['label'] as String,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  f['sub'] as String,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: NeoColors.subDark,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  height: 28,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.13),
                                    border: Border.all(color: color.withValues(alpha: 0.26)), // roughly 44 hex
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Open →',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),

                    // Insights
                    const Text(
                      'PERSONALIZED INSIGHTS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: NeoColors.subDark,
                        letterSpacing: 10 * 0.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: NeoColors.surfDark,
                        border: Border.all(color: NeoColors.borderDark),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          _InsightItem(icon: '⚡', text: 'SOP alignment for target programs is 88%', color: NeoColors.yellow),
                          SizedBox(height: 14),
                          _InsightItem(icon: '✅', text: 'Strong match: STEM Innovators Grant (94%)', color: NeoColors.green),
                          SizedBox(height: 14),
                          _InsightItem(icon: '⚠️', text: 'Interview prep incomplete — 3 sessions left', color: NeoColors.red),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: FloatingNav(
                activeId: 'ai',
                onChange: (id) {
                  if (id == 'home') context.go('/home');
                  if (id == 'discover') context.go('/discover');
                  if (id == 'apps') context.go('/applications');
                  if (id == 'ai') context.go('/copilot');
                  if (id == 'plan') context.go('/planner');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightItem extends StatelessWidget {
  final String icon;
  final String text;
  final Color color;

  const _InsightItem({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.09), // 18 hex
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(icon, style: const TextStyle(fontSize: 13)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white60,
                height: 1.45,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
