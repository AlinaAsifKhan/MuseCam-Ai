/// Frame capture settings
const int targetFrameRate = 30; // FPS
const int frameProcessingTimeoutMs = 100; // Max time to process one frame

/// Resolution settings
const double maxFrameWidth = 1920;
const double maxFrameHeight = 1080;
const double minFrameWidth = 320;
const double minFrameHeight = 240;

/// Camera permission timeout
const int cameraPermissionTimeoutMs = 5000; // 5 seconds

/// Default camera lens
const String defaultCameraLens = 'back'; // 'back' or 'front'

/// Camera initialization timeout
const int cameraInitTimeoutMs = 10000; // 10 seconds

/// Supported image formats
const List<String> supportedImageFormats = ['nv21', 'bgra8888', 'rgba8888'];
