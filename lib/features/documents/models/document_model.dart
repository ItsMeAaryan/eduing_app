enum DocumentStatus { verified, pending, rejected }

class DocumentAIAnalysis {
  final bool isVerified;
  final bool isOcrComplete;
  final int readabilityScore;
  final int resolutionScore;
  final List<String> missingInformation;
  final List<String> recommendations;

  const DocumentAIAnalysis({
    this.isVerified = false,
    this.isOcrComplete = false,
    this.readabilityScore = 0,
    this.resolutionScore = 0,
    this.missingInformation = const [],
    this.recommendations = const [],
  });
}

class AppDocument {
  final String id;
  final String name;
  final String category;
  final String size;
  final String uploadDate;
  final DocumentStatus status;
  final int aiQualityScore;
  final String? expiryDate;
  final bool isFavorite;
  final String previewUrl;
  final DocumentAIAnalysis aiAnalysis;

  const AppDocument({
    required this.id,
    required this.name,
    required this.category,
    required this.size,
    required this.uploadDate,
    required this.status,
    required this.aiQualityScore,
    this.expiryDate,
    this.isFavorite = false,
    required this.previewUrl,
    this.aiAnalysis = const DocumentAIAnalysis(),
  });
}
