import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase/firebase_service.dart';

abstract class BaseRepository<T> {
  final String collection;
  final bool userScoped;
  final FirebaseFirestore _firestore = FirebaseService.firestore;

  BaseRepository(this.collection, {this.userScoped = true});

  String get _uid {
    final user = FirebaseService.auth.currentUser;
    if (user == null) throw Exception('User must be authenticated to access this resource.');
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _colRef {
    if (userScoped) {
      return _firestore.collection('users').doc(_uid).collection(collection);
    }
    return _firestore.collection(collection);
  }

  T fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc);
  Map<String, dynamic> toFirestore(T model);

  Future<void> create(String id, T model) async {
    await _colRef.doc(id).set(toFirestore(model));
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await _colRef.doc(id).update(data);
  }

  Future<void> delete(String id) async {
    await _colRef.doc(id).delete();
  }

  Future<T?> get(String id) async {
    final doc = await _colRef.doc(id).get();
    if (!doc.exists) return null;
    return fromFirestore(doc);
  }

  Stream<T?> stream(String id) {
    return _colRef.doc(id).snapshots().map((doc) => doc.exists ? fromFirestore(doc) : null);
  }

  Stream<List<T>> streamQuery(Query<Map<String, dynamic>> query) {
    return query.snapshots().map((snapshot) => snapshot.docs.map(fromFirestore).toList());
  }
}
