import 'package:camera/camera.dart';
import '../entities/camera_frame.dart';

/// Abstract camera repository interface
///
/// This defines the contract that all camera implementations must follow.
/// Domain layer only knows about this interface, not the implementation.
abstract class CameraRepository {
  /// Initialize camera with given lens direction
  /// 
  /// Throws CameraException if initialization fails
  Future<void> initialize({required CameraLensDirection lensDirection});

  /// Request camera permission
  /// 
  /// Returns true if permission is granted, false otherwise
  Future<bool> requestCameraPermission();

  /// Check if camera permission is already granted
  Future<bool> isCameraPermissionGranted();

  /// Get stream of camera frames (real-time feed)
  /// 
  /// Yields CameraFrame objects at approximately 30 FPS
  /// This is the core data source for all ML processing
  Stream<CameraFrame> getFrameStream();

  /// Switch between front and back camera
  /// 
  /// Throws CameraException if switch fails
  Future<void> switchCameraLens(CameraLensDirection lensDirection);

  /// Get current lens direction
  CameraLensDirection getCurrentLensDirection();

  /// Take a single photo (for capture feature in later phases)
  /// 
  /// Returns path to saved image
  Future<String> takePicture();

  /// Dispose camera resources
  /// 
  /// Must be called when camera is no longer needed
  Future<void> dispose();
}
