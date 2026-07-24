import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/repositories/base_repository.dart';
import '../models/resume_model.dart';

class ResumeRepository extends BaseRepository<UserResume> {
  ResumeRepository() : super('resumes');

  @override
  UserResume fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserResume.fromMap(doc.data() ?? {}, doc.id);
  }

  @override
  Map<String, dynamic> toFirestore(UserResume model) {
    return model.toMap();
  }

  Stream<List<UserResume>> getResumesStream() {
    final col = getUserCollection();
    if (col == null) return Stream.value([]);
    return col.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserResume.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}
