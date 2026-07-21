import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'ai_service.dart';
import 'models/ai_responses.dart';
import 'package:flutter/foundation.dart';

class GeminiAIService implements AIService {
  late final GenerativeModel _model;
  late final GenerativeModel _jsonModel;
  late ChatSession _chatSession;
  
  GeminiAIService(String apiKey) {
    final key = apiKey.isNotEmpty ? apiKey : 'mock_key';
    
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: key,
    );
    
    _jsonModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: key,
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );

    resetChat();
  }

  @override
  void resetChat() {
    _chatSession = _model.startChat();
  }

  @override
  Future<String> chat(String message) async {
    try {
      final response = await _chatSession.sendMessage(Content.text(message));
      return response.text ?? 'I could not generate a response.';
    } catch (e) {
      debugPrint('Gemini Chat Error: \$e');
      return 'Mock AI Copilot response to: \$message';
    }
  }

  @override
  Stream<String> streamChat(String message) async* {
    try {
      final stream = _chatSession.sendMessageStream(Content.text(message));
      await for (final chunk in stream) {
        if (chunk.text != null) yield chunk.text!;
      }
    } catch (e) {
      debugPrint('Gemini Stream Error: \$e');
      yield 'Mock stream response to: \$message';
    }
  }

  Future<Map<String, dynamic>> _generateJson(String prompt) async {
    try {
      final response = await _jsonModel.generateContent([Content.text(prompt)]);
      if (response.text == null) return {};
      return jsonDecode(response.text!);
    } catch (e) {
      debugPrint('Gemini JSON Error: \$e');
      return {};
    }
  }

  @override
  Future<ResumeReview> analyzeResume(String resumeText) async {
    const prompt = '''
      Analyze the following resume and return a JSON object with this exact structure:
      {
        "atsScore": 85,
        "strengths": ["string"],
        "weaknesses": ["string"],
        "missingSkills": ["string"],
        "recommendations": ["string"],
        "summary": "string"
      }
      Resume: \$resumeText
    ''';
    final json = await _generateJson(prompt.replaceAll('\$resumeText', resumeText));
    return ResumeReview.fromJson(json);
  }

  @override
  Future<SOPReview> analyzeSOP(String sopText) async {
    const prompt = '''
      Analyze the following SOP and return a JSON object:
      {
        "overallScore": 90,
        "grammar": "string",
        "clarity": "string",
        "impact": "string",
        "suggestions": ["string"],
        "rewrittenExample": "string"
      }
      SOP: \$sopText
    ''';
    final json = await _generateJson(prompt.replaceAll('\$sopText', sopText));
    return SOPReview.fromJson(json);
  }

  @override
  Future<DocumentAnalysis> analyzeDocument(String documentText) async {
    const prompt = '''
      Analyze the document and return a JSON object:
      {
        "documentType": "string",
        "importantInfo": ["string"],
        "missingFields": ["string"],
        "confidenceScore": 95
      }
      Document: \$documentText
    ''';
    final json = await _generateJson(prompt.replaceAll('\$documentText', documentText));
    return DocumentAnalysis.fromJson(json);
  }

  @override
  Future<InterviewFeedback> evaluateInterview(String question, String answer) async {
    const prompt = '''
      Evaluate the interview answer and return a JSON object:
      {
        "confidenceScore": 80,
        "communication": "string",
        "technicalDepth": "string",
        "behavioralFeedback": "string",
        "improvementPlan": "string"
      }
      Question: \$question
      Answer: \$answer
    ''';
    final json = await _generateJson(prompt.replaceAll('\$question', question).replaceAll('\$answer', answer));
    return InterviewFeedback.fromJson(json);
  }

  @override
  Future<List<ScholarshipRecommendation>> recommendScholarships(Map<String, dynamic> profile) async {
    const prompt = '''
      Recommend 3 scholarships based on this profile. Return JSON array of objects:
      [{ "title": "string", "amount": "string", "reason": "string" }]
      Profile: \$profileData
    ''';
    final json = await _generateJson(prompt.replaceAll('\$profileData', jsonEncode(profile)));
    if (json.containsKey('recommendations') && json['recommendations'] is List) {
      return (json['recommendations'] as List).map((e) => ScholarshipRecommendation.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<List<UniversityRecommendation>> recommendUniversities(Map<String, dynamic> profile) async {
    const prompt = '''
      Recommend 3 universities based on this profile. Return JSON array of objects:
      [{ "name": "string", "matchReason": "string", "matchScore": 95 }]
      Profile: \$profileData
    ''';
    final json = await _generateJson(prompt.replaceAll('\$profileData', jsonEncode(profile)));
    if (json.containsKey('recommendations') && json['recommendations'] is List) {
      return (json['recommendations'] as List).map((e) => UniversityRecommendation.fromJson(e)).toList();
    }
    return [];
  }
}
