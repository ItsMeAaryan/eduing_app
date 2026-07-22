import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/university_application.dart';
import '../repositories/applications_repository.dart';
import '../../../shared/models/university_model.dart';

final applicationRepositoryProvider = Provider((ref) => ApplicationRepository());

final applicationsStreamProvider = StreamProvider<List<UniversityApplication>>((ref) {
  final repo = ref.watch(applicationRepositoryProvider);
  return repo.getApplicationsStream();
});

final applicationsNotifierProvider = StateNotifierProvider<ApplicationsNotifier, List<UniversityApplication>>((ref) {
  final repo = ref.watch(applicationRepositoryProvider);
  return ApplicationsNotifier(repo);
});

class ApplicationsNotifier extends StateNotifier<List<UniversityApplication>> {
  final ApplicationRepository _repository;

  ApplicationsNotifier(this._repository) : super([]) {
    _loadInitialData();
  }

  void _loadInitialData() {
    _repository.getApplicationsStream().listen((apps) {
      if (apps.isNotEmpty) {
        state = apps;
      } else if (state.isEmpty) {
        state = [
          const UniversityApplication(
            id: 'app_1',
            university: University(
              id: 'uni_mit',
              name: 'Massachusetts Institute of Technology (MIT)',
              location: 'Cambridge, MA',
              imageUrl: '',
              logoUrl: '',
              aiMatch: 95,
              rating: 4.9,
              nirfRanking: '#1 Global',
              accreditation: 'NECHE',
              type: 'Private Research',
              established: '1861',
              course: 'M.S. in Computer Science',
              fees: '\$58,000/yr',
              placementScore: 98.0,
              roiScore: 96.0,
              researchScore: 99.0,
              tags: ['AI', 'Tech', 'Engineering'],
              studentCount: '11,500',
            ),
            course: 'M.S. in Computer Science',
            status: ApplicationStatus.review,
            submissionDate: '15 Oct 2025',
            deadline: '01 Dec 2025',
            progress: 0.85,
            notes: 'Followed up with professor regarding research assistantship.',
            timeline: [
              ApplicationTimelineStage(title: 'Profile Created', date: '01 Sep', isCompleted: true),
              ApplicationTimelineStage(title: 'Documents Uploaded', date: '15 Sep', isCompleted: true),
              ApplicationTimelineStage(title: 'Application Submitted', date: '15 Oct', isCompleted: true, isActive: true),
              ApplicationTimelineStage(title: 'Interview', date: '10 Nov', isCompleted: false),
              ApplicationTimelineStage(title: 'Decision Received', date: '15 Dec', isCompleted: false),
            ],
          ),
        ];
      }
    });
  }

  Future<void> createApplication({
    required String universityName,
    required String course,
    required String deadline,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final appId = 'app_${DateTime.now().millisecondsSinceEpoch}';

    final newApp = UniversityApplication(
      id: appId,
      university: University(
        id: 'uni_${DateTime.now().millisecondsSinceEpoch}',
        name: universityName,
        location: 'Global Campus',
        imageUrl: '',
        logoUrl: '',
        aiMatch: 88,
        rating: 4.5,
        nirfRanking: '#15',
        accreditation: 'Global Accredited',
        type: 'University',
        established: '1990',
        course: course,
        fees: '\$45,000/yr',
        placementScore: 90.0,
        roiScore: 88.0,
        researchScore: 92.0,
        tags: ['Higher Education'],
        studentCount: '15,000',
      ),
      course: course,
      status: ApplicationStatus.draft,
      submissionDate: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
      deadline: deadline,
      progress: 0.2,
      timeline: [
        const ApplicationTimelineStage(title: 'Draft Started', date: 'Today', isCompleted: true, isActive: true),
        const ApplicationTimelineStage(title: 'Application Submitted', date: 'Pending', isCompleted: false),
        const ApplicationTimelineStage(title: 'Under Review', date: 'Pending', isCompleted: false),
      ],
    );

    state = [newApp, ...state];
    if (uid != null) {
      await _repository.create(appId, newApp);
    }
  }

  Future<void> updateStatus(String id, ApplicationStatus newStatus) async {
    final app = state.firstWhere((a) => a.id == id);
    final updated = app.copyWith(status: newStatus);
    state = state.map((a) => a.id == id ? updated : a).toList();

    if (_repository.getUserCollection() != null) {
      await _repository.update(id, updated);
    }
  }

  Future<void> updateNotes(String id, String notes) async {
    final app = state.firstWhere((a) => a.id == id);
    final updated = app.copyWith(notes: notes);
    state = state.map((a) => a.id == id ? updated : a).toList();

    if (_repository.getUserCollection() != null) {
      await _repository.update(id, updated);
    }
  }

  Future<void> deleteApplication(String id) async {
    state = state.where((a) => a.id != id).toList();
    if (_repository.getUserCollection() != null) {
      await _repository.delete(id);
    }
  }
}
