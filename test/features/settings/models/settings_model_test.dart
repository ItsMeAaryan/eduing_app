import 'package:flutter_test/flutter_test.dart';
import 'package:eduing_app/features/settings/models/settings_model.dart';

void main() {
  group('AppSettings Model Tests', () {
    test('Default constructor creates correct initial state', () {
      const settings = AppSettings();
      expect(settings.language, 'English');
      expect(settings.themeMode, 'System');
      expect(settings.fontSize, 14.0);
      expect(settings.pushNotifications, true);
    });

    test('copyWith updates fields correctly', () {
      const settings = AppSettings();
      final updated = settings.copyWith(
        themeMode: 'Dark',
        pushNotifications: false,
      );

      expect(updated.themeMode, 'Dark');
      expect(updated.pushNotifications, false);
      expect(updated.language, 'English'); // Unchanged
    });

    test('toFirestore serializes correctly', () {
      const settings = AppSettings();
      final map = settings.toFirestore();

      expect(map['language'], 'English');
      expect(map['themeMode'], 'System');
      expect(map['pushNotifications'], true);
    });
  });
}
