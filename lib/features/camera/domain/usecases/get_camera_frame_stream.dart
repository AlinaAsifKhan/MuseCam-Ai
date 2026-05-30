import '../entities/camera_frame.dart';
import '../repositories/camera_repository.dart';

/// Use case: Get stream of camera frames
class GetCameraFrameStream {
  final CameraRepository repository;

  GetCameraFrameStream({required this.repository});

  Stream<CameraFrame> call() {
    return repository.getFrameStream();
  }
}
