import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../../core/theme/neo_design_system.dart' as neo show Badge;

class PlannerCalendarScreen extends StatefulWidget {
  const PlannerCalendarScreen({super.key});

  @override
  State<PlannerCalendarScreen> createState() => _PlannerCalendarScreenState();
}

class _PlannerCalendarScreenState extends State<PlannerCalendarScreen> {
  DateTime _currentMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  final DateTime _today = DateTime.now();

  final Map<int, List<Map<String, dynamic>>> _events = {
    12: [{"title": "Stanford Application Due", "color": NeoColors.yellow}],
    15: [{"title": "Mock Interview with AI", "color": NeoColors.purple}],
    20: [{"title": "Submit Transcripts", "color": NeoColors.green}],
  };

  final List<Map<String, dynamic>> _upcoming = [
    {"date": "12 Aug", "title": "Stanford Application Due", "badge": "Urgent", "color": NeoColors.yellow},
    {"date": "15 Aug", "title": "Mock Interview with AI", "badge": "Prep", "color": NeoColors.purple},
    {"date": "20 Aug", "title": "Submit Transcripts", "badge": "Doc", "color": NeoColors.green},
  ];

  void _prevMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Text(
                          'PLANNER',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white30,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: NeoColors.surfDark,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: NeoColors.borderDark),
                            ),
                            child: const Text('Timeline View', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: NeoColors.surfDark,
                      shape: BoxShape.circle,
                      border: Border.all(color: NeoColors.borderDark),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.add, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Calendar Section
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: NeoColors.surfDark,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: NeoColors.borderDark),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: _prevMonth,
                                  child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                                ),
                                Text(
                                  DateFormat('MMMM yyyy').format(_currentMonth),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: _nextMonth,
                                  child: const Icon(Icons.chevron_right, color: Colors.white, size: 28),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((d) => 
                                SizedBox(
                                  width: 32,
                                  child: Text(d, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white30)),
                                )
                              ).toList(),
                            ),
                            const SizedBox(height: 12),
                            _buildCalendarGrid(),
                          ],
                        ),
                      ),
                    ),

                    // Selected Day Events
                    if (_events.containsKey(_selectedDate.day)) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          '${DateFormat('dd MMM').format(_selectedDate)} Events',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white60, letterSpacing: 0.5),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...(_events[_selectedDate.day]!).map((e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: NeoColors.surfDark2,
                            borderRadius: BorderRadius.circular(16),
                            border: Border(
                              left: BorderSide(color: e['color'], width: 4),
                              top: BorderSide(color: (e['color'] as Color).withValues(alpha: 0.3)),
                              right: BorderSide(color: (e['color'] as Color).withValues(alpha: 0.3)),
                              bottom: BorderSide(color: (e['color'] as Color).withValues(alpha: 0.3)),
                            ),
                          ),
                          child: Text(e['title'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                        ),
                      )),
                      const SizedBox(height: 24),
                    ],

                    // Upcoming List
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Text('ALL UPCOMING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white30, letterSpacing: 1.2)),
                    ),
                    const SizedBox(height: 12),
                    ..._upcoming.map((u) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: NeoColors.surfDark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: NeoColors.borderDark),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: (u['color'] as Color).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(u['date'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: u['color'])),
                            ),
                            const SizedBox(width: 14),
                            Expanded(child: Text(u['title'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white))),
                            neo.Badge(label: u['badge'], color: u['color']),
                          ],
                        ),
                      ),
                    )),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 42, // 6 weeks
      itemBuilder: (context, index) {
        if (index < firstWeekday || index >= firstWeekday + daysInMonth) {
          return const SizedBox();
        }

        final day = index - firstWeekday + 1;
        final date = DateTime(_currentMonth.year, _currentMonth.month, day);
        final isSelected = date.year == _selectedDate.year && date.month == _selectedDate.month && date.day == _selectedDate.day;
        final isToday = date.year == _today.year && date.month == _today.month && date.day == _today.day;
        final hasEvent = _events.containsKey(day);

        return GestureDetector(
          onTap: () => setState(() => _selectedDate = date),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? NeoColors.green : Colors.transparent,
              shape: BoxShape.circle,
              border: isToday && !isSelected ? Border.all(color: NeoColors.green, width: 2) : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected || isToday ? FontWeight.w900 : FontWeight.w600,
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                ),
                if (hasEvent)
                  Positioned(
                    bottom: 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _events[day]!.take(3).map((e) => Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : e['color'],
                          shape: BoxShape.circle,
                        ),
                      )).toList(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
