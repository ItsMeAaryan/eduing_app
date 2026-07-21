import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';

import '../../../core/providers/ai_provider.dart';
import '../../../core/services/ai/ai_service.dart';

final copilotProvider = StateNotifierProvider<CopilotNotifier, CopilotDashboardData>((ref) {
  return CopilotNotifier(ref.watch(aiServiceProvider));
});

class CopilotNotifier extends StateNotifier<CopilotDashboardData> {
  final AIService _aiService;
  
  CopilotNotifier(this._aiService) : super(_initialData());

  static CopilotDashboardData _initialData() {
    return CopilotDashboardData(
      recentInsights: [
        'Your SOP alignment for Stanford is currently at 82%.',
        'You have a strong scholarship match for the STEM Innovators Grant.',
      ],
      priorityTasks: [
        'Upload your final transcript.',
        'Complete the behavioral interview mock session.',
      ],
      upcomingDeadlines: [
        'Nov 15: Stanford Application Deadline',
        'Dec 30: Tech Foundation Grant',
      ],
      recommendedNextActions: [
        'Review SOP',
        'Practice Interview',
        'Search Scholarships',
      ],
      overallReadiness: 78,
      history: [
        ChatMessage(
          id: const Uuid().v4(),
          text: 'Hello! I am your AI Admissions Copilot. How can I assist you with your applications today?',
          role: MessageRole.ai,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ],
    );
  }

  void sendMessage(String text) async {
    final userMsg = ChatMessage(
      id: const Uuid().v4(),
      text: text,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );

    final aiTyping = ChatMessage(
      id: const Uuid().v4(),
      text: '...',
      role: MessageRole.ai,
      timestamp: DateTime.now(),
      isTyping: true,
    );

    state = CopilotDashboardData(
      recentInsights: state.recentInsights,
      priorityTasks: state.priorityTasks,
      upcomingDeadlines: state.upcomingDeadlines,
      recommendedNextActions: state.recommendedNextActions,
      overallReadiness: state.overallReadiness,
      history: [...state.history, userMsg, aiTyping],
    );

    // Call real Gemini API
    String aiResponse = await _aiService.chat(text);

    final aiMsg = ChatMessage(
      id: aiTyping.id,
      text: aiResponse,
      role: MessageRole.ai,
      timestamp: DateTime.now(),
    );

    final updatedHistory = List<ChatMessage>.from(state.history);
    updatedHistory[updatedHistory.length - 1] = aiMsg;

    state = CopilotDashboardData(
      recentInsights: state.recentInsights,
      priorityTasks: state.priorityTasks,
      upcomingDeadlines: state.upcomingDeadlines,
      recommendedNextActions: state.recommendedNextActions,
      overallReadiness: state.overallReadiness,
      history: updatedHistory,
    );
  }
}
