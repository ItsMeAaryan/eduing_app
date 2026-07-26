import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/document_model.dart';
import '../repositories/documents_repository.dart';
import '../services/document_storage_service.dart';

final documentRepositoryProvider = Provider((ref) => DocumentRepository());
final documentStorageServiceProvider =
    Provider((ref) => DocumentStorageService());

final documentsStreamProvider = StreamProvider<List<AppDocument>>((ref) {
  final repo = ref.watch(documentRepositoryProvider);
  return repo.getDocumentsStream();
});

class UploadProgressNotifier extends Notifier<Map<String, UploadProgress?>> {
  @override
  Map<String, UploadProgress?> build() => {};

  void updateProgress(String docId, UploadProgress? progress) {
    state = {
      ...state,
      docId: progress,
    };
  }
}

final activeUploadProgressProvider = NotifierProvider<UploadProgressNotifier, Map<String, UploadProgress?>>(() {
  return UploadProgressNotifier();
});

final documentsNotifierProvider =
    NotifierProvider<DocumentsNotifier, List<AppDocument>>(() {
  return DocumentsNotifier();
});

class DocumentsNotifier extends Notifier<List<AppDocument>> {
  late final DocumentRepository _repository;
  late final DocumentStorageService _storageService;

  @override
  List<AppDocument> build() {
    _repository = ref.watch(documentRepositoryProvider);
    _storageService = ref.watch(documentStorageServiceProvider);
    _loadInitialData();
    return [];
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
    final nowStr =
        '${DateTime.now().day} ${_monthName(DateTime.now().month)} ${DateTime.now().year}';

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
    _storageService
        .uploadDocument(uid: uid, docId: docId, file: file)
        .listen((progress) async {
      ref.read(activeUploadProgressProvider.notifier).updateProgress(docId, progress);

      if (progress.isCompleted && progress.downloadUrl != null) {
        final updatedDoc = initialDoc.copyWith(
          previewUrl: progress.downloadUrl,
          storagePath: progress.storagePath,
          status: DocumentStatus.verified,
        );

        // Sync to Firestore
        await _repository.create(docId, updatedDoc);
        ref.read(activeUploadProgressProvider.notifier).updateProgress(docId, null);
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
    await _storageService.shareDocumentFile(
        doc.name, doc.localPath, doc.previewUrl);
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
