class InterviewQuestion {
  final String id;
  final String category;
  final String question;
  final List<String> hints;
  final String suggestedStructure;
  final String sampleAnswer;
  final List<String> preparationTips;
  final bool isPracticed;
  final bool isBookmarked;

  const InterviewQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.hints,
    required this.suggestedStructure,
    required this.sampleAnswer,
    required this.preparationTips,
    this.isPracticed = false,
    this.isBookmarked = false,
  });
}

class AIInterviewReport {
  final int overallScore;
  final int confidence;
  final int communication;
  final int technicalKnowledge;
  final int problemSolving;
  final int leadership;
  final int clarity;
  final int vocabulary;
  final int bodyLanguage;
  final int eyeContact;
  final int speakingPace;
  final List<AIInterviewRecommendation> recommendations;
  final List<String> strengths;

  const AIInterviewReport({
    this.overallScore = 0,
    this.confidence = 0,
    this.communication = 0,
    this.technicalKnowledge = 0,
    this.problemSolving = 0,
    this.leadership = 0,
    this.clarity = 0,
    this.vocabulary = 0,
    this.bodyLanguage = 0,
    this.eyeContact = 0,
    this.speakingPace = 0,
    this.recommendations = const [],
    this.strengths = const [],
  });
}

class AIInterviewRecommendation {
  final String text;
  final String priority;
  final String estimatedImpact;
  final bool isCompleted;

  const AIInterviewRecommendation({
    required this.text,
    required this.priority,
    required this.estimatedImpact,
    this.isCompleted = false,
  });
}

class InterviewSession {
  final String id;
  final String date;
  final String university;
  final String duration;
  final int overallScore;
  final String improvement;

  const InterviewSession({
    required this.id,
    required this.date,
    required this.university,
    required this.duration,
    required this.overallScore,
    required this.improvement,
  });
}

class InterviewDashboardData {
  final int overallReadiness;
  final int confidenceScore;
  final int communicationScore;
  final int technicalScore;
  final int behavioralScore;
  final int universityFitScore;
  final double completionPercentage;
  final List<InterviewQuestion> questions;
  final List<InterviewSession> history;

  const InterviewDashboardData({
    required this.overallReadiness,
    required this.confidenceScore,
    required this.communicationScore,
    required this.technicalScore,
    required this.behavioralScore,
    required this.universityFitScore,
    required this.completionPercentage,
    required this.questions,
    required this.history,
  });
}
