import 'package:muse_cam_ai/features/face_detection/domain/entities/detected_face.dart';
import 'package:muse_cam_ai/features/camera/domain/entities/camera_frame.dart';
import '../datasources/ml_kit_face_datasource.dart';
import '../../domain/repositories/face_detection_repository.dart';
import 'dart:developer' as developer;

/// Concrete implementation of FaceDetectionRepository
///
/// Uses ML Kit via MLKitFaceDataSource
class FaceDetectionRepositoryImpl implements FaceDetectionRepository {
  final MLKitFaceDataSource _dataSource;

  FaceDetectionRepositoryImpl({required MLKitFaceDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<DetectedFace>> detectFaces(CameraFrame frame) async {
    try {
      final faces = await _dataSource.detectFaces(frame);
      developer.log('Repository: detected ${faces.length} faces');
      return faces;
    } catch (e) {
      developer.log('Repository error: $e', error: e);
      rethrow;
    }
  }

  @override
  Future<void> dispose() async {
    try {
      await _dataSource.dispose();
      developer.log('Face detection repository disposed');
    } catch (e) {
      developer.log('Error disposing repository: $e', error: e);
    }
  }
}
