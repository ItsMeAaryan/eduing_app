// Everything that happens after a student applies — mirrors
// eduing-student/lib/firebase/admission.ts so the app and the website
// behave the same way.
//
// Status flow shared with the university portal:
//   submitted → under_review → docs_verified → selected | allotted
//   → seat_accepted → fee_paid → payment_verified → enrolled
//   side exits: rejected · waitlisted · offer_declined · withdrawn
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String normalizeStatus(String? raw) {
  final s = (raw ?? 'submitted').toLowerCase();
  const alias = {
    'review': 'under_review', 'in_review': 'under_review', 'in_progress': 'submitted',
    'draft': 'submitted', 'pending': 'submitted', 'accepted': 'selected', 'offered': 'selected',
    'offer': 'selected', 'reject': 'rejected', 'declined': 'offer_declined',
    'payment_rejected': 'seat_accepted',
  };
  return alias[s] ?? s;
}

const offerStatuses = ['selected', 'allotted'];
const withdrawableStatuses = ['submitted', 'under_review', 'docs_verified', 'waitlisted'];
const closedStatuses = ['rejected', 'offer_declined', 'withdrawn'];

/// Journey position 0–7 (matches the website stepper).
int stageOf(String status) => const {
      'submitted': 1, 'under_review': 2, 'waitlisted': 2, 'docs_verified': 3, 'selected': 4,
      'allotted': 4, 'seat_accepted': 5, 'fee_paid': 5, 'payment_verified': 6, 'enrolled': 7,
    }[status] ??
    0;

String statusLabel(String status) => const {
      'submitted': 'Submitted', 'under_review': 'Under review', 'docs_verified': 'Documents verified',
      'waitlisted': 'Waitlisted', 'selected': 'Offer received', 'allotted': 'Seat allotted',
      'seat_accepted': 'Seat accepted', 'fee_paid': 'Fee under verification',
      'payment_verified': 'Fee verified', 'enrolled': 'Enrolled', 'rejected': 'Not selected',
      'offer_declined': 'Offer declined', 'withdrawn': 'Withdrawn',
    }[status] ??
    status;

DateTime? toDate(dynamic v) {
  if (v == null) return null;
  if (v is Timestamp) return v.toDate();
  if (v is DateTime) return v;
  if (v is String) return DateTime.tryParse(v);
  return null;
}

final _db = FirebaseFirestore.instance;

// ── streams ────────────────────────────────────────────────────────────────
final applicationProvider = StreamProvider.family<Map<String, dynamic>?, String>((ref, id) {
  return _db.collection('applications').doc(id).snapshots().map((s) => s.exists ? {'id': s.id, ...s.data()!} : null);
});

final generatedDocumentsProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, id) {
  return _db.collection('applications/$id/generated_documents').snapshots().map((s) {
    final latest = <String, Map<String, dynamic>>{};
    for (final d in s.docs) {
      final data = {'id': d.id, ...d.data()};
      final type = data['type'] as String? ?? d.id;
      final v = (data['version'] as num?)?.toInt() ?? 0;
      if (!latest.containsKey(type) || ((latest[type]!['version'] as num?)?.toInt() ?? 0) < v) latest[type] = data;
    }
    return latest.values.toList();
  }).handleError((_) => <Map<String, dynamic>>[]);
});

final sharedDocumentsProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, id) {
  return _db
      .collection('applications/$id/documents')
      .snapshots()
      .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList())
      .handleError((_) => <Map<String, dynamic>>[]);
});

/// Published exam schedules for (universityId, programId). Key: "uniId|programId".
final examSchedulesProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, key) {
  final parts = key.split('|');
  return _db
      .collection('exam_schedules')
      .where('universityId', isEqualTo: parts[0])
      .where('isPublished', isEqualTo: true) // rules only let students read published schedules
      .snapshots()
      .map((s) => s.docs
          .map((d) => {'id': d.id, ...d.data()})
          .where((x) => parts.length < 2 || parts[1].isEmpty || x['programId'] == parts[1])
          .toList())
      .handleError((_) => <Map<String, dynamic>>[]);
});

// ── actions ────────────────────────────────────────────────────────────────
class AdmissionException implements Exception {
  final String message;
  AdmissionException(this.message);
  @override
  String toString() => message;
}

Future<Map<String, dynamic>> _ownedApp(String appId) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw AdmissionException('Please log in again to continue.');
  final snap = await _db.collection('applications').doc(appId).get();
  if (!snap.exists) throw AdmissionException('This application no longer exists.');
  final data = snap.data()!;
  if (data['studentId'] != user.uid && data['userId'] != user.uid) {
    throw AdmissionException('This application belongs to another account.');
  }
  return data;
}

Future<void> _notifyUniversity(Map<String, dynamic> app, String title, String message) async {
  final uni = app['universityId'] as String?;
  if (uni == null || uni.isEmpty) return;
  try {
    await _db.collection('notifications').add({
      'userId': uni, 'universityId': uni, 'title': title, 'message': message,
      'type': 'application', 'isRead': false, 'createdAt': FieldValue.serverTimestamp(),
    });
  } catch (_) {/* a failed notification must not undo the student's action */}
}

Future<Map<String, dynamic>> _transition(String appId, List<String> from, String to, String note,
    [Map<String, dynamic> extra = const {}]) async {
  final app = await _ownedApp(appId);
  final current = normalizeStatus(app['status'] as String?);
  if (!from.contains(current)) {
    throw AdmissionException('This can’t be done while the application is "${statusLabel(current).toLowerCase()}".');
  }
  await _db.collection('applications').doc(appId).update({
    'status': to,
    'updatedAt': FieldValue.serverTimestamp(),
    'statusHistory': FieldValue.arrayUnion([
      {'status': to, 'date': DateTime.now().toIso8601String(), 'note': note}
    ]),
    ...extra,
  });
  return app;
}

String _who(Map<String, dynamic> a) => (a['studentName'] as String?)?.isNotEmpty == true ? a['studentName'] : 'A student';
String _prog(Map<String, dynamic> a) => (a['programName'] ?? a['program'] ?? 'your program').toString();

Future<void> acceptSeat(String appId) async {
  final app = await _transition(appId, offerStatuses, 'seat_accepted', 'Student accepted the seat', {
    'offerResponse': {'accepted': true, 'respondedAt': DateTime.now().toIso8601String()},
  });
  await _notifyUniversity(app, 'Seat accepted', '${_who(app)} accepted the seat for ${_prog(app)}.');
}

Future<void> declineOffer(String appId, String reason) async {
  final app = await _transition(appId, offerStatuses, 'offer_declined',
      'Student declined the offer${reason.isNotEmpty ? ': $reason' : ''}', {
    'offerResponse': {'accepted': false, 'reason': reason, 'respondedAt': DateTime.now().toIso8601String()},
  });
  await _notifyUniversity(app, 'Offer declined', '${_who(app)} declined the offer for ${_prog(app)}. The seat can be re-allotted.');
}

Future<void> withdrawApplication(String appId, String reason) async {
  final app = await _transition(appId, withdrawableStatuses, 'withdrawn',
      'Student withdrew the application${reason.isNotEmpty ? ': $reason' : ''}', {
    'withdrawal': {'reason': reason, 'at': DateTime.now().toIso8601String()},
  });
  await _notifyUniversity(app, 'Application withdrawn', '${_who(app)} withdrew their application for ${_prog(app)}.');
}

Future<void> submitFeePayment(String appId,
    {required num amount, required String transactionRef, required String paidOn, required String mode, required File receipt}) async {
  await _ownedApp(appId);
  if (amount <= 0) throw AdmissionException('Enter the amount you paid.');
  if (transactionRef.trim().isEmpty) throw AdmissionException('Enter the transaction / UTR reference from your bank.');
  if (await receipt.length() > 10 * 1024 * 1024) throw AdmissionException('The receipt must be smaller than 10 MB.');
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final ext = receipt.path.split('.').last.toLowerCase();
  final contentType = ext == 'pdf' ? 'application/pdf' : (ext == 'png' ? 'image/png' : 'image/jpeg');
  final ref = FirebaseStorage.instance.ref('users/$uid/payments/${appId}_${DateTime.now().millisecondsSinceEpoch}.$ext');
  await ref.putFile(receipt, SettableMetadata(contentType: contentType));
  final url = await ref.getDownloadURL();
  final app = await _transition(appId, ['seat_accepted'], 'fee_paid', 'Fee payment submitted (ref ${transactionRef.trim()})', {
    'paymentDetails': {
      'amountPaid': amount, 'transactionRef': transactionRef.trim(), 'paidOn': paidOn, 'mode': mode,
      'receiptUrl': url, 'submittedAt': DateTime.now().toIso8601String(), 'status': 'submitted',
    },
  });
  await _notifyUniversity(app, 'Fee payment submitted', '${_who(app)} submitted a fee payment of ₹$amount for verification.');
}

// ── documents shared with universities ─────────────────────────────────────
const _docLabels = {
  '10th_marksheet': '10th Marksheet', '12th_marksheet': '12th Marksheet',
  'id_proof': 'Identity Proof', 'passport_photo': 'Passport Photo',
};

/// Copies the student's uploaded documents into an application so the university can verify them.
Future<int> shareDocumentsWithApplication(String appId) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return 0;
  final mine = await _db.collection('users/$uid/documents').get();
  final shared = await _db.collection('applications/$appId/documents').get();
  final existing = {for (final d in shared.docs) d.id: d.data()};
  var count = 0;
  for (final d in mine.docs) {
    final data = d.data();
    final url = (data['fileUrl'] ?? data['downloadUrl'] ?? data['url'] ?? data['previewUrl']) as String?;
    if (url == null || url.isEmpty) continue;
    final prev = existing[d.id];
    if (prev != null && prev['url'] == url) continue; // unchanged — keep the university's review
    await _db.collection('applications/$appId/documents').doc(d.id).set({
      'name': data['name'] ?? _docLabels[d.id] ?? d.id.replaceAll('_', ' '),
      'url': url,
      'category': data['category'] ?? 'Academic',
      'status': 'pending',
      'ownerId': uid,
      'uploadDate': FieldValue.serverTimestamp(),
      'history': prev != null
          ? FieldValue.arrayUnion([
              {'status': 'pending', 'date': DateTime.now().toIso8601String(), 'note': 'Student uploaded a new version'}
            ])
          : [],
    }, SetOptions(merge: true));
    count++;
  }
  return count;
}

Future<void> shareDocumentsWithActiveApplications() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;
  final apps = await _db.collection('applications').where('studentId', isEqualTo: uid).get();
  for (final a in apps.docs) {
    final s = normalizeStatus(a.data()['status'] as String?);
    if (closedStatuses.contains(s) || s == 'enrolled') continue;
    try {
      await shareDocumentsWithApplication(a.id);
    } catch (_) {}
  }
}
