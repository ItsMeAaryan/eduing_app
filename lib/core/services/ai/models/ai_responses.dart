class ResumeReview {
  final int atsScore;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> missingSkills;
  final List<String> recommendations;
  final String summary;

  ResumeReview({
    required this.atsScore,
    required this.strengths,
    required this.weaknesses,
    required this.missingSkills,
    required this.recommendations,
    required this.summary,
  });

  factory ResumeReview.fromJson(Map<String, dynamic> json) {
    return ResumeReview(
      atsScore: json['atsScore'] ?? 0,
      strengths: List<String>.from(json['strengths'] ?? []),
      weaknesses: List<String>.from(json['weaknesses'] ?? []),
      missingSkills: List<String>.from(json['missingSkills'] ?? []),
      recommendations: List<String>.from(json['recommendations'] ?? []),
      summary: json['summary'] ?? '',
    );
  }
}

class SOPReview {
  final int overallScore;
  final String grammar;
  final String clarity;
  final String impact;
  final List<String> suggestions;
  final String rewrittenExample;

  SOPReview({
    required this.overallScore,
    required this.grammar,
    required this.clarity,
    required this.impact,
    required this.suggestions,
    required this.rewrittenExample,
  });

  factory SOPReview.fromJson(Map<String, dynamic> json) {
    return SOPReview(
      overallScore: json['overallScore'] ?? 0,
      grammar: json['grammar'] ?? '',
      clarity: json['clarity'] ?? '',
      impact: json['impact'] ?? '',
      suggestions: List<String>.from(json['suggestions'] ?? []),
      rewrittenExample: json['rewrittenExample'] ?? '',
    );
  }
}

class DocumentAnalysis {
  final String documentType;
  final List<String> importantInfo;
  final List<String> missingFields;
  final int confidenceScore;

  DocumentAnalysis({
    required this.documentType,
    required this.importantInfo,
    required this.missingFields,
    required this.confidenceScore,
  });

  factory DocumentAnalysis.fromJson(Map<String, dynamic> json) {
    return DocumentAnalysis(
      documentType: json['documentType'] ?? 'Unknown',
      importantInfo: List<String>.from(json['importantInfo'] ?? []),
      missingFields: List<String>.from(json['missingFields'] ?? []),
      confidenceScore: json['confidenceScore'] ?? 0,
    );
  }
}

class InterviewFeedback {
  final int confidenceScore;
  final String communication;
  final String technicalDepth;
  final String behavioralFeedback;
  final String improvementPlan;

  InterviewFeedback({
    required this.confidenceScore,
    required this.communication,
    required this.technicalDepth,
    required this.behavioralFeedback,
    required this.improvementPlan,
  });

  factory InterviewFeedback.fromJson(Map<String, dynamic> json) {
    return InterviewFeedback(
      confidenceScore: json['confidenceScore'] ?? 0,
      communication: json['communication'] ?? '',
      technicalDepth: json['technicalDepth'] ?? '',
      behavioralFeedback: json['behavioralFeedback'] ?? '',
      improvementPlan: json['improvementPlan'] ?? '',
    );
  }
}

class ScholarshipRecommendation {
  final String title;
  final String amount;
  final String reason;

  ScholarshipRecommendation({
    required this.title,
    required this.amount,
    required this.reason,
  });

  factory ScholarshipRecommendation.fromJson(Map<String, dynamic> json) {
    return ScholarshipRecommendation(
      title: json['title'] ?? '',
      amount: json['amount'] ?? '',
      reason: json['reason'] ?? '',
    );
  }
}

class UniversityRecommendation {
  final String name;
  final String matchReason;
  final int matchScore;

  UniversityRecommendation({
    required this.name,
    required this.matchReason,
    required this.matchScore,
  });

  factory UniversityRecommendation.fromJson(Map<String, dynamic> json) {
    return UniversityRecommendation(
      name: json['name'] ?? '',
      matchReason: json['matchReason'] ?? '',
      matchScore: json['matchScore'] ?? 0,
    );
  }
}
