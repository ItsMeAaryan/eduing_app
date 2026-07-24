enum EventType {
  application,
  interview,
  scholarship,
  resume,
  sop,
  document,
  reminder,
  personal
}

class PlannerEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final EventType type;
  final bool isCompleted;

  const PlannerEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    this.isCompleted = false,
  });

  PlannerEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    EventType? type,
    bool? isCompleted,
  }) {
    return PlannerEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      type: type ?? this.type,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class AIPlannerRecommendation {
  final String id;
  final String suggestion;
  final String priority; // e.g. "High", "Medium", "Low"
  final String estimatedEffort; // e.g. "2 hours"
  final DateTime suggestedDate;

  const AIPlannerRecommendation({
    required this.id,
    required this.suggestion,
    required this.priority,
    required this.estimatedEffort,
    required this.suggestedDate,
  });
}

class PlannerDashboardData {
  final List<PlannerEvent> todayAgenda;
  final List<PlannerEvent> upcomingDeadlines;
  final int completedTasks;
  final int pendingTasks;
  final int aiPriorityScore;
  final List<AIPlannerRecommendation> aiRecommendations;
  final List<PlannerEvent> allEvents; // For calendar overview

  const PlannerDashboardData({
    required this.todayAgenda,
    required this.upcomingDeadlines,
    required this.completedTasks,
    required this.pendingTasks,
    required this.aiPriorityScore,
    required this.aiRecommendations,
    required this.allEvents,
  });
}
