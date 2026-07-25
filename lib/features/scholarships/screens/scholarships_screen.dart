import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../../core/theme/neo_design_system.dart' as neo show Badge;
import '../providers/v4_scholarships_provider.dart';

class ScholarshipsScreen extends ConsumerWidget {
  const ScholarshipsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(v4ScholarshipsProvider);
    final notifier = ref.read(v4ScholarshipsProvider.notifier);
    final scholarships = ref.watch(v4FilteredScholarshipsProvider);

    final filters = ["All", "Government", "Private", "Corporate", "Need-Based"];

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
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FINANCIAL AID',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: NeoColors.yellow,
                              letterSpacing: 10 * 0.12,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Scholarships',
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

                    // Hero
                    NotchedCard(
                      bg: Colors.transparent, // Background handled by container
                      padding: EdgeInsets.zero,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [NeoColors.yellow.withValues(alpha: 0.8), const Color(0xFFFF6B35)], // yellowCC, orange
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI MATCHED FOR YOU',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black.withValues(alpha: 0.5),
                                    letterSpacing: 10 * 0.1,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  '5 scholarships\nworth ₹8.25L',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                    letterSpacing: -1,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Based on your profile & eligibility',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black.withValues(alpha: 0.6),
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
                              bg: Colors.black,
                              color: Colors.white,
                              onClick: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Filter chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Row(
                        children: filters.map((f) {
                          final isSelected = state.filter == f;
                          return GestureDetector(
                            onTap: () => notifier.setFilter(f),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 32,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? NeoColors.yellow : NeoColors.surfDark,
                                border: Border.all(
                                  color: isSelected ? NeoColors.yellow : NeoColors.borderDark,
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
                                  color: isSelected ? Colors.black : Colors.white60,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Scholarship cards
                    ...scholarships.map((s) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: NotchedCard(
                          bg: Colors.transparent, // background handled by container
                          padding: EdgeInsets.zero,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16), // usually inner padding
                                decoration: const BoxDecoration(
                                  color: NeoColors.surfDark,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: s.color.withValues(alpha: 0.09), // 18 hex
                                            border: Border.all(color: s.color.withValues(alpha: 0.2)), // 33 hex
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          alignment: Alignment.center,
                                          child: const Text('🏆', style: TextStyle(fontSize: 20)),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(s.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white)),
                                              const SizedBox(height: 2),
                                              Text(s.org, style: const TextStyle(fontSize: 11, color: NeoColors.subDark)),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(s.amount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: s.color)),
                                            const Text('per year', style: TextStyle(fontSize: 10, color: NeoColors.subDark)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(child: ProgressBar(value: s.match.toDouble(), color: s.color, height: 4)),
                                        const SizedBox(width: 8),
                                        Text('${s.match}% match', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: s.color)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            neo.Badge(label: s.type, color: s.color),
                                            const SizedBox(width: 6),
                                            neo.Badge(label: 'Due ${s.deadline}', color: NeoColors.subDark),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: -10,
                                right: -10,
                                child: FloatingActionBtn(
                                  icon: '→',
                                  bg: s.color,
                                  color: s.color == NeoColors.yellow ? Colors.black : Colors.white,
                                  onClick: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 100), // floating nav padding
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
