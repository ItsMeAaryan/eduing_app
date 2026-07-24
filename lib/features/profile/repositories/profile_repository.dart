import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/repositories/base_repository.dart';

class ProfileRepository extends BaseRepository<Map<String, dynamic>> {
  ProfileRepository() : super('profile');

  @override
  Map<String, dynamic> fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return doc.data() ?? {};
  }

  @override
  Map<String, dynamic> toFirestore(Map<String, dynamic> model) {
    return model;
  }
}
