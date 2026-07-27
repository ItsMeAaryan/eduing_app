import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firebase/firebase_service.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseService.auth;
  final FirebaseFirestore _firestore = FirebaseService.firestore;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<UserCredential?> registerWithEmail(
      String email, String password, String fullName) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Update display name
      await credential.user?.updateDisplayName(fullName);

      // Create user profile in Firestore
      if (credential.user != null) {
        await _createUserDocument(credential.user!, fullName);
      }

      // Send verification email
      if (credential.user != null && !credential.user!.emailVerified) {
        await credential.user?.sendEmailVerification();
      }

      return credential;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).delete();
      await _firestore.collection('student_profiles').doc(user.uid).delete();
      await user.delete();
    }
  }

  Future<void> _createUserDocument(User user, String fullName) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final now = FieldValue.serverTimestamp();
      await docRef.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': fullName,
        'photoUrl': '',
        'role': 'student',
        'createdAt': now,
        'updatedAt': now,
        'onboardingCompleted': false,
        'profileCompletion': 10,
        'personal': {
          'fullName': fullName,
          'dob': null,
          'gender': '',
          'phone': '',
        },
        'academic': {
          'board': '',
          'percentage12': null,
          'graduationYear': null,
        },
        'entranceExams': {
          'jeeMainPercentile': null,
          'bitsatScore': null,
          'neetScore': null,
        },
        'reservation': {'category': 'General'},
        'aiProfile': {
          'readinessScore': 15,
          'lastComputed': now,
        },
        'settings': {
          'notifications': true,
          'darkMode': true,
          'language': 'en',
        },
        'referralSource': [],
      });

      // Mirror to student_profiles collection (visible to university portal)
      await _firestore.collection('student_profiles').doc(user.uid).set({
        'uid': user.uid,
        'displayName': fullName,
        'email': user.email,
        'role': 'student',
        'profileCompletion': 10,
        'createdAt': now,
      });
    }
  }
}
