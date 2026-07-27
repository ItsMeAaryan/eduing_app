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
    final unis = ref.watch(filteredUniversitiesProvider);
    final allAsync = ref.watch(allUniversitiesProvider);
    final filters = [
      'All',
      'Engineering',
      'Management',
      'Medicine',
      'Law',
      'Arts'
    ];
    final selectedFilter = ref.watch(filterCategoryProvider);
    final savedIds = ref.watch(savedUniversityIdsProvider);

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
                    // ── Header ──
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
                                letterSpacing: 1.2,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: NeoColors.green.withValues(alpha: 0.1),
                            border: Border.all(
                                color: NeoColors.green.withValues(alpha: 0.3)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: allAsync.when(
                            data: (all) => Text(
                              '${unis.length} Universities',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            loading: () => const Text('... Universities',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white54)),
                            error: (_, __) => const Text('Universities',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white54)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Search ──
                    Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: NeoColors.surfDark,
                        border: Border.all(color: NeoColors.borderDark),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 14),
                          const Icon(Icons.search,
                              color: NeoColors.subDark, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              onChanged: (v) => ref
                                  .read(searchQueryProvider.notifier)
                                  .set(v),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: 'Search universities...',
                                hintStyle: TextStyle(
                                    color: NeoColors.subDark, fontSize: 14),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Filters ──
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: filters.map((f) {
                          final isSelected = selectedFilter == f;
                          return GestureDetector(
                            onTap: () => ref
                                .read(filterCategoryProvider.notifier)
                                .set(f),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 32,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? NeoColors.surfDark2
                                    : NeoColors.surfDark,
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.white
                                      : NeoColors.borderDark,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                f,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white60,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── University list ──
                    allAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(
                          child: CircularProgressIndicator(
                              color: NeoColors.green),
                        ),
                      ),
                      error: (e, _) => Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(Icons.wifi_off,
                                  color: Colors.white30, size: 40),
                              const SizedBox(height: 12),
                              const Text('Could not load universities',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () =>
                                    ref.invalidate(allUniversitiesProvider),
                                child: const Text('Tap to retry',
                                    style: TextStyle(
                                        color: NeoColors.green,
                                        fontSize: 13)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      data: (_) {
                        if (unis.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Center(
                              child: Column(
                                children: [
                                  const Text('🔍',
                                      style: TextStyle(fontSize: 40)),
                                  const SizedBox(height: 16),
                                  const Text('No universities found',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No universities match your filters.\nCheck back soon as we add more.',
                                    style: TextStyle(
                                        color: Colors.white
                                            .withValues(alpha: 0.6),
                                        fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: unis.map((u) {
                            final id = u['id'] as String? ?? '';
                            final name = u['name'] as String? ?? 'Unknown';
                            final city = u['location']?['city'] as String? ?? '';
                            final state =
                                u['location']?['state'] as String? ?? '';
                            final loc = [city, state]
                                .where((s) => s.isNotEmpty)
                                .join(', ');
                            final nirf = u['rankings']?['nirfOverall'];
                            final rank = nirf != null
                                ? 'NIRF #$nirf'
                                : 'Unranked';
                            final type =
                                u['type'] as String? ?? 'University';
                            final fees = u['feesPerYear'] != null
                                ? '₹${((u['feesPerYear'] as num) / 100000).toStringAsFixed(1)}L/yr'
                                : '-';
                            final seats = u['totalSeats'] ?? 0;
                            final isSaved = savedIds.contains(id);

                            // Color cycling based on type
                            Color c = NeoColors.blue;
                            if (type == 'Engineering') c = NeoColors.green;
                            if (type == 'Management') c = NeoColors.purple;
                            if (type == 'Medicine') c = NeoColors.red;
                            if (type == 'Arts') c = NeoColors.yellow;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: NotchedCard(
                                bg: NeoColors.surfDark,
                                notchPos: 'br',
                                notchSize: 44,
                                padding: EdgeInsets.zero,
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: c.withValues(alpha: 0.09),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                  color: c.withValues(
                                                      alpha: 0.2)),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Text('🏛',
                                                style: TextStyle(
                                                    fontSize: 22)),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        name,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color: Colors.white,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    neo.Badge(
                                                        label: rank,
                                                        color: c),
                                                  ],
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  loc.isNotEmpty
                                                      ? '📍 $loc'
                                                      : '📍 India',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: NeoColors.subDark,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: ProgressBar(
                                                          value: 75,
                                                          color: c,
                                                          height: 4),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      '75%',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: c,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    const Text('💰',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: NeoColors
                                                                .subDark)),
                                                    const SizedBox(width: 4),
                                                    Text(fees,
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors
                                                                .white60)),
                                                    const SizedBox(width: 10),
                                                    const Text('💺',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: NeoColors
                                                                .subDark)),
                                                    const SizedBox(width: 4),
                                                    Text('$seats seats',
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors
                                                                .white60)),
                                                    const Spacer(),
                                                    GestureDetector(
                                                      onTap: () {
                                                        ref
                                                            .read(savedUniversityIdsProvider
                                                                .notifier)
                                                            .toggle(id);
                                                      },
                                                      child: Icon(
                                                        isSaved
                                                            ? Icons.bookmark
                                                            : Icons
                                                                .bookmark_border,
                                                        size: 18,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 44),
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
                                        bg: c,
                                        onClick: () =>
                                            context.push('/university/$id'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            FloatingNav(
              activeId: 'uni',
              onChange: (id) {
                if (id == 'home') context.go('/home');
                if (id == 'apps') context.push('/applications');
                if (id == 'ai') context.push('/copilot');
                if (id == 'plan') context.push('/planner');
              },
            ),
          ],
        ),
      ),
    );
  }
}
