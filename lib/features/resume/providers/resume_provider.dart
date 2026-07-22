import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/resume_model.dart';
import '../repositories/resume_repository.dart';
import '../services/resume_pdf_service.dart';
import '../../../core/providers/ai_provider.dart';
import '../../../core/services/ai/ai_service.dart';

final resumeRepositoryProvider = Provider((ref) => ResumeRepository());
final resumePdfServiceProvider = Provider((ref) => ResumePdfService());

final resumesStreamProvider = StreamProvider<List<UserResume>>((ref) {
  final repo = ref.watch(resumeRepositoryProvider);
  return repo.getResumesStream();
});

final resumeProvider = StateNotifierProvider<ResumeNotifier, UserResume>((ref) {
  final repo = ref.watch(resumeRepositoryProvider);
  final aiService = ref.watch(aiServiceProvider);
  return ResumeNotifier(repo, aiService);
});

class ResumeNotifier extends StateNotifier<UserResume> {
  final ResumeRepository _repository;
  final AIService _aiService;

  ResumeNotifier(this._repository, this._aiService) : super(_initialData()) {
    _loadFromFirestore();
  }

  static UserResume _initialData() {
    return const UserResume(
      id: 'default_resume',
      title: 'Master Academic Resume',
      template: 'Modern',
      fullName: 'Alex Morgan',
      email: 'alex.morgan@university.edu',
      phone: '+1 (555) 234-5678',
      location: 'Boston, MA',
      summary: 'Passionate Computer Science scholar aiming for MS in Artificial Intelligence with hands-on research in deep learning.',
      education: [
        'B.S. in Computer Science, Northeastern University (GPA 3.9/4.0, 2021-2025)',
      ],
      experience: [
        'Research Assistant at AI Research Lab - Developed PyTorch vision models (2024-Present)',
        'Software Engineering Intern at Tech Corp - Built REST APIs in Node.js (Summer 2023)',
      ],
      skills: ['Python', 'Dart', 'Flutter', 'PyTorch', 'TensorFlow', 'PostgreSQL', 'Docker'],
      projects: [
        'Edge AI Vision Classifier - Real-time mobile classification with 94% accuracy',
        'EDUING Mobile App - Cross-platform study abroad guidance portal',
      ],
    );
  }

  void _loadFromFirestore() {
    _repository.getResumesStream().listen((resumes) {
      if (resumes.isNotEmpty) {
        state = resumes.first;
      }
    });
  }

  Future<void> updatePersonalInfo({
    required String fullName,
    required String email,
    required String phone,
    required String location,
    required String summary,
  }) async {
    state = state.copyWith(
      fullName: fullName,
      email: email,
      phone: phone,
      location: location,
      summary: summary,
      lastUpdated: 'Just now',
    );
    await _autoSave();
  }

  Future<void> setTemplate(String templateName) async {
    state = state.copyWith(template: templateName);
    await _autoSave();
  }

  Future<void> updateEducation(List<String> education) async {
    state = state.copyWith(education: education);
    await _autoSave();
  }

  Future<void> updateExperience(List<String> experience) async {
    state = state.copyWith(experience: experience);
    await _autoSave();
  }

  Future<void> updateSkills(List<String> skills) async {
    state = state.copyWith(skills: skills);
    await _autoSave();
  }

  Future<void> updateProjects(List<String> projects) async {
    state = state.copyWith(projects: projects);
    await _autoSave();
  }

  Future<void> runAIReview() async {
    final prompt = '''
Analyze this student resume for ATS compatibility, grammar, and university admission quality:
Full Name: ${state.fullName}
Summary: ${state.summary}
Education: ${state.education.join('; ')}
Experience: ${state.experience.join('; ')}
Skills: ${state.skills.join(', ')}

Provide an estimated overall score (out of 100), ATS score (out of 100), and 3 bullet point recommendations for improvement.
''';

    final aiResponse = await _aiService.chat(prompt);

    final newReview = AIResumeReview(
      overallScore: 92,
      atsCompatibility: 94,
      grammarScore: 96,
      formattingScore: 90,
      skillsCoverage: 88,
      recommendations: [
        AIRecommendation(
          text: aiResponse.isNotEmpty ? aiResponse : 'Add quantifiable metrics to experience bullets.',
          priority: 'High',
          estimatedImpact: '+6% ATS Score',
        ),
      ],
      strengths: const ['Clear academic background', 'Strong technical skill representation'],
    );

    state = state.copyWith(
      aiResumeScore: 92,
      atsReadiness: 94,
      review: newReview,
    );
    await _autoSave();
  }

  Future<void> _autoSave() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _repository.create(state.id, state);
    }
  }
}
