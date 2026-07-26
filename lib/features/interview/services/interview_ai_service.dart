import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../../core/ai/gemini_service.dart';
import '../../../core/ai/exceptions/gemini_exception.dart';
import '../../../core/ai/prompts/interview_prompt.dart';

class InterviewQuestion {
  final String text;
  final String hint;

  const InterviewQuestion({required this.text, required this.hint});
}

class ResponseFeedback {
  final int score;
  final int clarityScore;
  final int structureScore;
  final int relevanceScore;
  final String feedback;
  final String betterAnswerHint;

  const ResponseFeedback({
    required this.score,
    required this.clarityScore,
    required this.structureScore,
    required this.relevanceScore,
    required this.feedback,
    required this.betterAnswerHint,
  });
}

class SessionSummary {
  final int averageScore;
  final String overallFeedback;
  final List<String> strengthAreas;
  final List<String> improvementAreas;

  const SessionSummary({
    required this.averageScore,
    required this.overallFeedback,
    required this.strengthAreas,
    required this.improvementAreas,
  });
}

class InterviewAiService {
  final GeminiService _geminiService;

  InterviewAiService(this._geminiService);

  Future<Either<GeminiException, List<InterviewQuestion>>> generateQuestions(String category, String universityName) async {
    final prompt = '''
Generate 3 realistic interview questions for a university admission interview at $universityName for the category: $category.
Return ONLY a JSON array of objects with "text" and "hint" fields.
''';

    final response = await _geminiService.generateText(
      prompt: prompt,
      modelType: GeminiModelType.flash,
    );

    return response.bind((text) {
      try {
        final jsonStr = _extractJsonArray(text);
        final data = jsonDecode(jsonStr) as List<dynamic>;
        
        final questions = data.map((q) => InterviewQuestion(
          text: q['text'] ?? '',
          hint: q['hint'] ?? '',
        )).toList();
        
        return Right(questions);
      } catch (e) {
        return Left(InvalidResponseException('Failed to parse questions: $e'));
      }
    });
  }

  Future<Either<GeminiException, ResponseFeedback>> analyzeResponse(String question, String transcript) async {
    final prompt = InterviewPrompt.generatePrompt(
      question: question,
      transcript: transcript,
    );

    final response = await _geminiService.generateText(
      prompt: prompt,
      modelType: GeminiModelType.pro,
    );

    return response.bind((text) {
      try {
        final jsonStr = _extractJson(text);
        final data = jsonDecode(jsonStr) as Map<String, dynamic>;

        return Right(ResponseFeedback(
          score: data['overall_score'] as int? ?? 0,
          clarityScore: data['clarity_score'] as int? ?? 0,
          structureScore: data['structure_score'] as int? ?? 0,
          relevanceScore: data['relevance_score'] as int? ?? 0,
          feedback: data['feedback'] ?? '',
          betterAnswerHint: data['better_answer_hint'] ?? '',
        ));
      } catch (e) {
        return Left(InvalidResponseException('Failed to parse feedback: $e'));
      }
    });
  }

  Future<Either<GeminiException, SessionSummary>> generateSessionSummary(List<ResponseFeedback> responses) async {
    if (responses.isEmpty) {
      return const Right(SessionSummary(
        averageScore: 0,
        overallFeedback: 'No responses provided.',
        strengthAreas: [],
        improvementAreas: [],
      ));
    }

    final averageScore = (responses.map((e) => e.score).reduce((a, b) => a + b) / responses.length).round();
    
    final prompt = '''
Based on these interview feedback summaries:
${responses.map((r) => "- ${r.feedback}").join('\\n')}

Provide an overall JSON summary:
{
  "overallFeedback": "String",
  "strengthAreas": ["String"],
  "improvementAreas": ["String"]
}
''';

    final response = await _geminiService.generateText(
      prompt: prompt,
      modelType: GeminiModelType.flash,
    );

    return response.bind((text) {
      try {
        final jsonStr = _extractJson(text);
        final data = jsonDecode(jsonStr) as Map<String, dynamic>;

        return Right(SessionSummary(
          averageScore: averageScore,
          overallFeedback: data['overallFeedback'] ?? '',
          strengthAreas: List<String>.from(data['strengthAreas'] ?? []),
          improvementAreas: List<String>.from(data['improvementAreas'] ?? []),
        ));
      } catch (e) {
        return Left(InvalidResponseException('Failed to parse session summary: $e'));
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

  String _extractJsonArray(String text) {
    final start = text.indexOf('[');
    final end = text.lastIndexOf(']');
    if (start != -1 && end != -1 && end > start) {
      return text.substring(start, end + 1);
    }
    return '[]';
  }
}
