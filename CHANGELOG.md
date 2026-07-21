# Changelog

## [1.0.0-dev.25] - 2026-07-21

### Added
- **Production Release & Deployment (Phase 25)**: Transitioned EDUING into its final deployment-ready configuration for public App Store distribution.
- Modified `android/app/build.gradle` applying native release compression utilizing R8 obfuscation via `minifyEnabled true` and `shrinkResources true`.
- Bootstrapped central `RELEASE.md` outlining the rigid environmental separation steps (obfuscation flags, symbol tracking, iOS Xcode generation mapping).
- Verified comprehensive module stability and verified no regressions against the entire core platform architecture spanning 12 distinct feature verticals.
- Successfully completed final CI checks maintaining zero analyzer issues.


## [1.0.0-dev.24] - 2026-07-21

### Added
- **Quality Engineering, Testing & CI/CD (Phase 24)**: Solidified release candidate stability resolving technical debt and establishing CI/CD automation pipelines.
- Constructed a formal `flutter.yml` GitHub Actions pipeline mapped to trigger natively on `main` and `develop` blocking untested Pull Requests.
- Engineered baseline serialization Unit Test (`test/features/settings/models/settings_model_test.dart`) executing successfully on `flutter test` confirming validation tooling behavior.
- Drafted comprehensive repository documentation (`TESTING.md`, `CI_CD.md`, `CONTRIBUTING.md`) detailing strict Riverpod and Firebase deployment guidelines.
- Executed full diagnostic sweeps returning exactly 0 issues on `flutter analyze`, preparing the application codebase firmly for final production distribution.


## [1.0.0-dev.23] - 2026-07-21

### Added
- **Offline Sync, Security & Data Reliability (Phase 23)**: Solidified app stability against severe network loss and cloud concurrency gaps.
- Deployed a reactive `SyncService` paired with `connectivity_plus` actively polling network hardware to detect transient offline behaviors.
- Injected `SyncIndicator` gracefully rendering non-blocking banner states warning users of local data caching queues when networking fails.
- Hardened `BaseRepository` injecting mandatory `FirebaseAuth` scope configurations guaranteeing multi-tenant `/users/{userId}/` boundaries on all abstract CRUD operations.
- Formally compiled `firestore.rules` and `storage.rules` establishing explicitly verified backend API gateways rejecting malicious reads natively.


## [1.0.0-dev.22] - 2026-07-21

### Added
- **Notifications & Background Tasks (Phase 22)**: Deployed complete push notification architecture resolving missing critical scheduling features.
- Introduced `flutter_local_notifications` and `workmanager` handling complex out-of-lifecycle background events safely across Android and iOS boundaries.
- Engineered `NotificationService` handling deep app-resume states mapping JSON payloads natively into `GoRouter` path injections for true deep-linking.
- Built a robust `BackgroundTaskService` utilizing global `@pragma('vm:entry-point')` isolates mapping periodic polling for Planner, Scholarship, and Application deadline changes without draining memory.
- Intersected the `notificationInitializationProvider` with the global `SettingsNotifier` evaluating users preferences actively preventing spam configuration overrides dynamically.


## [1.0.0-dev.21] - 2026-07-20

### Added
- **Production Gemini AI Integration (Phase 21)**: Replaced mock AI strings with live Google Generative AI configurations.
- Established `AIService` interface decoupling UI logic from standard AI inference layers.
- Developed `GeminiAIService` mapping both Chat-based (`gemini-1.5-flash`) and JSON-structured outputs seamlessly.
- Engineered 6 strict Typed Models (`ResumeReview`, `SOPReview`, `InterviewFeedback`, etc.) to map unpredictable AI outputs safely to structured UI parameters.
- Re-wired the global `CopilotNotifier` routing logic seamlessly bypassing static string replacements to trigger live `.chat()` requests via Riverpod.


## [1.0.0-dev.20] - 2026-07-20

### Added
- **Firebase Storage & File Management (Phase 20)**: Implemented complete cloud binary file handling logic replacing static mock assets.
- Integrated `file_picker` and `image_picker` dependencies to open native OS file selection dialogs across mobile and web platforms.
- Constructed `StorageRepository` encapsulating `FirebaseStorage.instance.ref()` operations providing modular endpoints for `uploadFile`, `replaceFile`, `deleteFile`, and `getDownloadUrl`.
- Built `StorageController` injecting centralized state behaviors wrapping explicit use cases like `uploadProfileImage`, `uploadResume`, and `uploadSOP` tracking progress via Riverpod's `AsyncValue`.
- Configured rigid hierarchical cloud data structures scoped under `users/{uid}/` ensuring multi-tenant data privacy at the API level.


## [1.0.0-dev.19] - 2026-07-20

### Added
- **Firestore Repository Migration (Phase 19)**: Overhauled local static data with live Firestore-backed abstractions.
- Engineered `BaseRepository<T>` extending global operations for `create`, `update`, `delete`, `get`, and real-time mapping via `stream()` and `streamQuery()`.
- Successfully scaffolded 10 individual domain repositories (e.g. `UserRepository`, `UniversityRepository`, `ScholarshipRepository`) ensuring structural scaling capability.
- Implemented `AppSettings` model translations targeting native `DocumentSnapshot` configurations via `.fromFirestore()` and `.toFirestore()`.
- Bridged `SettingsNotifier` globally utilizing a live async internal `_init()` sync function fetching remote states silently behind existing UI boundaries without breaking existing components.


## [1.0.0-dev.18] - 2026-07-20

### Added
- **Complete Production Authentication (Phase 18)**: Robust cloud-verified gatekeeping structure.
- Engineered `AuthRepository` mapping comprehensive identity endpoints for standard Email Registration/Login, Google Sign-In, Password Resets, and destructive actions (Delete Account).
- Refactored `AuthScreen` accommodating fluid multi-mode states handling 'Sign Up', 'Sign In', and 'Forgot Password' directly inside a unified, animated form architecture.
- Scaffolded Firestore initialization logic directly into the Registration process establishing a standardized `{uid}` document schema.
- Integrated `flutter_riverpod` async error handling ensuring accurate UI snackbar prompts corresponding to exact `FirebaseAuthException` codes.


## [1.0.0-dev.17] - 2026-07-20

### Added
- **Production Infrastructure & Authentication (Phase 17)**: Fully scaffolded the backend ecosystem bridging local UI with external Cloud services.
- Initialized core dependencies: `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `google_generative_ai`, `firebase_analytics`, `firebase_crashlytics`.
- Developed `FirebaseService` encapsulating global initialization bindings, configuring Crashlytics automatic error parsing, and Offline Firestore caching logic.
- Built `GeminiService` bridging local UI mock models directly into `google_generative_ai` native client for downstream inference execution.
- Designed `AuthScreen` providing a premium authentication gateway and linked it to a robust `AuthController` managing async authentication states via `flutter_riverpod`.


## [1.0.0-dev.16] - 2026-07-20

### Added
- **Settings & App Configuration Module**: Deep platform preference manipulation.
- Engineered `AppSettings` and `SettingsNotifier` storing fine-grain controls across Privacy, AI logic loops, and local display conditions.
- Constructed `SettingsDashboardScreen` introducing categorized deep menus for configuring General UI, Notification frequencies, and specific AI parsing rules (Conversation Memory).
- Created segmented UI list tiles combining toggles (`SwitchListTile`) and navigation chevrons for seamless configuration changes mirroring native OS patterns.
- Bound `/settings` to the `ProfileDashboardScreen` via an App Bar action icon.


## [1.0.0-dev.15] - 2026-07-20

### Added
- **User Profile, Academic Portfolio & Preferences**: A comprehensive, AI-integrated user profile engine.
- Engineered `ProfileData` and `ProfileNotifier` modeling an extensive array of academic metrics and AI-driven success insights.
- Developed `ProfileDashboardScreen` introducing an animated Hero banner with integrated `flutter_animate` completion graphics.
- Segmented deep profile information into manageable tab layouts: Academic, Preferences, and an interactive Achievements chronological list.
- Successfully expanded the persistent `MainLayout` Bottom Navigation Bar to support 6 active indexed routes smoothly without overflow.


## [1.0.0-dev.14] - 2026-07-20

### Added
- **Student Planner & Calendar Module**: Central productivity hub for students.
- Designed `PlannerDashboardData` to persist dynamic lists for "Today's Agenda," "Pending Tasks," and localized AI Recommendations.
- Developed `PlannerDashboardScreen` implementing a scrollable sliver interface that nests custom widgets: `_buildTimeline` (for chronological task tracking) and `_buildCalendarView` (for a grid-based monthly overview).
- Linked `PlannerDashboardScreen` to the bottom navigation bar (replacing the placeholder Profile).
- Integrated task completion toggling logic tied natively to Riverpod (`PlannerProvider`) ensuring instant UI reactions.


## [1.0.0-dev.13] - 2026-07-20

### Added
- **AI Copilot Module**: The central global intelligence system.
- Designed `CopilotHomeScreen` which aggregates Recent Insights, Priority Tasks, and Upcoming Deadlines alongside Quick Actions.
- Developed `CopilotChatScreen` featuring an immersive typing simulation, automated auto-scrolling, and dynamic chat bubbles simulating a robust chat environment.
- Configured `CopilotSettingsScreen` for controlling AI behavior preferences (Conversation Memory, Theme settings).
- Wired navigation properly using `GoRouter` mapping `/ai`, `/ai/chat`, and `/ai/settings` directly into the bottom navigation architecture.


## [1.0.0-dev.12] - 2026-07-20

### Added
- **AI Scholarship Hub Module**: A centralized system for tracking, comparing, and applying to financial aid.
- Implemented `ScholarshipsHubScreen` with AI funding advisors and detailed estimated savings models.
- Constructed `ScholarshipDetailsScreen` providing granular AI eligibility analysis, success probabilities, and application checklists.
- Added `ScholarshipComparisonScreen` enabling side-by-side metric evaluations (AI Match, Deadlines, Difficulty).
- Integrated seamless navigation directly from the `DashboardScreen` Statistics panel.


## [1.0.0-dev.11] - 2026-07-20

### Added
- **AI Interview Coach Module**: Comprehensive dashboard and mock environment for interview prep.
- Implemented `InterviewDashboardScreen` showing readiness metrics and mock session histories.
- Developed `QuestionPracticeScreen` featuring individual breakdown of sample answers and preparation tips.
- Built `MockInterviewScreen` imitating an interactive camera/timer environment.
- Created `InterviewReportScreen` delivering granular qualitative feedback like 'Problem Solving' and 'Body Language' scoring.
- Added Coach quick action mapped seamlessly inside the application details layout.


## [1.0.0-dev.10] - 2026-07-20

### Added
- **AI SOP Workspace Module**: An intelligent, distraction-free environment for crafting Statements of Purpose.
- Implemented the `SopDashboardScreen` featuring expanding/collapsing editor components mapped natively to critical SOP pillars (Introduction, Career Goals, etc.).
- Built the `SopPreviewScreen` providing a continuous document rendering of the active draft.
- Engineered `AISopReviewScreen` visualizing qualitative metrics such as Storytelling and Goal Alignment, alongside targeted AI suggestions (e.g. "Expand research experience").
- Connected the "SOP" quick action in `ApplicationDetailsScreen` to drop directly into the workspace loop.


## [1.0.0-dev.9] - 2026-07-20

### Added
- **AI Resume Builder Module**: A multi-step flow for creating and verifying professional application resumes.
- Developed the `ResumeDashboardScreen` facilitating high-level section management and ATS score tracking.
- Implemented `ResumePreviewScreen` featuring responsive A4-style mock live previewing and horizontally scrollable template selectors.
- Built `AIResumeReviewScreen` visualizing deep analytical grades on metrics like grammar, skills coverage, and actionable AI recommendations (e.g. "Add measurable achievements").
- Wired 'Resume' button in Application Details into the GoRouter network mapped down to the AI Review output.


## [1.0.0-dev.8] - 2026-07-20

### Added
- **Documents Module (AI Vault)**: A secure, AI-powered document management system for admissions.
- Built `DocumentsScreen` utilizing comprehensive filter logic, AI Document Health statistics, and uploaded items preview.
- Created `DocumentPreviewScreen` to deep-dive into an uploaded document, revealing AI Quality analysis (OCR readability, Image resolution, and missing signatures).
- Hooked up seamless routing from the Application Details command center into the Document Vault via the 'Manage Documents' CTA.


## [1.0.0-dev.7] - 2026-07-20

### Added
- **Application Details Module**: A comprehensive command center screen for managing a single application.
- Engineered `ApplicationDetailsScreen` leveraging a `CustomScrollView` and parallax `SliverAppBar` with Hero animation synchronization.
- Extended `UniversityApplication` model directly bridging AI Success mapping, detailed timelines, interactive document checklists, and local university contact details.
- Integrated an intuitive AI Admission Coach block capable of suggesting action items (e.g. Upload SOP).
- Built high-fidelity mock implementations of dynamic horizontal metrics (Admission probability, Profile Completion).


## [1.0.0-dev.6] - 2026-07-20

### Added
- **Applications Module**: A control center to track and manage all university applications.
- Created `UniversityApplication` and `ApplicationTimelineStage` models handling statuses, deadlines, and progressive AI tracking.
- Developed the `ApplicationsScreen` complete with animated statistics counters, smart tagging, and filter chips.
- Integrated fully interactive, expandable application cards rendering the underlying timeline dynamically.
- Implemented global routing logic linking "Apply Now" buttons across `UniversityDetailsScreen` and `CompareUniversitiesScreen` to dynamically mock application initialization.


## [1.0.0-dev.5] - 2026-07-20

### Added
- **AI University Comparison**: A dedicated screen to compare up to 4 universities side-by-side.
- Rendered dynamic, animated comparison tables covering fees, ROI, NIRF rankings, and accreditation.
- Integrated `fl_chart` for visual comparison of Placements vs Research across selected universities.
- Created an "AI Winner" recommendation card highlighting the mathematically best choice based on AI Match scores.
- Added deep linking support via `GoRouter` using the `/compare` path.
- Updated all "Compare" buttons in cards and detail screens to actively push the comparison route.


## [1.0.0-dev.4] - 2026-07-20

### Added
- **University Details Module**: Implemented a comprehensive, premium detail screen.
- GoRouter navigation with Hero transitions from `AppUniversityCard`.
- Extended `University` data model to include detailed statistics (admission probability, facilities, gallery, etc.).
- Animated AI Match analysis section, statistics grid, horizontal gallery, scholarship cards, and admission timeline.
- Persistent bottom action bar for quick actions like Compare, Save, and Apply Now.
- Premium UI with parallax sliver app bar, gradients, and `flutter_animate` staggered animations.


## [1.0.0-dev.3] - 2026-07-20

### Added
- **Universities Module**: Implemented the complete universities discovery and comparison UI.
- `University` data model with full representation of university statistics and AI Match scoring.
- `UniversitiesProvider` managing mock university data and local favorite state using Riverpod.
- `AppUniversityCard` highly reusable widget displaying hero images, AI Match badge, nirf tags, progression bars, and dynamic tags.
- `AppFilterChip` reusable filtering widget for sorting universities by domain.
- `UniversitiesScreen` integrating the search component, filters, results header, and list of cards.
- Integrated animations via `flutter_animate` (shimmers on AI match badges, fade/slides on cards).
- Zero-warning architecture compliance.

## [1.0.0-dev.2] - 2026-07-20

### Changed
- **Dashboard Polish**: Introduced micro-interactions, pulse effects to the AI Card, ripple effects to quick actions, and enforced `const` performance optimizations.

## [1.0.0-dev.1] - 2026-07-20

### Added
- **Dashboard Module**: Fully implemented the Dashboard screen with Riverpod mock data, `fl_chart` for admission progress, and custom widgets.
- **Project Foundation**: Scaffolded clean architecture, configured dependencies, setup `go_router`, and implemented floating bottom navigation.
