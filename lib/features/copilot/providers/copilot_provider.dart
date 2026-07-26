import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_message.dart';
import '../repositories/copilot_repository.dart';
import '../../../core/providers/ai_provider.dart';
import '../../../core/services/ai/ai_service.dart';

final copilotRepositoryProvider = Provider((ref) => CopilotRepository());

final chatSessionsStreamProvider = StreamProvider<List<ChatSession>>((ref) {
  final repo = ref.watch(copilotRepositoryProvider);
  return repo.getChatSessionsStream();
});

final copilotProvider =
    NotifierProvider<CopilotNotifier, CopilotDashboardData>(() {
  return CopilotNotifier();
});

class CopilotNotifier extends Notifier<CopilotDashboardData> {
  late final CopilotRepository _repository;
  late final AIService _aiService;
  String _activeSessionId = 'session_default';

  @override
  CopilotDashboardData build() {
    _repository = ref.watch(copilotRepositoryProvider);
    _aiService = ref.watch(aiServiceProvider);
    _loadSessionsFromFirestore();
    return _initialData();
  }

  static CopilotDashboardData _initialData() {
    return CopilotDashboardData(
      recentInsights: const [
        'Your SOP alignment for target programs is currently at 88%.',
        'You have a strong scholarship match for STEM Innovators Grant.',
      ],
      priorityTasks: const [
        'Upload your final official transcript.',
        'Complete mock interview practice.',
      ],
      upcomingDeadlines: const [
        'Nov 15: Stanford Application Deadline',
        'Dec 30: Global Tech Scholarship',
      ],
      recommendedNextActions: const [
        'Review SOP',
        'Practice Interview',
        'Search Scholarships',
      ],
      overallReadiness: 82,
      history: [
        ChatMessage(
          id: 'welcome_1',
          text:
              'Hello! I am your EDUING AI Copilot. Ask me anything about university admissions, SOPs, resumes, or scholarships.',
          role: MessageRole.ai,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ],
    );
  }

  void _loadSessionsFromFirestore() {
    _repository.getChatSessionsStream().listen((sessions) {
      if (sessions.isNotEmpty) {
        final active = sessions.first;
        _activeSessionId = active.id;
        state = CopilotDashboardData(
          recentInsights: state.recentInsights,
          priorityTasks: state.priorityTasks,
          upcomingDeadlines: state.upcomingDeadlines,
          recommendedNextActions: state.recommendedNextActions,
          overallReadiness: state.overallReadiness,
          history: active.messages,
        );
      }
    });
  }

  Future<void> sendMessage(String text, {String? contextInjection}) async {
    final userMsgId = 'msg_${DateTime.now().millisecondsSinceEpoch}';
    final userMsg = ChatMessage(
      id: userMsgId,
      text: text,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );

    final aiTypingId = 'ai_${DateTime.now().millisecondsSinceEpoch}';
    final aiTyping = ChatMessage(
      id: aiTypingId,
      text: '...',
      role: MessageRole.ai,
      timestamp: DateTime.now(),
      isTyping: true,
    );

    final updatedHistory = [...state.history, userMsg, aiTyping];

    state = CopilotDashboardData(
      recentInsights: state.recentInsights,
      priorityTasks: state.priorityTasks,
      upcomingDeadlines: state.upcomingDeadlines,
      recommendedNextActions: state.recommendedNextActions,
      overallReadiness: state.overallReadiness,
      history: updatedHistory,
    );

    final prompt = contextInjection != null
        ? '[CONTEXT: $contextInjection]\n\nUser Question: $text'
        : text;
    final aiResponse = await _aiService.chat(prompt);

    final finalAiMsg = ChatMessage(
      id: aiTypingId,
      text: aiResponse.isNotEmpty
          ? aiResponse
          : 'I am here to guide your study abroad journey. How can I help with your documents or applications?',
      role: MessageRole.ai,
      timestamp: DateTime.now(),
      isTyping: false,
    );

    final finalHistory =
        state.history.map((m) => m.id == aiTypingId ? finalAiMsg : m).toList();

    state = CopilotDashboardData(
      recentInsights: state.recentInsights,
      priorityTasks: state.priorityTasks,
      upcomingDeadlines: state.upcomingDeadlines,
      recommendedNextActions: state.recommendedNextActions,
      overallReadiness: state.overallReadiness,
      history: finalHistory,
    );

    await _autoSaveSession();
  }

  Future<void> _autoSaveSession() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final session = ChatSession(
        id: _activeSessionId,
        title: 'Application Guidance',
        messages: state.history,
        createdAt: DateTime.now(),
      );
      await _repository.create(_activeSessionId, session);
    }
  }
}
