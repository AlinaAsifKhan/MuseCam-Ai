import 'dart:typed_data';
import 'package:camera/camera.dart';

/// Camera frame entity - pure domain model
///
/// This represents a single frame from the camera.
/// It's what all features (face detection, analytics, etc) work with.
/// This class is framework-agnostic (doesn't depend on CameraAwesome or camera package)
class CameraFrame {
  /// Raw image bytes in specified format
  final Uint8List bytes;

  /// Image width in pixels
  final int width;

  /// Image height in pixels
  final int height;

  /// Image format (e.g., 'nv21', 'bgra8888', 'rgba8888')
  final String format;

  /// Timestamp when frame was captured (milliseconds since epoch)
  final int timestamp;

  /// Image rotation in degrees (0, 90, 180, 270)
  final int rotationDegrees;

  /// Which camera captured this frame
  final CameraLensDirection lensDirection;

  CameraFrame({
    required this.bytes,
    required this.width,
    required this.height,
    required this.format,
    required this.timestamp,
    required this.rotationDegrees,
    required this.lensDirection,
  });

  /// Get frame dimensions
  (int, int) get dimensions => (width, height);

  /// Check if frame is in portrait orientation
  bool get isPortrait => rotationDegrees == 90 || rotationDegrees == 270;

  @override
  String toString() =>
      'CameraFrame(${width}x$height, format: $format, rotation: $rotationDegrees°, lens: $lensDirection)';
}
