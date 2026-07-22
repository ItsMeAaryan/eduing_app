import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/repositories/base_repository.dart';
import '../../../shared/models/university_model.dart';

class UniversityRepository extends BaseRepository<University> {
  UniversityRepository() : super('universities', userScoped: false);

  @override
  University fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return University.fromMap(doc.data() ?? {}, docId: doc.id);
  }

  @override
  Map<String, dynamic> toFirestore(University model) {
    return model.toFirestore();
  }
}
