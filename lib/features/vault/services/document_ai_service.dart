import 'dart:io';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../../core/ai/gemini_service.dart';
import '../../../core/ai/exceptions/gemini_exception.dart';
import '../../../core/ai/prompts/document_analysis_prompt.dart';

class DocumentAnalysis {
  final int qualityScore;
  final bool blurDetected;
  final bool glareDetected;
  final bool isReadable;
  final String detectedType;
  final String extractedText;
  final int pageCount;
  final String verdict;
  final String? failureReason;

  const DocumentAnalysis({
    required this.qualityScore,
    required this.blurDetected,
    required this.glareDetected,
    required this.isReadable,
    required this.detectedType,
    required this.extractedText,
    required this.pageCount,
    required this.verdict,
    this.failureReason,
  });
}

class DocumentAiService {
  final GeminiService _geminiService;

  DocumentAiService(this._geminiService);

  Future<Either<GeminiException, DocumentAnalysis>> analyzeDocument(File imageFile, String documentType) async {
    final prompt = '''
${DocumentAnalysisPrompt.generatePrompt()}

Expected Document Type: $documentType
''';

    final response = await _geminiService.generateTextWithImage(
      prompt: prompt,
      imageFile: imageFile,
      modelType: GeminiModelType.pro,
    );

    return response.bind((text) {
      try {
        final jsonStr = _extractJson(text);
        final data = jsonDecode(jsonStr) as Map<String, dynamic>;

        return Right(DocumentAnalysis(
          qualityScore: data['quality_score'] as int? ?? 0,
          blurDetected: data['blur_detected'] as bool? ?? false,
          glareDetected: data['glare_detected'] as bool? ?? false,
          isReadable: data['is_readable'] as bool? ?? true,
          detectedType: data['detected_document_type'] ?? 'unknown',
          extractedText: data['extracted_text'] ?? '',
          pageCount: data['page_count'] as int? ?? 1,
          verdict: data['verdict'] ?? 'REVIEW',
          failureReason: data['failure_reason'],
        ));
      } catch (e) {
        return Left(InvalidResponseException('Failed to parse document analysis: $e'));
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
}
