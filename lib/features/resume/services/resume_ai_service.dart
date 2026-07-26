import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../../core/ai/gemini_service.dart';
import '../../../core/ai/exceptions/gemini_exception.dart';
import '../../../core/ai/prompts/resume_prompt.dart';

class ResumeData {
  // Define required fields based on existing app model, simplified for AI service
  final Map<String, dynamic> data;

  const ResumeData(this.data);
  
  String toJsonString() => jsonEncode(data);
}

class ATSResult {
  final int atsScore;
  final int keywordsScore;
  final int formatScore;
  final int lengthScore;
  final List<String> missingKeywords;
  final List<String> suggestions;
  final List<String> strengthAreas;

  const ATSResult({
    required this.atsScore,
    required this.keywordsScore,
    required this.formatScore,
    required this.lengthScore,
    required this.missingKeywords,
    required this.suggestions,
    required this.strengthAreas,
  });
}

class ResumeAiService {
  final GeminiService _geminiService;

  ResumeAiService(this._geminiService);

  Future<Either<GeminiException, ATSResult>> scoreResume(ResumeData resume, String targetRole) async {
    final prompt = ResumePrompt.generatePrompt(
      targetRole: targetRole,
      resumeJson: resume.toJsonString(),
    );

    final response = await _geminiService.generateText(
      prompt: prompt,
      modelType: GeminiModelType.pro,
    );

    return response.bind((text) {
      try {
        final jsonStr = _extractJson(text);
        final data = jsonDecode(jsonStr) as Map<String, dynamic>;

        return Right(ATSResult(
          atsScore: data['ats_score'] as int? ?? 0,
          keywordsScore: data['keywords_score'] as int? ?? 0,
          formatScore: data['format_score'] as int? ?? 0,
          lengthScore: data['length_score'] as int? ?? 0,
          missingKeywords: List<String>.from(data['missing_keywords'] ?? []),
          suggestions: List<String>.from(data['suggestions'] ?? []),
          strengthAreas: List<String>.from(data['strength_areas'] ?? []),
        ));
      } catch (e) {
        return Left(InvalidResponseException('Failed to parse ATS response: $e'));
      }
    });
  }

  Future<Either<GeminiException, List<String>>> suggestImprovements(ResumeData resume) async {
    final prompt = '''
Review this resume and provide exactly 3 impactful suggestions for improvement.
Return ONLY a JSON array of strings.
Resume: ${resume.toJsonString()}
''';
    final response = await _geminiService.generateText(
      prompt: prompt,
      modelType: GeminiModelType.flash,
    );

    return response.bind((text) {
      try {
        final jsonStr = _extractJsonArray(text);
        final data = jsonDecode(jsonStr) as List<dynamic>;
        return Right(List<String>.from(data));
      } catch (e) {
        return Left(InvalidResponseException('Failed to parse suggestions: $e'));
      }
    });
  }

  Future<Either<GeminiException, String>> generateSummary(ResumeData resume) async {
    final prompt = '''
Write a professional 3-sentence summary for this resume.
Return ONLY the text.
Resume: ${resume.toJsonString()}
''';
    final response = await _geminiService.generateText(
      prompt: prompt,
      modelType: GeminiModelType.flash,
    );
    return response.map((text) => text.trim());
  }

  String _extractJson(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start != -1 && end != -1 && end > start) {
      return text.substring(start, end + 1);
    }
    return '{}';
  }
  
  String _extractJsonArray(String text) {
    final start = text.indexOf('[');
    final end = text.lastIndexOf(']');
    if (start != -1 && end != -1 && end > start) {
      return text.substring(start, end + 1);
    }
    return '[]';
  }
}
