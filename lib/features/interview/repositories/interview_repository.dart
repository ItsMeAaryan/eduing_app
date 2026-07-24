import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/repositories/base_repository.dart';
import '../models/interview_model.dart';

class InterviewRepository extends BaseRepository<InterviewSession> {
  InterviewRepository() : super('interview_sessions');

  @override
  InterviewSession fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return InterviewSession.fromMap(doc.data() ?? {}, doc.id);
  }

  @override
  Map<String, dynamic> toFirestore(InterviewSession model) {
    return model.toMap();
  }

  Stream<List<InterviewSession>> getSessionsStream() {
    final col = getUserCollection();
    if (col == null) return Stream.value([]);
    return col.orderBy('date', descending: true).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => InterviewSession.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}
