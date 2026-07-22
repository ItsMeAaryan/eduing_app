import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/document_model.dart';
import '../repositories/documents_repository.dart';
import '../services/document_storage_service.dart';

final documentRepositoryProvider = Provider((ref) => DocumentRepository());
final documentStorageServiceProvider = Provider((ref) => DocumentStorageService());

final documentsStreamProvider = StreamProvider<List<AppDocument>>((ref) {
  final repo = ref.watch(documentRepositoryProvider);
  return repo.getDocumentsStream();
});

final activeUploadProgressProvider = StateProvider.family<UploadProgress?, String>((ref, docId) => null);

final documentsNotifierProvider = StateNotifierProvider<DocumentsNotifier, List<AppDocument>>((ref) {
  final repo = ref.watch(documentRepositoryProvider);
  final storageService = ref.watch(documentStorageServiceProvider);
  return DocumentsNotifier(repo, storageService, ref);
});

class DocumentsNotifier extends StateNotifier<List<AppDocument>> {
  final DocumentRepository _repository;
  final DocumentStorageService _storageService;
  final Ref _ref;

  DocumentsNotifier(this._repository, this._storageService, this._ref) : super([]) {
    _loadInitialData();
  }

  void _loadInitialData() {
    _repository.getDocumentsStream().listen((docs) {
      if (docs.isNotEmpty) {
        state = docs;
      }
    });
  }

  Future<void> uploadDocumentFile({
    required File file,
    required String name,
    required String category,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest_user';
    final docId = 'doc_${DateTime.now().millisecondsSinceEpoch}';

    final sizeInMb = (await file.length()) / (1024 * 1024);
    final sizeStr = '${sizeInMb.toStringAsFixed(1)} MB';
    final nowStr = '${DateTime.now().day} ${_monthName(DateTime.now().month)} ${DateTime.now().year}';

    final initialDoc = AppDocument(
      id: docId,
      name: name,
      category: category,
      size: sizeStr,
      uploadDate: nowStr,
      status: DocumentStatus.pending,
      aiQualityScore: 88,
      localPath: file.path,
      previewUrl: '',
    );

    // Optimistically add to state
    state = [initialDoc, ...state];

    // Listen to upload stream
    _storageService.uploadDocument(uid: uid, docId: docId, file: file).listen((progress) async {
      _ref.read(activeUploadProgressProvider(docId).notifier).state = progress;

      if (progress.isCompleted && progress.downloadUrl != null) {
        final updatedDoc = initialDoc.copyWith(
          previewUrl: progress.downloadUrl,
          storagePath: progress.storagePath,
          status: DocumentStatus.verified,
        );

        // Sync to Firestore
        await _repository.create(docId, updatedDoc);
        _ref.read(activeUploadProgressProvider(docId).notifier).state = null;
      }
    });
  }

  Future<void> renameDocument(String id, String newName) async {
    final doc = state.firstWhere((d) => d.id == id);
    final updated = doc.copyWith(name: newName);
    state = state.map((d) => d.id == id ? updated : d).toList();

    if (_repository.getUserCollection() != null) {
      await _repository.update(id, updated);
    }
  }

  Future<void> deleteDocument(String id) async {
    final doc = state.firstWhere((d) => d.id == id);
    state = state.where((d) => d.id != id).toList();

    if (doc.storagePath != null) {
      await _storageService.deleteStorageFile(doc.storagePath!);
    }

    if (_repository.getUserCollection() != null) {
      await _repository.delete(id);
    }
  }

  Future<void> shareDocument(String id) async {
    final doc = state.firstWhere((d) => d.id == id);
    await _storageService.shareDocumentFile(doc.name, doc.localPath, doc.previewUrl);
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
