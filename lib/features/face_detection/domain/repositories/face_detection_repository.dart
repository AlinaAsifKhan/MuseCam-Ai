import '../../domain/entities/detected_face.dart';
import 'package:muse_cam_ai/features/camera/domain/entities/camera_frame.dart';

/// Abstract face detection repository
///
/// Defines contract for face detection operations
abstract class FaceDetectionRepository {
  /// Detect faces in a given camera frame
  ///
  /// Returns list of detected faces (empty if no faces found)
  /// Throws exception if detection fails
  Future<List<DetectedFace>> detectFaces(CameraFrame frame);

  /// Dispose resources (ML models, etc)
  Future<void> dispose();
}
