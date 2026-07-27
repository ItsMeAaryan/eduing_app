import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/university_application.dart';
import '../repositories/applications_repository.dart';
import '../../../shared/models/university_model.dart';

// ── Raw-map stream (for new UI and dashboard) ─────────────────────────────

final myApplicationsProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return Stream.value([]);
  return FirebaseFirestore.instance
      .collection('applications')
      .where('studentId', isEqualTo: uid)
      .orderBy('updatedAt', descending: true)
      .snapshots()
      .map((s) =>
          s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
});

// ── Create application with full spec structure ────────────────────────────

Future<void> createApplicationInFirestore({
  required Map<String, dynamic> studentData,
  required Map<String, dynamic> university,
  required Map<String, dynamic> program,
}) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;
  await FirebaseFirestore.instance.collection('applications').add({
    'studentId': uid,
    'studentName': studentData['displayName'] ?? '',
    'studentEmail': studentData['email'] ?? '',
    'universityId': university['id'] ?? '',
    'universityName': university['name'] ?? '',
    'programId': program['id'] ?? '',
    'courseName': program['name'] ?? '',
    'status': 'in_progress',
    'progress': 10.0,
    'deadline': university['applicationDeadline'],
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
    'documents': [],
    'steps': [
      {'id': 'profile', 'label': 'Profile Complete', 'status': 'done'},
      {'id': 'documents', 'label': 'Documents', 'status': 'pending'},
      {'id': 'form', 'label': 'Application Form', 'status': 'pending'},
      {'id': 'payment', 'label': 'Payment', 'status': 'pending'},
      {'id': 'submitted', 'label': 'Submitted', 'status': 'pending'},
    ],
  });
}

final applicationRepositoryProvider =
    Provider((ref) => ApplicationRepository());

final applicationsStreamProvider =
    StreamProvider<List<UniversityApplication>>((ref) {
  final repo = ref.watch(applicationRepositoryProvider);
  return repo.getApplicationsStream();
});

final applicationsNotifierProvider =
    NotifierProvider<ApplicationsNotifier, List<UniversityApplication>>(
        () {
  return ApplicationsNotifier();
});

class ApplicationsNotifier extends Notifier<List<UniversityApplication>> {
  late final ApplicationRepository _repository;

  @override
  List<UniversityApplication> build() {
    _repository = ref.watch(applicationRepositoryProvider);
    _loadInitialData();
    return [];
  }

  void _loadInitialData() {
    _repository.getApplicationsStream().listen((apps) {
      state = apps;
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
      submissionDate:
          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
      deadline: deadline,
      progress: 0.2,
      timeline: [
        const ApplicationTimelineStage(
            title: 'Draft Started',
            date: 'Today',
            isCompleted: true,
            isActive: true),
        const ApplicationTimelineStage(
            title: 'Application Submitted',
            date: 'Pending',
            isCompleted: false),
        const ApplicationTimelineStage(
            title: 'Under Review', date: 'Pending', isCompleted: false),
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
