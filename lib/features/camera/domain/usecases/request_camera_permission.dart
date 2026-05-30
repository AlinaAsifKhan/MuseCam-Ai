import '../repositories/camera_repository.dart';

/// Use case: Request camera permission
class RequestCameraPermission {
  final CameraRepository repository;

  RequestCameraPermission({required this.repository});

  Future<bool> call() async {
    return repository.requestCameraPermission();
  }
}
