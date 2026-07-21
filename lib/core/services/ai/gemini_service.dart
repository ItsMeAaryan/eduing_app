import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';

class GeminiService {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;
  
  GeminiService(String apiKey) {
    if (apiKey.isEmpty) {
      debugPrint('Gemini API Key is empty, using mock model');
    }
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey.isNotEmpty ? apiKey : 'mock_key',
    );
    _chatSession = _model.startChat();
  }

  Future<String> generateText(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'I could not generate a response.';
    } catch (e) {
      debugPrint('Gemini API Error: \$e');
      return 'Mock AI Response for: \$prompt';
    }
  }

  Future<String> chat(String message) async {
    try {
      final response = await _chatSession.sendMessage(Content.text(message));
      return response.text ?? 'I have no response.';
    } catch (e) {
      debugPrint('Gemini Chat API Error: \$e');
      return 'Mock Chat Response for: \$message';
    }
  }
}
