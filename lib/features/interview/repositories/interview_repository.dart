import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/repositories/base_repository.dart';

class InterviewRepository extends BaseRepository<Map<String, dynamic>> {
  InterviewRepository() : super('interview');

  @override
  Map<String, dynamic> fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return doc.data() ?? {};
  }

  @override
  Map<String, dynamic> toFirestore(Map<String, dynamic> model) {
    return model;
  }
}
