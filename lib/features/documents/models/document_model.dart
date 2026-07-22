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

  Map<String, dynamic> toMap() {
    return {
      'isVerified': isVerified,
      'isOcrComplete': isOcrComplete,
      'readabilityScore': readabilityScore,
      'resolutionScore': resolutionScore,
      'missingInformation': missingInformation,
      'recommendations': recommendations,
    };
  }

  factory DocumentAIAnalysis.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const DocumentAIAnalysis();
    return DocumentAIAnalysis(
      isVerified: map['isVerified'] ?? false,
      isOcrComplete: map['isOcrComplete'] ?? false,
      readabilityScore: map['readabilityScore'] ?? 0,
      resolutionScore: map['resolutionScore'] ?? 0,
      missingInformation: List<String>.from(map['missingInformation'] ?? []),
      recommendations: List<String>.from(map['recommendations'] ?? []),
    );
  }
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
  final String? storagePath;
  final String? localPath;
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
    this.storagePath,
    this.localPath,
    this.aiAnalysis = const DocumentAIAnalysis(),
  });

  AppDocument copyWith({
    String? id,
    String? name,
    String? category,
    String? size,
    String? uploadDate,
    DocumentStatus? status,
    int? aiQualityScore,
    String? expiryDate,
    bool? isFavorite,
    String? previewUrl,
    String? storagePath,
    String? localPath,
    DocumentAIAnalysis? aiAnalysis,
  }) {
    return AppDocument(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      size: size ?? this.size,
      uploadDate: uploadDate ?? this.uploadDate,
      status: status ?? this.status,
      aiQualityScore: aiQualityScore ?? this.aiQualityScore,
      expiryDate: expiryDate ?? this.expiryDate,
      isFavorite: isFavorite ?? this.isFavorite,
      previewUrl: previewUrl ?? this.previewUrl,
      storagePath: storagePath ?? this.storagePath,
      localPath: localPath ?? this.localPath,
      aiAnalysis: aiAnalysis ?? this.aiAnalysis,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'size': size,
      'uploadDate': uploadDate,
      'status': status.name,
      'aiQualityScore': aiQualityScore,
      'expiryDate': expiryDate,
      'isFavorite': isFavorite,
      'previewUrl': previewUrl,
      'storagePath': storagePath,
      'localPath': localPath,
      'aiAnalysis': aiAnalysis.toMap(),
    };
  }

  factory AppDocument.fromMap(Map<String, dynamic> map, String docId) {
    DocumentStatus parsedStatus = DocumentStatus.pending;
    final statusStr = map['status'] as String?;
    if (statusStr == 'verified') parsedStatus = DocumentStatus.verified;
    if (statusStr == 'rejected') parsedStatus = DocumentStatus.rejected;

    return AppDocument(
      id: docId,
      name: map['name'] ?? 'Untitled Document',
      category: map['category'] ?? 'Miscellaneous',
      size: map['size'] ?? '0 KB',
      uploadDate: map['uploadDate'] ?? '',
      status: parsedStatus,
      aiQualityScore: map['aiQualityScore'] ?? 80,
      expiryDate: map['expiryDate'],
      isFavorite: map['isFavorite'] ?? false,
      previewUrl: map['previewUrl'] ?? '',
      storagePath: map['storagePath'],
      localPath: map['localPath'],
      aiAnalysis: DocumentAIAnalysis.fromMap(map['aiAnalysis'] as Map<String, dynamic>?),
    );
  }
}
