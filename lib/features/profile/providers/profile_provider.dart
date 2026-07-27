import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Streams the current user's full Firestore document as a raw map.
/// All screens should read from this instead of holding their own streams.
final profileProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return Stream.value({});
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((s) => s.data() ?? {});
});

/// Convenience getters for UI consumption.
extension ProfileDataX on Map<String, dynamic> {
  String get displayName =>
      this['displayName'] as String? ??
      this['personal']?['fullName'] as String? ??
      'Student';
  String get email => this['email'] as String? ?? '';
  String get phone =>
      (this['personal']?['phone'] as String?)?.isNotEmpty == true
          ? this['personal']['phone'] as String
          : 'Not added';
  int get profileCompletion =>
      (this['profileCompletion'] as num?)?.toInt() ?? 0;
  double get readinessScore =>
      (this['aiProfile']?['readinessScore'] as num?)?.toDouble() ?? 0.0;
}
