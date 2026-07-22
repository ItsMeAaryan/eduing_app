import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/repositories/base_repository.dart';
import '../models/sop_model.dart';

class SopRepository extends BaseRepository<UserSop> {
  SopRepository() : super('sops');

  @override
  UserSop fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserSop.fromMap(doc.data() ?? {}, doc.id);
  }

  @override
  Map<String, dynamic> toFirestore(UserSop model) {
    return model.toMap();
  }

  Stream<List<UserSop>> getSopsStream() {
    final col = getUserCollection();
    if (col == null) return Stream.value([]);
    return col.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserSop.fromMap(doc.data(), doc.id)).toList();
    });
  }
}
