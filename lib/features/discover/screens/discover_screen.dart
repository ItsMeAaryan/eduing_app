import 'package:flutter/material.dart' hide Badge;
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _activeFilter = 0;

  final List<String> filters = ["All", "Engineering", "Management", "Medicine", "Law"];

  final List<Map<String, dynamic>> unis = [
    {"name": "BITS Pilani", "loc": "Pilani, Rajasthan", "rank": "NIRF #1", "match": 96.0, "color": NeoColors.purple},
    {"name": "IIT Bombay", "loc": "Mumbai, Maharashtra", "rank": "NIRF #2", "match": 88.0, "color": NeoColors.blue},
    {"name": "Delhi University", "loc": "New Delhi", "rank": "NIRF #3", "match": 81.0, "color": const Color(0xFF1C8A5E)},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = NeoThemeData.of(context);

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 120), // padding for floating nav
                children: [
                  Text(
                    "Discover",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: t.text,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Explore global universities",
                    style: TextStyle(fontSize: 13, color: t.sub),
                  ),
                  const SizedBox(height: 16),

                  // Search
                  SCard(
                    border: true,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: SizedBox(
                      height: 48,
                      child: Row(
                        children: [
                          Text("🔍", style: TextStyle(fontSize: 16, color: t.muted)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: TextStyle(fontSize: 14, color: t.text),
                              decoration: const InputDecoration(
                                hintText: "Search universities, programs...",
                                hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: NeoColors.purpleBlock,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: const Text("⊟", style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filter pills
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: filters.asMap().entries.map((entry) {
                        final i = entry.key;
                        final f = entry.value;
                        final isActive = i == _activeFilter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: PillBtn(
                            label: f,
                            bg: isActive ? NeoColors.purple : Colors.transparent,
                            color: isActive ? Colors.white : t.sub,
                            size: "sm",
                            ghost: !isActive,
                            onClick: () {
                              setState(() {
                                _activeFilter = i;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${unis.length} Universities",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: t.text,
                        ),
                      ),
                      PillBtn(label: "Sort: Match ↓", size: "sm", ghost: true, onClick: () {}),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Cards
                  ...unis.map((u) {
                    final color = u["color"] as Color;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          NotchedCard(
                            notchPos: "br",
                            notchSize: 44,
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.11), // approx 18 hex
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: const Text("🏛", style: TextStyle(fontSize: 22)),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              u["name"] as String,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                color: t.text,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Badge(label: u["rank"] as String, color: color),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        u["loc"] as String,
                                        style: TextStyle(fontSize: 12, color: t.sub),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ProgressBar(
                                              value: u["match"] as double,
                                              color: color,
                                              height: 4,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "${(u["match"] as double).toInt()}% match",
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              color: color,
                                            ),
                                          ),
                                          const SizedBox(width: 24), // Space for floating btn
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
                              icon: "→",
                              bg: color,
                              size: 40,
                              onClick: () => context.push('/university/1'),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
