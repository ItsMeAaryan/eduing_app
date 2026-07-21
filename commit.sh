#!/bin/bash
git add lib/features/auth/
git commit -m "feat(auth): implement firebase authentication flow"

git add lib/core/services/firebase/
git commit -m "feat(firebase): add firebase initialization service"

git add lib/core/repositories/base_repository.dart
git commit -m "refactor(repository): introduce generic base repository"

git add lib/features/universities/
git commit -m "feat(university): build university comparison"

git add lib/features/applications/
git commit -m "feat(application): implement application tracking"

git add lib/features/scholarships/
git commit -m "feat(scholarship): implement scholarship hub"

git add lib/features/planner/
git commit -m "feat(planner): add planner management"

git add lib/features/profile/
git commit -m "feat(profile): implement user profile module"

git add lib/features/settings/
git commit -m "feat(settings): add settings dashboard"

git add lib/core/repositories/storage_repository.dart lib/core/providers/storage_provider.dart lib/features/documents/
git commit -m "feat(storage): integrate firebase storage uploads and document vault"

git add lib/core/services/ai/ lib/features/resume/ lib/features/sop/ lib/features/interview/ lib/features/copilot/ lib/core/providers/ai_provider.dart
git commit -m "feat(ai): integrate Gemini AI review service"

git add lib/core/services/sync/ lib/core/providers/sync_provider.dart lib/shared/widgets/sync_indicator.dart lib/shared/widgets/main_layout.dart
git commit -m "feat(sync): add offline synchronization layer"

git add lib/core/services/notifications/ lib/core/providers/notification_provider.dart lib/main.dart lib/core/router/app_router.dart
git commit -m "feat(notification): implement FCM notification service"

git add firestore.rules storage.rules
git commit -m "feat(security): add firestore and storage rules"

git add .github/ CI_CD.md
git commit -m "ci: configure github actions pipeline"

git add test/
git commit -m "test(settings): add settings model tests"

git add android/app/build.gradle
git commit -m "build(android): enable release optimizations"

git add pubspec.yaml pubspec.lock linux/ macos/ windows/
git commit -m "chore(deps): update dependencies and platforms"

git add lib/features/dashboard/
git commit -m "feat(dashboard): refine dashboard layout"

git add ARCHITECTURE.md APP_FLOW.md CHANGELOG.md PROJECT_PROGRESS.md RELEASE.md TESTING.md CONTRIBUTING.md
git commit -m "docs: finalize release documentation"

git add -A
git commit -m "chore: final adjustments"

git log --oneline --graph --decorate -25
git status
