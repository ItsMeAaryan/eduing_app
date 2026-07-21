# EDUING Architecture Overview

## Technology Stack
- **Framework**: Flutter (Dart)
- **State Management**: Riverpod (`flutter_riverpod`)
- **Navigation**: GoRouter
- **Backend Services**: Firebase Core, Auth, Firestore, Storage, Messaging, Crashlytics, Analytics
- **AI Integration**: Google Generative AI (`google_generative_ai` for Gemini)
- **Animations**: `flutter_animate`

## Module Structure (Feature-First)
EDUING utilizes a feature-first architectural pattern ensuring scalability. Each core feature is segmented into its own isolated directory inside `lib/features/`:

```
lib/
├── core/
│   ├── router/ (GoRouter Configuration)
│   ├── services/ (Firebase & Gemini Singletons)
│   └── theme/ (Colors, Typography, Design System)
├── features/
│   ├── auth/
│   ├── copilot/
│   ├── dashboard/
│   ├── documents/
│   ├── interview_coach/
│   ├── planner/
│   ├── profile/
│   ├── resume_builder/
│   ├── scholarships/
│   ├── sop_workspace/
│   └── universities/
└── shared/
    └── widgets/ (Global reusable components like MainLayout)
```

## State Management (Riverpod)
The application relies heavily on `StateNotifierProvider` to create unidirectional, predictable data flows. Local mocks currently simulate repository data retrieval, but they are fully decoupled to allow seamless swapping to Firestore streams in production without affecting UI widgets.

## Production Integration (Phase 17)
- **Authentication**: Gated through `/login` utilizing `FirebaseService.auth`.
- **AI Processing**: Sent asynchronously through `GeminiService` wrapping the official 1.5-flash LLM model.
- **Offline Persistence**: Firestore settings are configured globally on boot `CACHE_SIZE_UNLIMITED` for offline resilience.
