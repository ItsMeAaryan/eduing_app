import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/services/firebase/firebase_service.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseService.auth;
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        await _createUserDocument(
            userCredential.user!, userCredential.user!.displayName ?? 'User');
      }
      return userCredential;
    } catch (e) {
      throw e.toString();
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
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();
    }
  }

  Future<void> _createUserDocument(User user, String fullName) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'uid': user.uid,
        'displayName': fullName,
        'email': user.email,
        'photoUrl': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'profileCompletion': 0,
        'settings': {},
        'preferences': {},
      });
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }
}
