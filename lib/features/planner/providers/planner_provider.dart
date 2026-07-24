import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/planner_model.dart';

final plannerProvider =
    StateNotifierProvider<PlannerNotifier, PlannerDashboardData>((ref) {
  return PlannerNotifier();
});

class PlannerNotifier extends StateNotifier<PlannerDashboardData> {
  PlannerNotifier() : super(_initialData());

  static PlannerDashboardData _initialData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final allEvents = [
      PlannerEvent(
        id: '1',
        title: 'Upload Final Transcript',
        description: 'Required for Stanford application.',
        date: today,
        type: EventType.document,
        isCompleted: false,
      ),
      PlannerEvent(
        id: '2',
        title: 'Mock Interview Practice',
        description: 'Behavioral questions for MIT.',
        date: today.add(const Duration(hours: 4)),
        type: EventType.interview,
        isCompleted: false,
      ),
      PlannerEvent(
        id: '3',
        title: 'Stanford Application Deadline',
        description: 'Submit all required documents.',
        date: today.add(const Duration(days: 3)),
        type: EventType.application,
        isCompleted: false,
      ),
      PlannerEvent(
        id: '4',
        title: 'STEM Grant Deadline',
        description: 'Submit portfolio and SOP.',
        date: today.add(const Duration(days: 5)),
        type: EventType.scholarship,
        isCompleted: false,
      ),
      PlannerEvent(
        id: '5',
        title: 'Finish Resume Draft',
        description: 'Update work experience section.',
        date: today.subtract(const Duration(days: 1)),
        type: EventType.resume,
        isCompleted: true,
      ),
    ];

    final todayAgenda = allEvents
        .where((e) =>
            e.date.year == today.year &&
            e.date.month == today.month &&
            e.date.day == today.day)
        .toList();
    final upcomingDeadlines = allEvents
        .where((e) =>
            e.type == EventType.application || e.type == EventType.scholarship)
        .toList();

    return PlannerDashboardData(
      todayAgenda: todayAgenda,
      upcomingDeadlines: upcomingDeadlines,
      completedTasks: allEvents.where((e) => e.isCompleted).length,
      pendingTasks: allEvents.where((e) => !e.isCompleted).length,
      aiPriorityScore: 85,
      aiRecommendations: [
        AIPlannerRecommendation(
          id: 'rec1',
          suggestion: 'Finish SOP before Friday.',
          priority: 'High',
          estimatedEffort: '2 hours',
          suggestedDate: today.add(const Duration(days: 1)),
        ),
        AIPlannerRecommendation(
          id: 'rec2',
          suggestion: 'Upload transcript today.',
          priority: 'High',
          estimatedEffort: '15 mins',
          suggestedDate: today,
        ),
        AIPlannerRecommendation(
          id: 'rec3',
          suggestion: 'Prepare for your interview tomorrow.',
          priority: 'Medium',
          estimatedEffort: '1 hour',
          suggestedDate: today.add(const Duration(days: 1)),
        ),
      ],
      allEvents: allEvents,
    );
  }

  void toggleTaskCompletion(String id) {
    final updatedEvents = state.allEvents.map((e) {
      if (e.id == id) {
        return e.copyWith(isCompleted: !e.isCompleted);
      }
      return e;
    }).toList();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    state = PlannerDashboardData(
      todayAgenda: updatedEvents
          .where((e) =>
              e.date.year == today.year &&
              e.date.month == today.month &&
              e.date.day == today.day)
          .toList(),
      upcomingDeadlines: updatedEvents
          .where((e) =>
              e.type == EventType.application ||
              e.type == EventType.scholarship)
          .toList(),
      completedTasks: updatedEvents.where((e) => e.isCompleted).length,
      pendingTasks: updatedEvents.where((e) => !e.isCompleted).length,
      aiPriorityScore: state.aiPriorityScore,
      aiRecommendations: state.aiRecommendations,
      allEvents: updatedEvents,
    );
  }
}
