import 'dart:typed_data';
import 'package:camera/camera.dart';
import '../../domain/entities/camera_frame.dart';

/// Model for mapping raw camera data to domain entity
///
/// This mapper converts platform-specific camera frame data
/// into our framework-agnostic CameraFrame entity.
class CameraFrameMapper {
  /// Convert CameraImage from camera package to CameraFrame entity
  static CameraFrame fromCameraImage(
    CameraImage image,
    CameraLensDirection lensDirection,
  ) {
    // Determine image format
    final format = _getImageFormat(image.format.group);

    // Get timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Get rotation (camera package returns 0, 90, 180, 270)
    final rotation = _getRotationDegrees(image);

    return CameraFrame(
      bytes: _getImageBytes(image),
      width: image.width,
      height: image.height,
      format: format,
      timestamp: timestamp,
      rotationDegrees: rotation,
      lensDirection: lensDirection,
    );
  }

  /// Get image bytes from CameraImage
  ///
  /// For NV21 format (most common on Android), concatenate Y and UV planes
  static Uint8List _getImageBytes(CameraImage image) {
    final buffer = <int>[];

    // For NV21 format
    if (image.format.group == ImageFormatGroup.nv21) {
      buffer.addAll(image.planes[0].bytes);
      buffer.addAll(image.planes[1].bytes);
      return Uint8List.fromList(buffer);
    }

    // For BGRA format
    if (image.format.group == ImageFormatGroup.bgra8888) {
      return image.planes[0].bytes;
    }

    // Fallback: return first plane
    return image.planes[0].bytes;
  }

  /// Convert ImageFormatGroup to string format name
  static String _getImageFormat(ImageFormatGroup group) {
    switch (group) {
      case ImageFormatGroup.nv21:
        return 'nv21';
      case ImageFormatGroup.bgra8888:
        return 'bgra8888';
      case ImageFormatGroup.yuv420:
        return 'yuv420';
      case ImageFormatGroup.jpeg:
        return 'jpeg';
      default:
        return 'unknown';
    }
  }

  /// Get rotation degrees from CameraImage
  static int _getRotationDegrees(CameraImage image) {
    // Camera package provides sensorOrientation
    // 0, 90, 180, or 270
    return 0; // Default, would be overridden by camera config
  }
}
