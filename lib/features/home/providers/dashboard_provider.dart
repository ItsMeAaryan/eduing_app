import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ── User raw data ──────────────────────────────────────────────────────────

final userDataProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return Stream.value({});
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((s) => s.data() ?? {});
});

// ── Application counts (total / active / offers) ───────────────────────────

final applicationsCountProvider =
    StreamProvider<Map<String, int>>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    return Stream.value({'total': 0, 'active': 0, 'offers': 0});
  }
  return FirebaseFirestore.instance
      .collection('applications')
      .where('studentId', isEqualTo: uid)
      .snapshots()
      .map((s) {
    final docs = s.docs;
    final active = docs
        .where((d) => ['in_progress', 'submitted', 'under_review']
            .contains((d.data())['status']))
        .length;
    final offers =
        docs.where((d) => (d.data())['status'] == 'offer').length;
    return {'total': docs.length, 'active': active, 'offers': offers};
  });
});

// ── Universities total count ───────────────────────────────────────────────

final universitiesCountProvider = StreamProvider<int>((ref) {
  return FirebaseFirestore.instance
      .collection('universities')
      .where('approvalStatus', isEqualTo: 'approved')
      .snapshots()
      .map((s) => s.docs.length);
});

// ── Active applications (max 3, as raw maps) ──────────────────────────────

final activeApplicationsProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return Stream.value([]);
  return FirebaseFirestore.instance
      .collection('applications')
      .where('studentId', isEqualTo: uid)
      .where('status',
          whereIn: ['in_progress', 'submitted', 'under_review'])
      .orderBy('updatedAt', descending: true)
      .limit(3)
      .snapshots()
      .map((s) =>
          s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
});

// ── Upcoming planner tasks (max 5) ────────────────────────────────────────

final upcomingTasksProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return Stream.value([]);
  return FirebaseFirestore.instance
      .collection('planner_tasks')
      .where('userId', isEqualTo: uid)
      .where('isDone', isEqualTo: false)
      .orderBy('dueDate')
      .limit(5)
      .snapshots()
      .map((s) =>
          s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
});

// ── Legacy model kept for backwards compat with dashboard card ─────────────

class ApplicationModel {
  final String id;
  final String studentId;
  final String universityId;
  final String universityName;
  final String courseName;
  final String status;
  final double progress;
  final DateTime? deadline;
  final DateTime updatedAt;

  ApplicationModel({
    required this.id,
    required this.studentId,
    required this.universityId,
    required this.universityName,
    required this.courseName,
    required this.status,
    required this.progress,
    this.deadline,
    required this.updatedAt,
  });

  factory ApplicationModel.fromMap(Map<String, dynamic> data, String id) {
    return ApplicationModel(
      id: id,
      studentId: data['studentId'] ?? '',
      universityId: data['universityId'] ?? '',
      universityName: data['universityName'] ?? '',
      courseName: data['courseName'] ?? '',
      status: data['status'] ?? 'draft',
      progress: (data['progress'] ?? 0).toDouble(),
      deadline: (data['deadline'] as Timestamp?)?.toDate(),
      updatedAt:
          (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
