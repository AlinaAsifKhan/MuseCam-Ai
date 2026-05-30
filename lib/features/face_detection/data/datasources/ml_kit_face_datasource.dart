import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import '../../domain/entities/detected_face.dart';
import '../../domain/entities/face_landmark.dart' as domain;
import 'package:muse_cam_ai/features/camera/domain/entities/camera_frame.dart';
import 'dart:developer' as developer;

/// Data source for Google ML Kit face detection
///
/// Wraps the google_mlkit_face_detection package and handles
/// conversion from CameraFrame to ML Kit InputImage format.
class MLKitFaceDataSource {
  late final FaceDetector _faceDetector;

  MLKitFaceDataSource() {
    // Initialize face detector with options
    final options = FaceDetectorOptions(
      enableClassification: true,
      enableLandmarks: true,
      enableTracking: true,
    );
    _faceDetector = FaceDetector(options: options);
  }

  /// Detect faces in camera frame
  /// 
  /// Converts CameraFrame to ML Kit InputImage format and runs face detection
  Future<List<DetectedFace>> detectFaces(CameraFrame frame) async {
    try {
      // Convert CameraFrame to InputImage for ML Kit
      final inputImage = _cameraFrameToInputImage(frame);

      // Run face detection
      final mlKitFaces = await _faceDetector.processImage(inputImage);

      developer.log(
        'Face detection completed: ${mlKitFaces.length} faces detected in ${frame.width}x${frame.height} frame',
      );

      // Convert ML Kit results to domain entities
      final detectedFaces = mlKitFaces.map(_mlKitFaceToDetectedFace).toList();

      return detectedFaces;
    } catch (e) {
      developer.log('Error detecting faces: $e', error: e);
      return [];
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

  /// Convert ML Kit Face to domain DetectedFace
  DetectedFace _mlKitFaceToDetectedFace(Face mlKitFace) {
    // Extract bounding box
    final box = mlKitFace.boundingBox;
    final boundingBox = Rect.fromLTWH(
      box.left,
      box.top,
      box.width,
      box.height,
    );

    // Extract landmarks - landmarks is a Map<FaceLandmarkType, FaceLandmark?>
    final faceLandmarks = <domain.FaceLandmark>[];
    mlKitFace.landmarks.forEach((type, landmark) {
      if (landmark != null) {
        faceLandmarks.add(domain.FaceLandmark(
          type: _landmarkTypeToString(type),
          x: landmark.position.x.toDouble(),
          y: landmark.position.y.toDouble(),
        ));
      }
    });

    // Extract head rotation angles
    final headRotationX = mlKitFace.headEulerAngleX ?? 0.0;
    final headRotationY = mlKitFace.headEulerAngleY ?? 0.0;
    final headRotationZ = mlKitFace.headEulerAngleZ ?? 0.0;

    // Extract confidence (smiling probability can be used as confidence proxy)
    final confidence = mlKitFace.smilingProbability ?? 0.95;

    return DetectedFace(
      boundingBox: boundingBox,
      confidence: confidence,
      landmarks: faceLandmarks,
      headRotationX: headRotationX,
      headRotationY: headRotationY,
      headRotationZ: headRotationZ,
    );
  }

  /// Convert ML Kit landmark type to string
  String _landmarkTypeToString(FaceLandmarkType type) {
    switch (type) {
      case FaceLandmarkType.leftEye:
        return 'left_eye';
      case FaceLandmarkType.rightEye:
        return 'right_eye';
      case FaceLandmarkType.leftEar:
        return 'left_ear';
      case FaceLandmarkType.rightEar:
        return 'right_ear';
      case FaceLandmarkType.noseBase:
        return 'nose_base';
      case FaceLandmarkType.bottomMouth:
        return 'mouth_bottom';
      case FaceLandmarkType.leftCheek:
        return 'left_cheek';
      case FaceLandmarkType.rightCheek:
        return 'right_cheek';
      default:
        return 'unknown';
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      await _faceDetector.close();
      developer.log('ML Kit face detector disposed');
    } catch (e) {
      developer.log('Error disposing face detector: $e', error: e);
    }
  }
}
