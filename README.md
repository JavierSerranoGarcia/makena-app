# Makena

A Flutter mobile application that analyzes body measurements and skin undertone to generate personalized style recommendations and color palettes.

## Features

- **Body Measurement Analysis**: Capture and analyze body measurements (shoulder, bust, waist, hip ratios)
- **Skin Undertone Detection**: Analyze skin chemistry to determine optimal color palettes
- **Personalized Style Recommendations**: Get tailored style advice based on your body shape (Pear, Hourglass, Rectangle)
- **Profile Management**: Save and manage multiple measurement profiles
- **Live Camera Preview**: Real-time camera feed with silhouette overlay for measurement capture

## Screens

1. **Onboarding** — Introduction to the app's value propositions
2. **Measurement Input** — Manual profile entry with saved profile management
3. **Camera Simulation** — Live camera feed with overlay for body measurement capture
4. **Results** — Body shape analysis with personalized style rules and color palettes

## Requirements

- Flutter SDK >= 3.0.0 < 4.0.0
- Android SDK (for Android builds)
- Xcode (for iOS builds, macOS only)
- Camera permissions on device

## Installation

### Clone the Repository

```bash
git clone <repository-url>
cd makena
```

### Install Dependencies

```bash
flutter pub get
```

## Usage

### Run on Connected Device/Emulator

```bash
flutter run
```

### Build Commands

```bash
# Debug APK (fast, for sideloading)
flutter build apk --debug

# Release APK (optimized, for sideloading)
flutter build apk --release

# Android App Bundle (for Google Play Store)
flutter build appbundle --release

# iOS (requires macOS + Xcode)
flutter build ios
```

## Development

### Run Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart
```

### Code Quality

```bash
# Analyze code
flutter analyze

# Format code
dart format .
```

## Project Structure

```
makena/
├── lib/                    # Dart source files
├── android/                # Android platform configuration
├── ios/                    # iOS platform configuration
├── test/                   # Test files
├── docs/                   # Documentation
└── scripts/                # Utility scripts
```

## Key Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `camera` | ^0.10.6 | Live camera preview and image capture |
| `permission_handler` | ^11.3.1 | OS-level camera/microphone permission requests |
| `google_mlkit_pose_detection` | ^0.14.1 | Pose detection for body analysis |
| `shared_preferences` | ^2.5.5 | Local data persistence |

## Platform Configuration

### Android

- **App ID**: `com.makena.app.makena`
- **Min SDK**: 21 (required by camera package)
- **Permissions**: CAMERA, RECORD_AUDIO

### iOS

- Requires iOS privacy strings in `Info.plist`:
  - `NSCameraUsageDescription`
  - `NSMicrophoneUsageDescription`
- iOS builds require macOS, Xcode, and Apple Developer account

## Play Store Release

To sign a release build for Google Play:

1. **Generate keystore**:
   ```bash
   keytool -genkey -v -keystore ~/makena-release.jks -keyAlias makena -keyalg RSA -keysize 2048 -validity 10000
   ```

2. **Create `android/key.properties`** (do not commit):
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=makena
   storeFile=/path/to/makena-release.jks
   ```

3. **Build signed bundle**:
   ```bash
   flutter build appbundle --release
   ```

## Data Flow

The app follows a linear 4-screen flow using `StatefulWidget` with `AnimatedSwitcher` transitions:

1. User completes onboarding
2. Enters or selects a profile with body measurements
3. Captures measurements via camera (or uses manual input)
4. Receives personalized results based on body shape and skin undertone

## Known Limitations

- Camera measurement analysis currently returns placeholder values; real image analysis is under development
- iOS builds require macOS environment

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Flutter Codelabs](https://docs.flutter.dev/get-started/codelab)

## License

This project is proprietary software. All rights reserved.
