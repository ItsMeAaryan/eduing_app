enum MessageRole { user, ai }

class ChatMessage {
  final String id;
  final String text;
  final MessageRole role;
  final DateTime timestamp;
  final bool isTyping;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.role,
    required this.timestamp,
    this.isTyping = false,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    MessageRole? role,
    DateTime? timestamp,
    bool? isTyping,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

class CopilotDashboardData {
  final List<String> recentInsights;
  final List<String> priorityTasks;
  final List<String> upcomingDeadlines;
  final List<String> recommendedNextActions;
  final int overallReadiness;
  final List<ChatMessage> history;

  const CopilotDashboardData({
    required this.recentInsights,
    required this.priorityTasks,
    required this.upcomingDeadlines,
    required this.recommendedNextActions,
    required this.overallReadiness,
    required this.history,
  });
}
