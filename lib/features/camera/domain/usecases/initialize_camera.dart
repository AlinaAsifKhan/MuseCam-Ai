import 'package:camera/camera.dart';
import '../repositories/camera_repository.dart';

/// Use case: Initialize camera
///
/// Handles permission checking and camera setup
class InitializeCamera {
  final CameraRepository repository;

  InitializeCamera({required this.repository});

  Future<void> call({required CameraLensDirection lensDirection}) async {
    // Check permission first
    final hasPermission = await repository.isCameraPermissionGranted();

    if (!hasPermission) {
      final granted = await repository.requestCameraPermission();
      if (!granted) {
        throw Exception('Camera permission denied');
      }
    }

    // Initialize camera
    await repository.initialize(lensDirection: lensDirection);
  }
}
