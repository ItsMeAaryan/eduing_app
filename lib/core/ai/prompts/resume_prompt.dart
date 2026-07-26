class ResumePrompt {
  static String generatePrompt({
    required String targetRole,
    required String resumeJson,
  }) {
    return '''
You are an ATS (Applicant Tracking System) expert.
Analyze this resume for a $targetRole position at top engineering colleges in India.

Resume Content:
$resumeJson

Score the resume on:
1. Keywords (0-100): Presence of role-relevant technical keywords
2. Format (0-100): Structure, sections, consistency
3. Length (0-100): Appropriate length (1 page ideal for freshers)

Respond ONLY in JSON:
{
  "ats_score": number,
  "keywords_score": number,
  "format_score": number,
  "length_score": number,
  "missing_keywords": ["keyword1", "keyword2", "keyword3"],
  "suggestions": [
    "Add quantified achievements like 'Led team of X, improved Y by Z%'",
    "Include more technical keywords: machine learning, Python, data structures"
  ],
  "strength_areas": ["Strong education section", "Good project descriptions"]
}
''';
  }
}
