import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../../core/theme/neo_design_system.dart' as neo show Badge;
import '../../../core/widgets/floating_nav.dart';
import '../providers/applications_list_provider.dart';

class ApplicationsScreen extends ConsumerWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(applicationsListProvider);
    final notifier = ref.read(applicationsListProvider.notifier);
    final currentApps = ref.watch(currentAppsProvider);
    
    final totalApps = state.apps.length;
    final activeApps = state.apps.where((a) => a.type == 'active').length;
    final offersApps = state.apps.where((a) => a.type == 'offers').length;

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
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'MY',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: NeoColors.subDark,
                              letterSpacing: 10 * 0.12,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Applications',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.push('/applications/new'),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: NeoColors.green,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text('+', style: TextStyle(fontSize: 18, color: Colors.black)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Stats row
                    Row(
                      children: [
                        _StatBox(label: 'TOTAL', value: totalApps.toString(), color: Colors.white),
                        const SizedBox(width: 10),
                        _StatBox(label: 'ACTIVE', value: activeApps.toString(), color: NeoColors.green),
                        const SizedBox(width: 10),
                        _StatBox(label: 'OFFERS', value: offersApps.toString(), color: NeoColors.yellow),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Tab switcher
                    Container(
                      decoration: BoxDecoration(
                        color: NeoColors.surfDark,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.only(bottom: 18),
                      child: Row(
                        children: [
                          _TabItem(
                            id: 'active',
                            label: 'Active',
                            current: state.currentTab,
                            onTap: () => notifier.setTab('active'),
                            activeColor: NeoColors.green,
                          ),
                          const SizedBox(width: 6),
                          _TabItem(
                            id: 'offers',
                            label: 'Offers',
                            current: state.currentTab,
                            onTap: () => notifier.setTab('offers'),
                            activeColor: NeoColors.yellow,
                          ),
                          const SizedBox(width: 6),
                          _TabItem(
                            id: 'withdrawn',
                            label: 'Past',
                            current: state.currentTab,
                            onTap: () => notifier.setTab('withdrawn'),
                            activeColor: NeoColors.surf2Dark,
                          ),
                        ],
                      ),
                    ),

                    // Cards or empty state
                    if (currentApps.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Text('📋', style: TextStyle(fontSize: 48)),
                            SizedBox(height: 12),
                            Text(
                              'No applications here',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...currentApps.map((a) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: NotchedCard(
                            bg: NeoColors.surfDark,
                            notchPos: 'br',
                            notchSize: 44,
                            padding: const EdgeInsets.all(16),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: a.color.withValues(alpha: 0.09), // 18 hex approx
                                            borderRadius: BorderRadius.circular(14),
                                            border: Border.all(color: a.color.withValues(alpha: 0.2)), // 33 hex approx
                                          ),
                                          alignment: Alignment.center,
                                          child: const Text('🏛', style: TextStyle(fontSize: 20)),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                a.name,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                  letterSpacing: -0.3,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                a.course,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white60,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        neo.Badge(label: a.status, color: a.color),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    ProgressBar(value: a.progress.toDouble(), color: a.color, height: 4),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '📅 ${a.deadline}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: NeoColors.subDark,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 36), // Avoid FAB overlap
                                          child: Text(
                                            '${a.progress}%',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w900,
                                              color: a.color,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom: -26,
                                  right: -26,
                                  child: FloatingActionBtn(
                                    icon: a.status == 'OFFER' ? '✓' : '→',
                                    bg: a.color,
                                    onClick: () => context.push('/application/${a.id}'),
                                  ),
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
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: FloatingNav(
                activeId: 'apps',
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

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: NeoColors.surfDark,
          border: Border.all(color: NeoColors.borderDark),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: NeoColors.subDark,
                letterSpacing: 9 * 0.08,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String id;
  final String label;
  final String current;
  final VoidCallback onTap;
  final Color activeColor;

  const _TabItem({
    required this.id,
    required this.label,
    required this.current,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = current == id;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 34,
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(17),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isActive ? ((id == 'offers' || id == 'withdrawn') ? Colors.white : Colors.black) : NeoColors.subDark,
            ),
          ),
        ),
      ),
    );
  }
}
