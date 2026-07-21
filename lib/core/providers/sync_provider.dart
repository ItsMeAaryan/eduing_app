import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/sync/sync_service.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  final service = SyncService();
  service.initialize();
  ref.onDispose(() => service.dispose());
  return service;
});

final syncStateProvider = StreamProvider<SyncState>((ref) {
  final service = ref.watch(syncServiceProvider);
  return service.syncStateStream;
});
