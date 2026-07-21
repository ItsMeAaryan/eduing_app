# CI/CD Pipeline

## GitHub Actions
Our primary continuous integration pipeline executes on every push and pull request targeted at `main` and `develop`.

### Pipeline Steps
1. **Setup**: Installs Java 17 and Flutter stable via `subosito/flutter-action`.
2. **Dependency Resolution**: Runs `flutter pub get`.
3. **Formatting Check**: Executes `dart format --set-exit-if-changed .`. Fails if developers did not format their code.
4. **Static Analysis**: Runs `flutter analyze`. Must return **0 issues**.
5. **Testing**: Runs the test suite via `flutter test`.
6. **Build**: Compiles a debug APK using `flutter build apk --debug` to ensure the compilation process remains healthy.

## Pull Request Policy
No branch can merge into `develop` or `main` without all GitHub Actions passing green. Memory leaks and dead provider subscriptions will cause integration tests to fail.
