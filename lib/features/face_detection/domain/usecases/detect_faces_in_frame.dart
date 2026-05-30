import 'package:muse_cam_ai/features/camera/domain/entities/camera_frame.dart';
import '../entities/detected_face.dart';
import '../repositories/face_detection_repository.dart';

/// Use case: Detect faces in a camera frame
///
/// Orchestrates the face detection pipeline
class DetectFacesInFrame {
  final FaceDetectionRepository repository;

  DetectFacesInFrame({required this.repository});

  /// Detect faces in frame
  /// Returns empty list if no faces detected
  Future<List<DetectedFace>> call(CameraFrame frame) async {
    try {
      final faces = await repository.detectFaces(frame);
      return faces;
    } catch (e) {
      rethrow;
    }
  }
}
