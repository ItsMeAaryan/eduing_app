import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/document_model.dart';

final documentsProvider = StateNotifierProvider<DocumentsNotifier, List<AppDocument>>((ref) {
  return DocumentsNotifier();
});

class DocumentsNotifier extends StateNotifier<List<AppDocument>> {
  DocumentsNotifier() : super([]) {
    _initMockData();
  }

  void _initMockData() {
    state = [
      const AppDocument(
        id: 'doc_1',
        name: 'High School Transcript',
        category: 'Academic',
        size: '2.4 MB',
        uploadDate: '15 Aug 2025',
        status: DocumentStatus.verified,
        aiQualityScore: 98,
        previewUrl: 'https://via.placeholder.com/400x600.png?text=Transcript',
        aiAnalysis: DocumentAIAnalysis(
          isVerified: true,
          isOcrComplete: true,
          readabilityScore: 95,
          resolutionScore: 100,
          missingInformation: [],
          recommendations: ['Transcript formatting is excellent.'],
        ),
      ),
      const AppDocument(
        id: 'doc_2',
        name: 'Passport',
        category: 'Identity',
        size: '4.1 MB',
        uploadDate: '10 Aug 2025',
        status: DocumentStatus.pending,
        aiQualityScore: 75,
        expiryDate: '12 Dec 2025',
        previewUrl: 'https://via.placeholder.com/400x600.png?text=Passport',
        aiAnalysis: DocumentAIAnalysis(
          isVerified: false,
          isOcrComplete: true,
          readabilityScore: 80,
          resolutionScore: 70,
          missingInformation: ['Signature missing'],
          recommendations: ['Passport expires soon.', 'Image is slightly blurry.'],
        ),
      ),
      const AppDocument(
        id: 'doc_3',
        name: 'Statement of Purpose',
        category: 'Academic',
        size: '1.2 MB',
        uploadDate: '20 Aug 2025',
        status: DocumentStatus.verified,
        aiQualityScore: 92,
        previewUrl: 'https://via.placeholder.com/400x600.png?text=SOP',
        aiAnalysis: DocumentAIAnalysis(
          isVerified: true,
          isOcrComplete: true,
          readabilityScore: 100,
          resolutionScore: 100,
          missingInformation: [],
          recommendations: ['SOP formatting is excellent.', 'Word count is optimal.'],
        ),
      ),
    ];
  }

  void addDocument(AppDocument doc) {
    state = [doc, ...state];
  }

  void removeDocument(String id) {
    state = state.where((d) => d.id != id).toList();
  }
}
