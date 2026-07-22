class University {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final String logoUrl;
  final int aiMatch;
  final double rating;
  final String nirfRanking;
  final String accreditation;
  final String type;
  final String established;
  final String course;
  final String fees;
  final double placementScore;
  final double roiScore;
  final double researchScore;
  final List<String> tags;
  final String studentCount;
  final bool isFavorite;

  // Detail fields
  final String description;
  final double admissionProbability;
  final double scholarshipProbability;
  final double hostelCompatibility;
  final double internationalOpportunities;
  final List<String> gallery;
  final List<String> coursesList;
  final List<String> facilities;

  const University({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.logoUrl,
    required this.aiMatch,
    required this.rating,
    required this.nirfRanking,
    required this.accreditation,
    required this.type,
    required this.established,
    required this.course,
    required this.fees,
    required this.placementScore,
    required this.roiScore,
    required this.researchScore,
    required this.tags,
    required this.studentCount,
    this.isFavorite = false,
    this.description = 'A premier institution known for excellence in education and research. It offers world-class facilities and has a track record of outstanding placements.',
    this.admissionProbability = 85.0,
    this.scholarshipProbability = 75.0,
    this.hostelCompatibility = 90.0,
    this.internationalOpportunities = 80.0,
    this.gallery = const [],
    this.coursesList = const ['Engineering', 'Medical', 'MBA', 'Science', 'Arts'],
    this.facilities = const ['Hostels', 'Labs', 'Sports', 'Library', 'WiFi', 'Medical'],
  });

  University copyWith({
    String? id,
    String? name,
    String? location,
    String? imageUrl,
    String? logoUrl,
    int? aiMatch,
    double? rating,
    String? nirfRanking,
    String? accreditation,
    String? type,
    String? established,
    String? course,
    String? fees,
    double? placementScore,
    double? roiScore,
    double? researchScore,
    List<String>? tags,
    String? studentCount,
    bool? isFavorite,
    String? description,
    double? admissionProbability,
    double? scholarshipProbability,
    double? hostelCompatibility,
    double? internationalOpportunities,
    List<String>? gallery,
    List<String>? coursesList,
    List<String>? facilities,
  }) {
    return University(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      logoUrl: logoUrl ?? this.logoUrl,
      aiMatch: aiMatch ?? this.aiMatch,
      rating: rating ?? this.rating,
      nirfRanking: nirfRanking ?? this.nirfRanking,
      accreditation: accreditation ?? this.accreditation,
      type: type ?? this.type,
      established: established ?? this.established,
      course: course ?? this.course,
      fees: fees ?? this.fees,
      placementScore: placementScore ?? this.placementScore,
      roiScore: roiScore ?? this.roiScore,
      researchScore: researchScore ?? this.researchScore,
      tags: tags ?? this.tags,
      studentCount: studentCount ?? this.studentCount,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      admissionProbability: admissionProbability ?? this.admissionProbability,
      scholarshipProbability: scholarshipProbability ?? this.scholarshipProbability,
      hostelCompatibility: hostelCompatibility ?? this.hostelCompatibility,
      internationalOpportunities: internationalOpportunities ?? this.internationalOpportunities,
      gallery: gallery ?? this.gallery,
      coursesList: coursesList ?? this.coursesList,
      facilities: facilities ?? this.facilities,
    );
  }

  Map<String, dynamic> toMap() => toFirestore();

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
      'logoUrl': logoUrl,
      'aiMatch': aiMatch,
      'rating': rating,
      'nirfRanking': nirfRanking,
      'accreditation': accreditation,
      'type': type,
      'established': established,
      'course': course,
      'fees': fees,
      'placementScore': placementScore,
      'roiScore': roiScore,
      'researchScore': researchScore,
      'tags': tags,
      'studentCount': studentCount,
      'isFavorite': isFavorite,
      'description': description,
      'admissionProbability': admissionProbability,
      'scholarshipProbability': scholarshipProbability,
      'hostelCompatibility': hostelCompatibility,
      'internationalOpportunities': internationalOpportunities,
      'gallery': gallery,
      'coursesList': coursesList,
      'facilities': facilities,
    };
  }

  factory University.fromMap(Map<String, dynamic> map, {String? docId}) {
    return University(
      id: docId ?? map['id'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
      aiMatch: (map['aiMatch'] as num?)?.toInt() ?? 90,
      rating: (map['rating'] as num?)?.toDouble() ?? 4.5,
      nirfRanking: map['nirfRanking'] ?? '',
      accreditation: map['accreditation'] ?? '',
      type: map['type'] ?? '',
      established: map['established'] ?? '',
      course: map['course'] ?? '',
      fees: map['fees'] ?? '',
      placementScore: (map['placementScore'] as num?)?.toDouble() ?? 90.0,
      roiScore: (map['roiScore'] as num?)?.toDouble() ?? 90.0,
      researchScore: (map['researchScore'] as num?)?.toDouble() ?? 85.0,
      tags: List<String>.from(map['tags'] ?? []),
      studentCount: map['studentCount'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      description: map['description'] ?? 'A premier institution known for excellence in education and research.',
      admissionProbability: (map['admissionProbability'] as num?)?.toDouble() ?? 85.0,
      scholarshipProbability: (map['scholarshipProbability'] as num?)?.toDouble() ?? 75.0,
      hostelCompatibility: (map['hostelCompatibility'] as num?)?.toDouble() ?? 90.0,
      internationalOpportunities: (map['internationalOpportunities'] as num?)?.toDouble() ?? 80.0,
      gallery: List<String>.from(map['gallery'] ?? []),
      coursesList: List<String>.from(map['coursesList'] ?? ['Engineering', 'Management', 'Sciences']),
      facilities: List<String>.from(map['facilities'] ?? ['Hostels', 'Labs', 'Library']),
    );
  }
}
