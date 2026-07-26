import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings_model.dart';

import '../repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider((ref) => SettingsRepository());

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(() {
  return SettingsNotifier();
});

class SettingsNotifier extends Notifier<AppSettings> {
  late final SettingsRepository _repository;

  @override
  AppSettings build() {
    _repository = ref.watch(settingsRepositoryProvider);
    _init();
    return const AppSettings();
  }

  Future<void> _init() async {
    // Attempt to load from Firestore (mocking uid as 'default' for now)
    final doc = await _repository.get('default');
    if (doc != null) {
      state = doc;
    }
  }

  void updateSetting({
    bool? conversationMemory,
    bool? aiSuggestions,
    bool? aiNotifications,
    bool? applicationUpdates,
    bool? scholarshipDeadlines,
    bool? interviewReminders,
    bool? plannerReminders,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? analyticsToggle,
    bool? developerMode,
    bool? mockApiToggle,
    String? language,
    String? themeMode,
    String? writingStyle,
    String? responseLength,
  }) {
    state = state.copyWith(
      conversationMemory: conversationMemory,
      aiSuggestions: aiSuggestions,
      aiNotifications: aiNotifications,
      applicationUpdates: applicationUpdates,
      scholarshipDeadlines: scholarshipDeadlines,
      interviewReminders: interviewReminders,
      plannerReminders: plannerReminders,
      emailNotifications: emailNotifications,
      pushNotifications: pushNotifications,
      analyticsToggle: analyticsToggle,
      developerMode: developerMode,
      mockApiToggle: mockApiToggle,
      language: language,
      themeMode: themeMode,
      writingStyle: writingStyle,
      responseLength: responseLength,
    );
    _repository.create('default', state);
  }

  void resetPreferences() {
    state = const AppSettings();
    _repository.create('default', state);
  }
}
