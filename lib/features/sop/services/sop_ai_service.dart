import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../../core/ai/gemini_service.dart';
import '../../../core/ai/exceptions/gemini_exception.dart';
import '../../../core/ai/prompts/sop_prompt.dart';

import '../../../core/ai/models/user_profile.dart';

class SOPInput {
  final String universityName;
  final String courseName;
  final String whyUniversity;
  final String biggestAchievement;
  final String careerGoal;
  final String extracurriculars;
  final UserProfile userProfile;

  const SOPInput({
    required this.universityName,
    required this.courseName,
    required this.whyUniversity,
    required this.biggestAchievement,
    required this.careerGoal,
    required this.extracurriculars,
    required this.userProfile,
  });
}

class SOPResult {
  final String content;
  final int overallScore;
  final int clarityScore;
  final int relevanceScore;
  final int toneScore;
  final int wordCount;
  final List<String> improvementSuggestions;

  const SOPResult({
    required this.content,
    required this.overallScore,
    required this.clarityScore,
    required this.relevanceScore,
    required this.toneScore,
    required this.wordCount,
    required this.improvementSuggestions,
  });
}

class SOPScores {
  final int overallScore;
  final int clarityScore;
  final int relevanceScore;
  final int toneScore;
  final int wordCount;
  final List<String> improvementSuggestions;

  const SOPScores({
    required this.overallScore,
    required this.clarityScore,
    required this.relevanceScore,
    required this.toneScore,
    required this.wordCount,
    required this.improvementSuggestions,
  });
}

class SOPAiService {
  final GeminiService _geminiService;

  SOPAiService(this._geminiService);

  Future<Either<GeminiException, SOPResult>> generateSOP(SOPInput input) async {
    final prompt = SopPrompt.generatePrompt(
      universityName: input.universityName,
      courseName: input.courseName,
      jeePercentile: input.userProfile.jeePercentile,
      percentage: input.userProfile.percentage,
      board: input.userProfile.board,
      category: input.userProfile.category,
      whyUniversity: input.whyUniversity,
      biggestAchievement: input.biggestAchievement,
      careerGoal: input.careerGoal,
      extracurriculars: input.extracurriculars,
    );

    final response = await _geminiService.generateText(
      prompt: prompt,
      modelType: GeminiModelType.pro,
    );

    return response.bind((text) {
      try {
        final sopContent = _extractContentBeforeJson(text);
        final jsonStr = _extractJson(text);
        final data = jsonDecode(jsonStr) as Map<String, dynamic>;

        return Right(SOPResult(
          content: sopContent.trim(),
          overallScore: data['overall_score'] as int? ?? 0,
          clarityScore: data['clarity_score'] as int? ?? 0,
          relevanceScore: data['relevance_score'] as int? ?? 0,
          toneScore: data['tone_score'] as int? ?? 0,
          wordCount: data['word_count'] as int? ?? 0,
          improvementSuggestions: List<String>.from(data['suggestions'] ?? []),
        ));
      } catch (e) {
        return Left(InvalidResponseException('Failed to parse SOP response: $e'));
      }
    });
  }

  Future<Either<GeminiException, String>> improveSOP(String existingSOP, String instruction) async {
    final prompt = '''
You are an expert SOP editor.
Here is an existing Statement of Purpose:
$existingSOP

Instruction for improvement:
$instruction

Please provide the fully rewritten and improved Statement of Purpose based on the instruction.
Provide ONLY the improved SOP text, no extra commentary.
''';

    final response = await _geminiService.generateText(
      prompt: prompt,
      modelType: GeminiModelType.pro,
    );
    
    return response;
  }

  Future<Either<GeminiException, SOPScores>> scoreSOP(String sopContent, String universityName) async {
    final prompt = '''
You are an expert admission reviewer. Review this Statement of Purpose for $universityName.

SOP Content:
$sopContent

Respond ONLY with a JSON block:
{
  "overall_score": number,
  "clarity_score": number,
  "relevance_score": number,
  "tone_score": number,
  "word_count": number,
  "suggestions": ["suggestion1", "suggestion2"]
}
''';

    final response = await _geminiService.generateText(
      prompt: prompt,
      modelType: GeminiModelType.flash, // faster scoring
    );

    return response.bind((text) {
      try {
        final jsonStr = _extractJson(text);
        final data = jsonDecode(jsonStr) as Map<String, dynamic>;

        return Right(SOPScores(
          overallScore: data['overall_score'] as int? ?? 0,
          clarityScore: data['clarity_score'] as int? ?? 0,
          relevanceScore: data['relevance_score'] as int? ?? 0,
          toneScore: data['tone_score'] as int? ?? 0,
          wordCount: data['word_count'] as int? ?? 0,
          improvementSuggestions: List<String>.from(data['suggestions'] ?? []),
        ));
      } catch (e) {
        return Left(InvalidResponseException('Failed to parse scoring response: $e'));
      }
    });
  }

  String _extractJson(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start != -1 && end != -1 && end > start) {
      return text.substring(start, end + 1);
    }
    return '{}';
  }

  String _extractContentBeforeJson(String text) {
    final start = text.indexOf('{');
    if (start != -1) {
      // Remove any markdown block prefix if it ends exactly before json
      var content = text.substring(0, start).trim();
      if (content.endsWith('```json')) {
        content = content.substring(0, content.length - 7).trim();
      } else if (content.endsWith('```')) {
        content = content.substring(0, content.length - 3).trim();
      }
      return content;
    }
    return text;
  }
}
