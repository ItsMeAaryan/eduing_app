# Contributing to EDUING

Thank you for your interest in contributing!

## Architecture Standards
1. **Riverpod**: Do NOT use `StatefulWidget` unless strictly managing local animation state. All business logic goes in `StateNotifier`.
2. **Repositories**: Do NOT query `FirebaseService` from the UI. Data fetching belongs entirely in the `Repository` domain.
3. **Offline First**: We utilize `connectivity_plus` and Firebase cache. Always assume the user is offline. Do not block interactions waiting for a network callback. 
4. **Design System**: Use `AppColors` and `AppTypography`. Do not hardcode specific hex codes inside widgets.

## Submitting Code
1. Branch from `develop`.
2. Ensure you have run `dart format .`.
3. Ensure `flutter analyze` returns zero issues.
4. Ensure `flutter test` passes.
5. Create a Pull Request with a detailed summary.
