import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/repositories/base_repository.dart';
import '../models/document_model.dart';

class DocumentRepository extends BaseRepository<AppDocument> {
  DocumentRepository() : super('documents');

  @override
  AppDocument fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return AppDocument.fromMap(doc.data() ?? {}, doc.id);
  }

  @override
  Map<String, dynamic> toFirestore(AppDocument model) {
    return model.toMap();
  }

  Stream<List<AppDocument>> getDocumentsStream() {
    final col = getUserCollection();
    if (col == null) {
      return Stream.value([]);
    }
    return col.orderBy('uploadDate', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AppDocument.fromMap(doc.data(), doc.id)).toList();
    });
  }
}
