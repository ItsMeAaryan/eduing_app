class SopSection {
  final String title;
  final String content;
  final bool isCompleted;

  const SopSection({
    required this.title,
    this.content = '',
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() =>
      {'title': title, 'content': content, 'isCompleted': isCompleted};
  factory SopSection.fromMap(Map<String, dynamic> map) => SopSection(
        title: map['title'] ?? '',
        content: map['content'] ?? '',
        isCompleted: map['isCompleted'] ?? false,
      );
}

class AISopRecommendation {
  final String text;
  final String priority;
  final String estimatedImprovement;
  final bool isCompleted;

  const AISopRecommendation({
    required this.text,
    required this.priority,
    required this.estimatedImprovement,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() => {
        'text': text,
        'priority': priority,
        'estimatedImprovement': estimatedImprovement,
        'isCompleted': isCompleted,
      };

  factory AISopRecommendation.fromMap(Map<String, dynamic> map) =>
      AISopRecommendation(
        text: map['text'] ?? '',
        priority: map['priority'] ?? 'Medium',
        estimatedImprovement: map['estimatedImprovement'] ?? '',
        isCompleted: map['isCompleted'] ?? false,
      );
}

class AISopReview {
  final int overallScore;
  final int grammar;
  final int clarity;
  final int structure;
  final int storytelling;
  final int researchDepth;
  final List<AISopRecommendation> recommendations;
  final List<String> strengths;

  const AISopReview({
    this.overallScore = 88,
    this.grammar = 94,
    this.clarity = 90,
    this.structure = 92,
    this.storytelling = 86,
    this.researchDepth = 85,
    this.recommendations = const [
      AISopRecommendation(
          text: 'Mention specific university professors or lab initiatives.',
          priority: 'High',
          estimatedImprovement: '+8% Alignment'),
      AISopRecommendation(
          text:
              'Smooth out transitions between academic history and career aspirations.',
          priority: 'Medium',
          estimatedImprovement: '+4% Structure'),
    ],
    this.strengths = const [
      'Compelling motivation paragraph',
      'Strong academic achievement references'
    ],
  });

  Map<String, dynamic> toMap() => {
        'overallScore': overallScore,
        'grammar': grammar,
        'clarity': clarity,
        'structure': structure,
        'storytelling': storytelling,
        'researchDepth': researchDepth,
        'recommendations': recommendations.map((r) => r.toMap()).toList(),
        'strengths': strengths,
      };

  factory AISopReview.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const AISopReview();
    return AISopReview(
      overallScore: map['overallScore'] ?? 88,
      grammar: map['grammar'] ?? 94,
      clarity: map['clarity'] ?? 90,
      structure: map['structure'] ?? 92,
      storytelling: map['storytelling'] ?? 86,
      researchDepth: map['researchDepth'] ?? 85,
      recommendations: (map['recommendations'] as List<dynamic>?)
              ?.map(
                  (r) => AISopRecommendation.fromMap(r as Map<String, dynamic>))
              .toList() ??
          const [],
      strengths: List<String>.from(map['strengths'] ?? []),
    );
  }
}

class UserSop {
  final String id;
  final String universityName;
  final String targetProgram;
  final String fullContent;
  final String lastUpdated;
  final double wordCountProgress;
  final int wordCount;
  final int aiSopScore;
  final List<SopSection> sections;
  final AISopReview review;

  const UserSop({
    required this.id,
    this.universityName = 'Stanford University',
    this.targetProgram = 'M.S. in Computer Science',
    this.fullContent = '',
    this.lastUpdated = 'Just now',
    this.wordCountProgress = 0.8,
    this.wordCount = 850,
    this.aiSopScore = 88,
    this.sections = const [],
    this.review = const AISopReview(),
  });

  UserSop copyWith({
    String? id,
    String? universityName,
    String? targetProgram,
    String? fullContent,
    String? lastUpdated,
    double? wordCountProgress,
    int? wordCount,
    int? aiSopScore,
    List<SopSection>? sections,
    AISopReview? review,
  }) {
    return UserSop(
      id: id ?? this.id,
      universityName: universityName ?? this.universityName,
      targetProgram: targetProgram ?? this.targetProgram,
      fullContent: fullContent ?? this.fullContent,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      wordCountProgress: wordCountProgress ?? this.wordCountProgress,
      wordCount: wordCount ?? this.wordCount,
      aiSopScore: aiSopScore ?? this.aiSopScore,
      sections: sections ?? this.sections,
      review: review ?? this.review,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'universityName': universityName,
        'targetProgram': targetProgram,
        'fullContent': fullContent,
        'lastUpdated': lastUpdated,
        'wordCountProgress': wordCountProgress,
        'wordCount': wordCount,
        'aiSopScore': aiSopScore,
        'sections': sections.map((s) => s.toMap()).toList(),
        'review': review.toMap(),
      };

  factory UserSop.fromMap(Map<String, dynamic> map, String docId) {
    return UserSop(
      id: docId,
      universityName: map['universityName'] ?? 'Target University',
      targetProgram: map['targetProgram'] ?? 'Degree Program',
      fullContent: map['fullContent'] ?? '',
      lastUpdated: map['lastUpdated'] ?? 'Today',
      wordCountProgress: (map['wordCountProgress'] as num?)?.toDouble() ?? 0.8,
      wordCount: map['wordCount'] ?? 850,
      aiSopScore: map['aiSopScore'] ?? 88,
      sections: (map['sections'] as List<dynamic>?)
              ?.map((s) => SopSection.fromMap(s as Map<String, dynamic>))
              .toList() ??
          const [],
      review: AISopReview.fromMap(map['review'] as Map<String, dynamic>?),
    );
  }
}
