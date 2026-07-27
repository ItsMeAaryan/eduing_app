import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/floating_nav.dart';
import '../../../core/widgets/notched_card.dart';
import '../../../core/widgets/badge_chip.dart';
import '../../../core/widgets/glow_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_provider.dart';
import '../../notifications/providers/notifications_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

String _getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  if (hour < 21) return 'Good evening';
  return 'Good night';
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _nav = 'home';

  void _onNavChange(String id) {
    setState(() => _nav = id);
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
    final userData = ref.watch(userDataProvider).value ?? {};
    final appCounts = ref.watch(applicationsCountProvider).value ??
        {'total': 0, 'active': 0, 'offers': 0};
    final uniCount = ref.watch(universitiesCountProvider).value ?? 0;
    final activeAppsAsync = ref.watch(activeApplicationsProvider);
    final tasks = ref.watch(upcomingTasksProvider).value ?? [];
    final unreadCount = ref.watch(unreadCountProvider).value ?? 0;

    final displayName = userData['displayName'] ?? 'Student';
    final readinessScore =
        ((userData['aiProfile']?['readinessScore'] ?? 0) as num).toDouble();
    final profileCompletion =
        ((userData['profileCompletion'] ?? 0) as num).toDouble();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    18, 10, 18, MediaQuery.of(context).padding.bottom + 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── HEADER ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_getGreeting()},',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white54,
                              ),
                            ),
                            Text(
                              '$displayName 👋',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Bell with unread badge
                            GestureDetector(
                              onTap: () => context.push('/notifications'),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  border: Border.all(color: AppColors.border),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    const Icon(Icons.notifications_none,
                                        color: AppColors.text, size: 20),
                                    if (unreadCount > 0)
                                      Positioned(
                                        top: -2,
                                        right: -2,
                                        child: Container(
                                          width: unreadCount > 9 ? 16 : 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryAccent,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: AppColors.background,
                                                width: 1.5),
                                          ),
                                          alignment: Alignment.center,
                                          child: unreadCount > 9
                                              ? const Text('9+',
                                                  style: TextStyle(
                                                      fontSize: 7,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Colors.black))
                                              : null,
                                        ),
                                      ),
                                  ],
                                ),
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
                                  border: Border.all(
                                      color: AppColors.primaryAccent
                                          .withValues(alpha: 0.26),
                                      width: 2),
                                ),
                                alignment: Alignment.center,
                                child: const Text('👤',
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── READINESS HERO CARD ──
                    NotchedCard(
                      bg: Colors.transparent,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BadgeChip(
                              label: 'ADMISSION READINESS',
                              color: AppColors.text,
                              bg: Color(0x26FFFFFF),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${readinessScore.toInt()}%',
                              style: const TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.w900,
                                color: AppColors.text,
                                letterSpacing: -2,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(appCounts['active'] ?? 0)} active app${(appCounts['active'] ?? 0) == 1 ? '' : 's'} · Fall 2027 admissions',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xA6FFFFFF),
                              ),
                            ),
                            const SizedBox(height: 14),
                            GlowProgressBar(
                                value: readinessScore,
                                color: AppColors.text,
                                height: 4),
                            const SizedBox(height: 8),
                            Text(
                              profileCompletion < 100
                                  ? 'Next: Complete your profile (${profileCompletion.toInt()}%)'
                                  : 'Profile complete ✓',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0x80FFFFFF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── STATS ROW ──
                    Row(
                      children: [
                        _StatCard(
                            label: 'Universities',
                            value: uniCount.toString(),
                            delta: 'Available',
                            color: AppColors.primaryAccent),
                        const SizedBox(width: 10),
                        _StatCard(
                            label: 'Applications',
                            value: (appCounts['total'] ?? 0).toString(),
                            delta:
                                '${appCounts['active'] ?? 0} active',
                            color: AppColors.blue),
                        const SizedBox(width: 10),
                        _StatCard(
                            label: 'Offers',
                            value: (appCounts['offers'] ?? 0).toString(),
                            delta: (appCounts['offers'] ?? 0) > 0
                                ? '🎉 New!'
                                : 'Pending',
                            color: AppColors.orange),
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
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    activeAppsAsync.when(
                      data: (apps) {
                        if (apps.isEmpty) {
                          return GestureDetector(
                            onTap: () => context.push('/universities'),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColors.primaryAccent
                                        .withValues(alpha: 0.2)),
                              ),
                              child: const Column(
                                children: [
                                  Text('🏛',
                                      style: TextStyle(fontSize: 32)),
                                  SizedBox(height: 8),
                                  Text('No active applications yet',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700)),
                                  SizedBox(height: 4),
                                  Text('Browse universities to get started →',
                                      style: TextStyle(
                                          color: AppColors.primaryAccent,
                                          fontSize: 13)),
                                ],
                              ),
                            ),
                          );
                        }
                        final app = apps.first;
                        final deadline =
                            (app['deadline'] as Timestamp?)?.toDate();
                        final progress =
                            ((app['progress'] ?? 0) as num).toDouble();
                        return NotchedCard(
                          bg: AppColors.surface,
                          notchColor: AppColors.background,
                          actionIcon: const Text('→'),
                          actionBg: AppColors.blue,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: AppColors.blue
                                          .withValues(alpha: 0.13),
                                      border: Border.all(
                                          color: AppColors.blue
                                              .withValues(alpha: 0.26)),
                                      borderRadius:
                                          BorderRadius.circular(14),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text('🏛',
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (app['universityName'] as String?)
                                                  ?.isNotEmpty ==
                                              true
                                              ? app['universityName']
                                              : 'Unknown University',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.text,
                                            letterSpacing: -0.3,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          (app['courseName'] as String?)
                                                  ?.isNotEmpty ==
                                              true
                                              ? app['courseName']
                                              : 'Course unspecified',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.text60,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  BadgeChip(
                                    label: ((app['status'] as String?) ??
                                            'draft')
                                        .replaceAll('_', ' ')
                                        .toUpperCase(),
                                    color: AppColors.blue,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              GlowProgressBar(
                                  value: progress,
                                  color: AppColors.primaryAccent,
                                  height: 5),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    deadline != null
                                        ? 'Deadline: ${deadline.day}/${deadline.month}/${deadline.year}'
                                        : 'No deadline set',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.text30),
                                  ),
                                  Text(
                                    '${progress.toInt()}%',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.primaryAccent),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      loading: () => const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primaryAccent)),
                      error: (err, stack) => _ErrorTile(
                          message: 'Could not load applications.',
                          onRetry: () =>
                              ref.invalidate(activeApplicationsProvider)),
                    ),
                    const SizedBox(height: 14),

                    // ── QUICK ACTIONS ──
                    const Text(
                      'QUICK ACTIONS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text30,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _QuickAction(
                            label: 'SOP Builder',
                            icon: '📝',
                            color: AppColors.purple,
                            route: '/sop'),
                        _QuickAction(
                            label: 'Doc Vault',
                            icon: '🔐',
                            color: AppColors.blue,
                            route: '/vault'),
                        _QuickAction(
                            label: 'Interview',
                            icon: '🎤',
                            color: Color(0xFF1C8A5E)),
                        _QuickAction(
                            label: 'AI Copilot',
                            icon: '✦',
                            color: AppColors.primaryAccent,
                            route: '/copilot/chat'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── UPCOMING DEADLINES / TASKS ──
                    const Text(
                      'UPCOMING DEADLINES',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text30,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (tasks.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Text(
                          'No upcoming deadlines. You\'re all caught up! 🎉',
                          style:
                              TextStyle(color: Colors.white54, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      Column(
                        children: tasks.map((task) {
                          final dueDate =
                              (task['dueDate'] as Timestamp?)?.toDate();
                          final dueDateStr = dueDate != null
                              ? '${dueDate.day}/${dueDate.month}/${dueDate.year}'
                              : 'No date';
                          final now = DateTime.now();
                          final daysLeft = dueDate != null
                              ? dueDate.difference(now).inDays
                              : 99;
                          final color = daysLeft <= 1
                              ? AppColors.red
                              : daysLeft <= 3
                                  ? AppColors.yellow
                                  : AppColors.blue;
                          final tag = daysLeft <= 0
                              ? 'TODAY'
                              : daysLeft == 1
                                  ? 'TOMORROW'
                                  : 'IN $daysLeft DAYS';
                          return _TimelineItem(
                            title: task['title'] ?? 'Task',
                            tag: tag,
                            date: dueDateStr,
                            color: color,
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 16),

                    // ── SCHOLARSHIPS (static UI, future Firestore) ──
                    const Text(
                      'SCHOLARSHIPS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text30,
                        letterSpacing: 1.0,
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
                                Text('MATCH',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primaryAccent,
                                        letterSpacing: 0.6)),
                                SizedBox(height: 6),
                                Text('94%',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.text)),
                                SizedBox(height: 4),
                                Text('STEM Innovators Grant',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.text60,
                                        height: 1.3)),
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
                                Text('MATCH',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.purple,
                                        letterSpacing: 0.6)),
                                SizedBox(height: 6),
                                Text('87%',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.text)),
                                SizedBox(height: 4),
                                Text('Merit Excellence Fund',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.text60,
                                        height: 1.3)),
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

// ── Supporting widgets ──────────────────────────────────────────────────────

class _ErrorTile extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const _ErrorTile({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.red, size: 20),
          const SizedBox(width: 10),
          Expanded(
              child: Text(message,
                  style:
                      const TextStyle(color: Colors.white70, fontSize: 13))),
          if (onRetry != null)
            GestureDetector(
              onTap: onRetry,
              child: const Text('Retry',
                  style: TextStyle(
                      color: AppColors.primaryAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
            ),
        ],
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
            padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: widget.color.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.09),
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
                    letterSpacing: 0.72,
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
          color: color.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: color.withValues(alpha: 0.26), width: 1.5),
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
        border: Border.all(color: color.withValues(alpha: 0.13)),
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
                    BoxShadow(
                        color: color.withValues(alpha: 0.53),
                        blurRadius: 8)
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
