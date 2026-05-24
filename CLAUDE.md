# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Makena** is a Flutter mobile app (iOS & Android) that analyzes body measurements and skin undertone to generate personalized style recommendations and color palettes.

## Environment setup

Flutter SDK is installed at `~/flutter`. Android SDK is at `~/Android/Sdk`. Both are added to `~/.bashrc`, but in a new terminal or script you may need:

```bash
export PATH="$HOME/flutter/bin:$HOME/Android/Sdk/cmdline-tools/latest/bin:$HOME/Android/Sdk/platform-tools:$PATH"
export ANDROID_HOME="$HOME/Android/Sdk"
```

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run on connected device / emulator
flutter run

# Build debug APK (fast, for sideloading)
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk

# Build release APK (optimised, for sideloading)
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Build Android App Bundle (required for Google Play Store)
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab

# Build iOS (requires macOS + Xcode — not possible on this Linux machine)
flutter build ios

# Run tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Analyze code
flutter analyze

# Format code
dart format .
```

## Architecture

The app is a 4-screen linear flow using `StatefulWidget` with `AnimatedSwitcher` transitions. There is no external state management library — all state lives in widget state classes.

### Screen Flow

1. **`OnboardingScreen`** — PageView introducing the app's value propositions.
2. **`MeasurementInputScreen`** — Manual profile entry (body measurements, skin undertone selection), saved profiles via `ActionChip` wrappers.
3. **`CameraSimulationView`** — Live camera feed using the `camera` package. Initializes the back-facing camera, requests `camera` and `microphone` permissions via `permission_handler`, renders `CameraPreview` layered under a `CustomPainter` overlay (`SilhouetteOverlayPainter`). On capture, currently returns hardcoded placeholder metrics while image analysis logic is pending.
4. **`ResultsScreen`** — Translates shoulder/bust/waist/hip ratios into body shape categories (Pear, Hourglass, Rectangle) and displays style rule sets and color palettes based on skin chemistry inputs.

### Key Dependencies

| Package | Version | Purpose |
|---|---|---|
| `camera` | ^0.10.6 | Live camera preview and image capture |
| `permission_handler` | ^11.3.1 | OS-level camera/microphone permission requests |

### Data Flow

`CameraSimulationView` calls `onScanComplete(shoulder, bust, waist, hip)` to pass measured ratios back up to `MeasurementInputScreen`, which then navigates to `ResultsScreen`.

## Android platform configuration

- **Permissions** declared in `android/app/src/main/AndroidManifest.xml`: `CAMERA`, `RECORD_AUDIO`, camera feature flags.
- **`minSdk`** is managed by Flutter's Gradle plugin (`flutter.minSdkVersion`, currently 21) — the `camera` package requires ≥ 21.
- **App ID**: `com.makena.app.makena` (set in `android/app/build.gradle.kts`).
- **iOS privacy strings** are set in `ios/Runner/Info.plist` (`NSCameraUsageDescription`, `NSMicrophoneUsageDescription`). iOS builds require macOS + Xcode + Apple Developer account.

## Play Store signing

To sign a release build for the Play Store:

1. Generate keystore once: `keytool -genkey -v -keystore ~/makena-release.jks -keyAlias makena -keyalg RSA -keysize 2048 -validity 10000`
2. Create `android/key.properties` (do **not** commit this file):
   ```
   storePassword=<password>
   keyPassword=<password>
   keyAlias=makena
   storeFile=/home/javi/makena-release.jks
   ```
3. Wire it into `android/app/build.gradle.kts` using Flutter's standard signing config pattern.
4. Run `flutter build appbundle --release` and upload the `.aab`.

## Known Incomplete Areas

- `CameraSimulationView._triggerCaptureSequence()` returns hardcoded metrics (`96.5, 92.0, 66.4, 98.2`) — real image analysis is not yet implemented.
