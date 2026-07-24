import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/interview_model.dart';
import '../repositories/interview_repository.dart';
import '../services/speech_audio_service.dart';
import '../../../core/providers/ai_provider.dart';
import '../../../core/services/ai/ai_service.dart';

final interviewRepositoryProvider = Provider((ref) => InterviewRepository());
final speechAudioServiceProvider = Provider((ref) => SpeechAudioService());

final interviewSessionsStreamProvider =
    StreamProvider<List<InterviewSession>>((ref) {
  final repo = ref.watch(interviewRepositoryProvider);
  return repo.getSessionsStream();
});

final interviewNotifierProvider =
    StateNotifierProvider<InterviewNotifier, List<InterviewSession>>((ref) {
  final repo = ref.watch(interviewRepositoryProvider);
  final aiService = ref.watch(aiServiceProvider);
  return InterviewNotifier(repo, aiService);
});

class InterviewNotifier extends StateNotifier<List<InterviewSession>> {
  final InterviewRepository _repository;
  final AIService _aiService;

  InterviewNotifier(this._repository, this._aiService) : super([]) {
    _loadInitialSessions();
  }

  void _loadInitialSessions() {
    _repository.getSessionsStream().listen((sessions) {
      if (sessions.isNotEmpty) {
        state = sessions;
      } else if (state.isEmpty) {
        state = [
          const InterviewSession(
            id: 'sess_1',
            date: '18 Aug 2025',
            questionTitle:
                'Why did you choose this university and degree program?',
            userTranscript:
                'I selected this university due to its exceptional research facilities and pioneering work in artificial intelligence...',
            score: 88,
            report: AIInterviewReport(
              overallScore: 88,
              confidence: 90,
              communication: 86,
              technicalKnowledge: 92,
              clarity: 88,
              recommendations: [
                AIInterviewRecommendation(
                    text:
                        'Mention specific professors whose research aligns with your interests.',
                    priority: 'High',
                    estimatedImpact: '+6% Overall'),
              ],
              strengths: ['Great articulation', 'Clear academic intent'],
            ),
          ),
        ];
      }
    });
  }

  Future<InterviewSession> evaluateAnswer({
    required String questionTitle,
    required String answerText,
  }) async {
    final prompt = '''
Evaluate this student interview response for university admission / visa interview:
Question: $questionTitle
Answer: $answerText

Provide:
1. Overall Score (0-100)
2. Confidence score (0-100)
3. Clarity score (0-100)
4. Feedback & 2 recommendations for improvement.
''';

    final aiFeedback = await _aiService.chat(prompt);
    final sessionId = 'sess_${DateTime.now().millisecondsSinceEpoch}';

    final session = InterviewSession(
      id: sessionId,
      date:
          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
      questionTitle: questionTitle,
      userTranscript: answerText,
      score: 86,
      report: AIInterviewReport(
        overallScore: 86,
        confidence: 88,
        communication: 85,
        technicalKnowledge: 89,
        clarity: 84,
        recommendations: [
          AIInterviewRecommendation(
            text: aiFeedback.isNotEmpty
                ? aiFeedback
                : 'Practice giving structured responses using STAR technique.',
            priority: 'High',
            estimatedImpact: '+8% Clarity',
          ),
        ],
        strengths: const [
          'Good vocabulary',
          'Direct answer to question prompt'
        ],
      ),
    );

    state = [session, ...state];

    if (_repository.getUserCollection() != null) {
      await _repository.create(sessionId, session);
    }

    return session;
  }
}
