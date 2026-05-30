import 'dart:ui';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../domain/entities/detected_pose.dart';
import '../../domain/entities/pose_joint.dart';
import 'package:muse_cam_ai/features/camera/domain/entities/camera_frame.dart';
import 'dart:developer' as developer;

/// Data source for Google ML Kit pose detection
///
/// Wraps the google_mlkit_pose_detection package and handles
/// conversion from CameraFrame to ML Kit InputImage format.
/// Uses MediaPipe Pose model with 33 joints.
class MLKitPoseDataSource {
  late final PoseDetector _poseDetector;

  MLKitPoseDataSource() {
    // Initialize pose detector with options
    final options = PoseDetectorOptions();
    _poseDetector = PoseDetector(options: options);
  }

  /// Detect pose in camera frame
  ///
  /// Converts CameraFrame to ML Kit InputImage format and runs pose detection
  Future<DetectedPose?> detectPose(CameraFrame frame) async {
    try {
      // Convert CameraFrame to InputImage for ML Kit
      final inputImage = _cameraFrameToInputImage(frame);

      // Run pose detection (returns List<Pose>)
      final poses = await _poseDetector.processImage(inputImage);

      // Use first pose if available
      if (poses.isEmpty) {
        return null;
      }

      final pose = poses.first;
      developer.log(
        'Pose detection completed: ${pose.landmarks.length} landmarks detected',
      );

      // Convert ML Kit results to domain entity
      return _mlKitPoseToDetectedPose(pose);
    } catch (e) {
      developer.log('Error detecting pose: $e', error: e);
      return null;
    }
  }

  /// Convert CameraFrame to ML Kit InputImage
  ///
  /// Handles format conversion and rotation adjustments
  InputImage _cameraFrameToInputImage(CameraFrame frame) {
    // Determine input image format
    final inputImageFormat = _getInputImageFormat(frame.format);

    // Create InputImage from bytes
    return InputImage.fromBytes(
      bytes: frame.bytes,
      metadata: InputImageMetadata(
        size: Size(frame.width.toDouble(), frame.height.toDouble()),
        rotation: InputImageRotation.values[frame.rotationDegrees ~/ 90],
        format: inputImageFormat,
        bytesPerRow: frame.width,
      ),
    );
  }

  /// Map CameraFrame format string to ML Kit InputImageFormat
  InputImageFormat _getInputImageFormat(String format) {
    switch (format.toLowerCase()) {
      case 'nv21':
        return InputImageFormat.nv21;
      case 'bgra8888':
        return InputImageFormat.bgra8888;
      case 'yuv420':
        return InputImageFormat.yuv420;
      default:
        return InputImageFormat.nv21; // Default to NV21 (most common)
    }
  }

  /// Convert ML Kit Pose to domain DetectedPose
  DetectedPose _mlKitPoseToDetectedPose(Pose mlKitPose) {
    // Convert landmarks - they come as map entries
    final joints = <PoseJoint>[];
    mlKitPose.landmarks.forEach((landmarkType, poseLandmark) {
      joints.add(PoseJoint(
        type: _getLandmarkTypeName(landmarkType),
        x: poseLandmark.x,
        y: poseLandmark.y,
        confidence: poseLandmark.z, // z contains confidence in ML Kit
        z: poseLandmark.z, // Additional depth info
      ));
    });

    // Calculate average confidence
    final validJoints = joints.where((j) => j.confidence > 0.0).toList();
    final avgConfidence = validJoints.isEmpty
        ? 0.0
        : validJoints.map((j) => j.confidence).reduce((a, b) => a + b) /
            validJoints.length;

    // Determine if full body is visible (more than 15 valid joints)
    final isFullBody = validJoints.length > 15;

    return DetectedPose(
      joints: joints,
      confidence: avgConfidence,
      isFullBody: isFullBody,
    );
  }

  /// Get readable name for pose landmark type
  String _getLandmarkTypeName(PoseLandmarkType type) {
    switch (type) {
      // Head
      case PoseLandmarkType.nose:
        return 'nose';
      case PoseLandmarkType.leftEyeInner:
        return 'left_eye_inner';
      case PoseLandmarkType.leftEye:
        return 'left_eye';
      case PoseLandmarkType.leftEyeOuter:
        return 'left_eye_outer';
      case PoseLandmarkType.rightEyeInner:
        return 'right_eye_inner';
      case PoseLandmarkType.rightEye:
        return 'right_eye';
      case PoseLandmarkType.rightEyeOuter:
        return 'right_eye_outer';
      case PoseLandmarkType.leftEar:
        return 'left_ear';
      case PoseLandmarkType.rightEar:
        return 'right_ear';

      // Shoulders
      case PoseLandmarkType.leftShoulder:
        return 'left_shoulder';
      case PoseLandmarkType.rightShoulder:
        return 'right_shoulder';

      // Elbows
      case PoseLandmarkType.leftElbow:
        return 'left_elbow';
      case PoseLandmarkType.rightElbow:
        return 'right_elbow';

      // Wrists
      case PoseLandmarkType.leftWrist:
        return 'left_wrist';
      case PoseLandmarkType.rightWrist:
        return 'right_wrist';

      // Hands (5 points each)
      case PoseLandmarkType.leftPinky:
        return 'left_pinky';
      case PoseLandmarkType.leftIndex:
        return 'left_index';
      case PoseLandmarkType.leftThumb:
        return 'left_thumb';
      case PoseLandmarkType.rightPinky:
        return 'right_pinky';
      case PoseLandmarkType.rightIndex:
        return 'right_index';
      case PoseLandmarkType.rightThumb:
        return 'right_thumb';

      // Hips
      case PoseLandmarkType.leftHip:
        return 'left_hip';
      case PoseLandmarkType.rightHip:
        return 'right_hip';

      // Knees
      case PoseLandmarkType.leftKnee:
        return 'left_knee';
      case PoseLandmarkType.rightKnee:
        return 'right_knee';

      // Ankles
      case PoseLandmarkType.leftAnkle:
        return 'left_ankle';
      case PoseLandmarkType.rightAnkle:
        return 'right_ankle';

      // Feet
      case PoseLandmarkType.leftHeel:
        return 'left_heel';
      case PoseLandmarkType.leftFootIndex:
        return 'left_foot_index';
      case PoseLandmarkType.rightHeel:
        return 'right_heel';
      case PoseLandmarkType.rightFootIndex:
        return 'right_foot_index';

      default:
        return 'unknown';
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      await _poseDetector.close();
      developer.log('ML Kit pose detector disposed');
    } catch (e) {
      developer.log('Error disposing pose detector: $e', error: e);
    }
  }
}
