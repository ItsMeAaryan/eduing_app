import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/repositories/base_repository.dart';

class UniversityRepository extends BaseRepository<Map<String, dynamic>> {
  UniversityRepository() : super('universities');

  @override
  Map<String, dynamic> fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return doc.data() ?? {};
  }

  @override
  Map<String, dynamic> toFirestore(Map<String, dynamic> model) {
    return model;
  }
}
