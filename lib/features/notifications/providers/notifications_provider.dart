import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_item.dart';

class NotificationsNotifier extends Notifier<List<NotificationItem>> {
  @override
  List<NotificationItem> build() {
    return _initialData;
  }

  static final List<NotificationItem> _initialData = [
    NotificationItem(
      id: '1',
      title: 'AI Copilot Finished Audit',
      message: 'Your SOP has been audited. You scored 85% ATS readiness.',
      type: 'ai',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Stanford Application Deadline',
      message:
          'Your Stanford university application is due in 3 days. Complete the checklist.',
      type: 'deadline',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Resume Exported',
      message:
          'Your Executive ATS Resume was exported successfully to your files.',
      type: 'success',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'System Update',
      message: 'Welcome to the newly redesigned EDUing app experience!',
      type: 'system',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
  ];

  void markAsRead(String id) {
    state =
        state.map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList();
  }

  void markAllAsRead() {
    state = state.map((n) => n.copyWith(isRead: true)).toList();
  }

  void clearAll() {
    state = [];
  }
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, List<NotificationItem>>(() {
  return NotificationsNotifier();
});
