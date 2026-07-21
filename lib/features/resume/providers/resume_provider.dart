import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/resume_model.dart';

final resumeProvider = StateNotifierProvider<ResumeNotifier, UserResume>((ref) {
  return ResumeNotifier();
});

class ResumeNotifier extends StateNotifier<UserResume> {
  ResumeNotifier() : super(_initialData());

  static UserResume _initialData() {
    return const UserResume(
      id: 'resume_1',
      name: 'Primary Application Resume',
      lastUpdated: 'Just now',
      completionPercentage: 0.85,
      atsReadiness: 92,
      aiResumeScore: 88,
      sections: [
        ResumeSection(title: 'Personal Information', isCompleted: true),
        ResumeSection(title: 'Education', isCompleted: true),
        ResumeSection(title: 'Experience', isCompleted: true),
        ResumeSection(title: 'Projects', isCompleted: true),
        ResumeSection(title: 'Research', isCompleted: false),
        ResumeSection(title: 'Achievements', isCompleted: true),
        ResumeSection(title: 'Skills', isCompleted: true),
        ResumeSection(title: 'Languages', isCompleted: true),
        ResumeSection(title: 'Certifications', isCompleted: false),
        ResumeSection(title: 'Publications', isCompleted: false),
        ResumeSection(title: 'Volunteer Experience', isCompleted: false),
        ResumeSection(title: 'Extracurricular Activities', isCompleted: true),
      ],
      review: AIResumeReview(
        overallScore: 88,
        atsCompatibility: 92,
        grammarScore: 98,
        formattingScore: 95,
        skillsCoverage: 85,
        leadership: 70,
        researchProfile: 40,
        projectQuality: 90,
        achievements: 85,
        careerReadiness: 88,
        recommendations: [
          AIRecommendation(text: 'Add measurable achievements to your internship experience.', priority: 'High', estimatedImpact: '+5% ATS Score', isCompleted: false),
          AIRecommendation(text: 'Include more backend technical skills in the skills section.', priority: 'Medium', estimatedImpact: '+3% Skills Coverage', isCompleted: false),
          AIRecommendation(text: 'Quantify the impact of your major projects.', priority: 'High', estimatedImpact: '+8% Project Quality', isCompleted: false),
          AIRecommendation(text: 'Improve formatting consistency in the achievements section.', priority: 'Low', estimatedImpact: '+2% Formatting Score', isCompleted: true),
        ],
        strengths: [
          'Excellent academic record.',
          'Strong project portfolio demonstrating full-stack capability.',
          'Well-balanced skill set between technical and soft skills.',
          'Grammar and spelling are perfect.',
        ],
      ),
    );
  }
}
