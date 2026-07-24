import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint("Native called background task: $task");

    try {
      switch (task) {
        case 'refreshPlannerReminders':
          // Fetch deadlines and schedule local notifications
          break;
        case 'checkScholarshipExpiry':
          // Fetch scholarships and check expiry
          break;
        case 'refreshApplicationStatus':
          // Fetch applications and notify if changed
          break;
      }
      return Future.value(true);
    } catch (err) {
      debugPrint("Background task failed: $err");
      return Future.value(false);
    }
  });
}

class BackgroundTaskService {
  Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
  }

  void registerTasks() {
    Workmanager().registerPeriodicTask(
      "1",
      "refreshPlannerReminders",
      frequency: const Duration(hours: 4),
    );

    Workmanager().registerPeriodicTask(
      "2",
      "checkScholarshipExpiry",
      frequency: const Duration(hours: 12),
    );

    Workmanager().registerPeriodicTask(
      "3",
      "refreshApplicationStatus",
      frequency: const Duration(hours: 6),
    );
  }
}
