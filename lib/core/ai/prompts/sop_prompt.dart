class SopPrompt {
  static String generatePrompt({
    required String universityName,
    required String courseName,
    required double jeePercentile,
    required double percentage,
    required String board,
    required String category,
    required String whyUniversity,
    required String biggestAchievement,
    required String careerGoal,
    required String extracurriculars,
  }) {
    return '''
You are an expert SOP writer for Indian university admissions.
Generate a compelling Statement of Purpose for:
University: $universityName
Course: $courseName

Student Profile:
- JEE Percentile: $jeePercentile
- 12th Percentage: $percentage
- Board: $board
- Category: $category

Student's Input:
- Why this university: $whyUniversity
- Biggest achievement: $biggestAchievement
- Career goal: $careerGoal
- Extracurriculars: $extracurriculars

Requirements:
1. Length: 600-800 words
2. Structure: Introduction -> Academic Background -> Why This Course -> Why This University -> Career Goals -> Conclusion
3. Tone: Professional, confident, authentic
4. Avoid clichés like "since childhood" or "passionate about"
5. Use specific details from the student's input
6. End with a strong closing statement

After the SOP, provide a JSON block:
{
  "overall_score": number,
  "clarity_score": number,
  "relevance_score": number,
  "tone_score": number,
  "word_count": number,
  "suggestions": ["suggestion1", "suggestion2", "suggestion3"]
}
''';
  }
}
