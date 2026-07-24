import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/firebase/firebase_service.dart';
import 'core/services/notifications/notification_service.dart';
import 'core/services/notifications/background_task_service.dart';
import 'features/settings/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();

  final notificationService = NotificationService();
  notificationService.onNotificationTap = (route) {
    if (AppRouter.router.routerDelegate.navigatorKey.currentContext != null) {
      AppRouter.router.push(route);
    }
  };
  await notificationService.initialize();

  try {
    final backgroundTaskService = BackgroundTaskService();
    await backgroundTaskService.initialize();
    backgroundTaskService.registerTasks();
  } catch (e) {
    debugPrint('BackgroundTaskService initialization skipped: $e');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    ThemeMode themeMode;
    switch (settings.themeMode.toLowerCase()) {
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      case 'light':
        themeMode = ThemeMode.light;
        break;
      default:
        themeMode = ThemeMode.system;
        break;
    }

    return MaterialApp.router(
      title: 'EDUING',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
