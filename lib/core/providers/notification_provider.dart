import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notifications/notification_service.dart';
import '../services/notifications/background_task_service.dart';
import '../../features/settings/providers/settings_provider.dart';

final notificationServiceProvider = Provider((ref) => NotificationService());
final backgroundTaskServiceProvider =
    Provider((ref) => BackgroundTaskService());

final notificationInitializationProvider = FutureProvider<void>((ref) async {
  final notifService = ref.watch(notificationServiceProvider);
  final bgTaskService = ref.watch(backgroundTaskServiceProvider);
  final settings = ref.watch(settingsProvider);

  if (settings.pushNotifications) {
    await notifService.initialize();
    await bgTaskService.initialize();
    bgTaskService.registerTasks();
  }
});
