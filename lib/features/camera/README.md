# Camera Feature — Phase 2

## Overview

The camera feature provides real-time camera feed streaming following Clean Architecture principles.

## Architecture

```
Presentation Layer (UI)
├── CameraScreen (main UI)
├── CameraPreviewWidget (live feed)
├── PermissionRequestWidget (permission UI)
├── CameraControlsWidget (buttons)
└── Providers (Riverpod state management)

Domain Layer (Business Logic)
├── CameraRepository (interface)
├── UseCase: InitializeCamera
├── UseCase: RequestCameraPermission
├── UseCase: GetCameraFrameStream
└── UseCase: SwitchCameraLens

Data Layer (External Dependencies)
├── CameraDataSource (camera package wrapper)
├── CameraRepositoryImpl (implementation)
└── CameraFrameMapper (raw → domain mapping)
```

## Usage

### Initialization

```dart
// In CameraScreen, camera auto-initializes on load
// The state notifier handles permission checking and setup
```

### Getting Frames

```dart
// Watch frame stream provider to get camera frames
final frames = ref.watch(cameraFrameStreamProvider);

frames.when(
  data: (frame) => _processFrame(frame),
  loading: () => Center(child: CircularProgressIndicator()),
  error: (err, st) => Text('Error: $err'),
);
```

### Switching Cameras

```dart
final notifier = ref.read(cameraStateProvider.notifier);
await notifier.switchLens(CameraLensDirection.front);
```

### Taking Pictures

```dart
final notifier = ref.read(cameraStateProvider.notifier);
final path = await notifier.takePicture();
```

## State Flow

```
App Start
  ↓
CameraScreen mounted
  ↓
Initialize camera notifier
  ├─→ Check permission
  ├─→ Request if needed
  ├─→ Initialize camera
  └─→ Update state to initialized
  ↓
CameraPreviewWidget renders live feed
  ↓
CameraFrameStreamProvider yields frames (30 FPS)
  ↓
Other features (Face Detection, Analytics) can watch frame stream
```

## Key Components

### 1. **CameraState**
Immutable state class holding camera status and configuration.

### 2. **CameraStateNotifier**
StateNotifier managing camera lifecycle and operations.

### 3. **Riverpod Providers**
- `cameraRepositoryProvider` - Dependency injection
- `cameraStateProvider` - State management
- `cameraFrameStreamProvider` - Frame stream (30 FPS)
- `isCameraInitializedProvider` - Status check
- `currentCameraLensProvider` - Current lens

### 4. **Data Flow**
```
Camera Hardware
    ↓
CameraDataSource (wraps camera package)
    ↓
CameraRepositoryImpl
    ├─→ Map raw frames to CameraFrame entities
    └─→ Stream via StreamController
    ↓
Riverpod StreamProvider
    ├─→ Available to all features
    └─→ Automatically disposed on unmount
```

## Frame Format

Each `CameraFrame` contains:
- `bytes` - Raw image data (Uint8List)
- `width`, `height` - Dimensions
- `format` - Image format (nv21, bgra8888, etc)
- `timestamp` - Capture time
- `rotationDegrees` - Image rotation
- `lensDirection` - Front or back camera

## Error Handling

```
Permission Denied
  → state.status = permissionDenied
  → Show PermissionRequestWidget
  → User grants → Retry init

Camera Init Failed
  → state.status = failed
  → Show ErrorWidget
  → state.errorMessage contains details

Frame Processing Error
  → Logged but doesn't crash app
  → Next frame processed normally
```

## Performance Notes

- **Frame Rate**: ~30 FPS (camera package limitation)
- **Memory**: Frames are streamed, not buffered
- **Threading**: Image processing off main thread
- **GPU**: Camera preview uses native rendering

## Next Phase

Phase 3 will consume this frame stream for:
- Face detection (Google ML Kit)
- Bounding box overlay
- Establishing the ML pipeline pattern

## Testing

Unit tests cover:
- Frame mapping logic
- Permission flow
- State transitions
- Repository implementation

Integration tests cover:
- Full camera initialization
- Permission request → grant flow
- Frame streaming end-to-end

## Known Limitations

- Frame stream only available after initialization
- Can't switch cameras during active stream (would require restart)
- Image processing happens serially (one frame at a time)
