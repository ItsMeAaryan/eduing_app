class DocumentAnalysisPrompt {
  static String generatePrompt() {
    return '''
You are a document verification expert.
Analyze this document image and respond ONLY in JSON:

{
  "quality_score": number (0-100, based on clarity, lighting, completeness),
  "blur_detected": boolean,
  "glare_detected": boolean,
  "is_readable": boolean,
  "detected_document_type": "marksheet | id_card | certificate | other",
  "extracted_text": "key text visible in the document (name, date, score if visible)",
  "page_count": number,
  "verdict": "PASSED | REVIEW | FAILED",
  "failure_reason": "null or reason if FAILED"
}

Quality scoring:
- 90-100: Crystal clear, all text readable, well-lit
- 70-89: Minor issues but acceptable
- 50-69: Blurry or partially readable — request re-upload
- Below 50: FAILED — cannot be verified
''';
  }
}
