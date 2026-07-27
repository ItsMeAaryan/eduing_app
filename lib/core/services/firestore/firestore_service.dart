import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? get uid => _auth.currentUser?.uid;

  // ── USER ──────────────────────────────────────────────────────────────────

  static Stream<DocumentSnapshot> userStream() =>
      _db.collection('users').doc(uid).snapshots();

  static Future<void> updateUser(Map<String, dynamic> data) =>
      _db.collection('users').doc(uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  // ── UNIVERSITIES ──────────────────────────────────────────────────────────

  static Stream<QuerySnapshot> universitiesStream({
    String? filterType,
  }) {
    Query q = _db
        .collection('universities')
        .where('approvalStatus', isEqualTo: 'approved');
    if (filterType != null && filterType != 'All') {
      q = q.where('type', isEqualTo: filterType);
    }
    return q.orderBy('name').snapshots();
  }

  // ── PROGRAMS ──────────────────────────────────────────────────────────────

  static Stream<QuerySnapshot> programsStream(String universityId) =>
      _db
          .collection('programs')
          .where('universityId', isEqualTo: universityId)
          .snapshots();

  // ── APPLICATIONS ──────────────────────────────────────────────────────────

  static Stream<QuerySnapshot> myApplicationsStream() =>
      _db
          .collection('applications')
          .where('studentId', isEqualTo: uid)
          .orderBy('updatedAt', descending: true)
          .snapshots();

  static Future<DocumentReference> createApplication(
          Map<String, dynamic> data) =>
      _db.collection('applications').add({
        ...data,
        'studentId': uid,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'status': 'in_progress',
        'progress': 10.0,
      });

  static Future<void> updateApplication(
          String appId, Map<String, dynamic> data) =>
      _db.collection('applications').doc(appId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  // ── NOTIFICATIONS ─────────────────────────────────────────────────────────

  static Stream<QuerySnapshot> notificationsStream() =>
      _db
          .collection('notifications')
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .snapshots();

  static Future<void> markNotificationRead(String notifId) =>
      _db.collection('notifications').doc(notifId).update({
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });

  // ── PLANNER TASKS ─────────────────────────────────────────────────────────

  static Stream<QuerySnapshot> plannerTasksStream() =>
      _db
          .collection('planner_tasks')
          .where('userId', isEqualTo: uid)
          .orderBy('dueDate')
          .snapshots();

  static Future<DocumentReference> addPlannerTask(
          Map<String, dynamic> data) =>
      _db.collection('planner_tasks').add({
        ...data,
        'userId': uid,
        'createdAt': FieldValue.serverTimestamp(),
        'isDone': false,
      });
}
