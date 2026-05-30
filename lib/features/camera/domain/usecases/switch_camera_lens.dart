import 'package:camera/camera.dart';
import '../repositories/camera_repository.dart';

/// Use case: Switch camera lens (front/back)
class SwitchCameraLens {
  final CameraRepository repository;

  SwitchCameraLens({required this.repository});

  Future<void> call(CameraLensDirection lensDirection) async {
    await repository.switchCameraLens(lensDirection);
  }
}
