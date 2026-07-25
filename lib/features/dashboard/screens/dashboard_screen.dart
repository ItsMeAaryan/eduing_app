import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart';
import '../providers/dashboard_provider.dart';


class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = NeoThemeData.of(context);
    final user = ref.watch(userProfileProvider);
    final stats = ref.watch(dashboardStatsProvider);
    final deadlines = ref.watch(upcomingDeadlinesProvider);
    final applications = ref.watch(recentApplicationsProvider);

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120), // padded for floating nav
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "GOOD MORNING",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: t.muted,
                          letterSpacing: 0.6,
                        ),
                      ),
                      Text(
                        "${user.name} 👋",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: t.text,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [NeoColors.purple, NeoColors.blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          image: user.avatarUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(user.avatarUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: user.avatarUrl.isEmpty
                            ? const Text("👤", style: TextStyle(fontSize: 18))
                            : null,
                      ),
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: NeoColors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: t.bg, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Readiness hero card
              NotchedCard(
                bg: NeoColors.purple,
                notchPos: "br",
                notchSize: 56,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Badge(
                      label: "ADMISSION READINESS",
                      color: Colors.white,
                      bg: Colors.white.withValues(alpha: 0.15),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${stats.profileStrength.toInt()}%",
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -2,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "4 tasks left · Fall 2027",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ProgressBar(
                      value: stats.profileStrength,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              // Floating Yellow arrow
              Transform.translate(
                offset: const Offset(0, -32),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FloatingActionBtn(
                      icon: "→",
                      bg: NeoColors.yellow,
                      size: 52,
                      onClick: () {},
                    ),
                  ),
                ),
              ),
              const SizedBox(height: -10),

              // Stats Row
              Row(
                children: [
                  const Expanded(
                    child: StatChip(
                      label: "Universities",
                      value: "18",
                      delta: "↑ +3",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatChip(
                      label: "Applications",
                      value: stats.applications.toString(),
                      delta: "2 active",
                      accent: NeoColors.blue,
                      accentBg: NeoColors.blueBlock,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Active Application
              if (applications.isNotEmpty) ...[
                Text(
                  "ACTIVE APPLICATION",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: t.muted,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),
                SCard(
                  padding: const EdgeInsets.all(16),
                  onClick: () => context.push('/applications'),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                applications.first.university,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: t.text,
                                ),
                              ),
                              Text(
                                applications.first.campus,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: t.sub,
                                ),
                              ),
                            ],
                          ),
                          const Badge(
                            label: "IN PROGRESS",
                            color: NeoColors.blue,
                            bg: NeoColors.blueBlock,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const ProgressBar(value: 91, color: NeoColors.purple),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Deadline: Aug 30",
                            style: TextStyle(fontSize: 11, color: t.muted),
                          ),
                          const Text(
                            "91%",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: NeoColors.purple,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Quick Actions
              Text(
                "QUICK ACTIONS",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: t.muted,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  PillBtn(label: "SOP Builder", icon: "📝", bg: NeoColors.purple, size: "sm", onClick: () => context.push('/sop')),
                  PillBtn(label: "Vault", icon: "🔐", bg: NeoColors.blue, size: "sm", onClick: () => context.push('/documents')),
                  PillBtn(label: "Interview", icon: "🎤", bg: const Color(0xFF1C8A5E), size: "sm", onClick: () => context.push('/interview')),
                  PillBtn(label: "Planner", icon: "📅", bg: const Color(0xFFB45309), size: "sm", onClick: () => context.push('/planner')),
                ],
              ),
              const SizedBox(height: 16),

              // Timeline
              Text(
                "UPCOMING",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: t.muted,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              ...deadlines.take(2).map((d) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                d.task,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: t.text,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Tomorrow", // Or format d.date
                                style: TextStyle(
                                  fontSize: 11,
                                  color: t.sub,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Badge(
                          label: d.priority == 'REQUIRED' ? "REQUIRED" : "IN 2 DAYS",
                          color: d.priority == 'REQUIRED' ? NeoColors.red : NeoColors.yellow,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
