import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/repositories/base_repository.dart';
import '../models/chat_message.dart';

class CopilotRepository extends BaseRepository<ChatSession> {
  CopilotRepository() : super('chat_sessions');

  @override
  ChatSession fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ChatSession.fromMap(doc.data() ?? {}, doc.id);
  }

  @override
  Map<String, dynamic> toFirestore(ChatSession model) {
    return model.toMap();
  }

  Stream<List<ChatSession>> getChatSessionsStream() {
    final col = getUserCollection();
    if (col == null) return Stream.value([]);
    return col.orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ChatSession.fromMap(doc.data(), doc.id)).toList();
    });
  }
}
