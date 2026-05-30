# Muse Cam AI

<p align="center"><img src="assets/images/appIcon.png" alt="Muse Cam AI" width="120"/></p>

AI-powered camera assistant for real-time capture guidance and automated, professional-quality photos.

---

## Overview

Muse Cam AI analyzes live camera frames on-device to provide composition, lighting, and pose guidance. It uses Riverpod for state, ML Kit for pose/face detection, and a modular pipeline so UI, domain logic, and ML processing remain decoupled.

Key goals:
- Real-time analysis of lighting, clarity, and pose
- Non-blocking on-device ML inference
- Intelligent overlays and auto-capture when conditions are ideal
- Production-ready architecture and testability

---

## Features

- Live camera preview with animated capture UI
- HUD indicators: lighting, clarity, angle, overall readiness
- Rule-of-thirds grid and compositional overlays
- Mode selection (Portrait / Subject / Auto / Custom) via settings drop-up
- Pose recommendation overlay (Step 6) — currently gated for safety
- On-device ML: Google ML Kit (pose + face detection)
- Launcher icon updated from `assets/images/appIcon.png`

---

## Tech Stack

- Flutter & Dart (>= 3.x)
- Riverpod (state management)
- camera (live preview + frame access)
- google_mlkit_pose_detection, google_mlkit_face_detection
- video_player, image, photo_view
- flutter_launcher_icons (icon generation)

---

## Quick start

1. Install dependencies
```
flutter pub get
```

2. Connect an Android device or start an emulator, then run:
```
flutter run -d <device-id>
```

3. (Optional) Regenerate launcher icons after updating `assets/images/appIcon.png`:
```
flutter pub run flutter_launcher_icons:main
```

4. Run tests:
```
flutter test
```

---

## Development notes

- Architecture: Clean layered approach (presentation → domain → data → infra). See `PROJECT_CONTEXT.md` for design decisions and pipeline diagrams.
- Providers:
	- `modeProvider` controls capture modes.
	- Camera frames are streamed by the camera data source and consumed by ML providers.
- HUD updates: currently wired to static values. To make dynamic, implement frame analysis (average luminance, Laplacian variance for blur, and pose angles) in the data layer and expose via Riverpod providers sampled at 200–500ms to avoid jank.
- Avoid using `Positioned` inside non-Stack ParentDataWidgets (this previously caused a crash — keep `Positioned` only as direct children of `Stack`).

---

## Assets & Icons

- App icon source: assets/images/appIcon.png
- Icons generated using `flutter_launcher_icons`. Confirm `flutter_launcher_icons.yaml` is present and configured before running the generator.

---

## Running on a physical device (tips)

- Ensure camera permissions are granted on the device.
- For Android devices: enable developer options and USB debugging.
- If face/pose detection returns empty lists on Android, verify the `InputImage` rotation/format and that frames are being provided in the expected format by the `camera` plugin.

---

