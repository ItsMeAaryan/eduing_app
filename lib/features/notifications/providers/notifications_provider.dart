import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ── All notifications (top-level collection, limit 50) ────────────────────

final notificationsProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return Stream.value([]);
  return FirebaseFirestore.instance
      .collection('notifications')
      .where('userId', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .limit(50)
      .snapshots()
      .map((s) =>
          s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
});

// ── Unread badge count ────────────────────────────────────────────────────

final unreadCountProvider = StreamProvider<int>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return Stream.value(0);
  return FirebaseFirestore.instance
      .collection('notifications')
      .where('userId', isEqualTo: uid)
      .where('isRead', isEqualTo: false)
      .snapshots()
      .map((s) => s.docs.length);
});

// ── Actions ───────────────────────────────────────────────────────────────

final notificationsActionsProvider =
    Provider((ref) => NotificationsActions());

class NotificationsActions {
  final _db = FirebaseFirestore.instance;

  Future<void> markAsRead(String notifId) async {
    await _db.collection('notifications').doc(notifId).update({
      'isRead': true,
      'readAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> markAllAsRead(
      List<Map<String, dynamic>> notifications) async {
    final unread =
        notifications.where((n) => n['isRead'] != true).toList();
    if (unread.isEmpty) return;
    final batch = _db.batch();
    for (final n in unread) {
      final ref = _db.collection('notifications').doc(n['id'] as String);
      batch.update(ref, {
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }
}
