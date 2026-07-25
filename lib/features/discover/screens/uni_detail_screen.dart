import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../../core/theme/neo_design_system.dart' as neo show Badge;

class UniDetailScreen extends StatefulWidget {
  final String universityId;
  const UniDetailScreen({super.key, required this.universityId});

  @override
  State<UniDetailScreen> createState() => _UniDetailScreenState();
}

class _UniDetailScreenState extends State<UniDetailScreen> {
  String tab = 'overview';
  final tabs = ['overview', 'courses', 'placements', 'reviews'];

  @override
  Widget build(BuildContext context) {
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
                      'UNIVERSITY DETAIL',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: NeoColors.surfDark,
                      border: Border.all(color: NeoColors.borderDark),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text('🔖', style: TextStyle(fontSize: 15)),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 140,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  NeoColors.purple.withValues(alpha: 0.27), // 44 hex
                                  NeoColors.blue.withValues(alpha: 0.27),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: NeoColors.purple.withValues(alpha: 0.2)), // 33 hex
                            ),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: const Text('🏛', style: TextStyle(fontSize: 64)),
                          ),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'BITS Pilani',
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      '📍 Pilani, Rajasthan · Est. 1964',
                                      style: TextStyle(fontSize: 13, color: NeoColors.subDark),
                                    ),
                                  ],
                                ),
                              ),
                              const neo.Badge(label: 'NIRF #1', color: NeoColors.green),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Quick stats
                          Row(
                            children: [
                              {'label': 'Match', 'value': '96%', 'color': NeoColors.green},
                              {'label': 'Fees', 'value': '₹18L', 'color': NeoColors.blue},
                              {'label': 'Seats', 'value': '120', 'color': NeoColors.purple},
                              {'label': 'Cutoff', 'value': '260', 'color': Color(0xFFFF6B35)}, // orange
                            ].map((s) {
                              final c = s['color'] as Color;
                              return Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: s['label'] != 'Cutoff' ? 8 : 0),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: NeoColors.surfDark,
                                    border: Border.all(color: c.withValues(alpha: 0.13)), // 22 hex
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        s['value'] as String,
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: c),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        (s['label'] as String).toUpperCase(),
                                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: NeoColors.subDark, letterSpacing: 9 * 0.04),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),

                          // Apply CTA
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: NeoColors.green,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(color: NeoColors.green.withValues(alpha: 0.27), blurRadius: 20, offset: const Offset(0, 4)),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Apply Now →',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: NeoColors.surfDark,
                                  border: Border.all(color: NeoColors.borderDark),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: const Text('📤', style: TextStyle(fontSize: 18)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Tab switcher
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: tabs.map((t) {
                          final isSelected = tab == t;
                          return GestureDetector(
                            onTap: () => setState(() => tab = t),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 36,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: isSelected ? NeoColors.green : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${t[0].toUpperCase()}${t.substring(1)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected ? NeoColors.green : NeoColors.subDark,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Tab content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: _buildTabContent(),
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

  Widget _buildTabContent() {
    if (tab == 'overview') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: NeoColors.surfDark,
              border: Border.all(color: NeoColors.borderDark),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ABOUT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: NeoColors.subDark, letterSpacing: 10 * 0.08)),
                SizedBox(height: 10),
                Text(
                  'Birla Institute of Technology and Science, Pilani is a private deemed university known for its rigorous engineering programs, research culture, and strong industry connections. Consistently ranked #1 among private universities in India.',
                  style: TextStyle(fontSize: 13, color: Colors.white60, height: 1.6),
                ),
              ],
            ),
          ),
          ...[
            {'label': 'Accreditation', 'value': 'NAAC A++ · NBA Accredited', 'icon': '🏅', 'color': NeoColors.green},
            {'label': 'Intake Season', 'value': 'July–August (JEE + BITSAT)', 'icon': '📅', 'color': NeoColors.blue},
            {'label': 'Placement Rate', 'value': '95% placed · Avg ₹18 LPA', 'icon': '💼', 'color': NeoColors.purple},
            {'label': 'Campus Size', 'value': '1,095 acres · 4 campuses', 'icon': '🌳', 'color': const Color(0xFFFF6B35)}, // orange
          ].map((item) {
            final c = item['color'] as Color;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: NeoColors.surfDark,
                border: Border.all(color: c.withValues(alpha: 0.13)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: c.withValues(alpha: 0.09), // 18 hex
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(item['icon'] as String, style: const TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['label'] as String, style: const TextStyle(fontSize: 11, color: NeoColors.subDark, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 1),
                        Text(item['value'] as String, style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      );
    }

    if (tab == 'courses') {
      return Column(
        children: [
          {'name': 'B.Tech Computer Science', 'duration': '4 years', 'seats': 120, 'fees': '₹18L/yr', 'cutoff': '260', 'color': NeoColors.green},
          {'name': 'B.Tech Electrical Engg', 'duration': '4 years', 'seats': 80, 'fees': '₹18L/yr', 'cutoff': '270', 'color': NeoColors.blue},
          {'name': 'B.Tech Mechanical Engg', 'duration': '4 years', 'seats': 100, 'fees': '₹18L/yr', 'cutoff': '290', 'color': const Color(0xFFFF6B35)}, // orange
          {'name': 'M.Tech Artificial Intel', 'duration': '2 years', 'seats': 40, 'fees': '₹8L/yr', 'cutoff': 'N/A', 'color': NeoColors.purple},
        ].map((c) {
          final color = c['color'] as Color;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: NeoColors.surfDark,
              border: Border.all(color: color.withValues(alpha: 0.13)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    neo.Badge(label: c['duration'] as String, color: color),
                    neo.Badge(label: '${c['seats']} seats', color: NeoColors.subDark),
                    neo.Badge(label: c['fees'] as String, color: NeoColors.yellow),
                    neo.Badge(label: 'Cutoff: ${c['cutoff']}', color: NeoColors.red),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    if (tab == 'placements') {
      return Column(
        children: [
          NotchedCard(
            bg: Colors.transparent, // Background handled by container
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
                      colors: [Color(0xFF1C8A5E), NeoColors.blue],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('2024 PLACEMENTS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white.withValues(alpha: 0.5), letterSpacing: 10 * 0.1)),
                      const SizedBox(height: 6),
                      const Text('₹18 LPA', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1)),
                      const SizedBox(height: 4),
                      Text('Average Package · 95% placement rate', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.6))),
                    ],
                  ),
                ),
                Positioned(
                  bottom: -10,
                  right: -10,
                  child: FloatingActionBtn(
                    icon: '→',
                    bg: NeoColors.green,
                    color: Colors.black,
                    onClick: () {},
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ...[
            {'name': 'Google', 'pkg': '₹45L'},
            {'name': 'Microsoft', 'pkg': '₹38L'},
            {'name': 'Amazon', 'pkg': '₹36L'},
            {'name': 'Goldman Sachs', 'pkg': '₹40L'},
            {'name': 'Uber', 'pkg': '₹32L'},
            {'name': 'Adobe', 'pkg': '₹28L'},
          ].map((c) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: NeoColors.surfDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: NeoColors.borderDark),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: NeoColors.surfDark2,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text('🏢', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(c['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white))),
                  Text(c['pkg'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: NeoColors.green)),
                ],
              ),
            );
          }),
        ],
      );
    }

    if (tab == 'reviews') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: NeoColors.surfDark,
          border: Border.all(color: NeoColors.borderDark),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          children: [
            Text('⭐', style: TextStyle(fontSize: 32)),
            SizedBox(height: 8),
            Text('4.6 / 5', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
            Text('Based on 2,340 student reviews', style: TextStyle(fontSize: 13, color: NeoColors.subDark)),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
