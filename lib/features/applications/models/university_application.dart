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
