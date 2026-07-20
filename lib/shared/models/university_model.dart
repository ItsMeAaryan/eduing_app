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
}
