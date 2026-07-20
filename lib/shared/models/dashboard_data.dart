class UserProfile {
  final String name;
  final String avatarUrl;

  UserProfile({required this.name, required this.avatarUrl});
}

class DashboardStats {
  final int applications;
  final int offersReceived;
  final double profileStrength;
  final int scholarships;

  DashboardStats({
    required this.applications,
    required this.offersReceived,
    required this.profileStrength,
    required this.scholarships,
  });
}

class Deadline {
  final String task;
  final String date;
  final String priority; // Required, In 2 days, etc.
  final String statusColor;

  Deadline({
    required this.task,
    required this.date,
    required this.priority,
    required this.statusColor,
  });
}

class ApplicationStatus {
  final String university;
  final String campus;
  final String logoUrl;
  final int aiMatch;
  final String status;

  ApplicationStatus({
    required this.university,
    required this.campus,
    required this.logoUrl,
    required this.aiMatch,
    required this.status,
  });
}
