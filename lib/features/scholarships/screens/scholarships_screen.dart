import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../../core/theme/neo_design_system.dart' as neo show Badge;
import '../providers/scholarships_provider.dart';

class ScholarshipsScreen extends ConsumerStatefulWidget {
  const ScholarshipsScreen({super.key});

  @override
  ConsumerState<ScholarshipsScreen> createState() => _ScholarshipsScreenState();
}

class _ScholarshipsScreenState extends ConsumerState<ScholarshipsScreen> {
  String _filter = "All";
  final List<String> _filters = ["All", "Government", "Private", "Corporate", "Need-Based"];

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(scholarshipsProvider);
    final scholarships = _filter == "All" ? data.scholarships : data.scholarships.where((s) => s.coverage == _filter).toList();

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
                        children: _filters.map((f) {
                          final isSelected = _filter == f;
                          return GestureDetector(
                            onTap: () => setState(() => _filter = f),
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
                    ...scholarships.asMap().entries.map((entry) {
                      final i = entry.key;
                      final s = entry.value;
                      final colors = [NeoColors.green, NeoColors.purple, NeoColors.blue, const Color(0xFFFF3B7A), const Color(0xFFFF6B35)];
                      final color = colors[i % colors.length];

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
                                            color: color.withValues(alpha: 0.09), // 18 hex
                                            border: Border.all(color: color.withValues(alpha: 0.2)), // 33 hex
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
                                              Text(s.organization, style: const TextStyle(fontSize: 11, color: NeoColors.subDark)),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(s.fundingAmount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color)),
                                            const Text('per year', style: TextStyle(fontSize: 10, color: NeoColors.subDark)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(child: ProgressBar(value: s.aiMatchScore.toDouble(), color: color, height: 4)),
                                        const SizedBox(width: 8),
                                        Text('${s.aiMatchScore}% match', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: color)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            neo.Badge(label: s.coverage, color: color),
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
                                  bg: color,
                                  color: color == NeoColors.yellow ? Colors.black : Colors.white,
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
