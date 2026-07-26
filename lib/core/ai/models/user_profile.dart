class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String guardian;

  final double jeePercentile;
  final double percentage; // 12th
  final String board;
  final String category;
  final int graduationYear;

  final List<String> entranceExams;
  final List<String> verifiedDocuments;
  final int applicationsStarted;

  const UserProfile({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.guardian = '',
    this.jeePercentile = 0.0,
    this.percentage = 0.0,
    this.board = '',
    this.category = 'General',
    this.graduationYear = 2024,
    this.entranceExams = const [],
    this.verifiedDocuments = const [],
    this.applicationsStarted = 0,
  });
}
