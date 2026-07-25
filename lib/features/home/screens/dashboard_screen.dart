import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/floating_nav.dart';
import '../../../core/widgets/notched_card.dart';
import '../../../core/widgets/badge_chip.dart';
import '../../../core/widgets/glow_progress_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _nav = 'home';

  void _onNavChange(String id) {
    setState(() => _nav = id);
    // Usually here we'd also context.go to the respective route if this was a shell route
    // but the request implies DashboardScreen uses FloatingNav internally.
    switch (id) {
      case 'uni':
        context.push('/universities');
        break;
      case 'apps':
        context.push('/applications');
        break;
      case 'ai':
        context.push('/copilot');
        break;
      case 'plan':
        context.push('/planner');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 90), // 90px bottom padding for floating nav
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── HEADER ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'GOOD MORNING',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppColors.text30,
                                letterSpacing: 10 * 0.12,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Aaryan Sharma 👋',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppColors.text,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Bell
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                border: Border.all(color: AppColors.border),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Stack(
                                children: [
                                  const Icon(Icons.notifications_none, color: AppColors.text, size: 20),
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryAccent,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppColors.background, width: 2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Avatar
                            GestureDetector(
                              onTap: () => context.push('/profile'),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [AppColors.purple, AppColors.blue],
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.26), width: 2),
                                ),
                                alignment: Alignment.center,
                                child: const Text('👤', style: TextStyle(fontSize: 18)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── READINESS HERO CARD ──
                    NotchedCard(
                      bg: Colors.transparent, // We will use a Container inside for gradient, or we can just apply gradient manually. Actually let's use a custom child container to fake the bg gradient
                      notchColor: AppColors.background,
                      actionIcon: const Text('→'),
                      actionBg: AppColors.primaryAccent,
                      actionColor: AppColors.background,
                      padding: EdgeInsets.zero,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.purple, AppColors.blue],
                          ),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BadgeChip(
                              label: 'ADMISSION READINESS',
                              color: AppColors.text,
                              bg: Color(0x26FFFFFF), // rgba(255,255,255,0.15)
                            ),
                            SizedBox(height: 10),
                            Text(
                              '85%',
                              style: TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.w900,
                                color: AppColors.text,
                                letterSpacing: -2,
                                height: 1,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '4 tasks left · Fall 2027 admissions',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xA6FFFFFF), // rgba(255,255,255,0.65)
                              ),
                            ),
                            SizedBox(height: 14),
                            GlowProgressBar(value: 85, color: AppColors.text, height: 4),
                            SizedBox(height: 8),
                            Text(
                              'Next: Upload IELTS Score',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0x80FFFFFF), // rgba(255,255,255,0.5)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── STATS ROW ──
                    const Row(
                      children: [
                        _StatCard(label: 'Universities', value: '18', delta: '↑ +3', color: AppColors.primaryAccent),
                        SizedBox(width: 10),
                        _StatCard(label: 'Applications', value: '5', delta: '2 active', color: AppColors.blue),
                        SizedBox(width: 10),
                        _StatCard(label: 'Offers', value: '2', delta: '↑ new', color: AppColors.orange),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // ── ACTIVE APPLICATION ──
                    const Text(
                      'ACTIVE APPLICATION',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text30,
                        letterSpacing: 10 * 0.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    NotchedCard(
                      bg: AppColors.surface,
                      notchColor: AppColors.background,
                      actionIcon: const Text('→'),
                      actionBg: AppColors.blue,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.blue.withValues(alpha: 0.13), // 22 hex
                                  border: Border.all(color: AppColors.blue.withValues(alpha: 0.26)), // 44 hex
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: const Text('🏛', style: TextStyle(fontSize: 20)),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'BITS Pilani',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.text,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    Text(
                                      'B.Tech CSE · Pilani Campus',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.text60,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const BadgeChip(label: 'IN PROGRESS', color: AppColors.blue),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const GlowProgressBar(value: 91, color: AppColors.primaryAccent, height: 5),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Deadline: Aug 30, 2025', style: TextStyle(fontSize: 11, color: AppColors.text30)),
                              Text('91%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.primaryAccent)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── QUICK ACTIONS ──
                    const Text(
                      'QUICK ACTIONS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text30,
                        letterSpacing: 10 * 0.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _QuickAction(label: 'SOP Builder', icon: '📝', color: AppColors.purple, route: '/sop'),
                        _QuickAction(label: 'Doc Vault', icon: '🔐', color: AppColors.blue, route: '/vault'),
                        _QuickAction(label: 'Interview', icon: '🎤', color: Color(0xFF1C8A5E)),
                        _QuickAction(label: 'AI Copilot', icon: '✦', color: AppColors.primaryAccent, route: '/copilot/chat'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── UPCOMING TIMELINE ──
                    const Text(
                      'UPCOMING DEADLINES',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text30,
                        letterSpacing: 10 * 0.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Column(
                      children: [
                        _TimelineItem(title: 'Passport Upload', tag: 'REQUIRED', date: 'Tomorrow', color: AppColors.red),
                        _TimelineItem(title: 'BITS Application', tag: 'IN 2 DAYS', date: '22 Jul 2025', color: AppColors.yellow),
                        _TimelineItem(title: 'Interview Round', tag: 'IN 5 DAYS', date: '25 Jul 2025', color: AppColors.blue),
                        _TimelineItem(title: 'Stanford Application', tag: 'DEADLINE', date: '27 Jul 2025', color: AppColors.orange),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── SCHOLARSHIPS ──
                    const Text(
                      'SCHOLARSHIPS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text30,
                        letterSpacing: 10 * 0.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Expanded(
                          child: NotchedCard(
                            bg: AppColors.surface,
                            notchColor: AppColors.background,
                            actionIcon: Text('→'),
                            actionBg: AppColors.primaryAccent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('MATCH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primaryAccent, letterSpacing: 10 * 0.06)),
                                SizedBox(height: 6),
                                Text('94%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.text)),
                                SizedBox(height: 4),
                                Text('STEM Innovators Grant', style: TextStyle(fontSize: 11, color: AppColors.text60, height: 1.3)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: NotchedCard(
                            bg: AppColors.surface,
                            notchColor: AppColors.background,
                            actionIcon: Text('→'),
                            actionBg: AppColors.purple,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('MATCH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.purple, letterSpacing: 10 * 0.06)),
                                SizedBox(height: 6),
                                Text('87%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.text)),
                                SizedBox(height: 4),
                                Text('Merit Excellence Fund', style: TextStyle(fontSize: 11, color: AppColors.text60, height: 1.3)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            FloatingNav(activeId: _nav, onChange: _onNavChange),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  final String label;
  final String value;
  final String delta;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.delta,
    required this.color,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: widget.color.withValues(alpha: 0.2)), // 33 hex
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.09), // 18 hex
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text30,
                    letterSpacing: 9 * 0.08,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  widget.value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                BadgeChip(label: widget.delta, color: widget.color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String label;
  final String icon;
  final Color color;
  final String? route;

  const _QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: route != null ? () => context.push(route!) : null,
      child: Container(
        height: 36,
        padding: const EdgeInsets.only(left: 12, right: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.09), // 18 hex approx
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.26), width: 1.5), // 44 hex approx
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String tag;
  final String date;
  final Color color;

  const _TimelineItem({
    required this.title,
    required this.tag,
    required this.date,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.13)), // 22 hex
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(color: color.withValues(alpha: 0.53), blurRadius: 8) // 88 hex
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.text30,
                    ),
                  ),
                ],
              ),
            ],
          ),
          BadgeChip(label: tag, color: color),
        ],
      ),
    );
  }
}
