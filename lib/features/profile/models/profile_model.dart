class ProfileData {
  final String name;
  final String email;
  final String photoUrl;
  final String educationLevel;
  final String targetDegree;
  final List<String> targetCountries;
  final List<String> targetUniversities;
  final int profileCompletionPercentage;
  final int aiReadinessScore;

  // Academic
  final String currentGpa;
  final String standardizedTests;
  final String researchExperience;
  final String projects;
  final String skills;

  // Preferences
  final String budget;
  final String scholarshipPreference;
  final String studyMode;

  // Stats
  final int applicationsSubmitted;
  final int scholarshipsSaved;
  final int resumeScore;
  final int sopScore;
  final int interviewScore;
  final int upcomingDeadlines;

  // AI Insights
  final List<String> aiInsights;
  final List<String> achievements;

  const ProfileData({
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.educationLevel,
    required this.targetDegree,
    required this.targetCountries,
    required this.targetUniversities,
    required this.profileCompletionPercentage,
    required this.aiReadinessScore,
    required this.currentGpa,
    required this.standardizedTests,
    required this.researchExperience,
    required this.projects,
    required this.skills,
    required this.budget,
    required this.scholarshipPreference,
    required this.studyMode,
    required this.applicationsSubmitted,
    required this.scholarshipsSaved,
    required this.resumeScore,
    required this.sopScore,
    required this.interviewScore,
    required this.upcomingDeadlines,
    required this.aiInsights,
    required this.achievements,
  });

  ProfileData copyWith({
    String? name,
    String? email,
    String? photoUrl,
    String? educationLevel,
    String? targetDegree,
    List<String>? targetCountries,
    List<String>? targetUniversities,
    int? profileCompletionPercentage,
    int? aiReadinessScore,
    String? currentGpa,
    String? standardizedTests,
    String? researchExperience,
    String? projects,
    String? skills,
    String? budget,
    String? scholarshipPreference,
    String? studyMode,
    int? applicationsSubmitted,
    int? scholarshipsSaved,
    int? resumeScore,
    int? sopScore,
    int? interviewScore,
    int? upcomingDeadlines,
    List<String>? aiInsights,
    List<String>? achievements,
  }) {
    return ProfileData(
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      educationLevel: educationLevel ?? this.educationLevel,
      targetDegree: targetDegree ?? this.targetDegree,
      targetCountries: targetCountries ?? this.targetCountries,
      targetUniversities: targetUniversities ?? this.targetUniversities,
      profileCompletionPercentage: profileCompletionPercentage ?? this.profileCompletionPercentage,
      aiReadinessScore: aiReadinessScore ?? this.aiReadinessScore,
      currentGpa: currentGpa ?? this.currentGpa,
      standardizedTests: standardizedTests ?? this.standardizedTests,
      researchExperience: researchExperience ?? this.researchExperience,
      projects: projects ?? this.projects,
      skills: skills ?? this.skills,
      budget: budget ?? this.budget,
      scholarshipPreference: scholarshipPreference ?? this.scholarshipPreference,
      studyMode: studyMode ?? this.studyMode,
      applicationsSubmitted: applicationsSubmitted ?? this.applicationsSubmitted,
      scholarshipsSaved: scholarshipsSaved ?? this.scholarshipsSaved,
      resumeScore: resumeScore ?? this.resumeScore,
      sopScore: sopScore ?? this.sopScore,
      interviewScore: interviewScore ?? this.interviewScore,
      upcomingDeadlines: upcomingDeadlines ?? this.upcomingDeadlines,
      aiInsights: aiInsights ?? this.aiInsights,
      achievements: achievements ?? this.achievements,
    );
  }
}
