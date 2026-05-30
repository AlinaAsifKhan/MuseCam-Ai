import 'package:muse_cam_ai/features/face_detection/data/datasources/ml_kit_face_datasource.dart';
import 'package:muse_cam_ai/features/pose_detection/data/datasources/ml_kit_pose_datasource.dart';
import 'package:muse_cam_ai/features/camera/domain/entities/camera_frame.dart';
import 'package:muse_cam_ai/features/face_detection/domain/entities/detected_face.dart';
import 'package:muse_cam_ai/features/pose_detection/domain/entities/detected_pose.dart';
import 'dart:developer' as developer;

/// Central service for all ML Kit operations
///
/// This service wraps both face detection and pose detection
/// and provides a unified interface for camera frame analysis.
/// 
/// Usage:
/// ```dart
/// final mlKitService = MLKitService();
/// 
/// // Detect faces
/// final faces = await mlKitService.detectFaces(cameraFrame);
/// 
/// // Detect pose
/// final pose = await mlKitService.detectPose(cameraFrame);
/// 
/// // Cleanup
/// await mlKitService.dispose();
/// ```
class MLKitService {
  late final MLKitFaceDataSource _faceDetector;
  late final MLKitPoseDataSource _poseDetector;

  MLKitService() {
    _faceDetector = MLKitFaceDataSource();
    _poseDetector = MLKitPoseDataSource();
    developer.log('ML Kit service initialized');
  }

  /// Detect faces in a camera frame
  ///
  /// Returns a list of detected faces with bounding boxes, landmarks, and head rotation.
  /// Returns empty list if no faces detected or on error.
  Future<List<DetectedFace>> detectFaces(CameraFrame frame) async {
    try {
      return await _faceDetector.detectFaces(frame);
    } catch (e) {
      developer.log('Error in MLKitService.detectFaces: $e', error: e);
      return [];
    }
  }

  /// Detect pose in a camera frame
  ///
  /// Returns detected pose with 33 joints, or null if no pose detected or on error.
  Future<DetectedPose?> detectPose(CameraFrame frame) async {
    try {
      return await _poseDetector.detectPose(frame);
    } catch (e) {
      developer.log('Error in MLKitService.detectPose: $e', error: e);
      return null;
    }
  }

  /// Run both face and pose detection on same frame
  ///
  /// More efficient than calling both separately since frame is processed once.
  /// Returns tuple of (faces, pose).
  Future<(List<DetectedFace>, DetectedPose?)> detectFacesAndPose(
    CameraFrame frame,
  ) async {
    try {
      final faces = await _faceDetector.detectFaces(frame);
      final pose = await _poseDetector.detectPose(frame);
      final result = (faces, pose);
      return result;
    } catch (e) {
      developer.log('Error in MLKitService.detectFacesAndPose: $e', error: e);
      final emptyResult = (<DetectedFace>[], null);
      return emptyResult;
    }
  }

  /// Dispose all ML Kit resources
  ///
  /// Call this when done with ML Kit (e.g., on app close or feature unmount)
  Future<void> dispose() async {
    try {
      await _faceDetector.dispose();
      await _poseDetector.dispose();
      developer.log('ML Kit service disposed');
    } catch (e) {
      developer.log('Error disposing ML Kit service: $e', error: e);
    }
  }
}
