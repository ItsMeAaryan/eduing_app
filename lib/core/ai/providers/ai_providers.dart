import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../gemini_service.dart';
import '../../../features/sop/services/sop_ai_service.dart';
import '../../../features/resume/services/resume_ai_service.dart';
import '../../../features/interview/services/interview_ai_service.dart';
import '../../../features/copilot/services/copilot_chat_service.dart';
import '../../../features/vault/services/document_ai_service.dart';
import '../readiness_score_service.dart';
import '../models/user_profile.dart';
import '../../../features/profile/providers/profile_provider.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) {
  const apiKey = String.fromEnvironment('GEMINI_API_KEY');
  final service = GeminiService()..initialize(apiKey);
  return service;
});

final sopAiServiceProvider = Provider<SOPAiService>((ref) {
  return SOPAiService(ref.read(geminiServiceProvider));
});

final resumeAiServiceProvider = Provider<ResumeAiService>((ref) {
  return ResumeAiService(ref.read(geminiServiceProvider));
});

final interviewAiServiceProvider = Provider<InterviewAiService>((ref) {
  return InterviewAiService(ref.read(geminiServiceProvider));
});

final copilotChatServiceProvider = Provider<CopilotChatService>((ref) {
  return CopilotChatService(ref.read(geminiServiceProvider));
});

final documentAiServiceProvider = Provider<DocumentAiService>((ref) {
  return DocumentAiService(ref.read(geminiServiceProvider));
});

// A bridge provider to supply UserProfile for AI services.
final aiUserProfileProvider = FutureProvider.family<UserProfile, String>((ref, userId) async {
  final profile = ref.watch(profileProvider);
  if (profile.value == null || profile.value!.isEmpty) {
    return const UserProfile(name: '', email: '', phone: '', percentage: 0.0, jeePercentile: 0.0, board: '');
  }
  final p = profile.value!;
  return UserProfile(
    name: p.displayName,
    email: p.email,
    phone: p.phone,
    percentage: ((p['academic']?['percentage12'] as num?) ?? 85.0).toDouble(),
    jeePercentile: ((p['entranceExams']?['jeeMainPercentile'] as num?) ?? 0.0).toDouble(),
    board: (p['academic']?['board'] as String?) ?? 'CBSE',
  );
});

final readinessScoreProvider = FutureProvider.family<ReadinessResult, String>((ref, userId) async {
  final service = ReadinessScoreService();
  final profile = await ref.read(aiUserProfileProvider(userId).future);
  return service.computeReadinessScore(profile);
});
