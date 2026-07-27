import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/repositories/base_repository.dart';
import '../models/university_application.dart';

class ApplicationRepository extends BaseRepository<UniversityApplication> {
  ApplicationRepository() : super('applications');

  @override
  UniversityApplication fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return UniversityApplication.fromMap(doc.data() ?? {}, doc.id);
  }

  @override
  Map<String, dynamic> toFirestore(UniversityApplication model) {
    return model.toMap();
  }

  Stream<List<UniversityApplication>> getApplicationsStream() {
    final col = getUserCollection();
    if (col == null) return Stream.value([]);
    return col.orderBy('updatedAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UniversityApplication.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}
