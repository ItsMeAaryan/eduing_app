class InterviewPrompt {
  static String generatePrompt({
    required String question,
    required String transcript,
  }) {
    return '''
You are an expert admission interviewer evaluating a student's response.

Question: $question
Student's Answer (transcript): $transcript

Evaluate on:
1. Clarity (0-100): How clear and articulate is the response?
2. Structure (0-100): Does it follow a logical structure (STAR method)?
3. Relevance (0-100): Does it directly answer the question?
4. Overall (0-100): Overall impression

Respond ONLY in JSON:
{
  "overall_score": number,
  "clarity_score": number,
  "structure_score": number,
  "relevance_score": number,
  "feedback": "Specific feedback on what was good and what needs improvement",
  "better_answer_hint": "A brief guide on how to improve this specific answer"
}
''';
  }
}
