import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_model.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileData>((ref) {
  return ProfileNotifier();
});

class ProfileNotifier extends StateNotifier<ProfileData> {
  ProfileNotifier() : super(_initialData());

  static ProfileData _initialData() {
    return const ProfileData(
      name: 'Prince Mittal',
      email: 'prince.mittal@example.com',
      photoUrl: 'https://i.pravatar.cc/150?img=11',
      educationLevel: 'Undergraduate',
      targetDegree: 'MS Computer Science',
      targetCountries: ['USA', 'UK', 'Canada'],
      targetUniversities: ['Stanford', 'MIT', 'Imperial College'],
      profileCompletionPercentage: 85,
      aiReadinessScore: 92,
      currentGpa: '3.8/4.0',
      standardizedTests: 'GRE: 325, TOEFL: 110',
      researchExperience: '2 Publications in ML',
      projects: 'AI Scholarship Hub, Auto-Scheduler',
      skills: 'Python, Flutter, Machine Learning, Data Structures',
      budget: '\$30k - \$50k / year',
      scholarshipPreference: 'Merit-based, STEM',
      studyMode: 'On-campus, Full-time',
      applicationsSubmitted: 4,
      scholarshipsSaved: 12,
      resumeScore: 95,
      sopScore: 88,
      interviewScore: 82,
      upcomingDeadlines: 3,
      aiInsights: [
        'Your profile is highly competitive for Top 20 CS programs.',
        'Consider improving your SOP by adding more concrete examples of your leadership skills.',
        'Your scholarship readiness is very high. Make sure to apply to the STEM Innovators Grant.'
      ],
      achievements: [
        'Profile Created',
        'First Application Submitted',
        'Resume Scored 90+',
        'AI Mock Interview Passed'
      ],
    );
  }

  void updateField({String? name, String? currentGpa, String? skills}) {
    state = state.copyWith(
      name: name,
      currentGpa: currentGpa,
      skills: skills,
    );
  }
}
