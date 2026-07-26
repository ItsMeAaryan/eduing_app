import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/storage_repository.dart';

final storageRepositoryProvider = Provider((ref) => StorageRepository());

final storageControllerProvider =
    NotifierProvider<StorageController, AsyncValue<String?>>(() {
  return StorageController();
});

class StorageController extends Notifier<AsyncValue<String?>> {
  late final StorageRepository _repository;

  @override
  AsyncValue<String?> build() {
    _repository = ref.watch(storageRepositoryProvider);
    return const AsyncData(null);
  }

  Future<String?> uploadProfileImage(File file) async {
    return _upload('profile/avatar.png', file);
  }

  Future<String?> uploadDocument(String docId, File file) async {
    return _upload('documents/\$docId.pdf', file);
  }

  Future<String?> uploadResume(File file) async {
    return _upload('resume/resume.pdf', file);
  }

  Future<String?> uploadSOP(File file) async {
    return _upload('sop/statement.pdf', file);
  }

  Future<String?> _upload(String path, File file) async {
    try {
      state = const AsyncLoading();
      final url = await _repository.uploadFile(path, file);
      state = AsyncData(url);
      return url;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}
