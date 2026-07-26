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
// In a real app, this would fetch from a database.
final userProfileProvider = FutureProvider.family<UserProfile, String>((ref, userId) async {
  final profileState = ref.watch(profileProvider);
  return UserProfile(
    name: profileState.name,
    email: profileState.email,
    phone: profileState.phone,
    percentage: 85.0, // Stub data
    jeePercentile: 95.0, // Stub data
    board: 'CBSE', // Stub data
  );
});

final readinessScoreProvider = FutureProvider.family<ReadinessResult, String>((ref, userId) async {
  final service = ReadinessScoreService();
  final profile = await ref.read(userProfileProvider(userId).future);
  return service.computeReadinessScore(profile);
});
