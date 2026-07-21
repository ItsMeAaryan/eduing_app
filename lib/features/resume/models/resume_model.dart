class ResumeSection {
  final String title;
  final bool isCompleted;

  const ResumeSection({required this.title, required this.isCompleted});
}

class AIResumeReview {
  final int overallScore;
  final int atsCompatibility;
  final int grammarScore;
  final int formattingScore;
  final int skillsCoverage;
  final int leadership;
  final int researchProfile;
  final int projectQuality;
  final int achievements;
  final int careerReadiness;
  final List<AIRecommendation> recommendations;
  final List<String> strengths;

  const AIResumeReview({
    this.overallScore = 0,
    this.atsCompatibility = 0,
    this.grammarScore = 0,
    this.formattingScore = 0,
    this.skillsCoverage = 0,
    this.leadership = 0,
    this.researchProfile = 0,
    this.projectQuality = 0,
    this.achievements = 0,
    this.careerReadiness = 0,
    this.recommendations = const [],
    this.strengths = const [],
  });
}

class AIRecommendation {
  final String text;
  final String priority; // 'High', 'Medium', 'Low'
  final String estimatedImpact; // e.g. '+5% ATS Score'
  final bool isCompleted;

  const AIRecommendation({
    required this.text,
    required this.priority,
    required this.estimatedImpact,
    this.isCompleted = false,
  });
}

class UserResume {
  final String id;
  final String name;
  final String lastUpdated;
  final double completionPercentage;
  final int atsReadiness;
  final int aiResumeScore;
  final List<ResumeSection> sections;
  final AIResumeReview review;

  const UserResume({
    required this.id,
    required this.name,
    required this.lastUpdated,
    required this.completionPercentage,
    required this.atsReadiness,
    required this.aiResumeScore,
    required this.sections,
    required this.review,
  });
}
