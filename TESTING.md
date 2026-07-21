# Testing EDUING

## Overview
EDUING relies heavily on automated testing to guarantee application stability and offline synchronization reliability. 

## Testing Types
1. **Unit Tests**: Found in `/test/core/` and `/test/features/`. Tests logic boundaries, model serialization (e.g., `AppSettings`), and repository outputs.
2. **Widget Tests**: Isolates custom Riverpod `ConsumerWidget` behaviors ensuring loading and offline states render properly without actual backend network connectivity.
3. **Integration Tests**: Tests full user journeys using `integration_test` (such as filling out a registration form, bypassing the `/login` gate, and triggering a Mock Gemini response).

## Running Tests
Run all unit and widget tests:
```bash
flutter test
```
To run tests with coverage:
```bash
flutter test --coverage
```
