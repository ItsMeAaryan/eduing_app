import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../services/firebase/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageRepository {
  final FirebaseStorage _storage = FirebaseService.storage;
  final FirebaseAuth _auth = FirebaseService.auth;

  String? get _uid => _auth.currentUser?.uid;

  /// Uploads a file and returns its download URL
  Future<String> uploadFile(String path, File file,
      {void Function(double)? onProgress}) async {
    if (_uid == null) throw Exception('User not authenticated');

    final ref = _storage.ref().child('users/\$_uid/\$path');
    final uploadTask = ref.putFile(file);

    if (onProgress != null) {
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      });
    }

    await uploadTask;
    return await ref.getDownloadURL();
  }

  /// Replaces an existing file at the given path
  Future<String> replaceFile(String path, File file,
      {void Function(double)? onProgress}) async {
    return await uploadFile(path, file, onProgress: onProgress);
  }

  /// Deletes a file at the given path
  Future<void> deleteFile(String path) async {
    if (_uid == null) throw Exception('User not authenticated');
    final ref = _storage.ref().child('users/\$_uid/\$path');
    await ref.delete();
  }

  /// Gets the download URL for an existing file
  Future<String> getDownloadUrl(String path) async {
    if (_uid == null) throw Exception('User not authenticated');
    final ref = _storage.ref().child('users/\$_uid/\$path');
    return await ref.getDownloadURL();
  }
}
