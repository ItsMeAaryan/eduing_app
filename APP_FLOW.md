# EDUING Mobile App — Application Flow

This document outlines the user navigation flow through the completed modules of the EDUING mobile app.

## Core Navigation (Bottom Tab Bar)
1. **Home / Dashboard (`/`)** -> Main entry point. Quick access to summaries and AI interactions.
2. **Universities (`/universities`)** -> Discovery area for exploring colleges.
3. **Applications (`/applications`)** -> Central hub for tracking applied colleges.
4. **AI Copilot (`/ai`)** -> Placeholder for upcoming generative interactions.
5. **Profile (`/profile`)** -> Placeholder for user settings.

## Deep Flows

### 1. The Discovery & Comparison Flow
- **Universities Screen (`/universities`)** -> View list of universities.
  - ↳ **Tap University Card** -> Navigate to **University Details (`/university/:id`)**
    - ↳ View Hero Image, Stats, Info, and "Apply Now".
    - ↳ **Tap Compare Icon** -> Navigate to **AI Comparison (`/compare`)**
  - ↳ **Tap Compare on Card** -> Navigate to **AI Comparison (`/compare`)** directly.

### 2. The Application Pipeline Flow
- **Universities Screen** or **Details Screen** -> Tap **Apply Now**
  - ↳ Mocks an Application state in Riverpod and routes automatically to **Applications Screen (`/applications`)**.
- **Applications Screen (`/applications`)** -> View list of active tracked applications.
  - ↳ **Tap Application Card** -> Navigate to **Application Details (`/application/:id`)**.
    - ↳ View Hero parallax, timeline progress, action items, AI coach recommendations.

### 3. The Document Vault Flow
- **Application Details (`/application/:id`)** -> Tap **Manage Documents** or **Upload Documents**
  - ↳ Navigate to **Documents Vault (`/documents`)**.
    - ↳ View AI health score, filters, search, and list of uploaded documents.
  - ↳ **Tap Document Card** -> Navigate to **Document Preview (`/document/:id`)**.
    - ↳ View full image preview, OCR Readability scores, warnings, and document metadata.

### 4. The AI Resume Builder Flow
- **Application Details (`/application/:id`)** -> Tap **Resume**
  - ↳ Navigate to **Resume Dashboard (`/resume/builder`)**.
    - ↳ Manage sections (Education, Projects, etc.) and view overall ATS progress.
  - ↳ **Tap Eye Icon** -> Navigate to **Resume Preview (`/resume/preview`)**.
    - ↳ View live A4 formatted document rendering with horizontal template selectors.
  - ↳ **Tap AI Review** -> Navigate to **AI Resume Review (`/resume/review`)**.
    - ↳ Read complex breakdowns of Grammar, Formatting, and detailed AI Recommendations.

### 5. The AI SOP Workspace Flow
- **Application Details (`/application/:id`)** -> Tap **SOP**
  - ↳ Navigate to **SOP Dashboard (`/sop/builder`)**.
    - ↳ Edit targeted essay paragraphs and observe word count tracking.
  - ↳ **Tap Eye Icon** -> Navigate to **SOP Preview (`/sop/preview`)**.
    - ↳ View cohesive rendered text draft.
  - ↳ **Tap AI Review** -> Navigate to **AI SOP Review (`/sop/review`)**.
    - ↳ Review qualitative analytics (Storytelling, Goal Alignment) and context-aware feedback.

### 6. The AI Interview Coach Flow
- **Application Details (`/application/:id`)** -> Tap **Coach**
  - ↳ Navigate to **Interview Dashboard (`/interview`)**.
    - ↳ Access question banks, view overall readiness, and monitor session history.
  - ↳ **Tap Question** -> Navigate to **Question Practice (`/interview/practice`)**.
    - ↳ Study detailed sample answers, hints, and suggested structures (STAR method).
  - ↳ **Tap Mock Interview** -> Navigate to **Mock Interview (`/interview/mock`)**.
    - ↳ Participate in a simulated video session with progressing questions.
  - ↳ **Finish Mock / Tap Chart Icon** -> Navigate to **Interview Report (`/interview/report`)**.
    - ↳ View detailed performance grades across Communication, Technical Knowledge, and Body Language.

### 7. The AI Scholarship Hub Flow
- **Dashboard (`/`)** -> Tap **Scholarships (Statistics Panel)**
  - ↳ Navigate to **Scholarships Hub (`/scholarships`)**.
    - ↳ Access Funding AI Advisor, global search capabilities, and save/favorite metrics.
  - ↳ **Tap Scholarship Card** -> Navigate to **Scholarship Details (`/scholarship/:id`)**.
    - ↳ Review deep success analytics, covered expenses, and dynamic checklists.
  - ↳ **Tap Compare Icon (AppBar)** -> Navigate to **Scholarships Compare (`/scholarships/compare`)**.
    - ↳ Compare multiple saved scholarship profiles side-by-side.

### 8. The AI Copilot Flow
- **Bottom Navigation** -> Tap **Copilot (AI Icon)**
  - ↳ Navigate to **Copilot Home (`/ai`)**.
    - ↳ View AI Intelligence (Insights, Tasks, Deadlines), and Suggested Prompts.
  - ↳ **Tap Quick Action / Chat FAB** -> Navigate to **AI Chat (`/ai/chat`)**.
    - ↳ Interact with a simulated context-aware LLM for admissions advice.
  - ↳ **Tap Settings Icon** -> Navigate to **Copilot Settings (`/ai/settings`)**.
    - ↳ Configure Conversation Memory, Theme, and Language preferences.

### 9. The Planner & Calendar Flow
- **Bottom Navigation** -> Tap **Planner (Calendar Icon)**
  - ↳ Navigate to **Planner Dashboard (`/planner`)**.
    - ↳ View high-level metrics (Pending, Completed, Deadlines, AI Score).
  - ↳ **Tap Timeline Tab** -> Scroll chronologically through Today's Agenda and Upcoming Deadlines.
  - ↳ **Tap Calendar Tab** -> View a grid-style monthly layout pinpointing days with active events.
  - ↳ **Tap Task Circle** -> Toggle task completion status utilizing `PlannerProvider`.

### 10. The User Profile Flow
- **Bottom Navigation** -> Tap **Profile (Avatar Icon)**
  - ↳ Navigate to **Profile Dashboard (`/profile`)**.
    - ↳ View Hero metrics (Profile Completion % and AI Readiness Score).
    - ↳ Review macro Application Summaries (SOP, Interviews, Resumes).
  - ↳ **Tap Academic Tab** -> View deep data points on GPA, Research, and standardized tests.
  - ↳ **Tap Preferences Tab** -> Explore target countries, budgets, and study mode preferences.
  - ↳ **Tap Achievements Tab** -> Scroll chronological milestone badges mapping platform journey.
  - ↳ **Tap Settings Icon (App Bar)** -> Navigate to **Settings Dashboard (`/settings`)**.
    - ↳ Configure global platform AI, notifications, theme, and privacy preferences.

### 11. Authentication & Infrastructure
- **App Launch**
  - ↳ Verify Firebase Authentication Session.
  - ↳ If NOT authenticated -> Navigate to **AuthScreen (`/login`)**.
    - ↳ Enter credentials and dispatch `AuthController.signInWithEmail`.
    - ↳ Alternative: Toggle to `Register` -> Dispatches `AuthController.registerWithEmail`.
    - ↳ Alternative: Toggle to `Forgot Password` -> Dispatches `AuthController.sendPasswordReset`.
  - ↳ If authenticated -> Navigate to **Dashboard (`/`)**.
