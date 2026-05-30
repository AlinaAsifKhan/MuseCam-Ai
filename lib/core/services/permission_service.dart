import 'package:permission_handler/permission_handler.dart';

/// Service for managing camera permissions
///
/// Handles camera permission checking and requesting
class PermissionService {
  /// Check if camera permission is granted
  static Future<bool> isCameraPermissionGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Request camera permission
  /// Returns true if granted, false otherwise
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Check camera permission status
  static Future<PermissionStatus> getCameraPermissionStatus() async {
    return Permission.camera.status;
  }

  /// Open app settings for user to manually grant permissions
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
