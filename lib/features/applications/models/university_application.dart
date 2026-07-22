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

  Map<String, dynamic> toMap() => {
        'title': title,
        'date': date,
        'isCompleted': isCompleted,
        'isActive': isActive,
      };

  factory ApplicationTimelineStage.fromMap(Map<String, dynamic> map) => ApplicationTimelineStage(
        title: map['title'] ?? '',
        date: map['date'] ?? '',
        isCompleted: map['isCompleted'] ?? false,
        isActive: map['isActive'] ?? false,
      );
}

class DocumentRequirement {
  final String name;
  final String status;

  const DocumentRequirement({required this.name, required this.status});

  Map<String, dynamic> toMap() => {'name': name, 'status': status};
  factory DocumentRequirement.fromMap(Map<String, dynamic> map) => DocumentRequirement(
        name: map['name'] ?? '',
        status: map['status'] ?? 'Pending',
      );
}

class ApplicationActivity {
  final String action;
  final String date;

  const ApplicationActivity({required this.action, required this.date});

  Map<String, dynamic> toMap() => {'action': action, 'date': date};
  factory ApplicationActivity.fromMap(Map<String, dynamic> map) => ApplicationActivity(
        action: map['action'] ?? '',
        date: map['date'] ?? '',
      );
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
  final List<ApplicationActivity> activities;
  final String notes;
  final List<String> linkedDocumentIds;

  const UniversityApplication({
    required this.id,
    required this.university,
    required this.course,
    required this.status,
    required this.submissionDate,
    required this.deadline,
    this.progress = 0.5,
    this.aiSuccessPrediction = 85,
    this.timeline = const [],
    this.documents = const [],
    this.activities = const [],
    this.notes = '',
    this.linkedDocumentIds = const [],
  });

  String get statusDisplay => status.name.toUpperCase();

  UniversityApplication copyWith({
    String? id,
    University? university,
    String? course,
    ApplicationStatus? status,
    String? submissionDate,
    String? deadline,
    double? progress,
    int? aiSuccessPrediction,
    List<ApplicationTimelineStage>? timeline,
    List<DocumentRequirement>? documents,
    List<ApplicationActivity>? activities,
    String? notes,
    List<String>? linkedDocumentIds,
  }) {
    return UniversityApplication(
      id: id ?? this.id,
      university: university ?? this.university,
      course: course ?? this.course,
      status: status ?? this.status,
      submissionDate: submissionDate ?? this.submissionDate,
      deadline: deadline ?? this.deadline,
      progress: progress ?? this.progress,
      aiSuccessPrediction: aiSuccessPrediction ?? this.aiSuccessPrediction,
      timeline: timeline ?? this.timeline,
      documents: documents ?? this.documents,
      activities: activities ?? this.activities,
      notes: notes ?? this.notes,
      linkedDocumentIds: linkedDocumentIds ?? this.linkedDocumentIds,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'university': university.toMap(),
        'course': course,
        'status': status.name,
        'submissionDate': submissionDate,
        'deadline': deadline,
        'progress': progress,
        'aiSuccessPrediction': aiSuccessPrediction,
        'timeline': timeline.map((t) => t.toMap()).toList(),
        'documents': documents.map((d) => d.toMap()).toList(),
        'activities': activities.map((a) => a.toMap()).toList(),
        'notes': notes,
        'linkedDocumentIds': linkedDocumentIds,
      };

  factory UniversityApplication.fromMap(Map<String, dynamic> map, String docId) {
    ApplicationStatus parsedStatus = ApplicationStatus.submitted;
    final statusStr = map['status'] as String?;
    for (final s in ApplicationStatus.values) {
      if (s.name == statusStr) parsedStatus = s;
    }

    return UniversityApplication(
      id: docId,
      university: University.fromMap(map['university'] as Map<String, dynamic>? ?? {}),
      course: map['course'] ?? 'Computer Science',
      status: parsedStatus,
      submissionDate: map['submissionDate'] ?? '15 Oct 2025',
      deadline: map['deadline'] ?? '01 Dec 2025',
      progress: (map['progress'] as num?)?.toDouble() ?? 0.5,
      aiSuccessPrediction: map['aiSuccessPrediction'] ?? 85,
      timeline: (map['timeline'] as List<dynamic>?)
              ?.map((t) => ApplicationTimelineStage.fromMap(t as Map<String, dynamic>))
              .toList() ??
          const [],
      documents: (map['documents'] as List<dynamic>?)
              ?.map((d) => DocumentRequirement.fromMap(d as Map<String, dynamic>))
              .toList() ??
          const [],
      activities: (map['activities'] as List<dynamic>?)
              ?.map((a) => ApplicationActivity.fromMap(a as Map<String, dynamic>))
              .toList() ??
          const [],
      notes: map['notes'] ?? '',
      linkedDocumentIds: List<String>.from(map['linkedDocumentIds'] ?? []),
    );
  }
}
