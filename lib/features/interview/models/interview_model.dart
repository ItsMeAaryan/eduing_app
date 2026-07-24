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

  Map<String, dynamic> toMap() => {
        'id': id,
        'category': category,
        'question': question,
        'hints': hints,
        'suggestedStructure': suggestedStructure,
        'sampleAnswer': sampleAnswer,
        'preparationTips': preparationTips,
        'isPracticed': isPracticed,
        'isBookmarked': isBookmarked,
      };

  factory InterviewQuestion.fromMap(Map<String, dynamic> map) =>
      InterviewQuestion(
        id: map['id'] ?? '',
        category: map['category'] ?? 'General',
        question: map['question'] ?? '',
        hints: List<String>.from(map['hints'] ?? []),
        suggestedStructure: map['suggestedStructure'] ?? '',
        sampleAnswer: map['sampleAnswer'] ?? '',
        preparationTips: List<String>.from(map['preparationTips'] ?? []),
        isPracticed: map['isPracticed'] ?? false,
        isBookmarked: map['isBookmarked'] ?? false,
      );
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

  Map<String, dynamic> toMap() => {
        'text': text,
        'priority': priority,
        'estimatedImpact': estimatedImpact,
        'isCompleted': isCompleted,
      };

  factory AIInterviewRecommendation.fromMap(Map<String, dynamic> map) =>
      AIInterviewRecommendation(
        text: map['text'] ?? '',
        priority: map['priority'] ?? 'Medium',
        estimatedImpact: map['estimatedImpact'] ?? '',
        isCompleted: map['isCompleted'] ?? false,
      );
}

class AIInterviewReport {
  final int overallScore;
  final int confidence;
  final int communication;
  final int technicalKnowledge;
  final int clarity;
  final List<AIInterviewRecommendation> recommendations;
  final List<String> strengths;

  const AIInterviewReport({
    this.overallScore = 86,
    this.confidence = 88,
    this.communication = 84,
    this.technicalKnowledge = 90,
    this.clarity = 85,
    this.recommendations = const [
      AIInterviewRecommendation(
          text:
              'Structure answers using the STAR method (Situation, Task, Action, Result).',
          priority: 'High',
          estimatedImpact: '+10% Communication'),
      AIInterviewRecommendation(
          text:
              'Elaborate on specific research methodologies during technical questions.',
          priority: 'Medium',
          estimatedImpact: '+5% Technical'),
    ],
    this.strengths = const [
      'Clear vocal articulation',
      'Strong explanation of project achievements'
    ],
  });

  Map<String, dynamic> toMap() => {
        'overallScore': overallScore,
        'confidence': confidence,
        'communication': communication,
        'technicalKnowledge': technicalKnowledge,
        'clarity': clarity,
        'recommendations': recommendations.map((r) => r.toMap()).toList(),
        'strengths': strengths,
      };

  factory AIInterviewReport.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const AIInterviewReport();
    return AIInterviewReport(
      overallScore: map['overallScore'] ?? 86,
      confidence: map['confidence'] ?? 88,
      communication: map['communication'] ?? 84,
      technicalKnowledge: map['technicalKnowledge'] ?? 90,
      clarity: map['clarity'] ?? 85,
      recommendations: (map['recommendations'] as List<dynamic>?)
              ?.map((r) =>
                  AIInterviewRecommendation.fromMap(r as Map<String, dynamic>))
              .toList() ??
          const [],
      strengths: List<String>.from(map['strengths'] ?? []),
    );
  }
}

class InterviewSession {
  final String id;
  final String date;
  final String questionTitle;
  final String userTranscript;
  final int score;
  final AIInterviewReport report;

  const InterviewSession({
    required this.id,
    required this.date,
    required this.questionTitle,
    required this.userTranscript,
    required this.score,
    this.report = const AIInterviewReport(),
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date,
        'questionTitle': questionTitle,
        'userTranscript': userTranscript,
        'score': score,
        'report': report.toMap(),
      };

  factory InterviewSession.fromMap(Map<String, dynamic> map, String docId) =>
      InterviewSession(
        id: docId,
        date: map['date'] ?? 'Today',
        questionTitle: map['questionTitle'] ?? 'Mock Question',
        userTranscript: map['userTranscript'] ?? '',
        score: map['score'] ?? 85,
        report:
            AIInterviewReport.fromMap(map['report'] as Map<String, dynamic>?),
      );
}
