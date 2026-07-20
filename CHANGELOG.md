# Changelog

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
