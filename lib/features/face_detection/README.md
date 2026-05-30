# Face Detection Feature — Phase 3

## Overview

Real-time face detection with bounding box overlays using Google ML Kit.

## Architecture

```
Presentation Layer (UI)
├── FaceOverlayWidget (renders bounding boxes)
├── FaceOverlayPainter (CustomPaint drawer)
└── Providers (Riverpod state management)

Domain Layer (Business Logic)
├── DetectedFace entity
├── FaceLandmark entity
├── FaceDetectionRepository (interface)
└── DetectFacesInFrame use case

Data Layer (External Dependencies)
├── MLKitFaceDataSource (Google ML Kit wrapper)
└── FaceDetectionRepositoryImpl (implementation)
```

## How It Works

### Frame Processing Pipeline

```
Camera Frame (30 FPS)
    ↓
faceDetectionProvider watches frame stream
    ↓
FaceDetectionNotifier.detectFacesInFrame(frame)
    ↓
MLKitFaceDataSource.detectFaces(frame)
    ├─→ Convert CameraFrame → InputImage
    ├─→ Run ML Kit face detector
    └─→ Get List<Face> from ML Kit
    ↓
FaceMapper converts ML Kit Face → DetectedFace
    ├─→ Extract bounding box
    ├─→ Extract landmarks
    └─→ Extract head rotation angles
    ↓
FaceDetectionNotifier updates state
    ├─→ state.faces = detected faces
    └─→ Triggers UI rebuild
    ↓
FaceOverlayWidget watches detectedFacesProvider
    ├─→ Receives new face list
    └─→ FaceOverlayPainter redraws boxes
    ↓
User sees live bounding boxes on camera preview
```

## Key Components

### 1. **DetectedFace Entity**
Pure domain model containing:
- Bounding box position/size
- Confidence score (0.0-1.0)
- Facial landmarks (eyes, nose, mouth, etc)
- Head rotation angles (pitch, yaw, roll)

Helper properties:
- `isValid` — confidence > 0.5
- `isLookingAtCamera` — face roughly facing camera
- `confidencePercent` — confidence as 0-100

### 2. **MLKitFaceDataSource**
Wraps Google ML Kit:
- Initializes face detector with options
- Converts CameraFrame to ML Kit InputImage
- Runs face detection async
- Maps ML Kit Face to DetectedFace

### 3. **FaceDetectionNotifier**
StateNotifier that:
- Watches camera frame stream
- Processes each frame for faces
- Updates state reactively
- Handles errors gracefully

### 4. **FaceOverlayPainter**
CustomPainter that draws:
- Green bounding box per face
- Confidence percentage (top-right)
- Facial landmarks as small dots

### 5. **Riverpod Providers**
- `faceDetectionStateProvider` — Current state
- `detectedFacesProvider` — Just the faces
- `isFaceProcessingProvider` — Processing status
- `faceDetectionWithFramesProvider` — Linked to camera frames

## Usage

### Basic Usage (Auto-processing)

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  // Automatically watches camera frames and detects faces
  final faces = ref.watch(detectedFacesProvider);
  
  return Text('Detected ${faces.length} faces');
}
```

### Manual Processing

```dart
final notifier = ref.read(faceDetectionStateProvider.notifier);
await notifier.detectFacesInFrame(cameraFrame);
```

### Getting Detection State

```dart
final state = ref.watch(faceDetectionStateProvider);
print('Faces: ${state.faces.length}');
print('Processing: ${state.isProcessing}');
print('Error: ${state.error}');
```

## Performance

- **Detection Time:** 30-100ms per frame (ML Kit typical)
- **Frame Rate:** ~30 FPS camera, processes adaptively
- **Landmarks:** 468 facial landmarks available (we use subset)
- **Confidence:** ML Kit returns face confidence automatically

## ML Kit Features Enabled

- ✅ Face detection (bounding boxes)
- ✅ Facial landmarks (eyes, nose, mouth, etc)
- ✅ Face classification (smiling, eyes open)
- ✅ Face tracking (stable IDs across frames)

## Integration Points

**What Phase 3 depends on:**
- ✅ Phase 2 camera frame stream

**What depends on Phase 3:**
- ⏳ Phase 4 (Guidance) — Uses face position for framing hints
- ⏳ Phase 7 (Auto-capture) — Combines face confidence + other signals
- ⏳ Phase 8 (Editing) — Auto-crop around detected face

## Next Steps

Phase 4 will use detected face bounding box to provide:
- Rule-of-thirds guidance
- Framing hints (move camera)
- Positioning suggestions
