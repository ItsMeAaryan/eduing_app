import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class UploadProgress {
  final double progress; // 0.0 to 1.0
  final bool isCompleted;
  final bool isFailed;
  final String? downloadUrl;
  final String? storagePath;
  final String? error;

  UploadProgress({
    required this.progress,
    this.isCompleted = false,
    this.isFailed = false,
    this.downloadUrl,
    this.storagePath,
    this.error,
  });
}

class DocumentStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  static const int maxFileSizeBytes = 15 * 1024 * 1024; // 15 MB limit
  static const List<String> allowedExtensions = [
    'pdf',
    'doc',
    'docx',
    'png',
    'jpg',
    'jpeg'
  ];

  Future<File?> pickDocumentFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final length = await file.length();
      if (length > maxFileSizeBytes) {
        throw Exception('File size exceeds the 15 MB limit.');
      }
      return file;
    }
    return null;
  }

  Future<File?> pickImageFromGallery() async {
    final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      final length = await file.length();
      if (length > maxFileSizeBytes) {
        throw Exception('Image size exceeds the 15 MB limit.');
      }
      return file;
    }
    return null;
  }

  Future<File?> captureImageFromCamera() async {
    final picked = await _imagePicker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      final file = File(picked.path);
      final length = await file.length();
      if (length > maxFileSizeBytes) {
        throw Exception('Captured photo exceeds the 15 MB limit.');
      }
      return file;
    }
    return null;
  }

  Stream<UploadProgress> uploadDocument({
    required String uid,
    required String docId,
    required File file,
  }) async* {
    try {
      final storagePath =
          'users/$uid/documents/${docId}_${file.path.split('/').last}';
      final ref = _storage.ref().child(storagePath);
      final uploadTask = ref.putFile(file);

      await for (final snapshot in uploadTask.snapshotEvents) {
        switch (snapshot.state) {
          case TaskState.running:
            final double progress =
                snapshot.bytesTransferred / snapshot.totalBytes;
            yield UploadProgress(progress: progress);
            break;
          case TaskState.paused:
            break;
          case TaskState.success:
            final downloadUrl = await ref.getDownloadURL();
            yield UploadProgress(
              progress: 1.0,
              isCompleted: true,
              downloadUrl: downloadUrl,
              storagePath: storagePath,
            );
            break;
          case TaskState.canceled:
            yield UploadProgress(
              progress: 0.0,
              isFailed: true,
              error: 'Upload cancelled by user.',
            );
            break;
          case TaskState.error:
            yield UploadProgress(
              progress: 0.0,
              isFailed: true,
              error: 'Storage upload failed.',
            );
            break;
        }
      }
    } catch (e) {
      yield UploadProgress(
        progress: 0.0,
        isFailed: true,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteStorageFile(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      await ref.delete();
    } catch (_) {
      // Ignore if file doesn't exist in storage
    }
  }

  Future<void> shareDocumentFile(
      String name, String? localPath, String? previewUrl) async {
    if (localPath != null && File(localPath).existsSync()) {
      await Share.shareXFiles([XFile(localPath)],
          text: 'Sharing document: $name');
    } else if (previewUrl != null && previewUrl.isNotEmpty) {
      await Share.share('Document Link ($name): $previewUrl');
    } else {
      throw Exception(
          'No local file or share link available for this document.');
    }
  }

  Future<File> downloadDocument(String previewUrl, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/$fileName';
    final file = File(filePath);

    final request = await HttpClient().getUrl(Uri.parse(previewUrl));
    final response = await request.close();
    await response.pipe(file.openWrite());
    return file;
  }
}
