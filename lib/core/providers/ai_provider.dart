import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai/ai_service.dart';
import '../services/ai/gemini_ai_service.dart';

final aiServiceProvider = Provider<AIService>((ref) {
  // Read API Key from environment or remote config
  const apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  return GeminiAIService(apiKey);
});
