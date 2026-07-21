# EDUING Release Management

## Overview
This document outlines the strict protocol required to push EDUING into production environments (Google Play Store, Apple App Store).

## 1. Environment Configurations
Do NOT check API keys into source control. 
- Create a `.env.production` file in the root directory.
- Define `GEMINI_API_KEY` and any missing remote configuration hashes.

## 2. Android Release
Android uses ProGuard and R8 for minification.
1. Generate your production Upload Keystore.
2. Store `key.properties` inside `android/` (do NOT commit this).
3. Ensure `build.gradle` is set to `shrinkResources true` and `minifyEnabled true`.
4. Run:
```bash
flutter build appbundle --release --obfuscate --split-debug-info=./build/app/outputs/symbols
```
5. Upload the resulting `.aab` to Google Play Console.
6. Upload the symbols to Firebase Crashlytics if required.

## 3. iOS Release
iOS requires a registered Apple Developer Account.
1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select your provisioning profile and production certificate.
3. Update the App Version and Build Number.
4. Run:
```bash
flutter build ipa --release
```
5. Distribute using Transporter or directly via Xcode to TestFlight / App Store Connect.

## 4. Final Security Audit Checklist
- [ ] `firestore.rules` deployed to production Firebase project.
- [ ] `storage.rules` deployed.
- [ ] Authentication providers (Email, Google) enabled in console.
- [ ] Remote API keys restrict domains / package names (e.g., Maps API, Gemini API).
- [ ] Analytics streams configured correctly for Production vs Staging.
