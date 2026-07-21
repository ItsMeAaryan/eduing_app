class SopSection {
  final String title;
  final String content;
  final bool isCompleted;

  const SopSection({
    required this.title,
    this.content = '',
    this.isCompleted = false,
  });
}

class AISopReview {
  final int overallScore;
  final int grammar;
  final int clarity;
  final int structure;
  final int storytelling;
  final int originality;
  final int researchDepth;
  final int goalAlignment;
  final int universityAlignment;
  final int professionalTone;
  final List<AISopRecommendation> recommendations;
  final List<String> strengths;

  const AISopReview({
    this.overallScore = 0,
    this.grammar = 0,
    this.clarity = 0,
    this.structure = 0,
    this.storytelling = 0,
    this.originality = 0,
    this.researchDepth = 0,
    this.goalAlignment = 0,
    this.universityAlignment = 0,
    this.professionalTone = 0,
    this.recommendations = const [],
    this.strengths = const [],
  });
}

class AISopRecommendation {
  final String text;
  final String priority; // 'High', 'Medium', 'Low'
  final String estimatedImprovement; // e.g. '+5% Storytelling'
  final bool isCompleted;

  const AISopRecommendation({
    required this.text,
    required this.priority,
    required this.estimatedImprovement,
    this.isCompleted = false,
  });
}

class UserSop {
  final String id;
  final String universityName;
  final String lastUpdated;
  final double completionPercentage;
  final int wordCount;
  final int paragraphCount;
  final int estimatedReadingTimeMinutes;
  final int aiSopScore;
  final List<SopSection> sections;
  final AISopReview review;

  const UserSop({
    required this.id,
    required this.universityName,
    required this.lastUpdated,
    required this.completionPercentage,
    required this.wordCount,
    required this.paragraphCount,
    required this.estimatedReadingTimeMinutes,
    required this.aiSopScore,
    required this.sections,
    required this.review,
  });
}
