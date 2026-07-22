class ResumeSection {
  final String title;
  final bool isCompleted;

  const ResumeSection({required this.title, required this.isCompleted});

  Map<String, dynamic> toMap() => {'title': title, 'isCompleted': isCompleted};
  factory ResumeSection.fromMap(Map<String, dynamic> map) => ResumeSection(
        title: map['title'] ?? '',
        isCompleted: map['isCompleted'] ?? false,
      );
}

class AIRecommendation {
  final String text;
  final String priority; // 'High', 'Medium', 'Low'
  final String estimatedImpact;
  final bool isCompleted;

  const AIRecommendation({
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

  factory AIRecommendation.fromMap(Map<String, dynamic> map) => AIRecommendation(
        text: map['text'] ?? '',
        priority: map['priority'] ?? 'Medium',
        estimatedImpact: map['estimatedImpact'] ?? '',
        isCompleted: map['isCompleted'] ?? false,
      );
}

class AIResumeReview {
  final int overallScore;
  final int atsCompatibility;
  final int grammarScore;
  final int formattingScore;
  final int skillsCoverage;
  final List<AIRecommendation> recommendations;
  final List<String> strengths;

  const AIResumeReview({
    this.overallScore = 85,
    this.atsCompatibility = 90,
    this.grammarScore = 95,
    this.formattingScore = 88,
    this.skillsCoverage = 82,
    this.recommendations = const [
      AIRecommendation(text: 'Add quantifiable metrics to work experience bullets.', priority: 'High', estimatedImpact: '+8% ATS Score'),
      AIRecommendation(text: 'Include relevant technical keywords for target program.', priority: 'Medium', estimatedImpact: '+5% ATS Score'),
    ],
    this.strengths = const ['Clean layout formatting', 'Clear academic highlights'],
  });

  Map<String, dynamic> toMap() => {
        'overallScore': overallScore,
        'atsCompatibility': atsCompatibility,
        'grammarScore': grammarScore,
        'formattingScore': formattingScore,
        'skillsCoverage': skillsCoverage,
        'recommendations': recommendations.map((r) => r.toMap()).toList(),
        'strengths': strengths,
      };

  factory AIResumeReview.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const AIResumeReview();
    return AIResumeReview(
      overallScore: map['overallScore'] ?? 85,
      atsCompatibility: map['atsCompatibility'] ?? 90,
      grammarScore: map['grammarScore'] ?? 95,
      formattingScore: map['formattingScore'] ?? 88,
      skillsCoverage: map['skillsCoverage'] ?? 82,
      recommendations: (map['recommendations'] as List<dynamic>?)
              ?.map((r) => AIRecommendation.fromMap(r as Map<String, dynamic>))
              .toList() ??
          const [],
      strengths: List<String>.from(map['strengths'] ?? []),
    );
  }
}

class UserResume {
  final String id;
  final String title;
  final String template; // 'Modern', 'Executive', 'Academic', 'Minimal'
  final String fullName;
  final String email;
  final String phone;
  final String location;
  final String summary;
  final List<String> education;
  final List<String> experience;
  final List<String> skills;
  final List<String> projects;
  final String lastUpdated;
  final double completionPercentage;
  final int atsReadiness;
  final int aiResumeScore;
  final AIResumeReview review;

  const UserResume({
    required this.id,
    this.title = 'Master Academic Resume',
    this.template = 'Modern',
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.location = '',
    this.summary = '',
    this.education = const [],
    this.experience = const [],
    this.skills = const [],
    this.projects = const [],
    this.lastUpdated = 'Just now',
    this.completionPercentage = 0.85,
    this.atsReadiness = 90,
    this.aiResumeScore = 88,
    this.review = const AIResumeReview(),
  });

  UserResume copyWith({
    String? id,
    String? title,
    String? template,
    String? fullName,
    String? email,
    String? phone,
    String? location,
    String? summary,
    List<String>? education,
    List<String>? experience,
    List<String>? skills,
    List<String>? projects,
    String? lastUpdated,
    double? completionPercentage,
    int? atsReadiness,
    int? aiResumeScore,
    AIResumeReview? review,
  }) {
    return UserResume(
      id: id ?? this.id,
      title: title ?? this.title,
      template: template ?? this.template,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      summary: summary ?? this.summary,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      skills: skills ?? this.skills,
      projects: projects ?? this.projects,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      atsReadiness: atsReadiness ?? this.atsReadiness,
      aiResumeScore: aiResumeScore ?? this.aiResumeScore,
      review: review ?? this.review,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'template': template,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'location': location,
        'summary': summary,
        'education': education,
        'experience': experience,
        'skills': skills,
        'projects': projects,
        'lastUpdated': lastUpdated,
        'completionPercentage': completionPercentage,
        'atsReadiness': atsReadiness,
        'aiResumeScore': aiResumeScore,
        'review': review.toMap(),
      };

  factory UserResume.fromMap(Map<String, dynamic> map, String docId) {
    return UserResume(
      id: docId,
      title: map['title'] ?? 'My Resume',
      template: map['template'] ?? 'Modern',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      location: map['location'] ?? '',
      summary: map['summary'] ?? '',
      education: List<String>.from(map['education'] ?? []),
      experience: List<String>.from(map['experience'] ?? []),
      skills: List<String>.from(map['skills'] ?? []),
      projects: List<String>.from(map['projects'] ?? []),
      lastUpdated: map['lastUpdated'] ?? 'Today',
      completionPercentage: (map['completionPercentage'] as num?)?.toDouble() ?? 0.8,
      atsReadiness: map['atsReadiness'] ?? 85,
      aiResumeScore: map['aiResumeScore'] ?? 88,
      review: AIResumeReview.fromMap(map['review'] as Map<String, dynamic>?),
    );
  }
}
