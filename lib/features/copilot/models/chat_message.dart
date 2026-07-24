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

  Map<String, dynamic> toMap() => {
        'id': id,
        'text': text,
        'role': role.name,
        'timestamp': timestamp.millisecondsSinceEpoch,
        'isTyping': isTyping,
      };

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
        id: map['id'] ?? '',
        text: map['text'] ?? '',
        role: map['role'] == 'user' ? MessageRole.user : MessageRole.ai,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
            map['timestamp'] ?? DateTime.now().millisecondsSinceEpoch),
        isTyping: map['isTyping'] ?? false,
      );
}

class ChatSession {
  final String id;
  final String title;
  final List<ChatMessage> messages;
  final DateTime createdAt;

  const ChatSession({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'messages': messages.map((m) => m.toMap()).toList(),
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  factory ChatSession.fromMap(Map<String, dynamic> map, String docId) =>
      ChatSession(
        id: docId,
        title: map['title'] ?? 'AI Guidance Session',
        messages: (map['messages'] as List<dynamic>?)
                ?.map((m) => ChatMessage.fromMap(m as Map<String, dynamic>))
                .toList() ??
            const [],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
      );
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
