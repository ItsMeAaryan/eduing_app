import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../../core/theme/neo_design_system.dart' as neo show Badge;
import '../providers/planner_provider.dart';

class PlannerScreen extends ConsumerWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(plannerProvider);
    final notifier = ref.read(plannerProvider.notifier);

    final milestones = [
      {'label': 'Research', 'done': true, 'active': false},
      {'label': 'Shortlist', 'done': true, 'active': false},
      {'label': 'Applications', 'done': false, 'active': true},
      {'label': 'Documents', 'done': false, 'active': false},
      {'label': 'Interviews', 'done': false, 'active': false},
      {'label': 'Offers', 'done': false, 'active': false},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'YOUR',
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
                          'Planner',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        GreenBtn(
                          label: '+ Task',
                          small: true,
                          onClick: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Journey milestone bar
              Container(
                decoration: BoxDecoration(
                  color: NeoColors.surfDark,
                  border: Border.all(color: NeoColors.borderDark),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ADMISSION JOURNEY',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: NeoColors.subDark,
                        letterSpacing: 10 * 0.1,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: List.generate(milestones.length, (i) {
                        final m = milestones[i];
                        final isDone = m['done'] as bool;
                        final isActive = m['active'] as bool;
                        return Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isDone ? NeoColors.green : isActive ? NeoColors.purple : NeoColors.surfDark2,
                                        border: Border.all(
                                          color: isActive ? NeoColors.purple : isDone ? Colors.transparent : NeoColors.borderDark,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          if (isActive) BoxShadow(color: NeoColors.purple.withValues(alpha: 0.4), blurRadius: 16),
                                          if (isDone) BoxShadow(color: NeoColors.green.withValues(alpha: 0.27), blurRadius: 8),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        isDone ? '✓' : isActive ? '⟳' : '',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isDone || isActive ? Colors.black : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        m['label'] as String,
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          color: isDone ? NeoColors.green : isActive ? NeoColors.purple : NeoColors.subDark,
                                          letterSpacing: 9 * 0.03,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (i < milestones.length - 1)
                                Expanded(
                                  child: Container(
                                    height: 2,
                                    margin: const EdgeInsets.only(left: 4, right: 4, bottom: 20),
                                    decoration: BoxDecoration(
                                      color: isDone ? NeoColors.green : NeoColors.borderDark,
                                      boxShadow: [
                                        if (isDone) BoxShadow(color: NeoColors.green.withValues(alpha: 0.4), blurRadius: 6),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              // AI Copilot suggestion
              GestureDetector(
                onTap: () => context.push('/copilot'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: NeoColors.green.withValues(alpha: 0.08), // approx 14 hex
                    border: Border.all(color: NeoColors.green.withValues(alpha: 0.2)), // 33 hex
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: NeoColors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text('✦', style: TextStyle(fontSize: 16, color: Colors.black)),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Copilot Suggestion',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                            SizedBox(height: 1),
                            Text(
                              'Finish SOP before Friday · High priority',
                              style: TextStyle(fontSize: 12, color: NeoColors.subDark),
                            ),
                          ],
                        ),
                      ),
                      const Text('→', style: TextStyle(fontSize: 16, color: NeoColors.green)),
                    ],
                  ),
                ),
              ),

              // View toggle
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: NeoColors.surfDark,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    _buildToggleBtn('Timeline', 'timeline', state.view, notifier.setView),
                    const SizedBox(width: 6),
                    _buildToggleBtn('Calendar', 'calendar', state.view, notifier.setView),
                  ],
                ),
              ),

              // Task list
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'ACTION ITEMS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: NeoColors.subDark,
                    letterSpacing: 10 * 0.1,
                  ),
                ),
              ),
              ...state.tasks.map((task) {
                return GestureDetector(
                  onTap: () => notifier.toggleTask(task.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: NeoColors.surfDark,
                      border: Border.all(color: task.done ? NeoColors.borderDark : task.color.withValues(alpha: 0.13)), // 22 hex
                      borderRadius: BorderRadius.circular(16),
                    ),
                    // opacity roughly managed by wrapping content if needed, but doing it in child
                    child: Opacity(
                      opacity: task.done ? 0.5 : 1.0,
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: task.done ? NeoColors.green : Colors.transparent,
                              border: Border.all(color: task.done ? NeoColors.green : task.color, width: 2),
                            ),
                            alignment: Alignment.center,
                            child: task.done
                                ? const Text('✓', style: TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.w900))
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    decoration: task.done ? TextDecoration.lineThrough : TextDecoration.none,
                                    decorationColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 12, color: NeoColors.subDark),
                                    const SizedBox(width: 4),
                                    Text(
                                      task.date,
                                      style: const TextStyle(fontSize: 11, color: NeoColors.subDark),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          neo.Badge(label: task.tag, color: task.color),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 100), // padding for floating nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleBtn(String label, String id, String currentView, Function(String) onSelect) {
    final isActive = currentView == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 34,
          decoration: BoxDecoration(
            color: isActive ? NeoColors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(17),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isActive ? Colors.black : NeoColors.subDark,
            ),
          ),
        ),
      ),
    );
  }
}
