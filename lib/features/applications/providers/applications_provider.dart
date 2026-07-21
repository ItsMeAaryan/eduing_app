import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../universities/providers/universities_provider.dart';
import '../models/university_application.dart';

final applicationsProvider = StateNotifierProvider<ApplicationsNotifier, List<UniversityApplication>>((ref) {
  final universities = ref.watch(universitiesProvider);
  return ApplicationsNotifier(universities);
});

class ApplicationsNotifier extends StateNotifier<List<UniversityApplication>> {
  ApplicationsNotifier(this.universities) : super([]) {
    _initMockData();
  }

  final List<dynamic> universities;

  void _initMockData() {
    if (universities.isEmpty) return;

    final List<ApplicationTimelineStage> defaultTimeline = [
      const ApplicationTimelineStage(title: 'Application Started', date: '01 Aug', isCompleted: true),
      const ApplicationTimelineStage(title: 'Documents Uploaded', date: '05 Aug', isCompleted: true),
      const ApplicationTimelineStage(title: 'SOP Submitted', date: '10 Aug', isCompleted: true),
      const ApplicationTimelineStage(title: 'Review', date: 'Pending', isActive: true),
      const ApplicationTimelineStage(title: 'Decision', date: 'TBD'),
    ];

    state = [
      UniversityApplication(
        id: 'app_1',
        university: universities[0], // BITS Pilani
        course: 'B.Tech Computer Science',
        status: ApplicationStatus.review,
        submissionDate: '10 Aug 2025',
        deadline: '30 Aug 2025',
        progress: 0.75,
        aiSuccessPrediction: 88,
        timeline: defaultTimeline,
        documents: const [
          DocumentRequirement(name: 'Passport', status: 'Uploaded'),
          DocumentRequirement(name: 'Transcript', status: 'Uploaded'),
          DocumentRequirement(name: 'Resume', status: 'Uploaded'),
          DocumentRequirement(name: 'SOP', status: 'Uploaded'),
          DocumentRequirement(name: 'Recommendation Letters', status: 'Pending'),
        ],
        metrics: const ApplicationMetrics(admissionProbability: 85, scholarshipChance: 60, interviewReadiness: 40, profileCompletion: 90),
        activities: const [
          ApplicationActivity(action: 'SOP Submitted', date: '10 Aug 2025'),
          ApplicationActivity(action: 'Documents Uploaded', date: '05 Aug 2025'),
          ApplicationActivity(action: 'Application Created', date: '01 Aug 2025'),
        ],
        contactEmail: 'admissions@bits-pilani.ac.in',
        contactPhone: '+91 1596 242205',
        estimatedTimeRemaining: 'Waiting for Decision',
      ),
      if (universities.length > 1)
        UniversityApplication(
          id: 'app_2',
          university: universities[1], // IIT Bombay
          course: 'B.Tech Computer Science',
          status: ApplicationStatus.draft,
          submissionDate: 'Not Submitted',
          deadline: '15 Sep 2025',
          progress: 0.30,
          aiSuccessPrediction: 94,
          timeline: [
            const ApplicationTimelineStage(title: 'Application Started', date: '15 Aug', isCompleted: true),
            const ApplicationTimelineStage(title: 'Documents Uploaded', date: 'Pending', isActive: true),
          ],
          documents: const [
            DocumentRequirement(name: 'Passport', status: 'Missing'),
            DocumentRequirement(name: 'Transcript', status: 'Missing'),
            DocumentRequirement(name: 'Resume', status: 'Missing'),
          ],
          metrics: const ApplicationMetrics(admissionProbability: 92, scholarshipChance: 70, interviewReadiness: 0, profileCompletion: 30),
          activities: const [
            ApplicationActivity(action: 'Application Created', date: '15 Aug 2025'),
          ],
          contactEmail: 'admissions@iitb.ac.in',
          contactPhone: '+91 22 2572 2545',
          estimatedTimeRemaining: '30 Days Left',
        ),
    ];
  }

  void addMockApplication(String universityId) {
    final uni = universities.firstWhere((u) => u.id == universityId, orElse: () => universities.first);
    final newApp = UniversityApplication(
      id: 'app_${DateTime.now().millisecondsSinceEpoch}',
      university: uni,
      course: 'New Application',
      status: ApplicationStatus.draft,
      submissionDate: 'Not Submitted',
      deadline: 'TBD',
      progress: 0.1,
      aiSuccessPrediction: uni.aiMatch,
      timeline: [
        const ApplicationTimelineStage(title: 'Application Started', date: 'Just now', isCompleted: true, isActive: true),
      ],
    );
    state = [newApp, ...state];
  }
}
