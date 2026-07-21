import '../../../shared/models/university_model.dart';

enum ApplicationStatus { draft, submitted, review, accepted, rejected, interview, scholarship }

class ApplicationTimelineStage {
  final String title;
  final String date;
  final bool isCompleted;
  final bool isActive;

  const ApplicationTimelineStage({
    required this.title,
    required this.date,
    this.isCompleted = false,
    this.isActive = false,
  });
}

class DocumentRequirement {
  final String name;
  final String status; // 'Uploaded', 'Pending', 'Missing'

  const DocumentRequirement({required this.name, required this.status});
}

class ApplicationActivity {
  final String action;
  final String date;

  const ApplicationActivity({required this.action, required this.date});
}

class ApplicationMetrics {
  final int admissionProbability;
  final int scholarshipChance;
  final int interviewReadiness;
  final int profileCompletion;

  const ApplicationMetrics({
    required this.admissionProbability,
    required this.scholarshipChance,
    required this.interviewReadiness,
    required this.profileCompletion,
  });
}

class UniversityApplication {
  final String id;
  final University university;
  final String course;
  final ApplicationStatus status;
  final String submissionDate;
  final String deadline;
  final double progress;
  final int aiSuccessPrediction;
  final List<ApplicationTimelineStage> timeline;
  final List<DocumentRequirement> documents;
  final ApplicationMetrics metrics;
  final List<ApplicationActivity> activities;
  final String contactEmail;
  final String contactPhone;
  final String estimatedTimeRemaining;

  const UniversityApplication({
    required this.id,
    required this.university,
    required this.course,
    required this.status,
    required this.submissionDate,
    required this.deadline,
    required this.progress,
    required this.aiSuccessPrediction,
    required this.timeline,
    this.documents = const [],
    this.metrics = const ApplicationMetrics(admissionProbability: 0, scholarshipChance: 0, interviewReadiness: 0, profileCompletion: 0),
    this.activities = const [],
    this.contactEmail = 'admissions@university.edu',
    this.contactPhone = '+1 234 567 8900',
    this.estimatedTimeRemaining = '14 Days',
  });

  String get statusDisplay {
    switch (status) {
      case ApplicationStatus.draft: return 'Draft';
      case ApplicationStatus.submitted: return 'Submitted';
      case ApplicationStatus.review: return 'Under Review';
      case ApplicationStatus.accepted: return 'Accepted';
      case ApplicationStatus.rejected: return 'Rejected';
      case ApplicationStatus.interview: return 'Interview Scheduled';
      case ApplicationStatus.scholarship: return 'Scholarship Review';
    }
  }
}
