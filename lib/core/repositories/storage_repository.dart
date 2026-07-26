import 'dart:io';
import '../services/firebase/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageRepository {
  // Firebase Storage disabled until billing is enabled
  // Will be re-enabled when Storage is activated in Firebase Console
  final FirebaseAuth _auth = FirebaseService.auth;

  String? get _uid => _auth.currentUser?.uid;

  Future<String> uploadFile(String path, File file,
      {void Function(double)? onProgress}) async {
    if (_uid == null) throw Exception('User not authenticated');
    // TODO: Re-enable when Firebase Storage is activated
    // Returning mock URL for now
    onProgress?.call(1.0);
    return 'local://$path';
  }

  Future<String> replaceFile(String path, File file,
      {void Function(double)? onProgress}) async {
    return await uploadFile(path, file, onProgress: onProgress);
  }

  Future<void> deleteFile(String path) async {
    if (_uid == null) throw Exception('User not authenticated');
    // TODO: Re-enable when Firebase Storage is activated
    return;
  }

  Future<String> getDownloadUrl(String path) async {
    if (_uid == null) throw Exception('User not authenticated');
    // TODO: Re-enable when Firebase Storage is activated
    return 'local://$path';
  }
}