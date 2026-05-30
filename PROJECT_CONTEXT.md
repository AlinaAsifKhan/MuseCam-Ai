# Muse Cam AI — Production Architecture & Development Guide

> A production-grade AI camera assistant app using real-time ML vision for professional photo capture guidance.

**Last Updated:** May 2026  
**Phase:** 2 (Camera Core — Live Preview & Frame Streaming)  
**Status:** Phase 2 complete ✅

---

## 📋 Table of Contents

1. [Project Vision](#project-vision)
2. [Tech Stack](#tech-stack)
3. [Core Principles](#core-principles)
4. [Clean Architecture](#clean-architecture)
5. [Project Structure](#project-structure)
6. [ML Pipeline Architecture](#ml-pipeline-architecture)
7. [Development Roadmap](#development-roadmap)
8. [Phase 1: Foundation (Current)](#phase-1-foundation-current)
9. [Feature Dependencies](#feature-dependencies)
10. [State Management Pattern](#state-management-pattern)
11. [Data Flow](#data-flow)
12. [Development Standards](#development-standards)

---

## 🎯 Project Vision

**What:** AI-powered camera assistant that provides real-time guidance for professional-quality photo capture.

**Why:** Users struggle with framing, lighting, pose, and composition. Muse Cam AI leverages ML vision models to guide capture decisions in real-time.

**How:** 
- Real-time camera feed processing
- Multiple ML vision models (face, pose, object detection)
- Analytics layer (brightness, blur, stability)
- Intelligent overlay guidance system
- Auto-capture when optimal conditions are detected

**Core Value:** Turn any user into a professional photographer with AI-powered, real-time guidance.

---

## 🛠️ Tech Stack

### Framework & Language
- **Flutter** (latest stable)
- **Dart** 3.x
- **Clean Architecture** (strictly enforced)

### State Management
- **Riverpod** — Provider-based, reactive, compile-time safe
  - No BuildContext dependency
  - Type-safe state and effects
  - Async state handling

### Camera & Media
- **CameraAwesome** — Real-time camera feed, frame access, permissions
- **Alternative fallback:** `camera` package (if CameraAwesome unavailable)

### ML Vision Models
- **Google ML Kit** (Firebase ML Kit)
  - Face detection
  - Pose detection (33 landmarks)
  - Object detection
  - Text recognition (future)
- **On-device processing** (no backend dependency)

### Analytics & Utilities
- **Custom Dart utilities** for:
  - Brightness/luminance analysis
  - Blur detection (Laplacian variance)
  - Stability scoring
  - Composition analysis (rule-of-thirds, depth)

### Backend & Storage (Phase 9+)
- **Firebase Auth** (Sign-in, User profiles)
- **Firebase Storage** (Photo uploads)
- **Cloud Firestore** (User metadata, analytics)
- **Firebase Functions** (Post-processing, ML enrichment)

### Testing & Quality
- **flutter_test** + **riverpod_test**
- **mockito** — Mocking for repository tests
- **integration_test** — End-to-end camera workflows
- **patrol** — UI testing for camera integration

---

## 📐 Core Principles

### 1. **No Quick Hacks**
Every feature must be production-scalable from day one.
- No ad-hoc state management
- No UI-embedded business logic
- No single-file implementations

### 2. **Separation of Concerns**
Strict layering: **UI ≠ Domain ≠ Data**

```
User Input → UI Layer (Riverpod providers, widgets)
                ↓
         Domain Layer (Use cases, business rules)
                ↓
         Data Layer (Repositories, ML services)
                ↓
         Raw Data (Camera frames, ML models)
```

### 3. **Camera Frames Are Core Data**
The real-time camera frame stream is the foundation of all intelligence.
- **Single source of truth:** Camera provider streams frames
- **Stateless frame processing:** Each frame is independent
- **Reactive pipeline:** Frame → Processing → UI update

### 4. **ML Processing Isolation**
ML inference is **never** called from UI layer.
- All ML calls happen in domain/data layers
- Results are provided via Riverpod providers
- UI only listens to state changes

### 5. **Production-First Mindset**
Every feature must consider:
- Performance (GPU acceleration, frame dropping)
- Reliability (error boundaries, fallbacks)
- Scalability (modular feature structure)
- Testability (dependency injection via Riverpod)

---

## 🏗️ Clean Architecture

### Layer Structure

```
┌─────────────────────────────────────────────────────────┐
│         PRESENTATION LAYER (UI)                         │
│  - Screens, Widgets, Navigation                         │
│  - Riverpod providers (controllers)                      │
│  - State transformation for UI                          │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│         DOMAIN LAYER (Business Logic)                   │
│  - Use cases (CameraUseCase, FaceDetectionUseCase)      │
│  - Repository interfaces (abstract)                     │
│  - Domain models (entities)                             │
│  - Business rules & decisions                           │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│         DATA LAYER (External Dependencies)              │
│  - Repository implementations                           │
│  - Data sources (CameraAwesome, ML Kit)                 │
│  - Data mappers (raw → domain models)                   │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│         INFRASTRUCTURE (External Systems)               │
│  - Camera hardware, ML Kit, Firebase, sensors          │
└─────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

#### **Presentation Layer** (`lib/features/*/presentation/`)
- **What:** Display state, handle user input
- **Provides:** Screens, Widgets, Navigation
- **Uses:** Domain layer (use cases) via Riverpod
- **Never:** Business logic, data fetching, ML inference
- **Pattern:** Stateless widgets + Riverpod providers

#### **Domain Layer** (`lib/features/*/domain/`)
- **What:** Business rules, orchestration
- **Provides:** Use cases, interfaces, entities
- **Uses:** Data layer (repositories)
- **Never:** UI frameworks, Riverpod, external libraries
- **Pattern:** Pure Dart, testable in isolation

#### **Data Layer** (`lib/features/*/data/`)
- **What:** Fetch, map, and persist data
- **Provides:** Repository implementations
- **Uses:** Infrastructure (camera, ML Kit, Firebase)
- **Never:** Business logic, state management
- **Pattern:** Adapts external APIs to domain models

#### **Infrastructure** (External)
- **What:** Raw camera frames, ML model outputs, device sensors
- **No code:** Just configuration and dependencies
- **Examples:** CameraAwesome, ML Kit, device accelerometer

---

## 📁 Project Structure

```
lib/
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart          # App-wide constants
│   │   ├── ml_constants.dart           # ML model thresholds
│   │   └── ui_constants.dart           # UI dimensions, timings
│   │
│   ├── utils/
│   │   ├── analytics/
│   │   │   ├── brightness_analyzer.dart
│   │   │   ├── blur_detector.dart
│   │   │   └── stability_calculator.dart
│   │   ├── extensions/
│   │   │   └── image_extensions.dart
│   │   └── validators/
│   │       └── permission_validator.dart
│   │
│   ├── theme/
│   │   ├── app_theme.dart              # Material theme
│   │   ├── colors.dart
│   │   └── text_styles.dart
│   │
│   ├── services/
│   │   ├── permission_service.dart     # Camera permissions
│   │   ├── logger_service.dart         # Debug logging
│   │   └── error_handler.dart          # Error categorization
│   │
│   └── errors/
│       ├── failures.dart               # Failure types
│       └── exceptions.dart             # Custom exceptions
│
├── features/
│   │
│   ├── camera/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── camera_local_datasource.dart
│   │   │   │   └── camera_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── camera_frame_model.dart
│   │   │   └── repositories/
│   │   │       └── camera_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── camera_frame.dart
│   │   │   ├── repositories/
│   │   │   │   └── camera_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_camera_frame_stream.dart
│   │   │       ├── request_camera_permission.dart
│   │   │       └── initialize_camera.dart
│   │   │
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── camera_provider.dart       # Riverpod
│   │       │   ├── camera_frame_provider.dart # Frame stream
│   │       │   └── camera_state.dart          # State classes
│   │       ├── screens/
│   │       │   └── camera_screen.dart
│   │       └── widgets/
│   │           ├── camera_preview_widget.dart
│   │           └── permission_request_widget.dart
│   │
│   ├── face_detection/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── ml_kit_face_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── detected_face_model.dart
│   │   │   └── repositories/
│   │   │       └── face_detection_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── face_detection_result.dart
│   │   │   ├── repositories/
│   │   │   │   └── face_detection_repository.dart
│   │   │   └── usecases/
│   │   │       └── detect_faces_in_frame.dart
│   │   │
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── face_detection_provider.dart
│   │       │   └── face_state.dart
│   │       └── widgets/
│   │           └── face_detection_overlay.dart
│   │
│   ├── pose_detection/      # (Similar structure to face_detection)
│   ├── object_detection/    # (Similar structure to face_detection)
│   │
│   ├── guidance/
│   │   ├── data/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── framing_guidance.dart
│   │   │   │   ├── composition_rule.dart
│   │   │   │   └── guidance_hint.dart
│   │   │   ├── repositories/
│   │   │   │   └── guidance_repository.dart
│   │   │   └── usecases/
│   │   │       ├── analyze_composition.dart
│   │   │       ├── calculate_rule_of_thirds.dart
│   │   │       └── generate_guidance_hints.dart
│   │   │
│   │   └── presentation/
│   │       ├── providers/
│   │       └── widgets/
│   │           ├── composition_grid_overlay.dart
│   │           └── guidance_hint_widget.dart
│   │
│   ├── analytics/
│   │   ├── data/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── brightness_analysis.dart
│   │   │   │   ├── blur_score.dart
│   │   │   │   └── stability_metrics.dart
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   │       ├── analyze_brightness.dart
│   │   │       ├── detect_blur.dart
│   │   │       └── calculate_stability.dart
│   │   │
│   │   └── presentation/
│   │       ├── providers/
│   │       └── widgets/
│   │           └── analytics_indicator_widget.dart
│   │
│   ├── capture/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── capture_condition.dart
│   │   │   │   └── auto_capture_decision.dart
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   │       ├── evaluate_capture_readiness.dart
│   │   │       └── trigger_auto_capture.dart
│   │   │
│   │   └── presentation/
│   │       ├── providers/
│   │       └── widgets/
│   │           └── capture_button_widget.dart
│   │
│   └── editing/
│       ├── data/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── edited_image.dart
│       │   ├── repositories/
│       │   └── usecases/
│       │       ├── apply_filter.dart
│       │       ├── adjust_brightness.dart
│       │       └── export_image.dart
│       │
│       └── presentation/
│           ├── screens/
│           │   └── editing_screen.dart
│           └── widgets/
│
├── shared/
│   ├── widgets/
│   │   ├── loading_widget.dart
│   │   ├── error_widget.dart
│   │   └── app_bar_widget.dart
│   │
│   ├── overlays/
│   │   ├── overlay_painter.dart         # Base painter
│   │   ├── face_overlay_painter.dart
│   │   ├── pose_overlay_painter.dart
│   │   └── guidance_overlay_painter.dart
│   │
│   └── models/
│       ├── app_result.dart              # Success/Failure wrapper
│       └── ml_inference_result.dart     # Generic ML result
│
├── main.dart
└── app.dart

test/                          # Unit & widget tests
integration_test/              # End-to-end tests
```

---

## 🔄 ML Pipeline Architecture

All ML operations follow this **strict pipeline**:

```
┌──────────────┐
│ Camera Frame │  Raw frame from CameraAwesome
└──────┬───────┘
       │
       ▼
┌──────────────────────┐
│   Preprocessing      │  Resize, normalize, format conversion
│   (Optional)         │  Data layer responsibility
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│  ML Model Inference  │  ML Kit execution
│  (Google ML Kit)     │  On-device, async
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│  Result Mapping      │  ML Kit output → Domain entity
│  (Data layer)        │  Example: raw face → FaceDetectionResult
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│  Business Logic      │  Process results, combine signals
│  (Domain layer)      │  Generate guidance, make decisions
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│  UI State Update     │  Riverpod provider state change
│  (Riverpod provider) │  Triggers widget rebuild
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│  Overlay Rendering   │  CustomPaint or Canvas
│  (Presentation UI)   │  Visualize results
└──────────────────────┘
```

### Key Rules
- **No ML calls from UI layer** — Only domain/data layers call ML Kit
- **Async processing** — ML inference happens off-main-thread via Riverpod
- **Result caching** — Don't re-process identical frames
- **Frame dropping tolerance** — Skip frames if processing slower than capture rate
- **Dependency injection** — ML services injected into repositories

---

## 🛣️ Development Roadmap

### Timeline & Phases

| Phase | Goal | Duration | Status |
|-------|------|----------|--------|
| **1** | Foundation: Architecture + Riverpod | Week 1 | ✅ Complete |
| **2** | Camera Core: Live preview + permissions | Week 2 | 🟢 Complete |
| **3** | Face AI: Face detection + overlay | Week 3 | ⏳ Next |
| **4** | Guidance: Rule-of-thirds + hints | Week 4 | ⏳ Planned |
| **5** | Analytics: Brightness + blur detection | Week 5 | ⏳ Planned |
| **6** | Pose + Object: Advanced ML models | Week 6 | ⏳ Planned |
| **7** | Auto-capture: Decision engine | Week 7 | ⏳ Planned |
| **8** | Editing: Post-capture tools | Week 8 | ⏳ Planned |
| **9** | Backend: Firebase integration | Week 9+ | ⏳ Planned |

### Phase Dependencies

```
Phase 1 (Foundation)
   │
   ├─→ Phase 2 (Camera Core) ──→ Phase 3, 4, 5, 6, 7
   │
Phase 3 (Face AI) ──→ Phase 4, 5 ──→ Phase 7, 8
Phase 5 (Analytics) ──→ Phase 7
Phase 6 (Pose + Object) ──→ Phase 7
Phase 7 (Auto-capture) ──→ Phase 8
Phase 8 (Editing) ──→ Phase 9
Phase 9 (Backend)
```

**Critical Path:** Phase 1 → 2 → 3 → 7 (Full AI pipeline)

---

## ✅ Phase 1: Foundation (Current)

### Objectives
- ✅ Set up clean architecture folder structure
- ✅ Add Riverpod & dependency injection
- ✅ Create feature module skeleton for camera
- ✅ Set up app navigation (naive routing initially)
- ✅ Configure constants, theme, error handling
- ✅ Prepare for Phase 2 (camera integration)

### Deliverables
1. **Folder Structure** — Complete `lib/` hierarchy created
2. **Riverpod Setup** — Provider registration, async state management
3. **Camera Feature Skeleton** — Data, domain, presentation layers stubbed
4. **App Router** — Simple navigation setup (no deep-linking yet)
5. **Error Handling** — Custom failures & exception types
6. **Constants & Config** — Centralized configuration
7. **Documentation** — This file + inline code comments

### Key Files to Create
- `lib/core/constants/` — All configuration
- `lib/core/errors/` — Failure & exception types
- `lib/features/camera/domain/` — Camera repository interface
- `lib/features/camera/presentation/providers/` — Riverpod providers
- `lib/main.dart` — App setup with Riverpod
- `pubspec.yaml` — Dependencies (Riverpod, etc.)

### Testing Approach
- Unit tests for use cases (no UI needed)
- Integration tests for Riverpod provider behavior
- Manual testing of app launch & navigation

---

## 🔌 Feature Dependencies

```
Face Detection
├── Depends on: Camera Core, Analytics (optional brightness context)
├── Feeds into: Guidance System, Auto-capture Engine
└── Consumed by: Presentation (UI overlay)

Pose Detection
├── Depends on: Camera Core
├── Feeds into: Guidance System, Auto-capture Engine
└── Used for: Professional pose feedback

Object Detection
├── Depends on: Camera Core
├── Feeds into: Guidance System (context-aware hints)
└── Use case: Scene understanding

Guidance System
├── Depends on: Face, Pose, Object (optional), Analytics
├── Feeds into: UI Layer (hints, suggestions)
└── Non-blocking, advisory only

Analytics Engine
├── Depends on: Camera Core (frames)
├── Feeds into: Auto-capture, Guidance System
└── Used by: Quality assessment

Auto-capture Engine
├── Depends on: All ML features + Analytics
├── Feeds into: Capture action
└── Decision point: Combine all signals

Capture & Editing
├── Depends on: All previous
├── Feeds into: Firebase storage (Phase 9)
└── Final user action
```

**Important:** Features are **independent modules**. Don't create tight coupling between features. Each should be testable in isolation.

---

## 🧠 State Management Pattern (Riverpod)

### Provider Categories

#### 1. **Data Providers** (Raw data, no dependencies)
```dart
// Example: Global configuration
final appConfigProvider = Provider((ref) => AppConfig());
```
- One-time setup
- Never change after initialization
- Safe to use anywhere

#### 2. **Async Providers** (External dependencies)
```dart
// Example: Camera frame stream
final cameraFrameStreamProvider = StreamProvider<CameraFrame>((ref) async* {
  final camera = ref.watch(cameraRepositoryProvider);
  yield* camera.getFrameStream();
});
```
- Long-lived streams or futures
- Auto retry on error
- Cancels on provider disposal

#### 3. **State Notifier Providers** (Mutable state)
```dart
// Example: Face detection results
final faceDetectionProvider = StateNotifierProvider<
    FaceDetectionNotifier, 
    AsyncValue<List<Face>>
>((ref) {
  return FaceDetectionNotifier(ref);
});
```
- Reactive state changes
- Handle errors gracefully
- Persist state across rebuilds

#### 4. **Computed Providers** (Derived state)
```dart
// Example: Overall capture readiness
final captureReadinessProvider = Provider<CaptureReadiness>((ref) {
  final brightness = ref.watch(brightnessAnalysisProvider).valueOrNull;
  final blur = ref.watch(blurDetectionProvider).valueOrNull;
  final faces = ref.watch(faceDetectionProvider).valueOrNull;
  
  // Combine signals
  return _computeReadiness(brightness, blur, faces);
});
```
- Combine multiple providers
- Pure computation, no side effects
- Auto-memoized (cached)

#### 5. **Family Providers** (Parameterized)
```dart
// Example: Process specific frame
final frameProcessorProvider = FutureProvider.family<
    ProcessedFrame, 
    CameraFrame
>((ref, frame) async {
  final processor = ref.watch(mlServiceProvider);
  return processor.process(frame);
});
```
- Different state per parameter
- Useful for processing individual items

### Riverpod Best Practices
- ✅ Use `.watch()` in widgets
- ✅ Use `.read()` only in callbacks
- ✅ Avoid `.watch()` in business logic
- ✅ Always handle `AsyncValue` (loading, error, data)
- ✅ Keep providers small and focused
- ✅ Use `ref.refresh()` sparingly

---

## 📊 Data Flow

### Typical Frame Processing Flow

```
1. User opens camera screen
   ├─ Riverpod initializes camera repository
   ├─ Permission check & initialization
   └─ Camera preview starts

2. Camera emits frame every ~33ms (30 FPS)
   ├─ cameraFrameStreamProvider yields frame
   └─ All watchers notified

3. Face Detection Pipeline
   ├─ Domain layer requests face detection use case
   ├─ Data layer receives frame
   ├─ ML Kit processes frame (async)
   ├─ Results mapped to domain entity
   └─ faceDetectionProvider state updates

4. Analytics Pipeline (parallel)
   ├─ Brightness analysis on frame
   ├─ Blur detection on frame
   ├─ Stability tracking (frame-to-frame delta)
   └─ All results cached in Riverpod

5. Guidance System
   ├─ Domain layer evaluates all ML results
   ├─ Generates guidance hints (rule-of-thirds, etc.)
   └─ guidanceProvider state updates

6. Auto-capture Decision
   ├─ Combine all signals (face confidence, brightness, blur, stability)
   ├─ Check if conditions optimal
   └─ If yes: trigger capture action

7. UI Updates
   ├─ Face detection overlay renders
   ├─ Guidance hints display
   ├─ Capture button feedback
   └─ Analytics indicators update

8. On Capture
   ├─ Save image to device storage
   ├─ Navigate to editing screen (Phase 8)
   └─ Reset for next capture
```

### Error Handling Flow

```
Exception in ML inference
   │
   ├─→ Caught in data layer
   ├─→ Mapped to Failure
   ├─→ Riverpod AsyncValue.error state
   ├─→ UI shows error widget or fallback
   └─→ Automatic retry or user dismissal

Permission denied
   │
   ├─→ Caught in camera initialization
   ├─→ Show permission request widget
   └─→ Resume on permission granted
```

---

## 📋 Development Standards

### Code Style
- **Naming:**
  - Classes: `PascalCase` (e.g., `FaceDetectionRepository`)
  - Functions: `camelCase` (e.g., `detectFaces()`)
  - Constants: `camelCase` (e.g., `maxFrameSize`)
  - Private members: Leading `_` (e.g., `_mlKitService`)

- **Comments:**
  ```dart
  /// Doc comment for public APIs
  /// Used for IDE hints & documentation
  
  // Inline comment for logic explanation
  // Why, not what
  ```

- **Formatting:** `dart format --line-length=100`

### File Organization
```dart
import 'package:flutter/material.dart';  // Flutter imports first
import 'package:riverpod/riverpod.dart'; // Then pub packages
// Blank line
import 'domain/entities/face.dart';      // Then relative imports
```

### Layering Rules

**Presentation Layer CAN:**
- ✅ Import domain & data layers
- ✅ Use Riverpod providers
- ✅ Build UI widgets
- ✅ Handle user input

**Presentation Layer CANNOT:**
- ❌ Import UI from other layers
- ❌ Call services directly
- ❌ Business logic

**Domain Layer CAN:**
- ✅ Import other domain classes
- ✅ Define entities & use cases
- ✅ Abstract repository interfaces

**Domain Layer CANNOT:**
- ❌ Import presentation or data layers
- ❌ Use Riverpod, Flutter, external libs
- ❌ Access camera, sensors, network

**Data Layer CAN:**
- ✅ Import domain layer
- ✅ Import data sources & external libs
- ✅ Map models to entities

**Data Layer CANNOT:**
- ❌ Import presentation layer
- ❌ Business logic beyond mapping

### Testing Strategy

```
Unit Tests (70%)
├─ Domain use cases (mocked repositories)
├─ Data layer mappers
└─ Utility functions

Widget Tests (15%)
├─ Presentation providers
├─ Widget rendering
└─ User interactions

Integration Tests (15%)
├─ Full pipeline (camera → ML → UI)
├─ Permission flows
└─ Error scenarios
```

### Git Commit Convention
```
feat: [scope] Brief description
fix: [scope] Brief description
refactor: [scope] Brief description
docs: [scope] Brief description

Examples:
feat(camera): Integrate CameraAwesome and frame streaming
fix(face-detection): Handle nil face results in mapper
refactor(riverpod): Extract camera provider to separate file
docs(architecture): Update data flow diagram
```

### Documentation Requirements
- ✅ Public API doc comments
- ✅ Complex algorithm explanations
- ✅ Architecture decisions in ADRs (Architecture Decision Records)
- ✅ README.md in feature folders
- ✅ Inline comments for "why", not "what"

---

## 🚀 Getting Started (Next Steps)

### Immediate (Phase 1):
1. Review this document
2. Create folder structure in `lib/`
3. Set up Riverpod in `main.dart`
4. Create error handling framework
5. Stub out camera feature modules

### Next Phase (Phase 2):
1. Add CameraAwesome dependency
2. Create camera data source
3. Implement camera repository
4. Build camera permission flow
5. Display live preview

### Key Reminders
- **Never skip layers** — Always go presentation → domain → data
- **Test early** — Write tests alongside features
- **Document decisions** — Why, not just what
- **Reusable components** — Shared overlays, widgets, models
- **Performance first** — Optimize frame processing, GPU rendering
- **Production ready** — Assume this code goes to App Store today

---

## 📚 Reference Files

**To understand this project better, review:**
1. `pubspec.yaml` — All dependencies documented
2. `lib/core/constants/ml_constants.dart` — ML model thresholds
3. `lib/features/camera/domain/repositories/camera_repository.dart` — Camera interface
4. Each feature's `README.md` (to be added)

---

## 📞 Support & Questions

For architecture questions:
- ✅ Refer to Clean Architecture sections above
- ✅ Check feature-specific README.md files
- ✅ Review existing use case implementations

For dependency issues:
- ✅ Check `pubspec.yaml`
- ✅ Verify Riverpod provider setup
- ✅ Ensure correct layer imports

---

**Last Updated:** May 2026  
**Maintained By:** Senior Flutter + ML Engineer  
**Next Review:** After Phase 2 completion
