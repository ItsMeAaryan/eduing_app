import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../../core/theme/neo_design_system.dart' as neo show Badge;
import '../../../core/widgets/floating_nav.dart';
import '../providers/discover_provider.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(discoverProvider);
    final notifier = ref.read(discoverProvider.notifier);
    final unis = ref.watch(filteredUnisProvider);
    final filters = ['All', 'Engineering', 'Management', 'Medicine', 'Law', 'Arts'];

    return Scaffold(
      backgroundColor: NeoColors.bgDark,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 100), // padding for floating nav
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EXPLORE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: NeoColors.subDark,
                                letterSpacing: 10 * 0.12,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Discover',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: NeoColors.surfDark,
                            shape: BoxShape.circle,
                            border: Border.all(color: NeoColors.borderDark),
                          ),
                          alignment: Alignment.center,
                          child: const Text('🔖', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Search bar
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 46,
                            decoration: BoxDecoration(
                              color: NeoColors.surfDark,
                              border: Border.all(color: NeoColors.borderDark, width: 1.5),
                              borderRadius: BorderRadius.circular(23),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              children: [
                                const Text('🔍', style: TextStyle(fontSize: 15, color: NeoColors.subDark)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    onChanged: notifier.setQuery,
                                    style: const TextStyle(fontSize: 13, color: Colors.white),
                                    decoration: const InputDecoration(
                                      hintText: 'Search universities, programs...',
                                      hintStyle: TextStyle(color: NeoColors.subDark, fontSize: 13),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 46,
                          height: 46,
                          decoration: const BoxDecoration(
                            color: NeoColors.green,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text('⊟', style: TextStyle(fontSize: 16, color: Colors.black)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Filter chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: filters.map((f) {
                          final isSelected = state.filter == f;
                          return GestureDetector(
                            onTap: () => notifier.setFilter(f),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 32,
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: isSelected ? NeoColors.green : NeoColors.surfDark,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? NeoColors.green : NeoColors.borderDark,
                                  width: 1.5,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                f,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected ? Colors.black : Colors.white60,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Count + sort
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${unis.length} Universities',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const Row(
                          children: [
                            Text(
                              'Sort: Match',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: NeoColors.green,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              '↓',
                              style: TextStyle(
                                fontSize: 10,
                                color: NeoColors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // University cards
                    ...unis.map((u) {
                      final isSaved = state.savedIds.contains(u.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: NotchedCard(
                          bg: NeoColors.surfDark,
                          notchPos: 'br',
                          notchSize: 44, // Match size of action bg
                          padding: EdgeInsets.zero,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: u.color.withValues(alpha: 0.09), // 18 hex
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: u.color.withValues(alpha: 0.2)), // 33 hex
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text('🏛', style: TextStyle(fontSize: 22)),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  u.name,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              neo.Badge(label: u.rank, color: u.color),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '📍 ${u.loc}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: NeoColors.subDark,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ProgressBar(value: u.match.toDouble(), color: u.color, height: 4),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${u.match}%',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w900,
                                                  color: u.color,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Text('💰', style: TextStyle(fontSize: 10, color: NeoColors.subDark)),
                                              const SizedBox(width: 4),
                                              Text(u.fees, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white60)),
                                              const SizedBox(width: 10),
                                              const Text('💺', style: TextStyle(fontSize: 10, color: NeoColors.subDark)),
                                              const SizedBox(width: 4),
                                              Text('${u.seats} seats', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white60)),
                                              const Spacer(),
                                              GestureDetector(
                                                onTap: () => notifier.toggleSaved(u.id),
                                                child: Text(
                                                  '🔖',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: isSaved ? Colors.white : Colors.white.withValues(alpha: 0.4), // Simulated grayscale
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 44), // space for FAB
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: -10,
                                right: -10,
                                child: FloatingActionBtn(
                                  icon: '→',
                                  bg: u.color,
                                  onClick: () => context.push('/university/${u.id}'),
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
                activeId: 'discover',
                onChange: (id) {
                  if (id == 'home') context.go('/home');
                  if (id == 'discover') context.go('/discover');
                  if (id == 'apps') context.go('/applications');
                  if (id == 'ai') context.go('/copilot');
                  if (id == 'plan') context.go('/planner'); // Note: planner not yet in exact list but leaving logic
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
