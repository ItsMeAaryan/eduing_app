import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/repositories/base_repository.dart';
import '../models/settings_model.dart';

class SettingsRepository extends BaseRepository<AppSettings> {
  SettingsRepository() : super('settings');

  @override
  AppSettings fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return AppSettings.fromFirestore(doc);
  }

  @override
  Map<String, dynamic> toFirestore(AppSettings model) {
    return model.toFirestore();
  }
}
